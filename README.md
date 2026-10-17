# 0101-commits/skills

Claude Code 스킬/플러그인/에이전트 전체 스택. 새 머신에서 한 번에 설치.

마지막 실측 동기화: **2026-10-16** (플러그인 11개 중 6개 켬, npx 스킬 70개 + CLI 딸림 스킬 12개, 그중 77개 끔)

설치 경로는 세 가지다:
- **Claude Code 플러그인** — `claude plugin marketplace add` + `claude plugin install`
- **npx skills 패키지** — `npx skills add` (`~/.agents/skills/` 실체 + `~/.claude/skills/` 심링크/정션)
- **CLI 도구** — pip/uv/npm 으로 설치. 일부는 자기 스킬을 같이 깐다 (`onyx-cli`, `21st`, `playwright-cli`, `rea`)

setup 스크립트는 설치에서 끝나지 않고 마지막에 `scripts/apply-state.js` 로 **켜짐/꺼짐을 기준 PC와
똑같이 맞춘다** — 플러그인 6개 켬·5개 끔, 스킬 77개 `skillOverrides: "off"`. 목록에 없는 키는
건드리지 않고, 실행 전 `settings.json` 을 타임스탬프 백업한다. 여러 번 돌려도 결과가 같다.

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

전제조건: `claude` CLI, `node`/`npx`, `git`, `uv` 또는 `pip`(graphify·scrapling·onyx-cli용). 설치 후 Claude Code 재시작 또는 `/reload-plugins`.

스크립트 단계: `[1/5]` 플러그인 → `[2/5]` npx 스킬 패키지 → `[3/5]` CLI 도구(graphify·scrapling·onyx-cli) →
`[4/5]` 켜짐/꺼짐 맞추기(`apply-state.js`) → `[5/5]` ECC 전체 설치(선택, `ECC_FULL=1`).

`[3/5]` 의 `scrapling install` 은 브라우저를 내려받는다(수백 MB). uv 가 없으면 `[3/5]` 는 pip 으로 깔고,
이때는 아래 「CLI 도구」의 파이썬 3.12 고정과 uv 도구 폴더 파이썬 경로가 해당되지 않는다.

이미 설치된 머신에서 켜짐/꺼짐만 다시 맞추려면:

```bash
curl -fsSL https://raw.githubusercontent.com/0101-commits/skills/main/scripts/apply-state.js | node
```

### 방법 2: npx skills 패키지만

```bash
npx skills@latest add 0101-commits/skills
```

설치 후 Claude Code에서 `/my-stack` 스킬로 전체 설치 안내 확인 (기준 PC에서는 `my-stack` 이 꺼져 있다 — 쓰려면
`skillOverrides` 에서 키를 지운다).

## 이 저장소가 제공하는 스킬

| 스킬 | 상태 | 내용 |
|------|------|------|
| `my-stack` | 끔 | 전체 스택 설치 가이드 |
| `graphify` | 끔 | 임의 입력(코드·문서·논문·이미지·영상) → 질의 가능한 지식그래프. `/graphify` |

스킬 외 스크립트: `scripts/setup.sh`·`scripts/setup.ps1`(전체 설치), `scripts/apply-state.js`
(켜짐/꺼짐 맞추기).

