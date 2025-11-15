{ config, pkgs, ... }:

{
  # Power Management & Lid Switch - Simplified for stability
  services.logind = {
    settings.Login = {
      HandleLidSwitch = "suspend"; # Simple suspend only, no hibernation
      HandleLidSwitchExternalPower = "ignore"; # Don't suspend when on external power
      HandleLidSwitchDocked = "ignore"; # Don't suspend when docked (external monitor)
    };
  };

  # UPower for battery management
  services.upower = {
    enable = true;
    percentageLow = 20;
    percentageCritical = 5;
    percentageAction = 3;
    criticalPowerAction = "Hibernate";
  };
}
