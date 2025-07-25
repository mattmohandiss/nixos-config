# Test MCP Server

A simple Model Context Protocol (MCP) server for testing and demonstration purposes.

## Features

This server demonstrates basic MCP functionality with:

- **Tools**: 
  - `say_hello` - Greets a person by name (or "World" if no name provided)
  - `get_timestamp` - Returns the current timestamp

- **Resources**:
  - `test://server/info` - Basic information about the server

## Development

- **Run in development mode**: `bun run dev`
- **Start server**: `bun run start`

Both commands run the TypeScript file directly - no compilation needed!

## Testing

You can test the server manually:
```bash
echo '{"jsonrpc": "2.0", "id": 1, "method": "tools/list", "params": {}}' | bun run src/index.ts
```

## Usage with Cline

Once configured, you can test it by asking Cline to:
- Use the `say_hello` tool: "Say hello to me using the test MCP server"
- Use the `get_timestamp` tool: "Get the current timestamp from the test server"
- Access the server info resource: "Show me information about the test MCP server"

## Technical Details

- **Runtime**: Bun (fast JavaScript runtime with built-in TypeScript support)
- **Protocol**: Model Context Protocol (MCP) via stdio transport
- **Language**: TypeScript
- **Dependencies**: @modelcontextprotocol/sdk
