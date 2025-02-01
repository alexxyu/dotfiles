{ config, pkgs, ... }:
{
  config = {
    home.packages = [ pkgs.zsh-powerlevel10k ];

    home.file = {
      ".zsh/zshrc".source = ./zshrc;

      ".zsh/completion/_docker".source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/docker/cli/358d4996818ff3b5c4ae518323d02771e52fa9c9/contrib/completion/zsh/_docker";
        hash = "sha256-wsuSNFsCDZF7VI9Sjshmf0Hr4bJUmq/Sh9b7EqOzA9A=";
      };
    };

    home.sessionVariables = {
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=146,underline";
      WORDCHARS = "*?.[]~=&;!#$%^(){}<>";
    };

    programs.fzf.enableZshIntegration = true;
    programs.mise.enableZshIntegration = true;
    programs.thefuck.enableZshIntegration = true;
    programs.zoxide.enableZshIntegration = true;

    programs.zsh = {
      enable = true;

      enableCompletion = true;

      initExtraFirst = ''
        # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
        # Initialization code that may require console input (password prompts, [y/n]
        # confirmations, etc.) must go above this block; everything else may go below.
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '';

      initExtraBeforeCompInit = ''
        fpath+="$HOME/.zsh/completion"
      '';

      initExtra = ''
        source ~/.zsh/zshrc
      '';

      shellAliases = {
        la = "ls -a";
        ls = "ls -lhp --color --group-directories-first";
      };

      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/zsh_history";

        expireDuplicatesFirst = true;
        ignoreAllDups = true;
        ignoreDups = true;
        share = true;
      };

      plugins = [
        {
          name = "zsh-autosuggestions";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-autosuggestions";
            rev = "v0.7.0";
            sha256 = "KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
          };
        }
        {
          name = "zsh-syntax-highlighting";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-syntax-highlighting";
            rev = "0.8.0";
            sha256 = "iJdWopZwHpSyYl5/FQXEW7gl/SrKaYDEtTH9cGP7iPo=";
          };
        }
        {
          name = "fzf-tab";
          src = pkgs.fetchFromGitHub {
            owner = "Aloxaf";
            repo = "fzf-tab";
            rev = "v1.1.2";
            sha256 = "Qv8zAiMtrr67CbLRrFjGaPzFZcOiMVEFLg1Z+N6VMhg=";
          };
        }
        {
          name = "jq-zsh-plugin";
          file = "jq.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "reegnz";
            repo = "jq-zsh-plugin";
            rev = "v0.6.1";
            sha256 = "sha256-q/xQZ850kifmd8rCMW+aAEhuA43vB9ZAW22sss9e4SE=";
          };
        }
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src = ./p10k;
          file = "p10k.zsh";
        }
        {
          name = "powerlevel10k-mise-config";
          src = ./p10k;
          file = "p10k.mise.zsh";
        }
      ];
    };
  };
}
