mod lazy

rebuild-cmd := if os() == 'linux' {
  "nixos-rebuild switch --flake . --use-remote-sudo"
} else {
  "darwin-rebuild switch --flake ."
}

@switch:
  {{rebuild-cmd}}

@gc:
  sudo nix-collect-garbage --delete-old

@update:
  nix flake update --commit-lock-file --commit-lockfile-summary "flake: update lockfile"
