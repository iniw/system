{
  homeManagerModule = {
    xdg.dataFile = {
      # Claude Desktop asks for attention each time its window loses focus, so its taskbar entry is always highlighted.
      # This KWin script clears that request as soon as it is set. Notification pop-ups still show.
      # FIXME: Remove once the bug is fixed.
      # See: https://github.com/anthropics/claude-code/issues/91697
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

      # At login, the autostarted apps open their windows about two seconds before plasmashell shows the top panel.
      # KWin centers those windows on the whole screen, and when the panel appears and the work area shrinks, it
      # doesn't move them, so they end up half a panel above the center. This KWin script centers them again in the
      # new work area, unless they have moved since they opened.
      "kwin/scripts/recenter-after-panels-launch/metadata.json".text = builtins.toJSON {
        KPlugin = {
          Id = "recenter-after-panels-launch";
          Name = "Re-center after panels launch";
          Description = "Centers the windows that opened before the panels again once the panels appear.";
        };
        KPackageStructure = "KWin/Script";
        X-Plasma-API = "javascript";
        X-Plasma-MainScript = "code/main.js";
      };

      "kwin/scripts/recenter-after-panels-launch/contents/code/main.js".text = # javascript
        ''
          // KWin also loads the script when it's enabled in the middle of a session, after the panels exist.
          // There is nothing to fix then.
          if (!workspace.stackingOrder.some((window) => window.dock)) {
            const initialArea = workspace.clientArea(KWin.PlacementArea, workspace.activeScreen, workspace.currentDesktop);

            // The windows that opened before the panels, with their geometry and work area at that time.
            let opened = [];

            function track(window) {
              if (window.normalWindow) {
                opened.push({
                  window: window,
                  geometry: window.frameGeometry,
                  area: workspace.clientArea(KWin.PlacementArea, window),
                });
              }
            }

            function untrack(window) {
              opened = opened.filter((entry) => entry.window != window);
            }

            function recenter(dock) {
              // Other docks, such as tray icons, can appear before the panels without changing the work area.
              const screenArea = workspace.clientArea(KWin.PlacementArea, workspace.activeScreen, workspace.currentDesktop);
              if (!dock.dock || (screenArea.x == initialArea.x && screenArea.y == initialArea.y
                && screenArea.width == initialArea.width && screenArea.height == initialArea.height)) {
                return;
              }

              for (const { window, geometry, area } of opened) {
                const current = window.frameGeometry;
                const moved = current.x != geometry.x || current.y != geometry.y
                  || current.width != geometry.width || current.height != geometry.height;
                const centered = Math.abs(geometry.x - (area.x + (area.width - geometry.width) / 2)) < 1
                  && Math.abs(geometry.y - (area.y + (area.height - geometry.height) / 2)) < 1;
                if (moved || !centered || window.maximizeMode != 0 || window.fullScreen) {
                  continue;
                }

                // Rounds down like KWin's "Move Window to the Center" shortcut, so that the shortcut doesn't move the
                // window again.
                const newArea = workspace.clientArea(KWin.PlacementArea, window);
                window.frameGeometry = {
                  x: Math.floor(newArea.x + (newArea.width - current.width) / 2),
                  y: Math.floor(newArea.y + (newArea.height - current.height) / 2),
                  width: current.width,
                  height: current.height,
                };
              }

              // Once the first panel exists, KWin places new windows in the right work area, so the script stops.
              opened = [];
              workspace.windowAdded.disconnect(track);
              workspace.windowAdded.disconnect(recenter);
              workspace.windowRemoved.disconnect(untrack);
            }

            workspace.stackingOrder.forEach(track);
            workspace.windowAdded.connect(track);
            workspace.windowAdded.connect(recenter);
            workspace.windowRemoved.connect(untrack);
          }
        '';
    };

    programs.plasma.configFile.kwinrc.Plugins = {
      claude-desktop-attention-fixEnabled = true;
      recenter-after-panels-launchEnabled = true;
    };
  };
}
