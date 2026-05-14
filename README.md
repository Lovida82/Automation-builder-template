# Automation Builder Template

> **대화만으로 Windows 업무 자동화 프로그램(.exe)을 만드는 템플릿**
> Claude Code / Codex / Gemini CLI 등 CLI AI 도구와 함께 사용합니다.

![Status](https://img.shields.io/badge/status-active-success)
![Made for](https://img.shields.io/badge/made_for-Claude_Code-orange)
![Platform](https://img.shields.io/badge/platform-Windows-blue)
![Language](https://img.shields.io/badge/language-Python_3.11+-yellow)
![License](https://img.shields.io/badge/license-MIT-green)

---

## 이게 뭔가요?

매일 반복하는 웹/SAP/엑셀 업무를, **AI와 대화만 하면서** Windows 실행파일(`.exe`)로 자동화하는 템플릿입니다.

**비개발자도 만들 수 있어요.** 코딩, 명령어 입력, 빌드 — 전부 AI가 합니다. 당신이 할 일은:

1. 화면 캡쳐 폴더에 넣기
2. AI 질문에 답하기
3. 결과 확인하기
4. "다음", "다시", "에러 났어" 같은 자연어 명령

그게 끝입니다.

---

## 빠른 시작

### 30초 요약

```bash
# 1. 이 템플릿 복사
git clone https://github.com/Lovida82/automation-builder-template my-automation
cd my-automation

# 2. CLI AI 켜기 (Claude Code 예시)
claude

# 3. AI에게 한 마디
"AUTOMATION_BUILDER_PRD.md 파일을 읽고 그대로 시작해줘"
```

그 다음부터는 AI가 묻는 것에 답하시면 됩니다.

### 처음이신가요?

→ **[QUICK_START.md](./QUICK_START.md)** 부터 읽으세요. Node.js 설치부터 안내합니다.

---

## 폴더에 들어 있는 것

| 파일 | 용도 | 누가 읽나요? |
|------|------|------------|
| **[README.md](./README.md)** | 이 페이지. 레포 소개 | GitHub 방문자 |
| **[QUICK_START.md](./QUICK_START.md)** | 처음 사용자를 위한 셋업/사용법 안내 | 사용자 (당신) |
| **[AUTOMATION_BUILDER_PRD.md](./AUTOMATION_BUILDER_PRD.md)** | AI에게 전달하는 개발 지침서 | AI (Claude Code 등) |
| [examples/](./examples/) | 실제 만들어진 자동화 사례 모음 | 참고용 |
| [CHANGELOG.md](./CHANGELOG.md) | 템플릿 버전 이력 | 업그레이드 시 |
| [CONTRIBUTING.md](./CONTRIBUTING.md) | 기여 가이드 | 개선 제안 시 |

---

## 핵심 특징

### 진짜 대화형 개발
- 사용자는 캡쳐와 답변만. 터미널 명령어 입력 0회.
- AI가 환경 셋업, 코드 작성, 테스트 실행, 빌드까지 직접 수행.

### 캡쳐 기반
- 자동화하고 싶은 화면을 캡쳐만 하면 AI가 분석.
- "이 버튼 클릭 → 저 필드에 입력" 같은 흐름을 캡쳐 보고 파악.

### 단계별 검증
- 한 번에 전체 만들지 않고 1스텝씩 코드 → 테스트 → 사용자 확인 → 다음.
- 도중에 끊겨도 `PROGRESS.md`로 정확히 그 지점부터 재개.

### 보안 기본 탑재
- 사내 계정/비밀번호는 Windows 자격증명 관리자(`keyring`) 자동 사용.
- 캡쳐 폴더는 자동으로 `.gitignore` 등록.

### 사내 환경 대응
- 웹포털 / SAP GUI 둘 다 지원 (한 프로젝트는 한 경로만)
- SAP GUI Scripting 자가진단 스크립트 자동 생성
- BASIS팀 활성화 요청 시 문구 그대로 제공

### 최종 산출물
- Windows GUI (PySide6) + 단일 `.exe` 파일 (PyInstaller)
- 동료에게 .exe 하나만 전달하면 Python 설치 없이 사용 가능

---

## 기술 스택

이 템플릿으로 만들어지는 자동화 프로그램의 스택입니다.

| 영역 | 사용 라이브러리 |
|------|---------------|
| GUI | PySide6 (Qt for Python, LGPL) |
| 웹 자동화 | Playwright |
| SAP GUI 자동화 | win32com + SAP GUI Scripting |
| 데스크탑 앱 자동화 | pywinauto |
| 이미지 기반 보조 | PyAutoGUI + OpenCV |
| Excel 처리 | openpyxl, xlwings |
| 로깅 | loguru |
| 자격증명 | keyring (Windows 자격증명 관리자) |
| 빌드 | PyInstaller |

---

## 지원되는 AI CLI 도구

| 도구 | 추천도 | 모델 | 비고 |
|------|--------|------|------|
| **Claude Code** | 상 | Claude (Anthropic) | 본 PRD 기준, 가장 안정적 |
| Codex CLI | 중 | GPT (OpenAI) | ChatGPT Plus와 연동 |
| Gemini CLI | 중 | Gemini (Google) | 무료 티어 관대 |

상세 비교는 [QUICK_START.md](./QUICK_START.md#3-cli-ai-도구-선택--설치) 참고.

---

## 사용 사례

이 템플릿으로 만든 자동화 사례는 [examples/](./examples/) 폴더 참고.

대표적인 사례:
- SAP 일일 판매실적 다운로드 → Excel 정리
- 사내 포털 보고서 양식 자동 수집
- 거래처 사이트 가격 모니터링
- 다운로드 파일 자동 분류 및 이름 변경

**본인이 만든 자동화를 공유해 주세요!** [Issue 등록](../../issues/new?template=automation_share.md)으로 사례를 추가할 수 있습니다.

---

## 기여하기

이 템플릿은 오픈소스로 운영됩니다.

- 버그 발견 → [Bug Report Issue](../../issues/new?template=bug_report.md)
- 사용 중 막힘 → [Usage Question Issue](../../issues/new?template=usage_question.md)
- 개선 제안 → Pull Request 환영
- 자동화 사례 공유 → [Automation Share Issue](../../issues/new?template=automation_share.md)

자세한 기여 방법은 [CONTRIBUTING.md](./CONTRIBUTING.md) 참고.

---

## 라이선스

[MIT License](./LICENSE) — 자유롭게 사용/수정/배포 가능합니다.

---

## 만든 의도

> "비개발자도 자동화의 주인이 될 수 있게"

---

**시작할 준비 되셨나요? [QUICK_START.md](./QUICK_START.md) 로 가세요.**
