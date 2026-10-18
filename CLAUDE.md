# nix-config

nix-darwin + home-manager flake. Profile name is read from `~/.config/nix-darwin-profile` (default `base`).

## Workflow

- Rebuild/activate with `scripts/nrs` (not `darwin-rebuild switch`; see the comment in the script for why).
- Never commit to `main`. Branch, push, open a PR; CI gates on the `ci-ok` job.
- Conventional commit messages (`fix(scope):`, `chore:`, `feat(scope):`, `ci:`).

## Sandbox limits

- Claude can't reach the Nix daemon socket, so `nix build`/`nrs` must be run by the user.
- `git push` and `gh` may be blocked; if so, hand the user the commands.
- When handing over multiple dependent commands, chain them with `&&` in a single code block.
