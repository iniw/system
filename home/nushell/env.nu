# Required for activating a virtualenv-generated python environment
# See: https://github.com/nushell/nushell/issues/14780 and https://github.com/pypa/virtualenv/issues/2838
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

def mc [path: path] {
  mkdir $path
  cd $path
}

def nix-system []: nothing -> string {
   nix eval --raw --impure --expr "builtins.currentSystem"
}
