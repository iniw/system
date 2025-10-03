{
  homeModule = {
    programs = {
      yazi = {
        enable = true;

        keymap.mgr.prepend_keymap = [
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

      helix.settings.keys = {
        normal.ret.e = [
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
  };
}
