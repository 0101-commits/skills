# 0101-commits/skills

Claude Code 스킬 모음. 한 번에 설치 가능.

## 설치 방법

### 방법 1: npx skills (권장)

```bash
npx skills@latest add 0101-commits/skills
```

설치 후 Claude Code에서 `/my-stack` 스킬로 전체 패키지 설치 안내 확인.

### 방법 2: 스크립트로 전체 자동 설치

**PowerShell:**
```powershell
irm https://raw.githubusercontent.com/0101-commits/skills/main/scripts/setup.ps1 | iex
```

**bash:**
```bash
curl -fsSL https://raw.githubusercontent.com/0101-commits/skills/main/scripts/setup.sh | bash
```

## 포함된 스킬

| 스킬 | 출처 | 내용 |
|------|------|------|
| `my-stack` | 이 저장소 | 전체 스킬 설치 가이드 |

## 설치되는 외부 패키지

| 패키지 | 스킬 수 | 내용 |
|--------|---------|------|
| `daleseo/korean-skills` | 3 | 한국어 문법 검사, 텍스트 자연화, 스타일 가이드 |
| `coreyhaines31/marketingskills` | 45 | SEO, 카피라이팅, 광고, 이메일 등 마케팅 전반 |
| `remotion-dev/skills` | 1 | React 영상 제작 베스트 프랙티스 |
