{
  homeManagerModule =
    { pkgs, ... }:
    {
      programs = {
        claude-code = {
          enable = true;
          package = pkgs.llm-agents.claude-code;

          context = ./ai/AGENTS.md;
          skills = ./ai/skills;

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

          context = ./ai/AGENTS.md;
          skills = ./ai/skills;
        };

        opencode = {
          enable = true;
          package = pkgs.llm-agents.opencode;

          context = ./ai/AGENTS.md;
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

        git.ignores = [
          ".agents"
          ".claude"
          ".codex"
        ];
      };

      home.sessionVariables.OPENCODE_DISABLE_LSP_DOWNLOAD = "true";

      # amp
      home.packages = [ pkgs.llm-agents.amp ];
      xdg.configFile."amp/AGENTS.md".source = ./ai/AGENTS.md;
    };
}
