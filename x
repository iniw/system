#!/usr/bin/env nu

const root = path self .

# A helper for managing the nix system.
# Runs the `switch` subcommand by default.
def --wrapped main [...$args] {
  main switch ...$args
}

# Build and switch to the new configuration.
def --wrapped "main switch" [...$args] {
  let host = match (sys host | get name) {
    "Darwin" => "darwin"
    "Linux" => "os"
  }

  nh $host switch $root ...$args
}

# Update the flake's inputs and make a commit out of the changes.
def --wrapped "main update" [...$args] {
  nix flake update --commit-lock-file --commit-lockfile-summary "flake: update lockfile" ...$args
}

# Launch a repl for the current system's config.
def --wrapped "main repl" [...$args] {
  let host = match (sys host | get name) {
    "Darwin" => "darwin"
    "Linux" => "nixos"
  }

  nix repl $".#($host)Configurations.(hostname -s)" ...$args
}
