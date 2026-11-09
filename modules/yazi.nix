{
  homeManagerModule = {
    programs = {
      yazi = {
        enable = true;

        settings.mgr.show_hidden = true;

        keymap.mgr.prepend_keymap = [
          {
            run = ''shell -- ya emit cd "$(jj workspace root)"'';
            on = [
              "g"
              "r"
            ];
            desc = "Go to repository root";
          }
        ];
      };

      nushell.extraConfig = # nu
        ''
          # Like `which`, but it opens the resulting paths with `yazi`.
          def yhich [
          ...applications: string
          --all (-a) # List all executables.
          ]: nothing -> nothing {
            y ...(which --all=$all ...$applications | get path)
          }
        '';
    };
  };
}
