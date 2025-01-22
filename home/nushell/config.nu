let fzf_command_picker = {
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
    | str join \"\\n\"
    | fzf --scheme=history
          --height=~30%
          -q (commandline)
    )"
  }
}

let fzf_file_picker = {
  name: fzf_file_picker
  modifier: control
  keycode: char_t
  mode: emacs
  event: {
    send: executehostcommand
    cmd: "commandline edit --insert (
      fzf --scheme=path
          --height=~30%
          --preview='bat --color=always --style=auto {}'
    )"
  }
}

$env.config.keybindings = [
  $fzf_command_picker,
  $fzf_file_picker,
]

$env.config.show_banner = false
