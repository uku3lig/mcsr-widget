let
  pkgs = import <nixpkgs> { };
in
pkgs.mkShellNoCC {
  packages = [
    pkgs.nodejs
    pkgs.pnpm
  ];
}
