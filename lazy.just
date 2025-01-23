nix-lock := "home/nvim/lazy-lock.nix.json"
nvim-lock := "$XDG_CONFIG_HOME/nvim/lazy-lock.json"

@update:
  nvim --headless "+Lazy! sync" +qa
  cp {{nvim-lock}} {{nix-lock}}
  git commit {{nix-lock}} -m "nvim: update lockfile"

@restore:
  cp {{nix-lock}} {{nvim-lock}}
  nvim --headless "+Lazy! restore" +qa

@diff:
  -git diff {{nix-lock}} {{nvim-lock}}
