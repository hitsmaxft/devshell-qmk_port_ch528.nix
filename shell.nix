


{ pkgs ? import <nixpkgs> { }, isMac ? false }:
let

  riscv = pkgs.callPackage ./toolchain.nix {};
  ENV_TC_PREFIX = "riscv-none-elf";
  ENV_TC_PATH = (if isMac then "${riscv}/" else "${"$"}ENV_TC_PATH");

  python311Custom = (pkgs.python311.withPackages (python-pkgs:
    with python-pkgs; [
      # select Python packages here
      click
      cbor2
      intelhex
      cryptography
      pyyaml
    ]));
  cmakeWrapper = pkgs.writeShellApplication {
    name = "cmake";
    runtimeInputs = [ pkgs.cmake python311Custom ];
    # export ENV_TC_PATH for gcc in your .envrc
    #${pkgs.cmake}/bin/cmake -DADDITIONAL_TOOLCHAIN_PATH="${"$"}{ENV_TC_PATH}" -DTOOLCHAIN_PREFIX=${ENV_TC_PREFIX}  "${
    text = ''
        echo  running command : ${pkgs.cmake}/bin/cmake -DADDITIONAL_TOOLCHAIN_PATH="${ENV_TC_PATH}" -DTOOLCHAIN_PREFIX=${ENV_TC_PREFIX}  "${
          "$"
        }{@}"
      ${pkgs.cmake}/bin/cmake -DADDITIONAL_TOOLCHAIN_PATH="${ENV_TC_PATH}" -DTOOLCHAIN_PREFIX=${ENV_TC_PREFIX}  "${"$"}{@}"
    '';
  };

in pkgs.mkShell {
  packages = with pkgs;
    [ ccache cmakeWrapper python311Custom ]
    ++ (if isMac then [ riscv ] else [ ]);
  nativeBuildInputs = with pkgs.buildPackages;
    [
      #FIXME use mbedtls in submodule
      mbedtls
    ];
}
