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

def --env grab [path: string] {
    let dir = if ($path ends-with ".git") { # Git repo
        # Extract the repository name from the URL to use as the directory name.
        # e.g: "https://github.com/nushell/nushell.git" becomes "nushell".
        let dir = $path | path parse | get stem

        jj git clone $path $dir --colocate

        $dir
    } else if ($path =~ '^https.*\.(tar\.(gz|bz2|xz))$') { # Archive
        let data = http get $path --raw

        # Determine the output dir by looking at the first entry in the archive.
        let dir = $data | tar --list | lines | first

        # Create the output directory, `tar` doesn't do it automatically.
        mkdir $dir

        # Extract the archive into the output directory, skipping the root folder.
        $data | tar --extract --strip-components 1 --directory $dir

        $dir
    } else { # Directory
        mkdir $path

        $path
    }

    # Go to the output directory.
    cd $dir
}

def nix-system [] {
   nix eval --raw --impure --expr "builtins.currentSystem"
}
