# T3 Code installation and remote-host intent (2026-11-12)

**2026-11-12 reprioritization:** T3 Code Provider/CLI/service setup on the Mac mini is postponed to **P10**. The application and `t3 v0.1.8` CLI are already present; do not configure accounts, services, Tailscale or VPS/Vancouver nodes during P6. Remote topology remains brainstorm only.


- **Mac mini M4:** `Brewfiles/Brewfile.base` now installs `cask "t3-code"` (Homebrew 0.1.8 at the time of verification). Run `brew bundle --file=Brewfiles/Brewfile.base` as part of a controlled workstation bootstrap; do not use that command only to test the T3 cask, because it also installs unrelated dependencies.
- **Removed:** `brew "herdr"` from Brewfile; Homebrew `herdr` and obsolete `orca` cask uninstalled. The `orca` Homebrew cask was Plotly's abandoned chart renderer, *not* the earlier agent UI concept. The agent concepts Orca and Herdr are not part of the active stack.
- **Global Pi extensions:** the three old `orca-*.ts` and one `herdr-*.ts` were removed from `~/.pi/agent/extensions` auto-discovery, archived under the owner-only `~/.local/state/pi-retired-extensions-20261112`; only `magpie.ts` remains in that directory. Do not re-enable them in a bootstrap script.
- **Theme configuration (2026-11-14):** A portable Cappuccin Contrast theme is now managed in public dotfiles and published locally; see `docs/tools/t3-code.md`. This appearance-only setting does not change the postponed P10 provider/service work.
- **Provider config:** T3 Code is not a substitute for Pi or Magpie/Jev, and installing the app does not authorize new provider credentials.
- **Future remote topology:** Linux VPS is the intended always-on **primary** T3 Code host; the Vancouver i9-13900 / RX6900XT tower is a secondary worker/compute node; Mac mini and iPad are clients via Tailscale, subject to reachable tailnet and device pairing. VPS and desktop installations are TODOs, not claimed active. Use `t3 service install` on a dedicated user after verifying the official CLI, then `t3 serve --tailscale-serve` or approved private pairing. Never publish its service openly by default.
- **Sync:** Obsidian Headless + official Sync is one candidate for a controlled VPS Vault working copy (requires subscription and a migration away from conflicting iCloud/Unison writers); Hindsight/Postgres must have one writable primary and safe backups; Zotero should use its own metadata sync and WebDAV attachment service, **not** SQLite file sync. No sensitive data or credentials migrated yet.
- **Outside China:** Actual Mac/iPad tailnet connectivity from China, alternate remote routes, latency and account compliance need live testing after VPS/desktop access is provisioned.

See [ai-workspace T3 multi-host plan](https://github.com/oldfatcrab/ai-workspace/blob/main/docs/pi-agent-setup/T3-CODE-MULTIHOST-2026-11-12.md) for staged milestones and acceptance.
