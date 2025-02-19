nix-lock := "home/nvim/lazy-lock.nix.json"
nvim-lock := "$XDG_CONFIG_HOME/nvim/lazy-lock.json"

@update:
    nvim --headless "+Lazy! sync" +qa
    cp {{ nvim-lock }} {{ nix-lock }}
    git commit -m "nvim: update lockfile" {{ nix-lock }}

@restore:
    cp {{ nix-lock }} {{ nvim-lock }}
    nvim --headless "+Lazy! restore" +qa

@diff:
    -git diff {{ nix-lock }} {{ nvim-lock }}
