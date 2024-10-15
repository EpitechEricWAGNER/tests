{ pkgs ? import <nixpkgs> {} , ... } : 
pkgs.mkShell {
    packages = with pkgs; [
    elixir
    postgresql
    awscli2
    terraform
    ];
}
