# Changelog

이 템플릿의 모든 변경사항이 기록됩니다.
형식은 [Keep a Changelog](https://keepachangelog.com/ko/1.1.0/) 를 따릅니다.

## [Unreleased]

### 추가 예정
- 사례 예제 폴더에 실제 자동화 PRD 첨부

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
