{
  homeModule =
    { pkgs-unstable, ... }:
    {
      programs.yazi = {
        enable = true;
        package = pkgs-unstable.yazi;

        keymap = {
          mgr.prepend_keymap = [
            {
              run = ''shell -- ya emit cd "$(git rev-parse --show-toplevel)"'';
              on = [
                "g"
                "r"
              ];
              desc = "Go to git root";
            }
          ];
        };
      };
    };
}
