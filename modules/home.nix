{
  pkgs,
  lib,
  config,
  ...
}:

{
  home.stateVersion = "25.05";
  home.username = "froeb";
  home.homeDirectory = "/Users/froeb";

  # ── PATH additions ────────────────────────────────────────────────────────────
  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  # ── Environment variables ─────────────────────────────────────────────────────
  home.sessionVariables = {
    DOCKER_DEFAULT_PLATFORM = "linux/amd64";
    LANG = "en_US.UTF-8";
  };

  # ── CLI packages ─────────────────────────────────────────────────────────────
  home.packages = with pkgs; [
    bat # better cat
    eza # better ls
    fd # better find
    fzf # fuzzy finder
    gh # GitHub CLI
    bottom # process viewer (binary: btm)
    wget
    jq # JSON processor
    ripgrep # better grep
    statix # nix linters
    deadnix # nix linters
    nix-output-monitor # better nix build output (nom)
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
      nrs = "sudo darwin-rebuild switch --flake ~/.config/nix-config#$(scutil --get LocalHostName) |& nom";
      nfmt = "nix fmt ~/.config/nix-config";
      nlint = "statix check ~/.config/nix-config && deadnix ~/.config/nix-config";
      t = "tmux";
      ta = "tmux attach || tmux new -s main";
      tn = "tmux new -s";
      tls = "tmux list-sessions";
      tk = "tmux kill-session -t";
      cat = "bat";
      ls = "eza --icons";
      ll = "eza -lah --icons";
      find = "fd";
      gst = "git status";
      gcmsg = "git commit -m";
      ga = "git add ";
      gaa = "git add .";
      gco = "git checkout";
      gcm = "git checkout main";
      gcb = "git checkout -b";
      gp = "git push";
      gpf = "git push --force-with-lease";
      gl = "git pull";
      gd = "git diff";
      glog = "git log --oneline --graph --decorate --all";
      grb = "git rebase";
      grbi = "git rebase -i";
      grba = "git rebase --abort";
      grbc = "git rebase --continue";
      "gcn!" = "git commit --amend --no-edit";
    };

    initContent = ''
      # Homebrew
      eval "$(/opt/homebrew/bin/brew shellenv)"

      # Bitwarden SSH agent — resolve socket dynamically regardless of distribution/Team ID
      # Requires: Bitwarden Desktop → Settings → SSH Agent → enabled
      _bw_sock=$(lsof -U 2>/dev/null | awk '/bitwarden-ssh-agent\.sock/ {print $NF; exit}')
      if [[ -S "$_bw_sock" ]]; then
        export SSH_AUTH_SOCK="$_bw_sock"
      fi
    '';
  };

  # ── Tmux ──────────────────────────────────────────────────────────────────────
  programs.tmux = {
    enable = true;
    mouse = true;
    historyLimit = 50000;
    keyMode = "vi";
    prefix = "C-a";
    terminal = "screen-256color";

    extraConfig = ''
      # ── Splits ────────────────────────────────────────────────────────────────────────
      bind-key -n 'M-|' split-window -h -c "#{pane_current_path}"
      bind-key -n 'M-_' split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %

      # ── Pane navigation (no prefix needed) ──────────────────────────────────────────
      bind-key -n C-h select-pane -L
      bind-key -n C-j select-pane -D
      bind-key -n C-k select-pane -U
      bind-key -n C-l select-pane -R

      # ── Copy mode vim bindings ───────────────────────────────────────────────────────────
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi V send-keys -X select-line
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
    '';

    plugins = with pkgs.tmuxPlugins; [
      resurrect
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '10'
        '';
      }
    ];
  };

  # ── starship prompt ───────────────────────────────────────────────────────────
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;

      # What shows on each line and in what order
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_status"
        "$nodejs"
        "$docker_context"
        "$nix_shell"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];

      right_format = lib.concatStrings [
        "$battery"
        "$time"
      ];

      directory = {
        style = "bold blue";
        truncation_length = 3;
        truncate_to_repo = true; # shortens path inside git repos
      };

      git_branch = {
        symbol = " ";
        style = "bold purple";
        format = "[$symbol$branch]($style) ";
      };

      git_status = {
        ahead = "⇡$count";
        behind = "⇣$count";
        diverged = "⇕⇡$ahead_count⇣$behind_count";
        modified = "!$count";
        untracked = "?$count";
        staged = "+$count";
        deleted = "✘$count";
        style = "bold red";
      };

      nix_shell = {
        symbol = " ";
        style = "bold cyan";
        format = "[$symbol$state( \\($name\\))]($style) ";
      };

      cmd_duration = {
        min_time = 2000; # only show if command took >2 seconds
        format = "[took $duration](bold yellow) ";
      };

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };

      username = {
        show_always = false; # only show when SSH or root
        style_user = "bold green";
        style_root = "bold red";
        format = "[$user]($style) ";
      };

      hostname = {
        ssh_only = true;
        style = "bold yellow";
        format = "[@$hostname]($style) ";
      };

      nodejs = {
        symbol = " ";
        style = "bold green";
        format = "[$symbol$version]($style) ";
      };

      docker_context = {
        symbol = " ";
        style = "bold blue";
        format = "[$symbol$context]($style) ";
        only_with_files = true;
      };

      battery = {
        full_symbol = "󰁹 ";
        charging_symbol = "󰂄 ";
        discharging_symbol = "󰂃 ";
        format = "[$symbol$percentage]($style) ";
        display = [
          {
            threshold = 20;
            style = "bold red";
          }
          {
            threshold = 40;
            style = "bold yellow";
          }
          {
            threshold = 75;
            style = "bold green";
          }
        ];
      };

      time = {
        disabled = false;
        format = "[🕐 $time]($style) ";
        style = "dimmed white";
        time_format = "%H:%M";
      };
    };
  };

  # ── git ───────────────────────────────────────────────────────────────────────
  programs.git = {
    enable = true;
    settings = {
      user.name = "Johan Fröb";
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
  # ── Cheat script ──────────────────────────────────────────────────────────────
  home.file.".local/bin/cheat" = {
    source = ../scripts/cheat;
    executable = true;
  };

  home.file."Library/Application Support/com.mitchellh.ghostty/config.ghostty".source =
    ../configs/ghostty;
}
