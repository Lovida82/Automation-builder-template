# 배포 가이드 — 이 템플릿을 다른 사람에게 나눠주는 법

> 이 문서는 **템플릿을 가지고 있는 당신(배포자)** 을 위한 안내입니다.
> 받는 사람(사용자)이 읽을 안내는 `QUICK_START.md` 입니다.

이 템플릿으로 동료/팀원이 직접 업무 자동화를 만들 수 있게 나눠주는 방법은 3가지입니다.
받는 사람의 성향에 맞는 방법을 고르세요.

| 방법 | 받는 사람 | 장점 | 비고 |
|------|-----------|------|------|
| A. GitHub "Use this template" | GitHub 계정 있음 | 항상 최신, 본인 레포 생성 | 가장 깔끔 |
| B. GitHub "Download ZIP" | GitHub 안 써도 됨 | 클릭 한 번 다운로드 | 링크만 주면 됨 |
| C. 오프라인 배포본 (USB/메일/공유드라이브) | GitHub 접근 불가/사내망 | 인터넷 없이 전달 | 이 폴더의 `bundle/` 사용 |

---

## 방법 A — GitHub "Use this template" (권장, GitHub 사용자)

레포가 **template repository**로 설정되어 있으면, 받는 사람이 버튼 한 번으로
본인 계정에 똑같은 시작 상태의 레포를 만들 수 있습니다.

### 배포자가 한 번 해둘 일 (템플릿 지정)

1. GitHub 레포 페이지 → **Settings**
2. General 탭 상단의 **"Template repository"** 체크박스 켜기

또는 CLI로:

```
gh repo edit Lovida82/Automation-builder-template --template
```

### 받는 사람에게 보낼 안내

```
아래 링크에서 초록색 "Use this template" 버튼을 누르고
"Create a new repository"를 선택하세요.
그러면 본인 계정에 자동화 시작용 레포가 생깁니다.

https://github.com/Lovida82/Automation-builder-template

만든 뒤에는 그 폴더에서 QUICK_START.md 부터 읽으시면 됩니다.
```

---

## 방법 B — GitHub "Download ZIP" (GitHub 계정 없어도 됨)

받는 사람이 GitHub 계정 없이도 파일만 통째로 받을 수 있습니다.

### 받는 사람에게 보낼 안내

```
아래 링크로 들어가서
초록색 "Code" 버튼 → "Download ZIP" 을 누르세요.
받은 zip 파일의 압축을 풀고, 그 폴더 안의 QUICK_START.md 부터 읽으시면 됩니다.

https://github.com/Lovida82/Automation-builder-template
```

또는 직접 다운로드 링크:

```
https://github.com/Lovida82/Automation-builder-template/archive/refs/heads/main.zip
```

---

## 방법 C — 오프라인 배포본 (사내망/USB/메일)

사내망에서 외부 GitHub 접근이 막혀 있거나, IT에 익숙하지 않은 분에게
**파일 묶음 자체를 전달**할 때 사용합니다. 이 폴더의 `bundle/` 가 그 묶음입니다.

### `bundle/` 에 들어 있는 것 (받는 사람에게 필요한 최소 구성)

```
bundle/
├── START_HERE.md                ← 받는 사람이 가장 먼저 볼 안내
├── QUICK_START.md               ← 사용자용 셋업/사용 안내
├── AUTOMATION_BUILDER_PRD.md    ← AI에게 주는 지침서 (핵심)
├── README.md                    ← 템플릿 소개
├── examples/                    ← 참고용 자동화 사례
├── .gitignore                   ← 캡쳐/비밀번호 유출 방지 (중요)
└── LICENSE
```

> `CONTRIBUTING.md`, `CHANGELOG.md`, `.github/`, `docs/` 같은 **레포 운영용 파일은
> 일부러 뺐습니다.** 받는 사람이 자동화를 만드는 데는 필요 없기 때문입니다.

### 전달 방법

1. `bundle/` 폴더를 통째로 zip으로 압축
   - 탐색기에서 `bundle` 폴더 우클릭 → "압축(ZIP) 폴더로 보내기"
   - 또는 PowerShell: 아래 "배포본 다시 만들기" 참고
2. zip 파일을 USB / 메일 / 사내 공유드라이브로 전달
3. 받는 사람에게 아래 안내를 함께 보냄

### 받는 사람에게 보낼 안내 (오프라인용)

```
첨부한 zip 파일의 압축을 원하는 위치에 푸세요.
(예: C:\AutoProjects\my-automation)

압축을 푼 폴더 안에 있는 START_HERE.md 파일을 먼저 열어보세요.
거기에 처음부터 끝까지 안내가 되어 있습니다.

요약하면: 폴더에서 CLI AI(Claude Code 등)를 켜고
"AUTOMATION_BUILDER_PRD.md 읽고 시작해줘" 한 줄만 입력하면 됩니다.
```

---

## 배포본 다시 만들기 (bundle 갱신)

`README.md` 나 `AUTOMATION_BUILDER_PRD.md` 를 수정했다면, `bundle/` 안의 복사본도
오래된 상태가 됩니다. 아래 스크립트로 최신 파일을 다시 복사하세요.

PowerShell에서 레포 루트 기준으로 실행:

```powershell
.\distribution\rebuild-bundle.ps1
```

이 스크립트는 루트의 최신 파일을 `distribution/bundle/` 로 다시 복사하고,
필요 없는 운영 파일은 제외합니다. (`bundle/` 자체는 git에 추적되지 않습니다 —
원본이 레포에 이미 있으므로 중복 추적하지 않습니다.)

---

## 배포 전 체크리스트 (매번 확인)

이 레포는 public이고 사내 환경에서 쓰이므로, 나눠주기 전에 항상 확인하세요.

- [ ] **민감 정보 없음**: 실제 거래처명/금액/사내 URL/계정이 examples나 문서에 없는가
- [ ] **회사/조직 식별 단서 없음**: 사내 팀명/시스템명/이메일 도메인 노출 없는가
- [ ] **이모지 없음**: UI/문서에 텍스트 이모티콘 없는가 (전역 규칙)
- [ ] **.gitignore 포함됨**: 배포본에 `.gitignore` 가 들어 있어야 받는 사람의 캡쳐/비밀번호가 보호됨
- [ ] **받는 사람 안내 동봉**: 위 "보낼 안내" 문구를 함께 전달

---

## 어떤 방법을 추천할까?

- 받는 사람이 **개발/IT에 익숙** → 방법 A (Use this template)
- 받는 사람이 **GitHub은 모르지만 인터넷 됨** → 방법 B (Download ZIP 링크만 전달)
- 받는 사람이 **사내망/오프라인/비개발자** → 방법 C (bundle zip 전달 + START_HERE 동봉)
