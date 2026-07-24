{ config, pkgs, ... }:

{
  # Replace 'to' with your username
  home.username = "to";
  home.homeDirectory = "/home/to";

  # Set stateVersion to the NixOS version you started with
  home.stateVersion = "24.05"; 

  # User-specific packages
  home.packages = with pkgs; [
    # Packages for your user account only (e.g., neofetch, htop, etc.)
  ];

  # Manage programs declaratively
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "tolemariamfufat";
        email = "tolemariamfufat@gmail.com";
      };
    };
  };

  # Let Home Manager manage itself
  programs.home-manager.enable = true;
}
