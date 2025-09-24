{
  homeModule =
    { pkgs, pkgs-unstable, ... }:
    {
      programs.helix = {
        enable = true;
        package = pkgs-unstable.helix;

        defaultEditor = true;

        # System-wide LSP support for languages used everywhere.
        extraPackages = [
          # Nix
          pkgs-unstable.nil
          pkgs-unstable.nixfmt
          # Markdown
          pkgs.marksman
          # Toml
          pkgs.taplo
        ];

        settings = {
          theme = {
            dark = "lua";
            light = "sol";
          };

          editor = {
            color-modes = true;
            completion-timeout = 5;
            completion-trigger-len = 1;
            continue-comments = false;
            cursorline = true;
            end-of-line-diagnostics = "hint";
            line-number = "relative";
            trim-final-newlines = true;
            trim-trailing-whitespace = true;

            indent-guides.render = true;

            inline-diagnostics.cursor-line = "hint";

            file-picker.hidden = false;

            soft-wrap.enable = true;

            lsp.goto-reference-include-declaration = false;
          };

          keys = {
            normal = {
              A-w = "move_next_sub_word_start";
              A-e = "move_next_sub_word_end";
              A-b = "move_prev_sub_word_start";
              X = "extend_line_above";
              "*" = "search_selection";
              "A-*" = "search_selection_detect_word_boundaries";
              tab = "move_parent_node_end";
              S-tab = "move_parent_node_start";

              space = {
                f = "file_picker_in_current_directory";
                F = "file_picker";
                e = "file_explorer_in_current_buffer_directory";
                E = "file_explorer_in_current_directory";
              };

              g = {
                C-d = [
                  "vsplit"
                  "jump_view_up"
                  "goto_definition"
                ];
                C-S-d = [
                  "vsplit"
                  "jump_view_up"
                  "goto_declaration"
                ];
                C-y = [
                  "vsplit"
                  "jump_view_up"
                  "goto_type_definition"
                ];
                C-i = [
                  "vsplit"
                  "jump_view_up"
                  "goto_implementation"
                ];
              };

              ret = {
                e = [
                  '':sh rm -f /tmp/yazi-chooser-file''
                  '':insert-output yazi %{buffer_name} --chooser-file=/tmp/yazi-chooser-file''
                  '':insert-output echo "[?1049h[?2004h" > /dev/tty''
                  '':open %sh{cat /tmp/yazi-chooser-file}''
                  '':redraw''
                  '':set mouse false''
                  '':set mouse true''
                ];
              };

            };

            select = {
              A-w = "extend_next_sub_word_start";
              A-e = "extend_next_sub_word_end";
              A-b = "extend_prev_sub_word_start";
              X = "extend_line_above";
              "*" = "search_selection";
              "A-*" = "search_selection_detect_word_boundaries";
              tab = "extend_parent_node_end";
              S-tab = "extend_parent_node_start";
            };

            insert = {
              "A-;" = "flip_selections";
              S-tab = "move_parent_node_start";
              C-h = "move_char_left";
              C-j = "move_line_down";
              C-k = "move_line_up";
              C-l = "move_char_right";
            };
          };
        };

        themes =
          let
            theme =
              {
                shade-1,
                shade-2,
                shade-3,
                shade-4,
                shade-5,
                shade-6,
                shade-7,
                shade-8,

                primary,
                secondary,

                blue,
                green,
                red,
                yellow,
              }:
              {
                "ui.background".bg = shade-8;
                "ui.background.separator".fg = shade-2;

                "ui.cursor".fg = shade-1;
                "ui.cursor".modifiers = [ "reversed" ];
                "ui.cursor.match".bg = shade-6;
                "ui.cursor.primary".fg = primary;
                "ui.cursor.primary".modifiers = [ "reversed" ];

                "ui.cursorcolumn.primary".bg = shade-7;
                "ui.cursorcolumn.secondary".bg = shade-7;

                "ui.cursorline.primary".bg = shade-7;
                "ui.cursorline.secondary".bg = shade-7;

                "ui.gutter".bg = shade-8;
                "ui.gutter.selected".fg = primary;
                "ui.gutter.selected".bg = shade-8;

                "ui.help".fg = shade-1;
                "ui.help".bg = shade-8;

                "ui.highlight".fg = primary;

                "ui.linenr".fg = shade-5;
                "ui.linenr.selected".fg = primary;
                "ui.linenr.selected".bg = shade-8;

                "ui.menu".fg = shade-1;
                "ui.menu".bg = shade-6;
                "ui.menu.scroll".fg = shade-4;
                "ui.menu.scroll".bg = shade-5;
                "ui.menu.selected".fg = primary;
                "ui.menu.selected".bg = shade-7;

                "ui.picker.header".fg = secondary;
                "ui.picker.header.active".fg = primary;
                "ui.picker.header.active".bg = shade-5;

                "ui.popup".fg = shade-1;
                "ui.popup".bg = shade-6;

                "ui.selection".bg = shade-6;
                "ui.selection.primary".bg = shade-6;
                "ui.selection.primary".modifiers = [ "bold" ];

                "ui.statusline".fg = shade-2;
                "ui.statusline".bg = shade-6;
                "ui.statusline.inactive".fg = shade-4;
                "ui.statusline.inactive".bg = shade-6;
                "ui.statusline.insert".fg = shade-6;
                "ui.statusline.insert".bg = primary;
                "ui.statusline.normal".fg = shade-2;
                "ui.statusline.normal".bg = shade-6;
                "ui.statusline.select".fg = shade-8;
                "ui.statusline.select".bg = secondary;

                "ui.text".fg = shade-1;
                "ui.text.directory".fg = shade-4;
                "ui.text.focus".bg = shade-7;
                "ui.text.inactive".fg = shade-4;

                "ui.virtual.indent-guide".fg = shade-5;
                "ui.virtual.inlay-hint".fg = shade-5;
                "ui.virtual.inlay-hint.parameter".fg = shade-5;
                "ui.virtual.inlay-hint.type".fg = shade-5;
                "ui.virtual.jump-label".fg = primary;
                "ui.virtual.jump-label".modifiers = [ "bold" ];
                "ui.virtual.ruler".bg = shade-5;
                "ui.virtual.whitespace".fg = shade-5;

                "ui.window".fg = shade-6;

                "attribute".fg = shade-3;
                "comment".fg = shade-4;
                "constant".fg = primary;
                "constant.builtin".fg = primary;
                "constant.builtin.character".fg = primary;
                "constant.builtin.character.escape".fg = shade-1;
                "constant.builtin.numeric".fg = primary;
                "constructor".fg = shade-2;
                "function".fg = shade-2;
                "keyword".fg = shade-4;
                "keyword.operator".fg = primary;
                "label".fg = primary;
                "namespace".fg = shade-3;
                "number_literal".fg = primary;
                "operator".fg = primary;
                "punctuation".fg = secondary;
                "punctuation.bracket".fg = secondary;
                "punctuation.delimiter".fg = shade-4;
                "punctuation.special".fg = primary;
                "special".fg = primary;
                "special".modifiers = [ "bold" ];
                "string".fg = primary;
                "tag".fg = shade-3;
                "type".fg = shade-2;
                "type.builtin".fg = shade-2;
                "variable".fg = shade-1;

                "markup.bold".fg = shade-2;
                "markup.bold".modifiers = [ "bold" ];
                "markup.heading".fg = shade-2;
                "markup.italic".fg = shade-2;
                "markup.italic".modifiers = [ "italic" ];
                "markup.link.text".fg = shade-2;
                "markup.link.url".fg = primary;
                "markup.list".fg = shade-3;

                "markup.quote".fg = shade-3;
                "markup.quote".modifiers = [ "italic" ];

                "markup.raw".fg = shade-2;

                "diff.delta".fg = blue;
                "diff.minus".fg = red;
                "diff.plus".fg = green;

                "diagnostic".fg = shade-5;
                "diagnostic.error".underline.style = "dotted";
                "diagnostic.hint".underline.style = "dotted";
                "diagnostic.info".underline.style = "dotted";
                "diagnostic.warning".underline.style = "dotted";

                "error".fg = red;
                "hint".fg = blue;
                "info".fg = blue;
                "warning".fg = yellow;
              };
          in
          {
            lua = theme {
              shade-1 = "#f2f2f2";
              shade-2 = "#cccccc";
              shade-3 = "#999999";
              shade-4 = "#666666";
              shade-5 = "#4d4d4d";
              shade-6 = "#333333";
              shade-7 = "#1a1a1a";
              shade-8 = "#0d0d0d";

              primary = "#73b6e6";
              secondary = "#cfdce6";

              blue = "#73b6e6";
              green = "#b6e673";
              red = "#e67373";
              yellow = "#e6bf73";
            };

            sol = theme {
              shade-1 = "#0d0d0d";
              shade-2 = "#262626";
              shade-3 = "#666666";
              shade-4 = "#808080";
              shade-5 = "#bfbfbf";
              shade-6 = "#d9d9d9";
              shade-7 = "#e6e6e6";
              shade-8 = "#f2f2f2";

              primary = "#0061a6";
              secondary = "#73b4e6";

              blue = "#0061a6";
              green = "#61a600";
              red = "#a60000";
              yellow = "#a66f00";
            };
          };

        languages = {
          language-server = {
            clangd.args = [
              "--query-driver=**"
              "--header-insertion=never"
              "--clang-tidy"
              "--background-index"
            ];

            tinymist.config = {
              formatterMode = "typstyle";
              preview.background = {
                enabled = true;
                args = [
                  "--data-plane-host=127.0.0.1:23635"
                  "--invert-colors=never"
                  "--open"
                ];
              };
            };

            rust-analyzer.config = {
              cargo = {
                features = "all";
                targetDir = true;
              };
              files.exclude = [
                ".git"
                ".jj"
                "target"
                "node_modules"
              ];
            };

            biome = {
              command = "npx";
              args = [
                "biome"
                "lsp-proxy"
              ];
            };

            vtsls = {
              command = "npx";
              args = [
                "vtsls"
                "--stdio"
              ];
              config = {
                hostInfo = "helix";
                typescript.inlayHints = {
                  enumMemberValues.enabled = true;
                  functionLikeReturnTypes.enabled = true;
                  parameterNames.enabled = "literals";
                  parameterTypes.enabled = true;
                  propertyDeclarationTypes.enabled = true;
                  variableTypes.enabled = true;
                };
                typescript.updateImportsOnFileMove.enabled = "always";
                vtsls = {
                  autoUseWorkspaceTsdk = true;
                  experimental.maxInlayHintLength = 30;
                };
              };
            };

            vscode-css-language-server = {
              command = "npx";
              args = [
                "vscode-css-language-server"
                "--stdio"
              ];
            };

            vscode-html-language-server = {
              command = "npx";
              args = [
                "vscode-html-language-server"
                "--stdio"
              ];
            };

            vscode-json-language-server = {
              command = "npx";
              args = [
                "vscode-json-language-server"
                "--stdio"
              ];
            };

            tailwindcss-ls = {
              command = "npx";
              args = [
                "tailwindcss-language-server"
                "--stdio"
              ];
            };
          };

          language = [
            {
              name = "c";
              auto-format = true;
            }
            {
              name = "cpp";
              auto-format = true;
            }
            {
              name = "nix";
              auto-format = true;
            }
            {
              name = "python";
              auto-format = true;
              language-servers = [
                "pyright"
                "ruff"
              ];
            }
            {
              name = "sql";
              auto-format = true;
              formatter = {
                command = "pg_format";
                args = [ "-" ];
              };
            }
            {
              name = "toml";
              auto-format = true;
            }
            {
              name = "typst";
              auto-format = true;
            }
            {
              name = "css";
              auto-format = true;
              language-servers = [
                {
                  name = "vscode-css-language-server";
                  except-features = [ "format" ];
                }
                "biome"
                "tailwindcss-ls"
              ];
            }
            {
              name = "json";
              auto-format = true;
              language-servers = [
                {
                  name = "vscode-json-language-server";
                  except-features = [ "format" ];
                }
                "biome"
              ];
            }
            {
              name = "jsonc";
              auto-format = true;
              language-servers = [
                {
                  name = "vscode-json-language-server";
                  except-features = [ "format" ];
                }
                "biome"
              ];
            }
            {
              name = "html";
              auto-format = true;
              language-servers = [
                "vscode-html-language-server"
                "tailwindcss-ls"
              ];
            }
            {
              name = "javascript";
              auto-format = true;
              language-servers = [
                {
                  name = "vtsls";
                  except-features = [ "format" ];
                }
                "biome"
              ];
            }
            {
              name = "jsx";
              auto-format = true;
              language-servers = [
                {
                  name = "vtsls";
                  except-features = [ "format" ];
                }
                "biome"
                "tailwindcss-ls"
              ];
            }
            {
              name = "typescript";
              auto-format = true;
              language-servers = [
                {
                  name = "vtsls";
                  except-features = [ "format" ];
                }
                "biome"
              ];
            }
            {
              name = "tsx";
              auto-format = true;
              language-servers = [
                {
                  name = "vtsls";
                  except-features = [ "format" ];
                }
                "biome"
                "tailwindcss-ls"
              ];
            }
          ];
        };
      };

      programs.git.ignores = [ ".helix" ];
    };
}
