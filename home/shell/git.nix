{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
{
  options = {
    shell.git = {
      credentialStore = mkOption {
        type = types.enum [
          "libsecret"
          "cache"
          "none"
        ];
        default = "none";
        description = "Credential store for git";
      };

      cacheTimeout = mkOption {
        type = types.ints.positive;
        default = 86400;
        description = "Timeout for cache credential store (if selected)";
      };

      useDeviceOauth = mkEnableOption "Whether to use device OAuth flow" // {
        default = false;
      };
    };
  };

  config = {
    home.packages = with pkgs; [ git-credential-oauth ];

    programs.git = {
      enable = true;

      userName = "Alex Yu";
      userEmail = "yu.alexanderx@gmail.com";

      aliases = {
        amend = "commit --amend";
        br = "branch";
        brd = "branch -D";
        bru = "branch --unset-upstream";
        cam = "commit -am";
        cb = "checkout -b";
        cm = "commit -m";
        co = "checkout";
        cp = "cherry-pick";
        diffh = "diff HEAD";
        dummy = "commit --allow-empty";
        ignore = "update-index --assume-unchanged";
        unignore = "update-index --no-assume-unchanged";
        lg = "log --graph --date=relative --pretty=tformat:'%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%an %ad)%Creset'";
        pls = "pull --rebase";
        rename = "branch -m";
        rs = "reset";
        rsh = "reset --hard";
        sparse = "sparse-checkout";
        st = "stash";
        stat = "status";
        stl = "stash list";
        stls = "stash list --stat";
        stm = "stash -m";
        stp = "stash pop";
        sts = "stash show -p";
        tag-archive = "! BRANCH_NAME=$(git branch --show-current) && git tag -a archive/$BRANCH_NAME -m \"Branch '$BRANCH_NAME' archived as tag\"";
        unstage = "restore --staged";
        upstack = "rebase --update-refs";
        alias = "! git config --get-regexp ^alias\\. | sed -e s/^alias\\.// -e s/\\ /\\ =\\ /";
        count-lines = "! git log --author=\"$1\" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf \"added lines: %s, removed lines: %s, total lines: %s\\n\", add, subs, loc }' #";
      };

      ignores = import ./gitignore.nix;

      lfs.enable = true;

      extraConfig = {
        init = {
          defaultBranch = "main";
        };

        credential.helper =
          (
            if config.shell.git.credentialStore == "libsecret" then
              [ "${pkgs.gitFull}/bin/git-credential-libsecret" ]
            else if config.shell.git.credentialStore == "cache" then
              [ "cache --timeout ${builtins.toString config.shell.git.cacheTimeout}" ]
            else
              [ ]
          )
          ++ [ ("oauth" + (if config.shell.git.useDeviceOauth then " -device" else "")) ];

        core = {
          excludesfile = "$HOME/.gitignore_global";
        };

        pull = {
          ff = "only";
        };

        diff = {
          external = "difft";
          renames = true;
          colorMoved = "default";
        };

        push = {
          autoSetupRemote = true;
        };

        merge = {
          ff = "false";
        };

        include = {
          path = "$HOME/.local/gitconfig";
        };

        rerere = {
          enabled = true;
        };
      };
    };
  };
}
