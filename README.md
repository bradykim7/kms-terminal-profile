# kms-terminal-profile

새 맥에서 터미널 환경을 한 번에 세팅하는 dotfiles 레포입니다.

## 설치

```bash
git clone <this-repo> ~/dotfiles
cd ~/dotfiles
./install.sh
```

## 설치 내용

### Terminal
| 항목 | 내용 |
|------|------|
| **Terminal** | Ghostty (Nord Light 테마, Hack Nerd Font) |
| **Shell** | zsh + oh-my-zsh (aphrodite 테마) |

### CLI Tools
| 명령어 | 도구 | 설명 |
|--------|------|------|
| `ls` / `ll` | eza | 아이콘 + frost 컬러 테마 |
| `cat` | bat | 문법 하이라이팅 |
| `grep` | ripgrep | 빠른 검색 |
| `find` | fd | 간단한 파일 탐색 |
| `cd` | zoxide | 스마트 디렉토리 이동 |

### Dev Tools
| 도구 | 설명 |
|------|------|
| mise | Node, Python 등 런타임 버전 관리 |
| nvm | Node.js 버전 관리 |
| bun | JavaScript 런타임 / 패키지 매니저 |
| gh | GitHub CLI |
| fzf | 퍼지 파인더 (Ctrl+T, Ctrl+R) |
| btop / htop | 시스템 모니터 |

## 구조

```
├── Brewfile          # brew 패키지 목록
├── install.sh        # 설치 스크립트
├── shell/
│   ├── .zshrc        # zsh 설정 + alias 전체
│   └── .zprofile     # Homebrew, OrbStack 초기화
├── ghostty/
│   └── config        # Ghostty 설정 (테마, 폰트, 단축키 등)
└── eza/
    └── theme.yml     # eza gruvbox-dark 컬러 테마
```

## Ghostty 주요 설정

| 설정 | 값 |
|------|----|
| 테마 | Nord Light |
| 폰트 | Hack Nerd Font 14pt |
| Quick Terminal | `Cmd + `` |
| Shell integration | cursor, sudo, title |

## 개인 alias 관리

회사 서버 SSH 등 git에 올리면 안 되는 alias는 `~/.zshrc.local`에 추가하세요.
이 파일은 자동으로 불러와지며 git에 추적되지 않습니다.

```bash
# ~/.zshrc.local 예시
alias myserver='ssh user@192.168.1.100'
alias work='ssh deploy@10.0.0.1'
```
