$env.config.show_banner = false

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

let carapace_completer = {|spans|
    # if the current command is an alias, get it's expansion
    let expanded_alias = (scope aliases | where name == $spans.0 | get -i 0 | get -i expansion)

    # overwrite
    let spans = (if $expanded_alias != null  {
      # put the first word of the expanded alias first in the span
      $spans | skip 1 | prepend ($expanded_alias | split row " " | take 1)
    } else {
      $spans
    })

    carapace $spans.0 nushell ...$spans
    | from json
    | if ($in | default [] | where value == $"($spans | last)ERR" | is-empty) { $in } else { null }
}

let zoxide_completer = {|spans|
    $spans | skip 1 | zoxide query -l ...$in | lines | each {|line| $line | str replace $env.HOME '~' } | where {|x| $x != $env.PWD}
}

let external_completer = {|spans|
  match $spans.0 {
    z | zi | __zoxide_z | __zoxide_zi => $zoxide_completer
    _ => $carapace_completer
  } | do $in $spans
}

$env.config.completions.external = {
    enable: true
    completer: $external_completer
}

# https://github.com/ghostty-org/ghostty/discussions/3476
$env.config.shell_integration.osc133 = false
