# This is a sample NixOS configuration file which you can import into
# your own configuration.nix in order to enable the TBCO binary cache.

{ config, lib, pkgs, ... }:

{
  nix = {
    binaryCachePublicKeys = [ "hydra.quantumone.network:f/?" "tbco.cachix.org-1:OYKDS3zfcsf4WEVuSTV+XmgaIn1GeclGW0kSFd3G0NU=" ];
    binaryCaches = [ "https://hydra.quantumone.network" "tbco.cachix.org" ];
  };
}
