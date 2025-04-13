# See /modules/nixos/* for actual settings
# This file is just *top-level* configuration.
{ inputs, ... }:
{
  imports = [ "${inputs.self}/modules/nixos" ];

  # TODO: if this gets too complex/long, modularize into folders
}
