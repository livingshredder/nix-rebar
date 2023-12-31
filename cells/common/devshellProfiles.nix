{ inputs, cell, }:
let
  inherit (inputs) nixpkgs;
  inherit (inputs.cells.lib.functions.devshells) pkgCategories;
  inherit (nixpkgs.stdenv) isLinux;

  l = inputs.nixpkgs.lib // builtins;
  cats = pkgCategories [ "formatting" "ops" "utils" "tests" ];

  commonCommands = [
    (cats.formatting nixpkgs.deadnix { })
    (cats.formatting nixpkgs.nixfmt { })
    (cats.formatting nixpkgs.nodePackages.prettier { })
    (cats.formatting nixpkgs.statix { })

    (cats.ops nixpkgs.colmena { })

    (cats.utils inputs.ragenix.packages.ragenix { })
    (cats.utils nixpkgs.cachix { })
    (cats.utils inputs.home.packages.default { })
    (cats.utils nixpkgs.just { })
    (cats.utils nixpkgs.nix-diff { })
    (cats.utils nixpkgs.nix-eval-jobs { })
    (cats.utils nixpkgs.nix-tree { })
    (cats.utils nixpkgs.nvd { })
    (cats.utils nixpkgs.shellcheck { })

    (cats.tests inputs.nixt.packages.default { })
  ];

  linuxCommands = l.optionals isLinux [
    (cats.utils inputs.deploy-rs.packages.deploy-rs { })
    (cats.utils inputs.nixos-generators.packages.nixos-generate { })
  ];
in {
  default = _: {
    commands = commonCommands ++ linuxCommands;

    env = [
      {
        name = "REBAR_SYS_DRV";
        eval = "/nix/var/nix/profiles/system";
      }
      {
        name = "REBAR_HOME_DRV";
        eval = "/nix/var/nix/profiles/per-user/$USER/home-manager";
      }
    ];

    packages = with nixpkgs; [ ];
  };
}
