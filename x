#!/usr/bin/env nu

const root = path self .

# A helper for managing the nix system.
# Runs the `switch` subcommand by default.
def main [] {
  main switch
}

# Build and switch to the new configuration.
def "main switch" [] {
  match (sys host | get name) {
    "Darwin" => (sudo darwin-rebuild switch --flake $root)
    "Linux" => (nixos-rebuild switch --use-remote-sudo --flake $root)
  }
}

# Build the configuration without switching to it.
def "main build" [] {
  match (sys host | get name) {
    "Darwin" => (darwin-rebuild build --flake $root)
    "Linux" => (nixos-rebuild build --flake $root)
  }
}

# Collect garbage for the entire system and delete previous generations.
def "main gc" [] {
  sudo nix-collect-garbage --delete-old
}

# Update the flake's inputs and make a commit out of the change.
def "main update" [] {
  nix flake update --commit-lock-file --commit-lockfile-summary "flake: update lockfile"
}
