#!/usr/bin/env zsh
# =============================================================================
# kms-terminal-profile installer
# 새 맥에서 실행하면 터미널 환경 전체가 세팅됩니다.
# 이미 설치된 환경에서 실행해도 안전합니다 (멱등성 보장).
# =============================================================================

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()    { echo "${BLUE}[INFO]${NC} $1"; }
success() { echo "${GREEN}[OK]${NC}   $1"; }
warn()    { echo "${YELLOW}[WARN]${NC} $1"; }

# 기존 파일을 백업하고 심볼릭 링크를 생성하는 함수
symlink() {
  local src="$1"
  local dst="$2"
  local dst_dir="$(dirname "$dst")"

  mkdir -p "$dst_dir"

  if [ -L "$dst" ]; then
    rm "$dst"
  elif [ -f "$dst" ]; then
    warn "백업: $dst → $dst.bak"
    mv "$dst" "$dst.bak"
  fi

  ln -s "$src" "$dst"
  success "링크: $dst → $src"
}

# =============================================================================
# 1. Homebrew
# =============================================================================
info "Homebrew 확인 중..."
if ! command -v brew &>/dev/null; then
  info "Homebrew 설치 중..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
success "Homebrew 준비 완료"

# =============================================================================
# 2. Brew 패키지 설치 (Brewfile)
# =============================================================================
info "Brew 패키지 설치 중..."
brew bundle --file="$DOTFILES_DIR/Brewfile"
success "Brew 패키지 설치 완료"

# =============================================================================
# 3. oh-my-zsh
# =============================================================================
info "oh-my-zsh 확인 중..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  info "oh-my-zsh 설치 중..."
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
success "oh-my-zsh 준비 완료"

# --- aphrodite 테마 설치 ---
APHRODITE_DST="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/aphrodite.zsh-theme"
if [ ! -f "$APHRODITE_DST" ]; then
  info "aphrodite 테마 설치 중..."
  curl -fsSL \
    "https://raw.githubusercontent.com/alhabish/aphrodite-theme/master/aphrodite.zsh-theme" \
    -o "$APHRODITE_DST"
fi
success "aphrodite 테마 준비 완료"

# =============================================================================
# 4. 설정 파일 심볼릭 링크
# =============================================================================
info "설정 파일 링크 생성 중..."

symlink "$DOTFILES_DIR/shell/.zshrc"     "$HOME/.zshrc"
symlink "$DOTFILES_DIR/shell/.zprofile"  "$HOME/.zprofile"
symlink "$DOTFILES_DIR/ghostty/config"   "$HOME/.config/ghostty/config"
symlink "$DOTFILES_DIR/eza/theme.yml"    "$HOME/.config/eza/theme.yml"

# =============================================================================
# 5. NVM
# =============================================================================
info "NVM 확인 중..."
if [ ! -d "$HOME/.nvm" ]; then
  info "NVM 설치 중..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi
success "NVM 준비 완료"

# =============================================================================
# 6. bun
# =============================================================================
info "bun 확인 중..."
if ! command -v bun &>/dev/null && [ ! -f "$HOME/.bun/bin/bun" ]; then
  info "bun 설치 중..."
  curl -fsSL https://bun.sh/install | bash
fi
success "bun 준비 완료"

# =============================================================================
# 7. fzf 셸 통합
# =============================================================================
info "fzf 셸 통합 설정 중..."
if [ ! -f "$HOME/.fzf.zsh" ]; then
  "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish
fi
success "fzf 준비 완료"

# =============================================================================
# 완료
# =============================================================================
echo ""
echo "${GREEN}===========================================${NC}"
echo "${GREEN}  설치 완료! 터미널을 재시작해 주세요.${NC}"
echo "${GREEN}===========================================${NC}"
echo ""
echo "개인 alias (회사 SSH 등)는 ${YELLOW}~/.zshrc.local${NC} 파일에 추가하세요."
echo "해당 파일은 git에 추적되지 않습니다."
