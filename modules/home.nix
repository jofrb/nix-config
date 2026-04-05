{ pkgs, lib, config, ... }:

{
  home.stateVersion = "25.05";
  home.username = "froeb";
  home.homeDirectory = "/Users/froeb";

  # ── CLI packages ─────────────────────────────────────────────────────────────
  home.packages = with pkgs; [
    bat       # better cat
    eza       # better ls
    fd        # better find
    fzf       # fuzzy finder
    gh        # GitHub CLI
    bottom    # process viewer (binary: btm)
    jq        # JSON processor
    ripgrep   # better grep
    pkgs.nerd-fonts.jetbrains-mono
  ];

  # ── zsh ──────────────────────────────────────────────────────────────────────
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    dotDir = "${config.xdg.configHome}/zsh";

    history = {
      size = 50000;
      save = 50000;
      ignoreAllDups = true;
      share = true;
    };

    shellAliases = {
      nrs = "sudo darwin-rebuild switch --flake ~/.config/nix-config#$(scutil --get LocalHostName)";
      cat = "bat";
      ls  = "eza --icons";
      ll  = "eza -lah --icons";
      find  = "fd";
      gst = "git status";
      gco = "git checkout";
      gcb = "git checkout -b";
      gp  = "git push";
      gpf = "git push --force-with-lease";
      gl  = "git pull";
      gd  = "git diff";
      glog = "git log --oneline --graph --decorate --all";
      grb = "git rebase";
      grbi = "git rebase -i";
      grba = "git rebase --abort";
      grbc = "git rebase --continue";
      "gcn!" = "git commit --amend --no-edit";
    };
  };

  # ── Tmux ──────────────────────────────────────────────────────────────────────
  programs.tmux = {
    enable = true;
    mouse = true;  # enables mouse scrolling
  };

  # ── starship prompt ───────────────────────────────────────────────────────────
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;

      # What shows on each line and in what order
      format = lib.concatStrings [
        "$directory"
        "$git_branch"
        "$git_status"
        "$nix_shell"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];

      directory = {
        style              = "bold blue";
        truncation_length  = 3;
        truncate_to_repo   = true;   # shortens path inside git repos
      };

      git_branch = {
        symbol = " ";
        style  = "bold purple";
        format = "[$symbol$branch]($style) ";
      };

      git_status = {
        ahead    = "⇡$count";
        behind   = "⇣$count";
        diverged = "⇕⇡$ahead_count⇣$behind_count";
        modified = "!$count";
        untracked = "?$count";
        staged   = "+$count";
        deleted  = "✘$count";
        style    = "bold red";
      };

      nix_shell = {
        symbol  = " ";
        style   = "bold cyan";
        format  = "[$symbol$state( \\($name\\))]($style) ";
      };

      cmd_duration = {
        min_time = 2000;       # only show if command took >2 seconds
        format   = "[took $duration](bold yellow) ";
      };

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol   = "[❯](bold red)";
      };
    };
  };

  # ── git ───────────────────────────────────────────────────────────────────────
  programs.git = {
    enable = true;
    settings = {
      user.name  = "Johan Fröb";
      user.email = "johan@froeb.se";
      pull.rebase = true;
      push.autoSetupRemote = true;
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      init.defaultBranch = "main";
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      side-by-side = true;
      line-numbers = true;
    };
  };

  # ── direnv + nix-direnv ───────────────────────────────────────────────────────
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # ── atuin ─────────────────────────────────────────────────────────────────────
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
  };

  # ── Application configs  ─────────────────────────────────────────────────────
  home.file."Library/Application Support/com.mitchellh.ghostty/config.ghostty".source = ../configs/ghostty;
}
