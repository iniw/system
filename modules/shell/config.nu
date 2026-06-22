$env.config.keybindings ++= [
  {
    name: unfreeze_job
    modifier: control
    keycode: char_z
    mode: emacs
    event: {
      send: executehostcommand
      cmd: "job unfreeze"
    }
  },
]

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
    if ($url =~ '^(https://)?git|\.git$') { # Git repo
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

  jj git clone $url $dir

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
    "NixOS" => {
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
def nix-system []: nothing -> string {
   nix eval --raw --impure --expr "builtins.currentSystem"
}

# Converts every flac file in the given folder to alac/m4a.
def flac2alac [folder: path]: nothing -> nothing {
  glob ($folder | path join "**" "*.flac") --no-dir
  | group-by { |file| $file | path dirname }
  | items { |folder, flacs|
    cd $folder

    let flacs = $flacs | path basename
    $flacs | each { |file| xld -f alac $file } | ignore
    rm ...$flacs

    print $"Converted flacs in '($folder)'"
  }
  | ignore
}

# Like `which`, but it opens the resulting paths with `yazi`.
def yich [...applications: string]: nothing -> nothing {
  y ...(which ...$applications | get path)
}
