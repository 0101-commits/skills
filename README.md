# 0101-commits/skills

Claude Code 스킬/플러그인/에이전트 전체 스택. 새 머신에서 한 번에 설치.

마지막 실측 동기화: **2026-07-31** (플러그인 10개, npx 스킬 66개, 이 저장소 스킬 2개)

설치 경로는 세 가지다:
- **Claude Code 플러그인** — `claude plugin marketplace add` + `claude plugin install`
- **npx skills 패키지** — `npx skills add` (`~/.agents/skills/` 실체 + `~/.claude/skills/` 심링크/정션)
- **독립 CLI 도구** — pip/uv/npm 으로 설치되는 보조 도구 (선택)

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

전제조건: `claude` CLI, `node`/`npx`, `git`, `python`(graphify용, 선택). 설치 후 Claude Code 재시작 또는 `/reload-plugins`.

### 방법 2: npx skills 패키지만

```bash
npx skills@latest add 0101-commits/skills
```

설치 후 Claude Code에서 `/my-stack` 스킬로 전체 설치 안내 확인.

## 이 저장소가 제공하는 스킬

| 스킬 | 내용 |
|------|------|
| `my-stack` | 전체 스택 설치 가이드 |
| `graphify` | 임의 입력(코드·문서·논문·이미지·영상) → 질의 가능한 지식그래프. `/graphify` |

