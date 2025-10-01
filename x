#!/usr/bin/env nu

const root = path self .

# A helper for managing the nix system.
# Runs the `switch` subcommand by default.
def main [] {
  main switch
}

# Build and switch to the new configuration.
def --wrapped "main switch" [...$args] {
  match (sys host | get name) {
    "Darwin" => (sudo darwin-rebuild switch --flake $root ...$args)
    "Linux" => (nixos-rebuild switch --use-remote-sudo --flake $root ...$args)
  }
}

# Build the configuration without switching to it.
def --wrapped "main build" [...$args] {
  match (sys host | get name) {
    "Darwin" => (darwin-rebuild build --flake $root ...$args)
    "Linux" => (nixos-rebuild build --flake $root ...$args)
  }
}

# Collect garbage for the entire system and delete previous generations.
def --wrapped "main gc" [...$args] {
  sudo nix-collect-garbage --delete-old ...$args
}

# Update the flake's inputs and make a commit out of the changes.
def "main update" [] {
  nix flake update --commit-lock-file --commit-lockfile-summary "flake: update lockfile"
}

# Update the flake's brew-related inputs and make a commit out of the changes.
def "main update brew" [] {
  nix flake update nix-homebrew homebrew-core homebrew-cask --commit-lock-file --commit-lock-file-summary "flake: update brew"
}

# Launch a repl for the current system's config.
def --wrapped "main repl" [...$args] {
  let host = match (sys host | get name) {
    "Darwin" => "darwin"
    "Linux" => "nixos"
  }

  nix repl $".#($host)Configurations.(hostname -s)" ...$args
}
