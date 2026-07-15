# 0101-commits/skills

Claude Code 스킬/플러그인 전체 스택. 새 머신에서 한 번에 설치.

두 가지 설치 경로를 모두 포함한다:
- **Claude Code 플러그인** — `claude plugin marketplace add` + `claude plugin install`
- **npx skills 패키지** — `npx skills add`

## 설치 방법

### 방법 1: 스크립트로 전체 자동 설치 (권장)

**PowerShell:**
```powershell
irm https://raw.githubusercontent.com/0101-commits/skills/main/scripts/setup.ps1 | iex
```

**bash:**
```bash
curl -fsSL https://raw.githubusercontent.com/0101-commits/skills/main/scripts/setup.sh | bash
```

전제조건: `claude` CLI, `node`/`npx`, `git`. 설치 후 Claude Code 재시작 또는 `/reload-plugins`.

### 방법 2: npx skills 패키지만

```bash
npx skills@latest add 0101-commits/skills
```

설치 후 Claude Code에서 `/my-stack` 스킬로 전체 설치 안내 확인.

## 포함된 스킬 (이 저장소)

| 스킬 | 내용 |
|------|------|
| `my-stack` | 전체 스택 설치 가이드 |

## 설치되는 Claude Code 플러그인

| 플러그인 | 마켓플레이스 출처 | 내용 |
|----------|-------------------|------|
| `andrej-karpathy-skills@karpathy-skills` | `forrestchang/andrej-karpathy-skills` | Karpathy 코딩 가이드라인 |
| `superpowers@claude-plugins-official` | 공식 마켓플레이스 | brainstorming, TDD, systematic-debugging, 플랜/워크트리 등 |
| `understand-anything@understand-anything` | `Egonex-AI/Understand-Anything` | 코드베이스 지식그래프/온보딩/투어 |
| `caveman@caveman` | `JuliusBrussee/caveman` | 초압축 커뮤니케이션 모드 |
| `watch@claude-video` | `bradautomates/claude-video` | 영상 자막/트랜스크립트 |
| `ui-ux-pro-max@ui-ux-pro-max-skill` | `nextlevelbuilder/ui-ux-pro-max-skill` | 디자인/브랜드/슬라이드/UI 스타일링 |
| `ponytail@ponytail` | `DietrichGebert/ponytail` | 코드 리뷰/감사/기술부채 |
| `mattpocock-skills@mattpocock` | `mattpocock/skills` | TDD, 도메인 모델링, 디버깅, 코드리뷰 |
| `ecc@ecc` | `affaan-m/ECC` (git) | Everything Claude Code — 250+ 스킬/에이전트/커맨드 |

## 설치되는 npx skills 패키지

| 패키지 | 스킬 수 | 내용 |
|--------|---------|------|
| `daleseo/korean-skills` | 3 | 한국어 문법 검사, 텍스트 자연화, 스타일 가이드 |
| `coreyhaines31/marketingskills` | 45 | SEO, 카피라이팅, 광고, 이메일 등 마케팅 전반 |
| `remotion-dev/skills` | 1 | React 영상 제작 베스트 프랙티스 |
| `Leonxlnx/taste-skill` (`design-taste-frontend`) | 1 | 안티-슬롭 프론트엔드 디자인 |

## ECC 전체 설치 (선택)

`ecc@ecc` 플러그인이 ecc 스킬/에이전트/커맨드를 이미 제공한다. rules + hooks + 프레임워크 모듈까지
`~/.claude`에 복사하는 전체 설치는 선택 사항:

```bash
# bash
ECC_FULL=1 ECC_LANG=typescript bash scripts/setup.sh
```
```powershell
# PowerShell
$env:ECC_FULL="1"; $env:ECC_LANG="typescript"; ./scripts/setup.ps1
```

수동:
```bash
git clone https://github.com/affaan-m/everything-claude-code.git
cd everything-claude-code
./install.sh typescript   # 또는 python, golang (여러 개 동시 가능)
```
