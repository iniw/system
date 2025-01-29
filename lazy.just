nix-lock := "home/nvim/lazy-lock.nix.json"
nix-extras := "home/nvim/lazyvim.nix.json"
nvim-lock := "$XDG_CONFIG_HOME/nvim/lazy-lock.json"
nvim-extras := "$XDG_CONFIG_HOME/nvim/lazyvim.json"

@update:
  nvim --headless "+Lazy! sync" +qa
  cp {{nvim-lock}} {{nix-lock}}
  cp {{nvim-extras}} {{nix-extras}}
  git commit "{{nix-lock}} {{nix-extras}}" -m "nvim: update lockfile"

@restore:
  cp {{nix-lock}} {{nvim-lock}}
  cp {{nix-extras}} {{nvim-extras}}
  nvim --headless "+Lazy! restore" +qa

@diff:
  -git diff {{nix-lock}} {{nvim-lock}}
