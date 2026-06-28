# Golson's MacOS ZSH Setup

2026 Revamped version of dotfiles

## Usage 

for lazy ones like me:
```
git clone https://github.com/oldfatcrab/dotfiles.git $HOME/.dotfiles --recurse-submodules
cd $HOME/.dotfiles
source setup.sh
```
and don't bother with the following...

---

Or if you want to set it up manually and/or make your preferred modification, follow these steps...

## Step 0: Quick setups I recommend everyone should do after getting a new Mac

### Homebrew
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
then follow the instructions to write into zshrc/zprofile

### Brew install:

```
brew install bash bat bat-extras btop chafa claude-code-router docker eza fastfetch fd ffmpeg-full fzf gcc gh hermes-agent imagemagick-full jq lazydocker lazygit make mise neovim ollama poppler resvg ripgrep rustup sevenzip starship stow tree-sitter-cli uv yazi yq zellij zoxide

brew link ffmpeg-full imagemagick-full -f --overwrite

brew install --cask 1password 1password-cli alfred antigravity antigravity-cli antigravity-ide audacity brave-browser chatgpt claude-code codex cursor discord docker-deskpop dropbox font-hack-nerd-font font-meslo-lg-nerd-font font-symbols-only-nerd-font ghostty github google-chrome obsidian signal spotify steam surfshark tailscale-app typora virtualbox visual-studio-code wechat whatsapp zoom

brew tap FelixKratz/formulae
brew install borders sketchybar

brew tap PeachlifeAB/tap
brew install --cask hyprspace
hyprspace init

```

After installing 1password, set up op cli.
