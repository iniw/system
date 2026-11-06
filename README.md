# system

My NixOS and nix-darwin configurations. Each directory in `hosts/` is one host.

## Bootstrapping a host

On NixOS:

```sh
nixos-rebuild switch --elevate sudo --flake github:iniw/system#$host --option extra-experimental-features pipe-operators
```

On macOS:

```sh
sudo nix --extra-experimental-features 'nix-command flakes' run github:nix-darwin/nix-darwin -- switch --flake github:iniw/system#$host --option extra-experimental-features pipe-operators
```

## Berkeley Mono

The configuration uses Berkeley Mono as the monospace font, but it's a paid font, so Nix doesn't install it. Copy the
`.ttf` files to `~/.local/share/fonts` on NixOS, or to `~/Library/Fonts` on macOS. Until then, programs fall back to
another monospace font.
