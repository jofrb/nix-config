# TODO

- [ ] `programs.zoxide`
- [ ] `programs.neovim` with `defaultEditor = true`
- [ ] `programs.ssh`: `ControlMaster auto` + `ControlPersist 10m` (everything is currently off)
- [ ] `sops-nix` or `agenix` for secrets (strutserver IP/user are plaintext in `home.nix`; low value, good exercise)
- [ ] `nix-homebrew`: declarative Homebrew install with pinned taps (removes brew assumption from `bootstrap.sh`)
- [ ] `networking.hostName` / `computerName` in `system.nix`
- [ ] Scheduled workflow using `DeterminateSystems/update-flake-lock` (Dependabot only covers Actions, not `flake.lock`)
- [ ] More `nix flake init -t` templates next to `templates/dev-shell` (python/uv, node, rust)
- [ ] Generate ghostty config from Nix and share colours with starship/tmux/bat (`stylix` or a Catppuccin flag)
- [ ] Zsh startup time: `brew shellenv` and `lsof -U | awk` run on every shell; use a fixed socket path or cache; measure with `zprof`
- [ ] Add `checks` / `devShells` outputs to the flake: devShell with `statix`, `deadnix`, `nixfmt` and `git-hooks.nix` so local checks match CI
- [ ] GC/optimise despite `nix.enable = false`: `launchd.daemons.nix-gc` running `nix-collect-garbage --delete-older-than 14d` weekly, plus `nix store optimise` (or `auto-optimise-store` in `/etc/nix/nix.custom.conf`)
- [ ] git: `fetch.prune = true`
- [ ] git: `diff.algorithm = "histogram"`
- [ ] git: SSH commit signing (`gpg.format = "ssh"`, `signing.signByDefault`, add the key to GitHub as a signing key)
- [ ] `home.sessionVariables`: `EDITOR`, `PAGER`, `BAT_THEME`, `MANPAGER`
- [ ] `xdg.enable = true` (see notes below)
- [ ] Split `home.nix` into `modules/home/*.nix` (start with starship + tmux; only when it starts to hurt)
- [ ] Dotfiles into Nix: `programs.git.ignores`, `programs.gh.settings` (never `hosts.yml`), `programs.zed-editor` (check Zed writing to its own settings.json vs read-only symlink)
- [ ] Dotfiles into Nix: `programs.gpg` + `services.gpg-agent` (config only, never the keyring)
- [ ] Dotfiles into Nix: `~/.aws/config` (config only, check for account IDs first), podman `containers.conf`/`registries.conf`
- [ ] Secrets via sops-nix/agenix: `~/.npmrc` (plaintext `_authToken` for Artifact Registry; consider rotating), `~/.pgpass.dev`, `~/.pgpass.prod`
- [ ] Clean up stale files: `.zprofile.backup`, `.gnupg_pre_2.1`, `.hawtjni`, `.ServiceHub`, `.node_repl_history`, `.viminfo`, `.zcompdump-*`, `~/.ssh/config.bak`, `~/.ssh/known_hosts.old` (inspect before deleting)
- [ ] `system.defaults.CustomUserPreferences` for GUI apps (Magnet, Raycast, Hyperkey): anything set in the GUI but not exported is lost on reinstall
- [ ] Secrets encryption: `age-plugin-yubikey` (PIV slot, PIN + touch) plus a second recipient (plain age key in Bitwarden or a 2nd YubiKey) so a lost key is not fatal; prefer `agenix` over `sops-nix` if it is more ergonomic with the plugin on darwin
- [ ] Portability goal: whole machine reproducible from the repo (see notes below)

## Notes

### xdg.enable
`xdg.enable = true` makes Home Manager export `XDG_CONFIG_HOME` etc. and lets modules put files under `~/.config`, `~/.local/share`, `~/.cache`, `~/.local/state`. It does not move files by itself; each program must support XDG, or be told via env vars / options.