> `graphify`는 [Graphify-Labs/graphify](https://github.com/Graphify-Labs/graphify) (Apache-2.0, pypi `graphifyy`)
> 스킬의 v0.9.31 스냅샷이다. 정식 최신 설치는 `pip install graphifyy && graphify install --platform claude`
> (setup 스크립트가 이 경로를 쓴다). 저장소 사본은 오프라인/버전 고정용.

## Claude Code 플러그인 (10)

| 플러그인 | 마켓플레이스 출처 | 버전 | 상태 | 내용 |
|----------|-------------------|------|------|------|
| `ecc@ecc` | `affaan-m/ECC` (git) | 2.0.0 | 활성 | Everything Claude Code — 250+ 스킬/70+ 에이전트/커맨드 |
| `oh-my-claudecode@omc` | `Yeachan-Heo/oh-my-claudecode` (git) | 4.15.7 | 활성 | 멀티에이전트 오케스트레이션 (autopilot·ralph·ultrawork·team) |
| `superpowers@claude-plugins-official` | 공식 마켓플레이스 | 6.2.0 | 활성 | brainstorming, TDD, systematic-debugging, 플랜/워크트리 |
| `understand-anything@understand-anything` | `Egonex-AI/Understand-Anything` | 2.8.0 | 활성 | 코드베이스 지식그래프/온보딩/투어 |
| `ui-ux-pro-max@ui-ux-pro-max-skill` | `nextlevelbuilder/ui-ux-pro-max-skill` | 2.6.2 | 활성 | 디자인/브랜드/슬라이드/UI 스타일링 |
| `caveman@caveman` | `JuliusBrussee/caveman` | `25d22f8` | 활성 | 초압축 커뮤니케이션 모드 + statusLine |
| `mattpocock-skills@mattpocock` | `mattpocock/skills` | 1.2.0 | 활성 | TDD, 도메인 모델링, 디버깅, 코드리뷰 |
| `andrej-karpathy-skills@karpathy-skills` | `forrestchang/andrej-karpathy-skills` | 1.0.0 | 활성 | Karpathy 코딩 가이드라인 |
| `ponytail@ponytail` | `DietrichGebert/ponytail` | 4.8.4 | **설치됨·비활성** | 코드 리뷰/감사/기술부채 |
| `watch@claude-video` | `bradautomates/claude-video` | 0.1.3 | **설치됨·비활성** | 영상 자막/트랜스크립트 |

비활성 두 개는 `~/.claude/settings.json` 의 `enabledPlugins` 에서 `false`. 켜려면 `true` 로 바꾸거나
`/plugin` 에서 토글.

### 에이전트

`~/.claude/agents/` 는 비어 있다 — 에이전트는 전부 플러그인이 제공한다:
`ecc:*` (언어별 reviewer/build-resolver 70+), `oh-my-claudecode:*` (planner·architect·executor·critic 등),
`caveman:cavecrew-*`, `understand-anything:*`.

## npx skills 패키지 (66 스킬)

| 패키지 | 스킬 수 | 내용 |
|--------|---------|------|
| `coreyhaines31/marketingskills` | 49 | SEO, 카피라이팅, 광고, 이메일, 어트리뷰션, marketing-council 등 |
| `remotion-dev/skills` | 12 | React 영상 제작 (create·render·captions·maps·multimedia·saas 등) |
| `daleseo/korean-skills` | 3 | 한국어 문법 검사, 텍스트 자연화, 스타일 가이드 |
| `Leonxlnx/taste-skill` | 1 | `design-taste-frontend` — 안티-슬롭 프론트엔드 디자인 |
| `0101-commits/skills` | 2 | 이 저장소 (`my-stack`, `graphify`) |

설치 상태의 원천은 `~/skills-lock.json`. 실체는 `~/.agents/skills/<name>/`, Claude Code 는
`~/.claude/skills/<name>` 정션(Windows)/심링크로 참조한다. lock 에는 있는데
`~/.agents/skills/` 에 없으면 설치가 중단된 것 — 해당 패키지를 다시 `add` 하면 복구된다.

### 컨텍스트 절약: skillOverrides

마케팅·한국어 스킬 대부분은 `~/.claude/settings.json` 의 `skillOverrides` 에서 `"off"` 로 꺼 둔다
(50개). 필요할 때만 켠다. 2026-07-31 재설치분(`attribution`, `influencer-marketing`,
`marketing-council`, `marketing-loops`, `remotion-*` 11개, `design-taste-frontend`, `mediabunny`)은
아직 `off` 목록에 없어 활성 상태다.

## 독립 CLI 도구 (선택)

| 도구 | 설치 방법 | 상태 |
|------|-----------|------|
| `graphifyy` 0.9.31 | `pip install graphifyy` | 작동 — CLI + `/graphify` 스킬 배선됨 |
| `headroom-ai` 0.33.0 | `uv tool install --python 3.13 "headroom-ai[all]"` | **미배선** — 프록시 미기동, `ANTHROPIC_BASE_URL` 미설정이라 효과 없음 |
| `@agentmemory/agentmemory` 0.9.27 | `npm i -g @agentmemory/agentmemory` | **미배선** — Windows 에서 `agentmemory connect` 미지원(수동 설치 필요) |
| `oh-my-claude-sisyphus` 4.15.7 | `npm i -g` | OMC npm 경로. `oh-my-claudecode@omc` 플러그인과 기능 중복 |

배선 방법:
```bash
# headroom: 로컬 프록시 상주 + 클라이언트 라우팅
#   주의 — 프록시가 죽으면 Claude Code 요청도 같이 죽는다. 상주 보장 후에만 켤 것.
headroom deploy --port 8787 --mode cache   # 또는: headroom proxy & ; headroom wrap claude
headroom doctor                            # 배선 상태 점검

# agentmemory: Windows 는 수동 — https://github.com/rohitg00/agentmemory#other-agents
agentmemory init && agentmemory status
```

## OMC (oh-my-claudecode) 추가 설정

플러그인 설치만으로는 전역 지침이 붙지 않는다. `~/.claude/CLAUDE-omc.md` 가 있어야 하고
`~/.claude/CLAUDE.md` 에서 `@CLAUDE-omc.md` 로 import 한다. 설치/갱신:

```
/oh-my-claudecode:omc-setup
```

## ECC 전체 설치 (선택)

`ecc@ecc` 플러그인이 ecc 스킬/에이전트/커맨드를 이미 제공한다. rules + hooks + 프레임워크 모듈까지
`~/.claude`에 복사하는 전체 설치는 선택 사항:

기본 언어: `typescript python golang` (전부). `ECC_LANG`로 재정의.

```bash
# bash
ECC_FULL=1 bash scripts/setup.sh                      # typescript python golang
ECC_FULL=1 ECC_LANG=typescript bash scripts/setup.sh  # 특정 언어만
```
```powershell
# PowerShell
$env:ECC_FULL="1"; ./scripts/setup.ps1                       # typescript python golang
$env:ECC_FULL="1"; $env:ECC_LANG="typescript"; ./scripts/setup.ps1
```

수동:
```bash
git clone https://github.com/affaan-m/everything-claude-code.git
cd everything-claude-code
./install.sh typescript python golang   # 여러 언어 동시 설치
```

ECC 훅 주의: `GateGuard` 가 첫 Bash/Write 호출 전 사실 확인을 요구한다. 끄려면 `ECC_GATEGUARD=off`
또는 `ECC_DISABLED_HOOKS=pre:bash:gateguard-fact-force,pre:edit-write:gateguard-fact-force`.

## MCP

`~/.claude` 프로젝트 스코프에 `context7` 1개. 그 밖의 MCP(claude-in-chrome, Notion, Slack,
PlayMCP 등)는 claude.ai 커넥터가 세션에 주입하는 것이라 이 저장소 범위가 아니다.
