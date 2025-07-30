[macos]
@switch:
    sudo darwin-rebuild switch --flake .

[linux]
@switch:
    nixos-rebuild switch --use-remote-sudo --flake .

@gc:
    sudo nix-collect-garbage --delete-old

@update:
    nix flake update --commit-lock-file --commit-lockfile-summary "flake: update lockfile"