> `graphify`는 [Graphify-Labs/graphify](https://github.com/Graphify-Labs/graphify) (Apache-2.0, pypi `graphifyy`)
> 스킬의 v0.9.31 스냅샷이다. 정식 최신 설치는 `pip install graphifyy && graphify install --platform claude`
> (setup 스크립트가 이 경로를 쓴다, 기준 PC는 0.9.40). 저장소 사본은 오프라인/버전 고정용.

## Claude Code 플러그인 (11)

| 플러그인 | 마켓플레이스 출처 | 버전 | 상태 | 내용 |
|----------|-------------------|------|------|------|
| `ecc@ecc` | `affaan-m/ECC` (git) | 2.0.0 | 켬 | Everything Claude Code — 250+ 스킬/70+ 에이전트/커맨드 |
| `oh-my-claudecode@omc` | `Yeachan-Heo/oh-my-claudecode` (git) | 4.15.7 | 켬 | 멀티에이전트 오케스트레이션 (autopilot·ralph·ultrawork·team) |
| `superpowers@claude-plugins-official` | 공식 마켓플레이스 | 7.0.0 | 켬 | brainstorming, TDD, systematic-debugging, 플랜/워크트리 |
| `caveman@caveman` | `JuliusBrussee/caveman` | `25d22f8` | 켬 | 초압축 커뮤니케이션 모드 + statusLine |
| `ponytail@ponytail` | `DietrichGebert/ponytail` | 4.8.4 | 켬 | 코드 리뷰/감사/기술부채 |
| `claude-mem@thedotmack` | `thedotmack/claude-mem` | 13.39.0 | 켬 | 세션 기억 저장·검색 (MCP `mcp-search` 포함) |
| `understand-anything@understand-anything` | `Egonex-AI/Understand-Anything` | 2.8.0 | 끔 | 코드베이스 지식그래프/온보딩/투어 |
| `ui-ux-pro-max@ui-ux-pro-max-skill` | `nextlevelbuilder/ui-ux-pro-max-skill` | 2.6.2 | 끔 | 디자인/브랜드/슬라이드/UI 스타일링 |
| `mattpocock-skills@mattpocock` | `mattpocock/skills` | 1.2.0 | 끔 | TDD, 도메인 모델링, 디버깅, 코드리뷰 |
| `andrej-karpathy-skills@karpathy-skills` | `forrestchang/andrej-karpathy-skills` | 1.0.0 | 끔 | Karpathy 코딩 가이드라인 |
| `watch@claude-video` | `bradautomates/claude-video` | 0.1.3 | 끔 | 영상 자막/트랜스크립트 |

켜짐/꺼짐은 `~/.claude/settings.json` 의 `enabledPlugins`. 하나를 바꾸려면 해당 키를 고치거나 `/plugin` 에서
토글 — 적용은 Claude Code 재시작 또는 `/reload-plugins` 이후. 새 머신에도 바꾼 상태를 넣으려면
`scripts/apply-state.js` 의 `PLUGINS` 를 같이 고친다.

`enabledPlugins` 에 보이는 `*@synced` 3개(`human-resources`, `cowork-plugin-management`, `ecom-econ-viz`)는
claude.ai 에서 동기화된 것이라 이 저장소 범위가 아니다.

### 에이전트

`~/.claude/agents/` 는 없다 — 에이전트는 전부 플러그인이 제공한다:
`ecc:*` (언어별 reviewer/build-resolver 70+), `oh-my-claudecode:*` (planner·architect·executor·critic 등),
`caveman:cavecrew-*`.

## npx skills 패키지 (70 스킬)

| 패키지 | 스킬 수 | 상태 | 내용 |
|--------|---------|------|------|
| `coreyhaines31/marketingskills` | 49 | 끔 | SEO, 카피라이팅, 광고, 이메일, 어트리뷰션, marketing-council 등 |
| `remotion-dev/skills` | 13 | 끔 | React 영상 제작 (create·render·captions·maps·multimedia·saas 등 + `mediabunny`) |
| `daleseo/korean-skills` | 3 | 끔 | 한국어 문법 검사, 텍스트 자연화, 스타일 가이드 |
| `Leonxlnx/taste-skill` | 1 | 끔 | `design-taste-frontend` — 안티-슬롭 프론트엔드 디자인 |
| `0101-commits/skills` | 2 | 끔 | 이 저장소 (`my-stack`, `graphify`) |
| `D4Vinci/Scrapling` | 1 | 켬 | `scrapling-official` — 차단 우회·스텔스 브라우저 스크래핑, 스파이더. CLI는 `[3/5]` 에서 설치 |
| `rebelytics/one-skill-to-rule-them-all` | 1 | 켬 | `task-observer` — 작업 중 스킬로 남길 패턴 관찰·기록 |

설치 상태의 원천은 `~/skills-lock.json`. 실체는 `~/.agents/skills/<name>/`, Claude Code 는
`~/.claude/skills/<name>` 정션(Windows)/심링크로 참조한다. lock 에는 있는데
`~/.agents/skills/` 에 없으면 설치가 중단된 것 — 해당 패키지를 다시 `add` 하면 복구된다.
`mediabunny` 는 기준 PC에서 `~/.agents/skills/` 에만 있고 `~/.claude/skills/` 에 연결되지 않았다(Claude Code에서 안 보임).

## CLI 가 같이 까는 스킬 (12)

| 스킬 | 출처 | 설치 | 상태 |
|------|------|------|------|
| `onyx-cli` | `onyx-cli` (pypi) | `[3/5]` 자동: `onyx-cli install-skill --global --agent claude-code` | 켬 |
| `reverse-engineer-anything` | `rea-agents` (npm) | `npm i -g rea-agents` → `rea setup` (스킬 + MCP `rea`) | 켬 |
| `21st-*` 8개 | `@21st-dev/cli` (npm) | `npm i -g @21st-dev/cli` → `21st skills install --global` | 끔 |
| `playwright-cli` | `@playwright/cli` (npm) | `npm i -g @playwright/cli` → `playwright-cli install --skills --global` | 끔 |
| `omc-reference` | OMC 플러그인 | `/oh-my-claudecode:omc-setup` | 끔 |

`21st-*` = `21st-ai`, `21st-cli-use`, `21st-design-sync`, `21st-registry`, `21st-ui-build`, `21st-ui-explore`,
`21st-ui-review`, `21st-video`. 주의: `21st skills install` 은 `--help` 를 붙여도 도움말 대신 실제로 설치하고,
Claude·Cursor·Codex 스킬 폴더 세 곳에 모두 깐다.

`onyx-cli` 스킬은 onyx 저장소의 `.agents/skills/onyx-cli` 에 있지만 `npx skills add onyx-dot-app/onyx` 로는
안 잡힌다 — CLI 의 `install-skill` 이 유일한 설치 경로다. 쓰려면 Onyx 서버 주소와 개인 토큰이 필요하다
(`onyx-cli chat` 첫 설정, 또는 `ONYX_SERVER_URL`·`ONYX_PAT` 환경변수 → `onyx-cli validate-config`).

## 켜짐/꺼짐 정책: 기준 PC 그대로

2026-08-03 에는 전부 켬이었지만, 2026-10-16 부터는 **기준 PC 상태를 그대로 재현**한다. 자주 안 쓰는
플러그인 5개와 스킬 77개(마케팅 49·remotion 12·한국어 3·taste 1·이 저장소 2·21st 8·playwright-cli·omc-reference)를
꺼서 매 턴 스킬 목록이 차지하는 컨텍스트를 줄인다.

목록은 `scripts/apply-state.js` 의 `PLUGINS`·`SKILLS_OFF` 두 개다. 이 목록에 있는 것만 맞추고, 목록 밖의 키(직접 넣은
override, 다른 플러그인)는 그대로 둔다. 스킬 하나를 켜려면 `settings.json` 의 `skillOverrides` 에서 키를 지우고,
새 머신에도 반영하려면 `SKILLS_OFF` 에서도 뺀다 — 안 빼면 `apply-state.js` 를 다시 돌릴 때 도로 꺼진다.

```json
{ "skillOverrides": { "task-observer": "name-only", "onyx-cli": "user-invocable-only" } }
```

`off` = 모델·`/명령` 양쪽에서 숨김, `name-only` = 설명 생략, `user-invocable-only` = `/명령`만.

## CLI 도구

| 도구 | 설치 방법 | 상태 |
|------|-----------|------|
| `graphifyy` 0.9.40 | `uv tool install graphifyy` (setup 자동) | CLI 작동 — `/graphify` 스킬은 꺼짐 |
| `scrapling` 0.4.15 | `uv tool install --python 3.12 "scrapling[all]>=0.4.15"` + `scrapling install` (setup 자동) | 작동 — `scrapling`·`scrapling-mcp`. Scrapling 으로 짠 파이썬 코드는 uv 도구 폴더의 파이썬(`<uv tool dir>/scrapling/Scripts/python.exe`)으로 돌린다 |
| `onyx-cli` 1.4.4 | `uv tool install onyx-cli` (setup 자동) | 설치됨 — **미설정**(서버·PAT 필요) |
| `rea-agents` 6.4.0 | `npm i -g rea-agents` → `rea setup` | 작동 — MCP `rea` + 스킬 |
| `@21st-dev/cli` 1.16.1 | `npm i -g @21st-dev/cli` | 스킬만 깔려 있고 꺼짐 |
| `@playwright/cli` 0.1.18 | `npm i -g @playwright/cli` | 스킬만 깔려 있고 꺼짐 |
| `headroom-ai` 0.33.0 | `uv tool install --python 3.13 "headroom-ai[all]"` | **미배선** — 프록시 미기동, `ANTHROPIC_BASE_URL` 미설정이라 효과 없음 |
| `@agentmemory/agentmemory` 0.9.27 | `npm i -g @agentmemory/agentmemory` | **미배선** — Windows 에서 `agentmemory connect` 미지원(수동 설치 필요) |
| `oh-my-claude-sisyphus` 4.15.7 | `npm i -g` | OMC npm 경로. `oh-my-claudecode@omc` 플러그인과 기능 중복 |

scrapling 은 의존성 휠 때문에 파이썬 3.12로 고정한다(3.14는 휠이 없을 수 있음).

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

setup 스크립트가 넣지 않는다 — 필요하면 직접 추가:

| 서버 | 범위 | 추가 방법 |
|------|------|-----------|
| `context7` | user | `claude mcp add -s user context7 -- npx -y @upstash/context7-mcp` |
| `filesystem` | user | `claude mcp add -s user filesystem -- npx -y @modelcontextprotocol/server-filesystem <홈 폴더>` |
| `rea` | user | `rea setup` 이 등록 (`rea mcp`) |
| `lovable` | local(홈 폴더) | `claude mcp add --transport http lovable https://mcp.lovable.dev` |

`claude-mem` 플러그인의 `mcp-search` 는 플러그인이 붙인다. 그 밖의 MCP(claude-in-chrome, Claude Docs, Context7·PlayMCP
커넥터 등)는 claude.ai 커넥터가 세션에 주입하는 것이라 이 저장소 범위가 아니다.
