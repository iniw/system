$env.config.keybindings ++= [
  {
    name: fzf_command_picker
    modifier: control
    keycode: char_r
    mode: emacs
    event: {
      send: executehostcommand
      cmd: "commandline edit --replace (
          history
        | get command
        | reverse
        | uniq
        | str join (char -i 0)
        | fzf --scheme=history
              --height=~30%
              --read0
              --query (commandline)
        | decode utf-8
        | str trim
      )"
    }
  },
  {
    name: fzf_file_picker
    modifier: control
    keycode: char_t
    mode: emacs
    event: {
      send: executehostcommand
      cmd: "commandline edit --insert (
        fzf --scheme=path
            --height=~30%
            --preview='bat --style=plain {}'
      )"
    }
  },
]

# Workaround ghostty hiding our prompt when resizing the window
# See: https://github.com/ghostty-org/ghostty/discussions/3476
$env.config.shell_integration.osc133 = false

$env.config.show_banner = false

$env.config.use_kitty_protocol = true
