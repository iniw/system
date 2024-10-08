@switch:
  darwin-rebuild switch --flake .

@gc:
  sudo nix-collect-garbage --delete-old

@update:
  nix flake update --commit-lock-file --commit-lockfile-summary "flake: update lockfile"

