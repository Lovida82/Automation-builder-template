# Changelog

이 템플릿의 모든 변경사항이 기록됩니다.
형식은 [Keep a Changelog](https://keepachangelog.com/ko/1.1.0/) 를 따릅니다.

## [Unreleased]

### 추가
- `examples/sap-sales-daily/` — 첫 자동화 사례 (SAP 웹포털 일일 판매실적 다운로드)
  - `README.md` (업무/환경/흐름/GUI 모형/효과/재사용 팁)
  - `PRD-snippet.md` (DECISIONS 발췌 + 더미 셀렉터)
  - `lessons-learned.md` (시행착오 4건)
  - 모든 데이터는 더미, 회사 식별 단서·이모지 없음
- `distribution/` — 배포 가이드 및 오프라인 배포본
  - `HOW_TO_DISTRIBUTE.md` (배포 3가지 방법 + 받는 사람용 안내 문구 + 배포 전 체크리스트)
  - `bundle/START_HERE.md` (배포본 받는 사람용 첫 안내)
  - `rebuild-bundle.ps1` (배포본 재생성 스크립트)
- 저장소를 GitHub template repository로 지정 ("Use this template" 버튼 활성화)

### 변경
- `examples/README.md` — 사례 목록 표에 첫 사례 등록
- `.gitignore` — 생성 배포본(`distribution/bundle/`) 추적 제외 (START_HERE.md 제외)

---

## [1.0.0] - 2026-05-14

### 추가
- 초기 템플릿 출시
- `AUTOMATION_BUILDER_PRD.md` — AI용 개발 지침서
  - 부트스트랩 자동 환경 셋업 (Python, venv, 의존성 설치)
  - SAP GUI Scripting 자가진단 스크립트 자동 생성
  - 캡쳐 가이드 → 전체 흐름 파악 → 스텝 분할 합의 → 단계별 개발 흐름
  - 상태 관리 3중 시스템 (`PROGRESS.md`, `DECISIONS.md`, `STEP_LOGS/`)
  - 단일 경로 정책 (웹 또는 SAP GUI, 혼용 금지)
  - 웹포털 우선 디폴트
  - 바이브 코딩 처음 사용자를 위한 응답 톤 가이드
  - AI가 직접 실행하는 빌드 프로세스
- `QUICK_START.md` — 사용자용 빠른 시작 안내
  - 3그룹 분기 (처음 / 웹은 써봤음 / CLI 경험자)
  - Node.js, Python 설치 안내
  - Claude Code / Codex / Gemini CLI 비교 및 설치
  - 자주 마주치는 상황 10개 + FAQ 6개
  - 사내 환경 보안 체크리스트
- `README.md` — GitHub 레포 첫 화면
- `.gitignore` — 사내 캡쳐/데이터 노출 방지 기본 탑재
- `CONTRIBUTING.md` — 기여 가이드
- GitHub Issue 템플릿 3종 (버그/사용질문/자동화공유)

### 기술 스택
- GUI: PySide6
- 웹 자동화: Playwright
- SAP GUI: win32com + SAP GUI Scripting
- 데스크탑: pywinauto
- 빌드: PyInstaller

[Unreleased]: https://github.com/Lovida82/automation-builder-template/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/Lovida82/automation-builder-template/releases/tag/v1.0.0
