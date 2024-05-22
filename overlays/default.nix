{
  # Add your overlays here
  #
  # my-overlay = import ./my-overlay;
  lceda-pro = (final: prev: {
    lceda-pro = final.callPackage ../pkgs/lceda-pro.nix {};
  });
}
