# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader & Hardware Freeze Fixes (Verbose Boot)
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    loader.timeout = 5; # Shows systemd-boot generation menu for 5 seconds

    # Early KMS for Intel iGPU (Prevents sleep/wake graphics freezes)
    initrd.kernelModules = [ "i915" ];

    # ACPI Deep Sleep Fix (Kept for sleep stability without forcing quiet boot)
    kernelParams = [
      "mem_sleep_default=deep"
    ];
  };

  # System Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    font-awesome
  ];

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Time zone & locale
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Desktop Environment & Display Manager
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Thermal Management & Compressed Swap
  services.thermald.enable = true;
  zramSwap.enable = true;

  # Printing & Audio (Pipewire)
  services.printing.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # User Account
  users.users."to" = {
    isNormalUser = true;
    description = "to";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [];
  };

  # Nix Settings & Flakes
  programs.firefox.enable = false;
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # System Packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    (brave.override { commandLineArgs = [ "--password-store=basic" ]; })
    libreoffice-fresh
    gnome-extension-manager
    gnomeExtensions.forge
    gnome-tweaks
    ghostty
    fastfetch
  ];

  # Hyprland Integration with UWSM
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true; # Enables UWSM session support for systemd & GDM
  };

  # Zsh Configuration
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    ohMyZsh = {
      enable = true;
      plugins = [ "git" "sudo" ];
      theme = "robbyrussell";
    };

    shellAliases = {
      nswitch = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
      gstatus = "git status";
    };

    interactiveShellInit = ''
      gpush() {
        git add .
        git commit -m "$1"
        git push
      }
    '';
  };

  system.stateVersion = "24.05";
}
