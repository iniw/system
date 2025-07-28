[macos]
@switch:
    # First build the derivation (without sudo) then activate it manually (using sudo).
    # This allows using the user's ssh keys to fetch private inputs (e.g: fonts).
    # Doing a straight `sudo darwin-rebuild switch` would fail cloning them since it'd try using root's ssh keys.
    # See: https://github.com/nix-darwin/nix-darwin/issues/1460
    # NOTE: We don't `build` followed by `switch` because that builds the system twice, which is stupid.
    #       Instead, we manually run the resulting activation script, which achieves the same thing.
    darwin-rebuild build --flake .

    # The `switch` action also does this. I'm not sure how important it is but we should probably do it too.
    # See: https://github.com/nix-darwin/nix-darwin/blob/e04a388232d9a6ba56967ce5b53a8a6f713cdfcf/pkgs/nix-tools/darwin-rebuild.sh#L241
    nix-env --set "$(readlink -f ./result)"

    sudo ./result/activate

[linux]
@switch:
    # Unlike `darwin-rebuild`, `nixos-rebuild` has a `--use-remote-sudo` flag that makes it only escalate on activation,
    # meaning it uses the the correct ssh keys during build time, which is exactly what we want.
    nixos-rebuild switch --use-remote-sudo --flake .

@gc:
    sudo nix-collect-garbage --delete-old

@update:
    nix flake update --commit-lock-file --commit-lockfile-summary "flake: update lockfile"
