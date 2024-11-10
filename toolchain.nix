{ pkgs ? import <nixpkgs> { }, lib ? pkgs.lib, stdenvNoCC ? pkgs.stdenv }:

# cleaned from https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/nr/nrf-command-line-tools/package.nix
let

  supported = {
    x86_64-linux = {
      arch = "linux-x64";
      hash = "sha256-1yvc0e7kHcWiCKigOXa3DQFFEN61iQyehzjoBLoj+YU=";
    };
    aarch64-linux = {
      arch = "linux-arm64";
      hash = "sha256-00000000000000000000000000000000000000000000";
    };
    x86_64-darwin = {
      arch = "darwin-x64";
      hash = "sha256-YmN7ZbpfV7iO4y6/MpFky9my+h1FMZFZUPcHSZp++io=";
    };
    aarch64-darwin = {
      arch = "darwin-x64";
      hash = "sha256-YmN7ZbpfV7iO4y6/MpFky9my+h1FMZFZUPcHSZp++io=";
    };
  };

  platform = supported.${stdenvNoCC.system} or (throw
    "unsupported platform ${stdenvNoCC.system}");

  version = "10.2.0-1.2";
  inherit (platform) arch;

in stdenvNoCC.mkDerivation rec {
  pname = "riscv-none-embed-gcc-xpack";
  inherit version;

  src = pkgs.fetchurl {
    url =
      "https://github.com/xpack-dev-tools/riscv-none-embed-gcc-xpack/releases/download/v${version}/xpack-riscv-none-embed-gcc-${version}-${arch}.tar.gz";
    inherit (platform) hash;
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r * $out

    runHook postInstall
  '';

  nativeBuildInputs = [
    #autoPatchelfHook
  ];
  dontConfigure = true;
  dontBuild = true;

  meta = with lib; {
    homepage = "https://lxgw.github.io/";
    description =
      "An open-source Chinese font derived from Fontworks' Klee One";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ hitsmaxft ];
  };
}

