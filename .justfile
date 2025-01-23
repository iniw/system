mod lazy

rebuild-cmd := if os() == 'linux' {
  "sudo nixos-rebuild"
} else {
  "darwin-rebuild"
}

@switch:
  {{rebuild-cmd}} switch --flake .

@gc:
  sudo nix-collect-garbage --delete-old

@update:
  nix flake update --commit-lock-file --commit-lockfile-summary "flake: update lockfile"
