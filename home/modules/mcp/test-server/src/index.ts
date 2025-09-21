#!/usr/bin/env bun
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ErrorCode,
  ListResourcesRequestSchema,
  ListToolsRequestSchema,
  McpError,
  ReadResourceRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';

interface SayHelloArgs {
  name?: string;
}

const isValidSayHelloArgs = (args: any): args is SayHelloArgs =>
  typeof args === 'object' &&
  args !== null &&
  (args.name === undefined || typeof args.name === 'string');

class TestMcpServer {
  private server: Server;

  constructor() {
    this.server = new Server(
      {
        name: 'test-mcp-server',
        version: '1.0.0',
      },
      {
        capabilities: {
          resources: {},
          tools: {},
        },
      }
    );

    this.setupResourceHandlers();
    this.setupToolHandlers();
    
    // Error handling
    this.server.onerror = (error) => console.error('[MCP Error]', error);
    process.on('SIGINT', async () => {
      await this.server.close();
      process.exit(0);
    });
  }

  private setupResourceHandlers() {
    // List available resources
    this.server.setRequestHandler(ListResourcesRequestSchema, async () => ({
      resources: [
        {
          uri: 'test://server/info',
          name: 'Server Information',
          mimeType: 'application/json',
          description: 'Basic information about this test MCP server',
        },
      ],
    }));

    // Handle resource reading
    this.server.setRequestHandler(ReadResourceRequestSchema, async (request) => {
      if (request.params.uri === 'test://server/info') {
        return {
          contents: [
            {
              uri: request.params.uri,
              mimeType: 'application/json',
              text: JSON.stringify(
                {
                  name: 'Test MCP Server',
                  version: '1.0.0',
                  description: 'A simple test server for learning MCP',
                  capabilities: ['tools', 'resources'],
                  runtime: 'Bun',
                  created: new Date().toISOString(),
                },
                null,
                2
              ),
            },
          ],
        };
      }

      throw new McpError(
        ErrorCode.InvalidRequest,
        `Unknown resource: ${request.params.uri}`
      );
    });
  }

  private setupToolHandlers() {
    // List available tools
    this.server.setRequestHandler(ListToolsRequestSchema, async () => ({
      tools: [
        {
          name: 'say_hello',
          description: 'Say hello to someone (or everyone if no name provided)',
          inputSchema: {
            type: 'object',
            properties: {
              name: {
                type: 'string',
                description: 'Name of the person to greet (optional)',
              },
            },
            required: [],
          },
        },
        {
          name: 'get_timestamp',
          description: 'Get the current timestamp',
          inputSchema: {
            type: 'object',
            properties: {},
            required: [],
          },
        },
      ],
    }));

    // Handle tool calls
    this.server.setRequestHandler(CallToolRequestSchema, async (request) => {
      switch (request.params.name) {
        case 'say_hello':
          if (!isValidSayHelloArgs(request.params.arguments)) {
            throw new McpError(
              ErrorCode.InvalidParams,
              'Invalid arguments for say_hello'
            );
          }

          const name = request.params.arguments.name || 'World';
          return {
            content: [
              {
                type: 'text',
                text: `Hello, ${name}! 👋 This greeting comes from your test MCP server running on Bun.`,
              },
            ],
          };

        case 'get_timestamp':
          return {
            content: [
              {
                type: 'text',
                text: `Current timestamp: ${new Date().toISOString()}`,
              },
            ],
          };

        default:
          throw new McpError(
            ErrorCode.MethodNotFound,
            `Unknown tool: ${request.params.name}`
          );
      }
    });
  }

  async run() {
    const transport = new StdioServerTransport();
    await this.server.connect(transport);
    console.error('Test MCP server running on stdio');
  }
}

const server = new TestMcpServer();
server.run().catch(console.error);
