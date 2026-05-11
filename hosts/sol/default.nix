sys:
sys.darwinSystem (
  { user, ... }:
  {
    # Increase the maximum numbers of opened files.
    # Helps when building all the grammar derivations in helix.
    environment.launchDaemons."limit.maxfiles.plist".text = # xml
      ''
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
          <dict>
            <key>Label</key>
            <string>limit.maxfiles</string>
            <key>ProgramArguments</key>
            <array>
              <string>launchctl</string>
              <string>limit</string>
              <string>maxfiles</string>
              <string>4096</string>
              <string>4096</string>
            </array>
            <key>RunAtLoad</key>
            <true/>
            <key>ServiceIPC</key>
            <false/>
          </dict>
        </plist>
      '';

    home-manager.users.${user}.home.stateVersion = "26.05";
    system.stateVersion = 5;
  }
)
