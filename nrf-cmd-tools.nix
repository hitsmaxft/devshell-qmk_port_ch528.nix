{ pkgs ? import <nixpkgs> { }, lib ? pkgs.lib, stdenvNoCC ? pkgs.stdenv }:
# cleaned from https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/nr/nrf-command-line-tools/package.nix
let

  supported = {
    x86_64-linux = {
      name = "linux-amd64";
      hash = "sha256-nWWw2A/MtWdmj6QVhckmGUexdA9S66jTo2jPb4/Xt5M=";
    };
  };

  platform = supported.${stdenvNoCC.system} or (throw
    "unsupported platform ${stdenvNoCC.system}");

  version = "10.24.2";
  url = let
    versionWithDashes = builtins.replaceStrings ["."] ["-"] version;
  in "https://nsscprodmedia.blob.core.windows.net/prod/software-and-other-downloads/desktop-software/nrf-command-line-tools/sw/versions-${lib.versions.major version}-x-x/${versionWithDashes}/nrf-command-line-tools-${version}_${platform.name}.tar.gz";


in stdenvNoCC.mkDerivation rec {
  pname = "nrf-command-line-tools-github";
  inherit version;

  src = pkgs.fetchurl {
    inherit url;
    inherit (platform) hash;
  };

    runtimeDependencies = [
    segger-jlink
  ];

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    udev
    libusb1
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    rm -rf ./python
    mkdir -p $out
    cp -r * $out

    runHook postInstall
  '';


  meta = with lib; {
    homepage = "https://www.nordicsemi.com/Products/Development-tools/nRF-Command-Line-Tools/Download?lang=en#infotabs";
    description = "The nRF Command Line Tools is used for development, programming and debugging of Nordic Semiconductor's nRF51, nRF52, nRF53 and nRF91 Series devices.";
    license = licenses.unlicense;
    platforms = platforms.all;
    maintainers = with maintainers; [ hitsmaxft ];
  };
}

