{ pkgs ? import <nixpkgs> {} }:
let

          toolchain = pkgs.callPackage ./toolchain.nix { };

          ENV_TC_PATH = "${toolchain}/bin";
          ENV_TC_PREFIX = "riscv-none-embed";

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
            name = "cmake-nix";
            runtimeInputs = [ pkgs.cmake python311Custom ];
            text = ''
              cmake -DADDITIONAL_TOOLCHAIN_PATH=${ENV_TC_PATH} -DTOOLCHAIN_PREFIX=${ENV_TC_PREFIX}  "${
                "$"
              }{@}"
            '';
          };

in
  pkgs.mkShell {
    packages = with pkgs; [
      cmake
      ccache
      python311Custom
      cmakeWrapper
    ];
    nativeBuildInputs = with pkgs.buildPackages; [
      mbedtls
    ];
  }
