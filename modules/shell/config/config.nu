# Required for activating a virtualenv-generated python environment
# See: https://github.com/nushell/nushell/issues/14780 and https://github.com/pypa/virtualenv/issues/2838
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

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

# A recreation of oh-my-zsh's `take` function.
#
# Based on the given `url` parameter, it produces an "output folder" by doing one of the following things:
#
# - If given a URL to a git repository, cloning it into the output folder.
# - If given a URL to a tar-compressed archive, downloading it then extracting into the output folder.
# - Otherwise, by treating the URL as a path and creating a directory with it.
#
# Then, after the output folder is produced, it changes the directory to it.
@example "Grab the 'fonts' repo (clone + cd)" { grab git@github.com:iniw/fonts.git }
@example "Grab the 'foo' directory (mkdir + cd)" { grab foo }
def --env grab [url: string]: nothing -> nothing {
    if ($url =~ '(^(https://)?git)|(\.git$)') { # Git repo
        grab git $url
    } else if ($url =~ '^https.*\.(tar\.(gz|bz2|xz))$') { # Archive
        grab tar $url
    } else { # Directory
        grab dir $url
    }
}

# Clones a git repo and cd's into it's output directory.
def --env "grab git" [url: string]: nothing -> nothing {
  # Extract the repository name from the URL to use as the directory name.
  # e.g: "https://github.com/nushell/nushell.git" becomes "nushell".
  let dir = $url | path parse | get stem

  jj git clone $url $dir --colocate

  cd $dir
}

# Downloads and extracts a tar archive and cd's into it's output directory.
def --env "grab tar" [url: string]: nothing -> nothing {
  let data = http get $url --raw

  # Determine the output dir by looking at the first entry in the archive.
  let dir = $data | tar --list | lines | first

  # Create the output directory, `tar` doesn't do it automatically.
  mkdir $dir

  # Extract the archive into the output directory, skipping the root folder.
  $data | tar --extract --strip-components 1 --directory $dir

  cd $dir
}

# Creates a directory and cd's into it.
def --env "grab dir" [path: string]: nothing -> nothing {
  mkdir $path

  cd $path
}

# Interact with the system clipboard from the shell.
#
# When used in a pipeline, it pipes `$in` to the system clipboard handler (pbcopy/wl-copy).
# Otherwise, it simply returns the current clipboard as a string.
@example "Copy the output of a value/command" { ls | klip }
@example "Return the current clipboard" { klip } --result "{clipboard content}"
def klip []: [
  any -> any,
  nothing -> string
] {
  # Save $in to a variable to avoid it being replaced.
  let input = $in;

  let clipboard = match (sys host | get name) {
    "Darwin" => {
      copy: "pbcopy"
      paste: "pbpaste"
    }
    "Linux" => {
      copy: "wl-copy"
      paste: "wl-paste"
    }
  }

  if $input == null {
    ^($clipboard.paste)
  } else {
    $input | ^($clipboard.copy)
  }
}

# Returns the output of the "builtins.currentSystem" nix expression.
@example "Build the default package for a flake" { nix build .#packages.(nix-system).default }
def nix-system [] {
   nix eval --raw --impure --expr "builtins.currentSystem"
}
