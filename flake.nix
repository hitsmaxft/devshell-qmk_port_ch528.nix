{
  description = "A Nix-flake-based C/C++ development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/24.05";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

      forMac = f:
        nixpkgs.lib.genAttrs supportedSystems (system:
          f {
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
              config.segger-jlink.acceptLicense = true;
              config.permittedInsecurePackages = [ "segger-jlink-qt4-794l" ];
            };
          });
      forLinux = f:
        nixpkgs.lib.genAttrs [ "x86_64-linux" ] (system:
          f {
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
              config.segger-jlink.acceptLicense = true;
              config.permittedInsecurePackages = [ "segger-jlink-qt4-794l" ];
            };
          });
    in {
      devShells =
        forLinux ({ pkgs }: { default = pkgs.callPackage ./shell.nix { }; })
        // forMac ({ pkgs }: {
          default = pkgs.callPackage ./shell.nix { isMac = true; };
        })

      ;
    };
}
