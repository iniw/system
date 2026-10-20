{
  homeManagerModule = { config, lib, ... }: {
    xdg = {
      desktopEntries.claude-code-url-handler = {
        name = "Claude Code URL Handler";
        exec = "${lib.getExe config.programs.claude-code.finalPackage} --handle-uri %u";
        noDisplay = true;
        mimeType = [ "x-scheme-handler/claude-cli" ];
      };

      mimeApps.defaultApplications = {
        "x-scheme-handler/claude" = "com.anthropic.Claude.desktop";
        "x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop";
        "x-scheme-handler/codex" = "chatgpt.desktop";
      };
    };
  };
}
