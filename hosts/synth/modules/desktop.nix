{
  homeManagerModule = {
    # synth is a headless OrbStack container, so there is no session bus where
    # Home Manager can activate GNOME dconf settings.
    dconf.enable = false;
  };
}
