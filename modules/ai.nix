{
  homeManagerModule =
    { pkgs, ... }:
    {
      programs = {
        claude-code = {
          enable = true;
          package = pkgs.llm-agents.claude-code;

          enableMcpIntegration = true;

          memory.source = ./ai/AGENTS.md;
          skillsDir = ./ai/skills;

          lspServers = {
            rust = {
              command = "rust-analyzer";
              settings = {
                cargo = {
                  features = "all";
                  targetDir = true;
                };
              };
              extensionToLanguage = {
                ".rs" = "rust";
              };
            };

            cpp = {
              command = "clangd";
              args = [
                "--query-driver=**"
                "--clang-tidy"
              ];
              extensionToLanguage = {
                ".cpp" = "cpp";
                ".hpp" = "cpp";
                ".c" = "cpp";
                ".h" = "cpp";
              };
            };

            typescript = {
              command = "vtsls";
              extensionToLanguage = {
                ".ts" = "typescript";
                ".tsx" = "typescriptreact";
                ".js" = "javascript";
                ".jsx" = "javascriptreact";
              };
            };
          };
        };

        codex = {
          enable = true;
          package = pkgs.llm-agents.codex;

          enableMcpIntegration = true;

          custom-instructions = builtins.readFile ./ai/AGENTS.md;
          skills = ./ai/skills;
        };

        opencode = {
          enable = true;
          package = pkgs.llm-agents.opencode;

          enableMcpIntegration = true;

          rules = ./ai/AGENTS.md;
          skills = ./ai/skills;

          settings = {
            lsp.rust = {
              command = [ "rust-analyzer" ];
              initialization = {
                cargo = {
                  features = "all";
                  targetDir = true;
                };
              };
            };

            permission.external_directory = {
              "~/work/**" = "allow";
            };
          };
        };

        mcp = {
          enable = true;

          servers = {
            linear.url = "https://mcp.linear.app/mcp";
          };
        };

        git.ignores = [
          ".agents/"
          ".claude/"
          ".codex/"
        ];
      };

      home = {
        packages = with pkgs.llm-agents; [
          amp
        ];

        sessionVariables = {
          OPENCODE_DISABLE_LSP_DOWNLOAD = "true";
        };
      };
    };
}
