build TARGET:
  rm result
  NIXPKGS_ALLOW_UNFREE=1 nix build .#{{TARGET}} --impure

shell TARGET:
  NIXPKGS_ALLOW_UNFREE=1 nix shell .#{{TARGET}} --impure

alias b := build
alias s := shell

bs TARGET:
  build {{TARGET}}
  shell {{TARGET}}
