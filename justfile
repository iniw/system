rebuild-cmd := if os() == 'linux' { "nixos-rebuild" } else { "sudo darwin-rebuild" }
rebuild-cmd-extra-args := if os() == 'linux' { "--use-remote-sudo" } else { "" }

@switch:
    {{ rebuild-cmd }} switch --flake . {{ rebuild-cmd-extra-args }}

@gc:
    sudo nix-collect-garbage --delete-old

@update:
    nix flake update --commit-lock-file --commit-lockfile-summary "flake: update lockfile"
