import { tool } from "@opencode-ai/plugin"
import { access, mkdtemp, rm } from "node:fs/promises"
import os from "node:os"
import path from "node:path"

const DEFAULT_LANG = "eng"
const DEFAULT_DPI = 300
const DEFAULT_MAX_PAGES = 40
type ReadMode = "auto" | "paper" | "slides" | "ocr"
type NativePreference = "plain" | "layout"

function resolvePdfPath(input: string, directory: string) {
  return path.isAbsolute(input) ? path.normalize(input) : path.resolve(directory, input)
}

function parsePageSelection(selection: string | undefined, totalPages: number, maxPages: number) {
  if (!selection) {
    return Array.from({ length: Math.min(totalPages, maxPages) }, (_, index) => index + 1)
  }

  const pages = new Set<number>()
  for (const rawPart of selection.split(",")) {
    const part = rawPart.trim()
    if (!part) continue

    const rangeMatch = part.match(/^(\d+)\s*-\s*(\d+)$/)
    if (rangeMatch) {
      const start = Number(rangeMatch[1])
      const end = Number(rangeMatch[2])
      if (!Number.isInteger(start) || !Number.isInteger(end) || start < 1 || end < start) {
        throw new Error(`Invalid page range: ${part}`)
      }
      for (let page = start; page <= end; page += 1) {
        if (page <= totalPages) pages.add(page)
      }
      continue
    }

    const page = Number(part)
    if (!Number.isInteger(page) || page < 1) {
      throw new Error(`Invalid page number: ${part}`)
    }
    if (page <= totalPages) pages.add(page)
  }

  const sortedPages = [...pages].sort((left, right) => left - right)
  if (sortedPages.length === 0) {
    throw new Error("No selected pages are within the PDF page range")
  }
  return sortedPages
}

function parsePageCount(pdfInfoText: string) {
  const match = pdfInfoText.match(/^Pages:\s+(\d+)$/m)
  if (!match) {
    throw new Error("Could not determine page count from pdfinfo")
  }
  return Number(match[1])
}

function collapseWhitespace(text: string) {
  return text.replace(/[ \t]+/g, " ").trim()
}

function normalizeLines(text: string) {
  return text
    .replace(/\r\n?/g, "\n")
    .split("\n")
    .map((line) => line.replace(/\s+$/g, ""))
}

function removePageArtifacts(lines: string[]) {
  return lines.filter((line, index) => {
    const trimmed = line.trim()
    if (!trimmed) return true
    if (/^\d+$/.test(trimmed) && (index === 0 || index === lines.length - 1)) {
      return false
    }
    return true
  })
}

function isBulletLine(line: string) {
  return /^(?:[-*o]|[0-9]+[.)]|[A-Z][.)]|[•])\s+/.test(line.trim())
}

function isHeadingLine(line: string) {
  const trimmed = line.trim()
  if (!trimmed) return false
  if (trimmed.length > 120) return false
  if (isBulletLine(trimmed)) return false
  const letters = trimmed.replace(/[^A-Za-z]/g, "")
  if (letters.length < 3) return false
  const uppercaseRatio = trimmed.replace(/[^A-Z]/g, "").length / letters.length
  return uppercaseRatio > 0.7
}

