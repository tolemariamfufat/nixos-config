# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader, Silent Plymouth Boot, and Hardware Freeze Fixes
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    loader.timeout = 0; # Press Space on boot to reveal systemd-boot menu

    # Early KMS for Intel iGPU (Prevents sleep/wake graphics freezes)
    initrd.kernelModules = [ "i915" ];

    # Graphical splash screen
    plymouth = {
      enable = true;
      theme = "bgrt"; # Uses OEM motherboard vendor logo
    };

    # Silent boot & ACPI Deep Sleep Configuration
    initrd.systemd.enable = true;
    initrd.verbose = false;
    initrd.systemd.emergencyAccess = true;
    consoleLogLevel = 0;

    kernelParams = [
      "mem_sleep_default=deep"
      "quiet"
      "splash"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
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

  # Set your time zone & locale
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

  # Enable X11 & GNOME
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Thermal Management & Compressed Swap
  services.thermald.enable = true;
  zramSwap.enable = true;

  # Keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable Printing & Audio (Pipewire)
  services.printing.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define User Account
  users.users."to" = {
    isNormalUser = true;
    description = "to";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [];
  };

  # Nix Settings & Unfree Packages
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

  # Hyprland & UWSM Integration
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  # Zsh & Oh My Zsh
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
