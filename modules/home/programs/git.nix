{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  c = config.hm.programs.git;
in
{
  options.hm.programs.git = {
    enable = mkEnableOption "enable default git configuration for user";
  };
  
  config = mkIf c.enable {
    programs.git = {
      enable = true;
      lfs = {
        enable = true;
        skipSmudge = true;
      };
      settings = {
        init.defaultBranch = "main";
        repack.usedeltabaseoffset = "true";
        color.ui = "auto";
        help.autocorrect = 10;
        diff = {
          algorithm = "histogram"; # a much better diff
          colorMoved = "default";
          mnemonicprefix = true;
        };
        core.whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
        # QoL
        branch = {
          autosetupmerge = "true";
          sort = "committerdate";
        };
        commit.verbose = true;
        fetch.prune = true;
        # if a remote does not have a branch that i have, create it
        push.autoSetupRemote = true;
        # nicer diffing for merges
        merge = {
          stat = "true";
          conflictstyle = "zdiff3";
          tool = "meld";
        };
        rebase = {
          # https://andrewlock.net/working-with-stacked-branches-in-git-is-easier-with-update-refs/
          updateRefs = true;
          autoSquash = true;
          autoStash = true;
        };
        rerere = {
          enabled = true;
          autoupdate = true;
        };
        # prevent data corruption
        transfer.fsckObjects = true;
        fetch.fsckObjects = true;
        receive.fsckObjects = true;
      };
    };
  };
}
