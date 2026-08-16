{ pkgs, ... }:
{
  languages.clojure.enable = true;
  languages.ansible.enable = true;
  languages.opentofu.enable = true;

  packages = with pkgs; [
    awscli2
    babashka
    curl
    doctl
    jq
    openssh
    postgresql_17
  ];
}
