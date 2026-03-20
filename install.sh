#!/usr/bin/env zsh
# =============================================================================
# kms-terminal-profile installer
# 새 맥에서 실행하면 터미널 환경 전체가 세팅됩니다.
# 이미 설치된 환경에서 실행해도 안전합니다 (멱등성 보장).
#
# 사용법:
#   ./install.sh
#   ./install.sh --ghostty-theme "Nord" --eza-theme "gruvbox-dark" --omz-theme "robbyrussell"
#
# 옵션:
#   --ghostty-theme  Ghostty 테마 이름 (기본값: Nord Light)
#   --eza-theme      eza 테마 이름 - eza-community/eza-themes 기준 (기본값: frost)
#   --omz-theme      oh-my-zsh 테마 이름 (기본값: aphrodite)
#   --help           도움말 출력
# =============================================================================

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

info()    { echo "${BLUE}[INFO]${NC} $1"; }
success() { echo "${GREEN}[OK]${NC}   $1"; }
warn()    { echo "${YELLOW}[WARN]${NC} $1"; }
error()   { echo "${RED}[ERR]${NC}  $1"; exit 1; }

# =============================================================================
# 파라미터 파싱
# =============================================================================
GHOSTTY_THEME="Nord Light"
EZA_THEME="frost"
OMZ_THEME="aphrodite"

while [[ $# -gt 0 ]]; do
  case $1 in
    --ghostty-theme) GHOSTTY_THEME="$2"; shift 2 ;;
    --eza-theme)     EZA_THEME="$2";     shift 2 ;;
    --omz-theme)     OMZ_THEME="$2";     shift 2 ;;
    --help)
      echo "사용법: ./install.sh [옵션]"
      echo ""
      echo "옵션:"
      echo "  --ghostty-theme  <name>   Ghostty 테마 (기본값: 'Nord Light')"
      echo "  --eza-theme      <name>   eza 테마, eza-community/eza-themes 기준 (기본값: 'frost')"
      echo "  --omz-theme      <name>   oh-my-zsh 테마 (기본값: 'aphrodite')"
      echo ""
      echo "예시:"
      echo "  ./install.sh"
      echo "  ./install.sh --ghostty-theme 'Dracula' --eza-theme 'gruvbox-dark' --omz-theme 'agnoster'"
      exit 0
      ;;
    *) error "알 수 없는 옵션: $1  (--help 로 사용법 확인)" ;;
  esac
done

echo ""
echo "${BLUE}=========================================${NC}"
echo "${BLUE}  kms-terminal-profile 설치 시작${NC}"
echo "${BLUE}=========================================${NC}"
echo "  Ghostty 테마 : ${YELLOW}$GHOSTTY_THEME${NC}"
echo "  eza 테마     : ${YELLOW}$EZA_THEME${NC}"
echo "  omz 테마     : ${YELLOW}$OMZ_THEME${NC}"
echo ""

# =============================================================================
# 유틸: 기존 파일을 백업하고 심볼릭 링크 생성
# =============================================================================
symlink() {
  local src="$1"
  local dst="$2"

  mkdir -p "$(dirname "$dst")"

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
# 3. oh-my-zsh + 테마
# =============================================================================
info "oh-my-zsh 확인 중..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  info "oh-my-zsh 설치 중..."
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
success "oh-my-zsh 준비 완료"

# 커스텀 테마 설치 (built-in 테마가 아닌 경우 다운로드 시도)
OMZ_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
OMZ_THEME_FILE="$OMZ_CUSTOM/themes/${OMZ_THEME}.zsh-theme"
OMZ_BUILTIN="$HOME/.oh-my-zsh/themes/${OMZ_THEME}.zsh-theme"

if [ ! -f "$OMZ_BUILTIN" ] && [ ! -f "$OMZ_THEME_FILE" ]; then
  # aphrodite는 알려진 URL에서 다운로드
  if [ "$OMZ_THEME" = "aphrodite" ]; then
    info "aphrodite 테마 설치 중..."
    curl -fsSL \
      "https://raw.githubusercontent.com/alhabish/aphrodite-theme/master/aphrodite.zsh-theme" \
      -o "$OMZ_THEME_FILE"
  else
    warn "'$OMZ_THEME' 테마 파일을 찾을 수 없습니다. 직접 설치 후 사용하세요."
  fi
fi

# .zshrc의 ZSH_THEME 값 업데이트
sed -i '' "s/^ZSH_THEME=.*/ZSH_THEME=\"${OMZ_THEME}\"/" "$DOTFILES_DIR/shell/.zshrc"
success "omz 테마 설정 완료: $OMZ_THEME"

# =============================================================================
# 4. eza 테마 다운로드
# =============================================================================
info "eza 테마 설정 중: $EZA_THEME"
EZA_THEME_URL="https://raw.githubusercontent.com/eza-community/eza-themes/main/themes/${EZA_THEME}.yml"

if curl -fsSL "$EZA_THEME_URL" -o "$DOTFILES_DIR/eza/theme.yml" 2>/dev/null; then
  success "eza 테마 다운로드 완료: $EZA_THEME"
else
  warn "eza 테마 '$EZA_THEME'를 찾을 수 없습니다. 기존 theme.yml을 유지합니다."
fi

# =============================================================================
# 5. 설정 파일 심볼릭 링크
# =============================================================================
info "설정 파일 링크 생성 중..."

symlink "$DOTFILES_DIR/shell/.zshrc"     "$HOME/.zshrc"
symlink "$DOTFILES_DIR/shell/.zprofile"  "$HOME/.zprofile"
symlink "$DOTFILES_DIR/ghostty/config"   "$HOME/.config/ghostty/config"
symlink "$DOTFILES_DIR/eza/theme.yml"    "$HOME/.config/eza/theme.yml"

# =============================================================================
# 6. Ghostty 테마 적용
# =============================================================================
info "Ghostty 테마 설정 중: $GHOSTTY_THEME"
sed -i '' "s/^theme = .*/theme = ${GHOSTTY_THEME}/" "$DOTFILES_DIR/ghostty/config"
success "Ghostty 테마 설정 완료: $GHOSTTY_THEME"

# =============================================================================
# 7. NVM
# =============================================================================
info "NVM 확인 중..."
if [ ! -d "$HOME/.nvm" ]; then
  info "NVM 설치 중..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi
success "NVM 준비 완료"

# =============================================================================
# 8. bun
# =============================================================================
info "bun 확인 중..."
if ! command -v bun &>/dev/null && [ ! -f "$HOME/.bun/bin/bun" ]; then
  info "bun 설치 중..."
  curl -fsSL https://bun.sh/install | bash
fi
success "bun 준비 완료"

# =============================================================================
# 9. fzf 셸 통합
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
echo "  Ghostty 테마 : ${YELLOW}$GHOSTTY_THEME${NC}"
echo "  eza 테마     : ${YELLOW}$EZA_THEME${NC}"
echo "  omz 테마     : ${YELLOW}$OMZ_THEME${NC}"
echo ""
echo "개인 alias (회사 SSH 등)는 ${YELLOW}~/.zshrc.local${NC} 파일에 추가하세요."
