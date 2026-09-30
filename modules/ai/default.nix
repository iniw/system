{
  homeManagerModule =
    { pkgs, inputs, ... }:
    let
      llm-agents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      programs = {
        codex = {
          enable = true;

          context = ./AGENTS.md;
          skills = ./skills;
        };

        claude-code = {
          enable = true;
          package = llm-agents.claude-code;

          context = ./AGENTS.md;
          skills = ./skills;
        };

        git.ignores = [
          ".agents"
          ".claude"
          ".codex"
        ];
      };

      home.packages =
        let
          inherit (llm-agents) amp chatgpt claude-desktop;
        in
        [
          amp
          chatgpt
          claude-desktop
        ];

      xdg.configFile."amp/AGENTS.md".source = ./AGENTS.md;
    };

  nixosHomeManagerModule = { config, lib, ... }: {
    xdg = {
      desktopEntries.claude-code-url-handler = {
        name = "Claude Code URL Handler";
        exec = "${lib.getExe config.programs.claude-code.finalPackage} --handle-uri %u";
        noDisplay = true;
        mimeType = [ "x-scheme-handler/claude-cli" ];
      };

      mimeApps.defaultApplications = {
        "x-scheme-handler/claude" = "claude-desktop.desktop";
        "x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop";
        "x-scheme-handler/codex" = "chatgpt.desktop";
      };

      # Claude Desktop asks for attention each time its window loses focus, so its taskbar entry is always highlighted.
      # This KWin script clears that request as soon as it is set. Notification pop-ups still show.
      # FIXME: Remove once the bug is fixed.
      # See: https://github.com/anthropics/claude-code/issues/91697
      dataFile = {
        "kwin/scripts/claude-desktop-attention-fix/metadata.json".text = builtins.toJSON {
          KPlugin = {
            Id = "claude-desktop-attention-fix";
            Name = "Claude Desktop attention fix";
            Description = "Stops Claude Desktop from asking for attention when its window loses focus.";
          };
          KPackageStructure = "KWin/Script";
          X-Plasma-API = "javascript";
          X-Plasma-MainScript = "code/main.js";
        };

        "kwin/scripts/claude-desktop-attention-fix/contents/code/main.js".text = # javascript
          ''
            function guard(window) {
              if (window.resourceClass != "com.anthropic.Claude") {
                return;
              }

              window.demandsAttention = false;
              window.demandsAttentionChanged.connect(function () {
                if (window.demandsAttention) {
                  window.demandsAttention = false;
                }
              });
            }

            workspace.windowList().forEach(guard);
            workspace.windowAdded.connect(guard);
          '';
      };
    };

    programs.plasma.configFile.kwinrc.Plugins.claude-desktop-attention-fixEnabled = true;
  };
}