function isLikelyContinuation(previous: string, current: string) {
  const prev = previous.trim()
  const curr = current.trim()
  if (!prev || !curr) return false
  if (isBulletLine(prev) || isBulletLine(curr)) return false
  if (isHeadingLine(prev) || isHeadingLine(curr)) return false
  if (/[.!?:]$/.test(prev)) return false
  if (/^[A-Z][a-z]+:/.test(curr)) return false
  if (/^[({\[]/.test(curr)) return true
  return /^[a-z0-9]/.test(curr)
}

function normalizeForLlm(text: string, preference: NativePreference) {
  const lines = removePageArtifacts(normalizeLines(text))

  if (preference === "layout") {
    const output: string[] = []
    let blankPending = false
    for (const rawLine of lines) {
      const line = collapseWhitespace(rawLine)
      if (!line) {
        blankPending = output.length > 0
        continue
      }
      if (blankPending && output[output.length - 1] !== "") {
        output.push("")
      }
      blankPending = false
      output.push(line)
    }
    return output.join("\n").trim()
  }

  const output: string[] = []
  for (const rawLine of lines) {
    const line = collapseWhitespace(rawLine)
    if (!line) {
      if (output.length > 0 && output[output.length - 1] !== "") {
        output.push("")
      }
      continue
    }

    if (output.length === 0) {
      output.push(line)
      continue
    }

    const previous = output[output.length - 1]
    if (previous !== "" && isLikelyContinuation(previous, line)) {
      output[output.length - 1] = `${previous} ${line}`
    } else {
      output.push(line)
    }
  }

  return output.join("\n").replace(/\n{3,}/g, "\n\n").trim()
}

function analyzeText(text: string) {
  const compact = collapseWhitespace(text)
  const alnum = (compact.match(/[A-Za-z0-9]/g) ?? []).length
  const weird = (compact.match(/[\uFFFD]/g) ?? []).length
  const lines = normalizeLines(text).map((line) => line.trim()).filter(Boolean)
  const bulletLines = lines.filter(isBulletLine).length
  const headingLines = lines.filter(isHeadingLine).length
  const averageLineLength =
    lines.length === 0 ? 0 : lines.reduce((sum, line) => sum + line.length, 0) / lines.length

  return {
    compact,
    alnum,
    weird,
    lines,
    bulletLines,
    headingLines,
    averageLineLength,
    looksSlideLike:
      bulletLines >= 2 || (headingLines >= 1 && lines.length <= 18) || averageLineLength < 55,
  }
}

function looksWeak(text: string) {
  const analysis = analyzeText(text)
  if (analysis.alnum === 0) return true
  if (analysis.weird >= 3) return true
  if (analysis.lines.length === 0) return true
  if (analysis.lines.length === 1 && analysis.alnum < 12) return true
  return false
}

function choosePreference(mode: ReadMode, plainText: string, layoutText: string): NativePreference {
  if (mode === "paper") return "plain"
  if (mode === "slides") return "layout"

  const plain = analyzeText(plainText)
  const layout = analyzeText(layoutText)
  if (layout.looksSlideLike && layout.alnum >= plain.alnum * 0.7) {
    return "layout"
  }
  return "plain"
}

function chooseOcrPsm(mode: ReadMode, preferredNativeText: string, layoutText: string) {
  if (mode === "slides") return 11
  if (mode === "paper") return 3
  const preferred = analyzeText(preferredNativeText)
  const layout = analyzeText(layoutText)
  return preferred.looksSlideLike || layout.looksSlideLike ? 11 : 3
}

async function ensureReadablePdf(pdfPath: string) {
  await access(pdfPath)
  if (path.extname(pdfPath).toLowerCase() !== ".pdf") {
    throw new Error(`Expected a PDF file, got: ${pdfPath}`)
  }
}

async function readPdfText(pdfPath: string, page: number, preference: NativePreference) {
  if (preference === "layout") {
    return Bun.$`pdftotext -f ${page} -l ${page} -layout -nopgbrk ${pdfPath} -`.quiet().text()
  }
  return Bun.$`pdftotext -f ${page} -l ${page} -nopgbrk ${pdfPath} -`.quiet().text()
}

async function ocrPdfPage(pdfPath: string, page: number, lang: string, psm: number, tempDir: string) {
  const outputPrefix = path.join(tempDir, `page-${page}`)
  const imagePath = `${outputPrefix}.png`

  await Bun.$`pdftoppm -png -singlefile -r ${DEFAULT_DPI} -f ${page} -l ${page} ${pdfPath} ${outputPrefix}`
    .quiet()
    .text()

  return Bun.$`tesseract ${imagePath} stdout -l ${lang} --psm ${psm}`.quiet().text()
}

export default tool({
  description:
    "Read text from a PDF for LLM use, preferring native text extraction and falling back to OCR only on weak pages.",
  args: {
    path: tool.schema.string().describe("Path to the PDF file to read"),
    pages: tool.schema
      .string()
      .optional()
      .describe("Optional page selection like '1-10' or '1,3,8-12'"),
    lang: tool.schema
      .string()
      .optional()
      .default(DEFAULT_LANG)
      .describe("Tesseract language code for OCR fallback, defaults to eng"),
    mode: tool.schema
      .enum(["auto", "paper", "slides", "ocr"])
      .optional()
      .default("auto")
      .describe("Extraction strategy: auto, paper, slides, or ocr"),
    force_ocr: tool.schema
      .boolean()
      .optional()
      .default(false)
      .describe("If true, OCR every selected page instead of using native text extraction"),
    max_pages: tool.schema
      .number()
      .int()
      .positive()
      .optional()
      .default(DEFAULT_MAX_PAGES)
      .describe("Maximum pages to read by default when pages is not specified"),
  },
  async execute(args, context) {
    const pdfPath = resolvePdfPath(args.path, context.directory)
    await ensureReadablePdf(pdfPath)

    context.metadata({
      title: "Read PDF",
      metadata: {
        path: pdfPath,
        mode: args.mode,
      },
    })

    const pdfInfo = await Bun.$`pdfinfo ${pdfPath}`.quiet().text()
    const totalPages = parsePageCount(pdfInfo)
    const selectedPages = parsePageSelection(args.pages, totalPages, args.max_pages)
    const tempDir = await mkdtemp(path.join(os.tmpdir(), "opencode-read-pdf-"))
    const notes: string[] = []
    let nativePages = 0
    let ocrPages = 0

    if (!args.pages && totalPages > args.max_pages) {
      notes.push(
        `Read the first ${args.max_pages} pages by default out of ${totalPages}. Pass pages to read a different range.`,
      )
    }

    try {
      const sections: string[] = []

      for (const page of selectedPages) {
        const layoutText = args.mode === "paper" && !args.force_ocr ? "" : await readPdfText(pdfPath, page, "layout")
        const plainText = args.force_ocr || args.mode === "ocr" ? "" : await readPdfText(pdfPath, page, "plain")

        const preference = choosePreference(args.mode, plainText, layoutText || plainText)
        const nativeRaw = preference === "layout" ? layoutText || plainText : plainText || layoutText
        const nativeNormalized = normalizeForLlm(nativeRaw, preference)
        const shouldUseOcr = args.force_ocr || args.mode === "ocr" || looksWeak(nativeNormalized)

        let method: "native" | "ocr" = "native"
        let finalText = nativeNormalized

        if (shouldUseOcr) {
          const psm = chooseOcrPsm(args.mode, nativeRaw, layoutText || plainText)
          const ocrRaw = await ocrPdfPage(pdfPath, page, args.lang, psm, tempDir)
          const ocrPreference = args.mode === "slides" ? "layout" : "plain"
          const ocrNormalized = normalizeForLlm(ocrRaw, ocrPreference)
          finalText = looksWeak(ocrNormalized) ? "[No reliable text detected]" : ocrNormalized
          method = "ocr"
        }

        if (method === "ocr") {
          ocrPages += 1
        } else {
          nativePages += 1
        }

        sections.push(`--- Page ${page} (${method}) ---`)
        sections.push(finalText || "[No text detected]")
      }

      const relativePath = path.relative(context.worktree, pdfPath) || pdfPath
      const header = [
        `PDF: ${relativePath}`,
        `Pages read: ${selectedPages.join(", ")}`,
        `Mode: ${args.mode}`,
        `Extraction summary: ${nativePages} native, ${ocrPages} OCR`,
        ...notes,
        "",
      ]

      return [...header, ...sections].join("\n")
    } finally {
      await rm(tempDir, { recursive: true, force: true })
    }
  },
})
