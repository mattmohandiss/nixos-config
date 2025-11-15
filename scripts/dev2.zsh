dev2() {
  if [ $# -lt 1 ]; then
    echo "Usage: dev <zoxide-query>"
    return 1
  fi

  local dir
  dir=$(zoxide query "$1") || { echo "No match"; return 1; }

  kitty --directory "$dir" nvim &
  kitty --directory "$dir" &
  kitty --directory "$dir" gemini &
}
