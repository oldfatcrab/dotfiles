# Project Memory

## Current State
- The dotfiles repository has been migrated from Basecamp's Omarchy bash philosophy to a modular Zsh setup on macOS, managed by `chezmoi`.
- The `omarchy/` folder is strictly for **READ-ONLY reference**.
- Zsh is configured modularly using `~/.config/zsh/{env,aliases,functions,init}.zsh`.
- Package management relies on Homebrew, with a separated `Brewfile.base` and `Brewfile.personal`.
- Neovim is configured using LazyVim with static Lua files in `home/dot_config/nvim/`.

## Completed Tasks
- [x] Restructured Brewfiles (Base + Personal).
- [x] Implemented idempotent package installation script (`run_onchange_before_00-install-packages.sh.tmpl`).
- [x] Created Zsh modular architecture based on the `~/.zprofile` and `~/.zshrc` convention.
- [x] Configured Zinit with Turbo Mode for `powerlevel10k`, `zsh-eza`, `fzf-tab`, etc.
- [x] Set up LazyVim structure without dynamically cloning `lazy.nvim` in a script (it bootstraps itself).

## Pending/Future Tasks (TODOs)
- **Linux Support:** Some scripts (e.g., package installation, certain Omarchy functions like `rsyncing/rsw` or drive management) have placeholder `TODO`s for Linux support since the current focus was macOS. These need to be implemented when expanding OS support.
- **Brewfile Personalization:** `Brewfile.personal` currently has `wechat` as a placeholder. The user will edit `Brewfile.base` and `Brewfile.personal` later to better reflect their application needs.
- **Further customization:** Any new tools or aliases should be added to the respective `~/.config/zsh/` modules.

## Important Context for Next Agent
- **Bugs Fixed:** Fixed a bash `set -e` arithmetic evaluation gotcha where `((var++))` exited with 1 when `var` was 0. Also fixed the template paths so `chezmoi apply` runs successfully.
- **Fastfetch positioning:** `fastfetch` runs at the very top of `.zshrc` BEFORE Powerlevel10k instant prompt so console output occurs before p10k captures the terminal output.
- **Documentation & Git Rule:** Agents MUST update markdown files (`README.md`, `MEMORY.md`, `.agents/AGENTS.md`) and create descriptive, atomic git commits after completing work.
- **DO NOT analyze `omarchy/`** directly unless you explicitly need to look up a reference. The migration of its philosophy is largely complete for macOS.
- **Chezmoi variables:** `.is_work_machine` determines if `Brewfile.personal` is used. Template uses `(get . "is_work_machine")` to avoid panicking before `chezmoi init` runs. `.chezmoiroot` is set to `home/`.
- Ensure any includes in templates (like Brewfile hashing) use `../` to escape the `home/` root.
- See `.agents/AGENTS.md` for strict style guidelines and file naming conventions.
- See `README.md` for a comprehensive architecture and project graph.
