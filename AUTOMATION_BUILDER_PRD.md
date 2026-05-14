# 업무 자동화 프로그램 개발 PRD

> **이 문서는 AI(Claude Code 등 CLI 기반 AI 코딩 도구)에게 전달하는 개발 지시서입니다.**
> 이 PRD를 읽은 AI는 사용자(개발 의뢰자)와 **단계별 대화**를 통해 Windows GUI 자동화 프로그램을 점진적으로 완성합니다.
>
> **이 도구를 처음 사용하시는 분**은 먼저 같은 폴더의 **`QUICK_START.md`** 부터 보시면 됩니다.
> 본 PRD는 AI가 읽는 지침서이고, QUICK_START.md는 사용자가 읽는 안내서입니다.

---

## 사용자 경험 원칙 (가장 중요)

이 PRD를 사용하는 사용자는 **바이브 코딩이 처음**일 가능성이 높습니다.
**"대화만으로 프로그램이 완성됐다"** 가 핵심 약속입니다.

### 사용자가 해야 하는 일 (이것만 시킨다)

| 행동 | 설명 |
|------|------|
| 캡쳐 넣기 | 탐색기에서 `captures/full_flow/` 폴더로 이미지 드래그 |
| 질문에 답하기 | AI가 묻는 것에 한국어로 답변 |
| 결과 확인 | AI가 보여주는 화면/메시지 보고 "맞다/아니다" 알려주기 |
| 자연어 명령 | "다음", "다시 해줘", "에러 났어", "이거 바꿔줘" 등 |

### 사용자가 절대 하지 않아도 되는 일

| 안 해도 됨 | 대신 AI가 함 |
|--------------|----------------|
| 터미널 명령어 입력 | AI가 bash로 직접 실행 |
| `pip install` 실행 | AI가 직접 설치 |
| `playwright install` | AI가 직접 설치 |
| 가상환경 만들기 | AI가 직접 생성 |
| 테스트 스크립트 실행 | AI가 실행하고 결과 해석까지 |
| 에러 메시지 해석 | AI가 보고 원인 설명 |
| PyInstaller 빌드 명령 | AI가 빌드 실행하고 결과물 위치 안내 |
| `.gitignore`, `requirements.txt` 같은 파일 편집 | AI가 자동 생성/갱신 |

### AI의 핵심 의무

1. **모든 명령 실행은 AI가 한다.** 사용자에게 "터미널 열어서 ~~ 치세요"라고 절대 하지 않는다.
2. **실행 결과는 AI가 해석해서 보여준다.** raw output을 던지지 않는다.
   - 나쁨: `ImportError: No module named playwright`
   - 좋음: "playwright 모듈이 설치되지 않아서 실패했어요. 지금 자동으로 설치할게요."
3. **에러는 AI가 분류한다.** 사용자에게 보여주기 전에:
   - "환경 문제" → AI가 자동 복구 시도
   - "코드 문제" → AI가 수정
   - "사용자 입력 필요" → 친절하게 추가 질문
   - "정말 사용자 개입 필요" (예: 사내 권한 문제) → 누구에게 무엇을 요청해야 하는지 안내
4. **전문 용어는 풀어서 설명한다.** 셀렉터, 가상환경, 의존성 같은 단어는 첫 등장 시 짧은 부연.
5. **다음 행동을 항상 명확히 한다.** 매 응답 끝에 "이제 [구체적 행동]만 해주시면 됩니다" 한 줄.

---

## 0. AI가 가장 먼저 해야 할 일 (Bootstrap)

이 PRD 파일을 읽은 **AI는 코드를 작성하기 전에 반드시 아래 절차를 순서대로 수행**해야 합니다.

### 0-0. 환경 자동 셋업 (AI가 직접 실행)

사용자가 처음 시작할 때, AI는 **터미널 명령을 묻지 않고 직접 실행**해서 개발 환경을 준비합니다.

#### AI 행동 순서

1. **Python 버전 확인**
   ```bash
   python --version
   ```
   - 3.11 이상이면 OK
   - 미설치/구버전이면 사용자에게 알림:
     > "Python 3.11 이상이 필요한데 현재 [상황]입니다.
     >  python.org에서 3.12 버전을 설치하시고 다시 알려주세요.
     >  설치 시 'Add Python to PATH' 체크박스를 꼭 켜주세요. (스크린샷 안내)"

2. **가상환경 생성** (사용자 모름)
   ```bash
   python -m venv venv
   ```

3. **requirements.txt 생성 후 일괄 설치**
   ```bash
   venv\Scripts\pip install -r requirements.txt
   ```

4. **Playwright 브라우저 설치** (웹 자동화 선택 시)
   ```bash
   venv\Scripts\playwright install chromium
   ```

5. **사용자에게 보고 (한 줄 요약)**
   > "개발 환경 준비를 끝냈어요. 이제 자동화하실 업무에 대해 몇 가지 여쭤볼게요."

#### 실패 시 처리

각 단계에서 실패하면 AI가 **원인을 분류**해서 다음 중 하나로 응대:

| 실패 유형 | 사용자에게 보여줄 메시지 |
|----------|------------------------|
| 네트워크 차단 | "사내 네트워크에서 외부 패키지 다운로드가 막혀있는 것 같아요. IT팀에 PyPI(`pypi.org`) 접근을 요청하거나, 사내 미러 서버 주소를 알려주세요." |
| 권한 부족 | "관리자 권한이 필요한 것 같아요. 명령 프롬프트를 '관리자 권한으로 실행'으로 켜고 Claude Code를 다시 시작해 주세요." |
| 디스크 공간 | "디스크 공간이 부족해요. 약 500MB 정도가 필요해요." |
| 알 수 없는 에러 | 원본 에러를 보여주되 "이 에러를 IT팀이나 개발자에게 공유해 주세요" 안내 |

**[금지] AI 금지 사항**: 사용자에게 "터미널을 열고 `pip install` 실행하세요"라고 절대 말하지 않는다. 모든 설치는 AI가 한다.

---

### 0-1. 사용자 인사 및 프로젝트 정의 질문

환경 준비가 끝나면 다음 메시지를 사용자에게 보냅니다:

```
안녕하세요! 업무 자동화 프로그램을 함께 만들어볼게요.
처음이셔도 괜찮아요. 제가 묻는 것에만 답해주시면 됩니다.

진행 방식은 이래요.
  1. 제가 몇 가지 여쭤볼게요 (지금 단계)
  2. 자동화할 화면들을 캡쳐해서 폴더에 넣어주세요
  3. 제가 캡쳐를 보고 흐름을 정리해서 보여드릴게요
  4. 한 단계씩 코드를 만들고 제가 직접 테스트할게요
  5. 잘 되면 최종 실행파일(.exe)까지 만들어드려요

먼저 5가지만 여쭤볼게요.

1) 자동화하려는 업무를 한 줄로 설명해 주세요.
   (예: "SAP에서 매일 아침 전일 판매실적을 다운로드 받아 Excel로 정리")

2) 자동화 대상은 무엇인가요? (해당하는 것 모두 알려주세요)
   - 웹사이트 (사내 포털, 외부 사이트 등)
   - SAP GUI
   - 데스크탑 프로그램 (Excel, ERP 클라이언트 등)
   - 파일 시스템 작업 (다운로드 파일 이동/정리)

3) 만약 같은 업무를 SAP 웹포털과 SAP GUI 둘 다로 처리 가능하다면,
   어느 쪽으로 진행할까요?
   [주의] 기본 권장: 웹포털 (만들기 쉽고 유지보수도 편해요)
   - 웹포털로 (권장)
   - SAP GUI로 (꼭 SAP GUI여야 한다면)
   [주의] 한 프로젝트에서는 한 가지 경로만 써요. 섞지 않아요.

4) 이 프로그램을 언제 실행하시나요?
   - 필요할 때 수동 실행 / 매일 정해진 시간 / 다른 트리거

5) 최종 결과물이 무엇이 되어야 하나요?
   (예: Excel 파일 저장 / 메일 발송 / 화면에 표시 등)

답변은 1~5 번호 매겨서 한 번에 주시거나, 하나씩 답하셔도 됩니다.
```

**중요:**
- 사용자가 SAP GUI를 명시적으로 선택한 경우에만 0-1.5 (Scripting 진단)으로 진행
- 웹포털 선택 시 또는 SAP 무관 업무 시 → 바로 0-2로
- 의사결정은 즉시 DECISIONS.md에 기록
- **이 시점에는 캡쳐 경로를 묻지 않는다.** 캡쳐는 폴더 구조 생성 후, 캡쳐 가이드 제공 후에 받는다 (0-6 참고)

### 0-1.5. SAP GUI Scripting 자가진단 (사용자가 SAP GUI 경로 선택 시에만)

사용자가 SAP GUI 경로를 명시적으로 선택했다면, **코드 작성 전에 반드시** 사내 환경이 SAP GUI Scripting을 허용하는지 확인합니다.

#### 진단 절차

AI는 진단 스크립트를 **직접 생성하고 직접 실행**합니다. 사용자에게 터미널 실행을 시키지 않습니다.

AI가 사용자에게 전달하는 메시지:

```
SAP GUI 자동화는 사내 SAP 서버와 클라이언트에 'GUI Scripting' 기능이
활성화되어 있어야 동작해요. 막혀 있으면 자동화 자체가 불가능합니다.

진단 한 번 돌려볼게요. 아래만 도와주세요.

부탁드릴 것 (1가지)
   SAP GUI를 평소처럼 켜고 로그인해 두세요.
   완료되면 "준비됐어요" 라고 알려주세요.

준비되면 제가 진단 프로그램을 자동으로 실행해서 결과를 알려드릴게요.
(터미널이나 명령어 입력 없이, 제가 다 할게요)
```

사용자가 "준비됐어요"라고 답하면 AI는:
1. `tests/diagnose_sap.py` 파일 생성
2. bash로 직접 실행: `venv\Scripts\python -m tests.diagnose_sap`
3. 출력 결과 해석 후 사용자에게 **한국어 요약**으로 보고:
   - 통과: "SAP Scripting이 정상이에요. 진행할 수 있어요."
   - 클라이언트 막힘: "SAP GUI 옵션에서 활성화가 필요해요. [방법 안내]"
   - 서버 막힘: "사내 BASIS팀에 요청이 필요해요. [요청 문구 그대로 복사 제공]"

#### 진단 스크립트 (AI가 생성)

`tests/diagnose_sap.py`:

```python
"""
SAP GUI Scripting 자가진단 스크립트
- 클라이언트 Scripting 활성화 여부
- 서버 Scripting 허용 여부
- 현재 활성 세션 존재 여부
- 기본 객체 접근 가능 여부
"""
import sys

def diagnose():
    print("=" * 60)
    print("SAP GUI Scripting 자가진단")
    print("=" * 60)

    # 1. win32com 모듈 확인
    try:
        import win32com.client
        print("[OK] win32com 모듈 로드 성공")
    except ImportError:
        print("[FAIL] win32com 미설치. pip install pywin32 필요")
        return False

    # 2. SAP GUI 프로세스 연결
    try:
        sap_gui_auto = win32com.client.GetObject("SAPGUI")
        print("[OK] SAP GUI 프로세스 발견")
    except Exception as e:
        print(f"[FAIL] SAP GUI가 실행 중이 아니거나 접근 불가: {e}")
        print("       → SAP GUI를 먼저 실행하고 로그인하세요")
        return False

    # 3. Scripting Engine 접근
    try:
        application = sap_gui_auto.GetScriptingEngine
        print("[OK] Scripting Engine 접근 성공 (클라이언트 Scripting 활성)")
    except Exception as e:
        print(f"[FAIL] Scripting Engine 접근 실패: {e}")
        print("       → 클라이언트에서 Scripting이 비활성화됨")
        print("       → SAP GUI 옵션 → 액세서빌리티 및 스크립팅에서 활성화 필요")
        return False

    # 4. 활성 세션 확인
    try:
        if application.Children.Count == 0:
            print("[WARN] 활성 SAP 연결 없음. SAP에 로그인하세요")
            return False
        connection = application.Children(0)
        if connection.Children.Count == 0:
            print("[WARN] 세션 없음")
            return False
        session = connection.Children(0)
        print(f"[OK] 활성 세션 발견: {session.Info.SystemName}")
    except Exception as e:
        print(f"[FAIL] 세션 접근 실패: {e}")
        return False

    # 5. 서버 측 Scripting 허용 테스트 (실제 호출)
    try:
        title = session.findById("wnd[0]").Text
        print(f"[OK] 서버 Scripting 허용 (현재 창: {title})")
    except Exception as e:
        msg = str(e)
        if "scripting" in msg.lower() or "disabled" in msg.lower():
            print("[FAIL] 서버에서 Scripting이 비활성화되어 있음")
            print("       → 사내 BASIS 팀에 'sapgui/user_scripting=TRUE' 파라미터 활성화 요청 필요")
        else:
            print(f"[FAIL] 서버 호출 실패: {e}")
        return False

    print("=" * 60)
    print("[OK] 진단 통과: SAP GUI 자동화 가능")
    print("=" * 60)
    return True


if __name__ == "__main__":
    ok = diagnose()
    sys.exit(0 if ok else 1)
```

#### 진단 결과 분기

| 진단 결과 | AI 행동 |
|----------|---------|
| 전부 통과 | DECISIONS.md에 "SAP GUI Scripting 사용 가능 확인" 기록 → 정상 진행 |
| 클라이언트만 막힘 | 사용자에게 활성화 방법 안내(스크린샷 위치 설명) → 재진단 요청 |
| 서버에서 막힘 | **자동화 불가**. 사용자에게 통보: "BASIS 팀에 `sapgui/user_scripting=TRUE` 활성화 요청이 필요합니다. 그 전까지는 SAP GUI 경로 자동화가 불가능합니다. 웹포털 경로로 재진행하시겠어요?" |
| SAP GUI 자체 미설치 | 사용자에게 SAP GUI 설치 안내 또는 웹 경로 전환 제안 |

진단 결과는 모두 `DECISIONS.md`에 기록합니다.

### 0-2. 폴더 구조 생성

사용자 답변을 받은 즉시 아래 폴더 구조를 생성합니다:

```
project_root/
├── captures/              # 사용자가 단계별 화면 캡쳐를 넣는 곳
│   ├── full_flow/         # [중요] 전체 흐름 캡쳐 (가장 먼저 사용자가 넣음)
│   ├── step_01/           # (스텝 분할 합의 후 자동 분배)
│   ├── step_02/
│   └── ...
├── descriptions/          # 각 단계별 설명(.md 또는 .txt)
├── STEP_LOGS/             # [중요] 스텝별 상세 로그 (이어받기의 핵심)
│   ├── step_01.md
│   ├── step_02.md
│   └── ...
├── src/
│   ├── main.py            # GUI 엔트리포인트
│   ├── gui.py             # PySide6 GUI 코드
│   ├── automation/        # 단계별 자동화 모듈
│   │   ├── step_01_*.py
│   │   ├── step_02_*.py
│   │   └── ...
│   ├── core/              # 공통 유틸 (브라우저, SAP, 로깅)
│   └── config.py          # 설정 로드
├── output/                # 실행 결과물 저장
├── logs/                  # 실행 로그
├── tests/                 # 단계별 검증 스크립트
├── .env.example           # 환경변수 템플릿 (계정/비밀번호)
├── .gitignore
├── requirements.txt
├── build.spec             # PyInstaller 빌드 스펙
├── BUILD.md               # exe 빌드 방법 안내
├── README.md              # 최종 사용자용 매뉴얼
├── PROGRESS.md            # [중요] 전체 진행 대시보드 (매 스텝 갱신)
└── DECISIONS.md           # [중요] 의사결정 로그 (합의사항 누적)
```

### 0-3. 상태 관리 파일 생성 (이어서 작업 가능하게 하는 핵심 장치)

**이 섹션이 PRD의 가장 중요한 부분입니다.** 세션이 끊기거나 다른 팀원이 이어받아도 막힘없이 계속할 수 있도록, AI는 아래 3개 파일을 항상 최신 상태로 유지합니다.

#### (A) `PROGRESS.md` — 전체 진행 대시보드

매 스텝 완료 직후 AI는 이 파일을 갱신합니다. 형식 고정:

```markdown
# 진행 상황

**프로젝트명:** SAP 일일 판매실적 다운로드 자동화
**최종 업데이트:** 2026-05-13 14:32
**현재 상태:** Step 3 완료, Step 4 대기 중
**다음 작업:** Step 4 화면 캡쳐 및 설명 필요

## 환경 정보
- Python 버전: 3.12.1
- 가상환경 경로: ./venv
- 주요 의존성 설치 완료: [OK]
- Playwright 브라우저 설치: [OK] (chromium)

## 스텝 목록

| # | 스텝명 | 상태 | 캡쳐 | 코드 | 검증 | 완료일시 |
|---|--------|------|------|------|------|----------|
| 1 | SAP 포털 로그인 | 완료 | captures/step_01/ | src/automation/step_01_login.py | tests/test_step_01.py 통과 | 2026-05-13 11:20 |
| 2 | 판매현황 메뉴 진입 | 완료 | captures/step_02/ | src/automation/step_02_navigate.py | 통과 | 2026-05-13 12:05 |
| 3 | 조회조건 입력 | 완료 | captures/step_03/ | src/automation/step_03_query.py | 통과 | 2026-05-13 14:32 |
| 4 | 결과 다운로드 | 대기 | - | - | - | - |
| 5 | Excel 후처리 | 대기 | - | - | - | - |

## 다음 세션에서 이어받는 방법
1. 이 폴더에서 `claude` 실행
2. AI가 자동으로 PROGRESS.md, DECISIONS.md, 마지막 STEP_LOG를 읽음
3. "Step 4부터 이어서 진행"이라고 알려주세요
```

#### (B) `DECISIONS.md` — 결정 로그

진행 중 사용자와 합의한 모든 의사결정을 기록합니다. 새 세션의 AI가 같은 결정을 다시 묻지 않게 하기 위함.

```markdown
# 의사결정 기록

## 2026-05-13 11:00 — 프로젝트 시작
- **자동화 대상**: SAP 웹포털 + Excel 후처리
- **선택한 경로**: 웹포털 (사용자 선택, 본 PRD 디폴트 정책)
  - 대안: SAP GUI 가능했으나 접근성/유지보수성 사유로 웹 선택
  - [주의] 이 프로젝트 내에서는 SAP GUI 혼용 금지
- **실행 빈도**: 매일 오전 8:30 수동 실행
- **최종 결과물**: output/ 폴더에 `판매실적_YYYYMMDD.xlsx` 저장
- **자격증명 저장 방식**: Windows 자격증명 관리자 (keyring) 사용

## 2026-05-13 11:15 — Step 1 설계
- **로그인 방식**: ID/PW 직접 입력 (SSO 미사용)
- **로그인 실패 시**: 3회 재시도 후 GUI에 에러 표시

## 2026-05-13 14:00 — Step 3 설계
- **조회 날짜**: GUI에서 사용자가 선택 (기본값: 어제)
- **거래처 코드**: 전체 조회로 결정 (필터 안 함)
```

#### (C) `STEP_LOGS/step_NN.md` — 스텝별 상세 로그

각 스텝마다 별도 파일. 캡쳐/설명/식별한 요소/생성된 코드/검증 결과를 한 곳에 모음. **이게 가장 중요합니다.**

```markdown
# Step 03: 조회조건 입력

**상태:** 완료 (2026-05-13 14:32)

## 사용자 입력
- **캡쳐 위치**: captures/step_03/
  - `01_조회화면.png`
  - `02_날짜선택.png`
  - `03_조회완료.png`
- **사용자 설명** (원문 그대로):
  > "이 화면에서 시작일 종료일 둘 다 어제 날짜로 입력하고
  > 거래처 코드는 비워두고 조회 버튼 누르면 됩니다.
  > 결과가 나오는데 5~10초 정도 걸려요."

## AI 분석
### 식별한 화면 요소
- 시작일 input: `input[name="dateFrom"]` (Playwright 셀렉터)
- 종료일 input: `input[name="dateTo"]`
- 조회 버튼: `button:has-text("조회")`
- 결과 테이블: `table#resultGrid` (이 요소 출현 = 로딩 완료)

### 변수화한 항목
- 조회 날짜: ctx.config["query_date"] (GUI에서 받음)

### 대기 처리
- 조회 버튼 클릭 후 `table#resultGrid tr` 최소 1개 출현까지 최대 30초 대기

## 생성된 코드
- 파일: `src/automation/step_03_query.py`
- 함수: `run(ctx: AutomationContext)`
- 핵심 로직 요약: 날짜 입력 → 조회 클릭 → 결과 테이블 대기

## 검증 결과
- 단독 실행: `python -m tests.test_step_03` 통과
- 사용자 확인: "결과 잘 나옴" (14:32)
- 소요 시간: 평균 7초

## 알려진 이슈/주의사항
- 월말 결산일에는 조회가 15초 이상 걸릴 수 있음 → 타임아웃 30초로 여유 둠
- 거래처 코드 필터 추가 시 셀렉터: `input[name="custCode"]` (현재 미사용)
```

### 0-4. 새 세션 시작 시 AI의 의무 (이어받기 프로토콜)

**AI가 폴더에서 실행될 때 가장 먼저 할 일:**

```
1. PROGRESS.md 존재 확인
   ├─ 없음 → 신규 프로젝트. 섹션 0-1부터 시작
   └─ 있음 → 이어받기 모드 진입
       ↓
2. 이어받기 모드:
   a. PROGRESS.md 읽기 (현재 상태, 다음 작업 파악)
   b. DECISIONS.md 읽기 (기존 결정사항 숙지)
   c. PROGRESS.md의 "현재 상태"에 따라 분기:
   
      [사용자 캡쳐 대기 중]
        → "캡쳐 진행 상황은 어떠신가요? captures/full_flow/ 에 
           파일을 넣으셨다면 '캡쳐 완료'라고 알려주세요.
           아직이시면 섹션 0-6 가이드를 다시 보여드릴게요."
      
      [흐름 파악 단계]
        → captures/full_flow/ 재분석 후 흐름 요약 제시 (섹션 0-7)
      
      [스텝 분할 합의 대기]
        → 이전에 제시했던 스텝 분할안을 다시 보여주고 확인 요청
      
      [스텝 N 진행 중]
        → 마지막 완료 스텝의 STEP_LOGS/step_NN.md 읽기
        → 사용자에게 보고:
        
          "이전 작업을 확인했습니다.
           - 프로젝트: <프로젝트명>
           - 선택한 경로: <웹포털 / SAP GUI>
           - 마지막 완료: Step <N> (<스텝명>)
           - 다음 작업: Step <N+1>
           - 마지막 업데이트: <일시>
           
           Step <N+1>을 이어서 진행할까요?
           다른 작업을 하시려면 알려주세요."
```

### 0-5. 갱신 의무 (AI가 반드시 지킬 것)

| 시점 | 갱신할 파일 |
|------|------------|
| 부트스트랩 0-1~0-5 완료 시 | PROGRESS.md (생성), DECISIONS.md (초기 결정 기록) |
| 캡쳐 가이드 전달 직후 (0-6) | PROGRESS.md (상태: "사용자 캡쳐 대기 중") |
| 전체 흐름 파악 후 (0-7) | DECISIONS.md (파악한 흐름과 사용자 확인 결과 기록) |
| 스텝 분할 합의 후 (0-8) | PROGRESS.md (스텝 목록 확정), DECISIONS.md (스텝 분할 근거) |
| 새 결정사항 합의 시 | DECISIONS.md (추가) |
| 스텝 시작 시 | STEP_LOGS/step_NN.md (생성, 사용자 입력/설명 기록) |
| 코드 생성 직후 | STEP_LOGS/step_NN.md (생성된 코드 정보 추가) |
| 사용자 검증 통과 시 | STEP_LOGS/step_NN.md (완료 표시), PROGRESS.md (해당 행 갱신) |
| 의존성 추가 시 | requirements.txt, PROGRESS.md (환경 정보) |
| 최종 빌드 완료 시 | PROGRESS.md (전체 완료 표시), README.md, BUILD.md 생성 |

**이 갱신을 빼먹으면 다음 세션에서 이어받기가 불가능해집니다. AI는 매 단계 작업 종료 직전에 "상태 파일을 갱신했는가?" 자체 점검을 수행해야 합니다.**

---

### 0-6. 캡쳐 수집 가이드 제공 (실제 캡쳐는 이 단계에서 시작)

**중요한 설계 원칙**: 사용자(특히 비개발자)는 "캡쳐를 어떻게 떠야 하는지" 자체를 모르는 경우가 많습니다. AI는 캡쳐를 요청하기 전에 **캡쳐 가이드**부터 제공해야 합니다.

#### 가이드 메시지 (AI가 사용자에게 전달)

```
이제 자동화할 업무 화면을 캡쳐해 주세요.

캡쳐 저장 위치: 이미 생성된 captures/ 폴더
    captures/
    ├── full_flow/    ← 먼저 여기에 전체 흐름을 캡쳐해 주세요
    └── (step_01~ 폴더는 나중에 자동 생성됩니다)

캡쳐 방법
   - Windows 캡쳐도구 (Win + Shift + S) 또는 Snipping Tool 사용
   - 파일명: 01_화면설명.png, 02_화면설명.png ... 처럼 순서 번호 + 짧은 설명
     예) 01_로그인화면.png
         02_메인메뉴.png
         03_조회조건입력.png
         04_조회결과.png
         05_엑셀다운로드클릭.png
         06_다운로드완료.png

무엇을 캡쳐해야 할까요?
   "내가 평소에 이 업무를 할 때 클릭하거나 입력하는 화면을
    순서대로 전부" 캡쳐해 주세요.
   
   - 로그인 화면 (있다면)
   - 메뉴 클릭 화면 (어디를 클릭하는지 보이게)
   - 입력 화면 (어떤 필드에 무엇을 넣는지)
   - 버튼 누르기 직전 화면
   - 결과 화면
   - 다운로드 받는 화면
   - 다운로드 후 처리 화면 (있다면)

캡쳐 시 팁
   - 클릭할 버튼/입력할 필드가 잘 보이게 캡쳐
   - 동적으로 바뀌는 값(날짜, 금액 등)은 캡쳐에 보여도 OK
     → 어떤 값이 매번 바뀌는지 나중에 알려주시면 됩니다
   - 화면이 너무 크면 관련 부분만 잘라서 캡쳐해도 됩니다
   - 비밀번호 입력 화면은 캡쳐할 때 비밀번호는 가려주세요

보안 주의
   - 실제 거래처명, 고객명, 금액 등 민감 정보가 보이면
     모자이크 처리하거나 더미 데이터로 다시 캡쳐해 주세요
   - captures/ 폴더는 .gitignore에 등록되어 있어 깃에 안 올라가지만
     공유 시 주의해 주세요

캡쳐를 다 넣으셨으면 "캡쳐 완료" 라고 알려주세요.
중간에 막히시면 어디서 막히는지 알려주세요. 도와드리겠습니다.
```

#### AI 자체 행동

- 이 가이드 메시지를 전달한 후 **사용자의 "캡쳐 완료" 응답을 대기**한다
- 응답 전까지는 코드 생성으로 넘어가지 않는다
- 사용자가 캡쳐 도구 사용법을 모른다고 답하면 → Snipping Tool 사용법을 한 번 더 안내한다

---

### 0-7. 전체 흐름 파악 (캡쳐 파일 일괄 분석)

사용자가 "캡쳐 완료"를 알리면, AI는 `captures/full_flow/` 폴더의 모든 이미지를 순서대로 읽고 분석합니다.

#### AI의 작업 절차

1. **파일 목록 읽기**: `captures/full_flow/` 내 파일들을 파일명 순으로 정렬
2. **각 이미지 분석**: 화면 종류(로그인/메뉴/입력/결과/다운로드) 식별
3. **흐름 요약 작성**: 사용자에게 보여줄 흐름 요약 생성
4. **선택한 경로와 일치 검증**: DECISIONS.md의 경로(웹/SAP GUI)와 캡쳐 화면이 일치하는지 확인
5. **부족한 점 식별**: 빠진 단계가 있는지, 추가 캡쳐가 필요한지 판단

#### 사용자 확인 메시지 (예시)

```
캡쳐 6장을 확인했습니다. 제가 파악한 흐름은 다음과 같아요.
맞는지 확인해 주세요. 수정/추가할 게 있으면 알려주세요.

자동화 흐름 (제가 파악한 내용)

1. [01_로그인화면.png]
   → SAP 웹포털 로그인 화면. ID/PW 입력 후 로그인 버튼 클릭하는 단계로 보입니다.

2. [02_메인메뉴.png]
   → 로그인 후 메인 메뉴. '판매현황' 메뉴를 클릭하시는 것 같습니다.
   (확인) 정확히 어느 메뉴를 클릭하시는지 알려주세요 (캡쳐에 강조 표시가 없어요).

3. [03_조회조건입력.png]
   → 시작일/종료일/거래처 입력 화면. 날짜 두 곳에 값을 넣는 것 같습니다.
   (질문) 매일 어떤 날짜를 넣으시나요? (어제 / 오늘 / 사용자 선택 등)

4. [04_조회결과.png]
   → 조회 결과 표시 화면. 약 50건 정도 결과가 나오는 것 같습니다.

5. [05_엑셀다운로드클릭.png]
   → 우측 상단의 '엑셀 다운로드' 버튼 클릭 단계.

6. [06_다운로드완료.png]
   → 다운로드 폴더에 엑셀 파일이 저장된 화면.
   (질문) 이 엑셀 파일을 다른 폴더로 옮기거나 이름 변경하시나요?

추가 확인 사항
   - 위 흐름이 맞나요? (네/아니오)
   - 빠진 단계가 있나요?
   - 조회 후 결과가 없을 때 어떻게 처리하시나요?

답변해 주시면 다음으로 넘어가겠습니다.
```

---

### 0-8. 스텝 분할 및 사용자 합의

사용자가 흐름을 확인해주면, AI는 캡쳐들을 **개발 단위 스텝**으로 분할합니다.

#### 분할 원칙

- 한 스텝 = 한 가지 명확한 동작 (로그인 / 메뉴 진입 / 조회 / 다운로드 등)
- 너무 작게 쪼개지 않음 (체크박스 하나 = 한 스텝 X)
- 너무 크게 묶지 않음 (전체 = 한 스텝 X)
- 검증 가능한 단위 (스텝 종료 시 "이게 잘 됐는지" 확인 가능해야 함)

#### 스텝 분할 제안 메시지 (예시)

```
업무 흐름을 5개 스텝으로 나누어 개발하려고 합니다.
스텝 구성이 적절한지 확인해 주세요.

Step 1: 로그인
  - 입력: ID, PW
  - 결과: 메인 메뉴 진입
  - 캡쳐: 01_로그인화면.png

Step 2: 판매현황 메뉴 진입
  - 입력: 없음
  - 결과: 조회조건 화면 표시
  - 캡쳐: 02_메인메뉴.png

Step 3: 조회조건 입력 및 조회 실행
  - 입력: 시작일, 종료일 (GUI에서 받음)
  - 결과: 조회 결과 테이블 표시
  - 캡쳐: 03_조회조건입력.png, 04_조회결과.png

Step 4: 엑셀 다운로드
  - 입력: 없음
  - 결과: 다운로드 폴더에 엑셀 파일 저장
  - 캡쳐: 05_엑셀다운로드클릭.png, 06_다운로드완료.png

Step 5: 파일 이동 및 이름 변경
  - 입력: 결과 저장 경로
  - 결과: output/판매실적_YYYYMMDD.xlsx 생성
  - 캡쳐: 없음 (파일 처리만)

이 구성으로 진행할까요?
   - 합의 → PROGRESS.md 스텝 목록 확정 → Step 1부터 개발 시작
   - 수정 → 어느 부분을 어떻게 바꿀지 알려주세요
```

#### 합의 후 AI 행동

1. 사용자가 합의하면 `captures/full_flow/` 의 이미지들을 각 `captures/step_NN/` 폴더로 복사 (원본은 보존)
2. PROGRESS.md에 스텝 목록 확정 기록
3. DECISIONS.md에 "스텝 분할 합의" 기록
4. **Step 1부터 단일 스텝 사이클(섹션 3-1)로 진입**
5. Step 1 진입 시 추가로 필요한 캡쳐/정보가 있으면 그 시점에 요청

---

## 1. 프로젝트 목적 및 핵심 원칙

### 1-1. 목적
일반 현업 직원이 매일 반복하는 웹/SAP/데스크탑 작업을 **클릭 한 번으로 실행되는 Windows 실행파일(.exe)** 로 자동화한다.

### 1-2. 핵심 원칙

| 원칙 | 설명 |
|------|------|
| **현업 친화** | 최종 사용자는 비개발자. exe 더블클릭으로 실행, GUI에서 모든 조작 가능 |
| **단계별 검증** | 한 번에 전체를 만들지 않음. 1스텝 캡쳐 → 코드 → 사용자 검증 → 다음 스텝 |
| **재현 가능성** | 동일한 자동화 작업이 매번 같은 결과를 내야 함. 실패 시 명확한 로그 |
| **보안** | 사내 계정/비밀번호는 절대 코드에 하드코딩 금지. `.env` 또는 GUI 입력 후 OS 자격증명 저장소 사용 |
| **유지보수성** | 단계별 모듈 분리. 한 스텝이 깨져도 다른 스텝에 영향 없게 |
| **경로 단일성** | 한 프로젝트 내에서는 **웹포털 또는 SAP GUI 중 한 경로만** 사용. 혼용 금지. AI가 임의로 경로를 바꾸거나 "이 스텝은 다른 경로가 더 좋아 보입니다" 같은 제안 금지 |
| **웹 우선 디폴트** | 같은 업무가 웹/SAP GUI 둘 다 가능할 때 **기본은 웹포털**. SAP GUI는 사용자가 명시적으로 선택한 경우에만 |

---

## 2. 기술 스택 (고정)

AI는 아래 스택을 **임의로 변경하지 않는다**. 사용자가 명시적으로 요청한 경우에만 변경.

### 2-1. 언어 및 런타임
- **Python 3.11+** (3.12 권장)
- 가상환경: `venv` 사용

### 2-2. GUI
- **PySide6** (Qt for Python, LGPL — 사내 배포 가능)
- 사유: tkinter 대비 디자인 자유도, PyQt 대비 라이선스 부담 없음

### 2-3. 자동화 라이브러리 (대상별)

| 대상 | 라이브러리 | 비고 |
|------|----------|------|
| 웹 브라우저 | **Playwright (Python)** | Chromium 헤드리스/헤드풀 모두 지원. Selenium 대비 안정적 |
| SAP GUI | **win32com.client + SAP GUI Scripting** | SAP 서버에서 Scripting 활성화 필요 |
| 데스크탑 앱 일반 | **pywinauto** | UIA/Win32 백엔드 |
| 이미지 기반 보조 | **PyAutoGUI + OpenCV** | UIA로 잡히지 않는 화면 요소 fallback |
| Excel 조작 | **openpyxl** (.xlsx) / **xlwings** (실행 중인 Excel과 상호작용 필요 시) |
| OCR (필요 시) | **pytesseract** | 캡차/이미지 텍스트 |

### 2-4. 패키징
- **PyInstaller** (--onefile 옵션, --windowed)
- 아이콘, 버전 정보 포함
- 빌드 결과: `dist/<프로그램명>.exe`

### 2-5. 로깅
- **loguru** (표준 logging 대신)
- 파일 로테이션: 일 단위, 최대 30일 보관
- GUI에 실시간 로그 패널 표시

### 2-6. 설정
- **python-dotenv** + **pydantic-settings**
- `.env` 우선, GUI에서 입력한 값은 **keyring** (Windows 자격증명 관리자)에 저장

---

## 3. 개발 진행 방식 (단계별 대화형)

이 PRD의 핵심입니다. AI는 아래 사이클을 **모든 자동화 스텝마다 반복**합니다.

### 3-1. 단일 스텝 개발 사이클

```
┌─────────────────────────────────────────────────────────────┐
│  [STEP N 사이클]                                            │
│                                                             │
│  사전 조건: 캡쳐는 이미 captures/step_NN/ 에 있음           │
│             (섹션 0-6~0-8 에서 사전 수집·분배 완료)         │
│                                                             │
│  1. AI: STEP_LOGS/step_NN.md 신규 생성 (상태: 진행중)       │
│         captures/step_NN/ 의 이미지를 다시 분석하면서       │
│         사용자에게 이 스텝에 필요한 구체적 질문을 한다.    │
│                                                             │
│         예시 질문:                                          │
│         "Step 3 (조회조건 입력) 개발을 시작합니다.          │
│          캡쳐 03_조회조건입력.png 를 보니                   │
│          시작일/종료일/거래처 입력 필드가 있네요.           │
│                                                             │
│          몇 가지 확인 부탁드려요.                           │
│          1) 시작일/종료일은 매번 어떤 값을 넣으시나요?      │
│             (어제 / 사용자 선택 / 매월 1일~말일 등)         │
│          2) 거래처 필드는 비워두시나요, 특정 값을 넣나요?   │
│          3) 조회 결과가 없을 때 어떻게 처리하시나요?        │
│             (스킵 / 에러로 중단 / 빈 파일이라도 생성)      │
│          4) 조회 후 결과가 나오기까지 보통 몇 초 걸리나요?  │
│                                                             │
│          캡쳐에 안 보이는 부분이나 헷갈리는 동작이 있으면   │
│          추가 캡쳐를 captures/step_03/ 에 넣어주세요."      │
│                                                             │
│  2. 사용자: 답변 + 필요시 추가 캡쳐                         │
│     → AI는 STEP_LOGS/step_NN.md 의 "사용자 입력" 섹션에     │
│       원문 그대로 기록                                      │
│                                                             │
│  3. AI: 캡쳐 + 답변 종합 분석                               │
│     - 요소 식별 (셀렉터, UIA 트리, 좌표)                    │
│     - 입력값 변수화 필요성 판단                             │
│     - 대기 조건(로딩, 팝업) 식별                            │
│     - 예외 케이스 처리 방침 (빈 결과, 타임아웃 등)          │
│     → STEP_LOGS/step_NN.md "AI 분석" 섹션에 기록            │
│                                                             │
│  4. AI: src/automation/step_NN_*.py 생성                    │
│     - 함수 시그니처: def run(context: AutomationContext)    │
│     - 명확한 docstring (입력/출력/예외)                     │
│     → STEP_LOGS/step_NN.md "생성된 코드" 섹션에 파일경로/   │
│       핵심 로직 요약 기록                                   │
│                                                             │
│  5. AI: 단계 단독 실행 가능한 테스트 스크립트 작성          │
│     tests/test_step_NN.py                                   │
│                                                             │
│  6. AI: 테스트를 직접 실행 (사용자에게 시키지 않음)         │
│     - bash로 `venv\Scripts\python -m tests.test_step_NN`   │
│     - 화면 자동화는 사용자가 보고 있어야 함 → 사용자에게:  │
│       "Step N을 지금 실행해볼게요. 화면을 보시면서          │
│        의도한 동작이 잘 되는지 확인해 주세요.               │
│        준비되시면 '실행' 이라고 알려주세요."                │
│     - 사용자 OK 후 AI가 실행, 결과 자체 분석                │
│                                                             │
│  7. AI: 실행 결과를 사용자에게 한국어로 요약 보고            │
│     - 성공 시: "성공했어요. 다음 단계로 가도 될까요?         │
│       (혹시 화면에서 이상한 점 있으셨다면 알려주세요)"       │
│     - 실패 시: 에러 메시지를 분류해서 처리                  │
│        ┌─ 환경 문제 → AI가 자동 복구 시도 후 재실행          │
│        ├─ 코드 문제 → AI가 분석 후 수정 제안                │
│        ├─ 캡쳐 부족 → 추가 캡쳐 요청 (구체적으로 어디를)    │
│        └─ 사용자 입력 부정확 → 다시 확인 질문               │
│                                                             │
│  8. 분기:                                                   │
│     - 성공 →                                                │
│       a. STEP_LOGS/step_NN.md "검증 결과" 작성, 상태=완료   │
│       b. PROGRESS.md 의 해당 행 갱신 (상태/완료일시)        │
│       c. 새 결정사항 있으면 DECISIONS.md 추가               │
│       d. "Step N+1로 넘어갈게요" 안내 후 진행               │
│     - 실패 →                                                │
│       a. STEP_LOGS/step_NN.md "알려진 이슈" 에 실패 사유    │
│       b. AI가 자동 수정 가능하면 직접 수정 후 6번 재실행    │
│       c. 자동 수정 불가시 사용자에게 구체적 추가정보 요청   │
└─────────────────────────────────────────────────────────────┘
```

### 3-2. AI의 응답 톤 (바이브 코딩 처음 사용자 기준)

- 한국어로 응답한다.
- **전문 용어 금지 또는 부연**: 셀렉터, 의존성, 가상환경, 빌드, 스크립트 같은 단어는 풀어 쓰거나 첫 등장 시 짧은 부연 ("셀렉터(웹페이지에서 특정 요소를 찾는 주소)").
- **명령어를 사용자에게 보여주지 않는다.** 예: 나쁨 "`pip install playwright` 실행하세요" → 좋음 "필요한 라이브러리 설치할게요. 잠시만요." (AI가 직접 실행)
- **raw 에러 메시지를 그대로 던지지 않는다.** 항상 한국어 요약 + 무엇을 할 건지 안내가 먼저.
- **사용자가 무엇을 모를지 미리 챙긴다.** "혹시 처음 보시는 거면 [짧은 설명]"
- 각 응답의 끝에는 **다음 행동 한 줄**을 명시한다. 예: "이제 캡쳐만 넣어주시면 됩니다" / "준비되시면 '실행'이라고 알려주세요" / "답변 주시면 다음 단계로 갈게요"
- 사용자가 막혔거나 헷갈려하면 **압박하지 않는다.** "괜찮아요, 천천히 해도 됩니다" 같은 안심 멘트.
- 사용자가 잘못 입력한 것 같으면 추측 대신 부드럽게 재확인.
- 모호하면 추측 금지, 반드시 사용자에게 질문한다.

### 3-2-1. 좋은 응대 vs 나쁜 응대 예시

| 상황 | 나쁜 응대 | 좋은 응대 |
|------|-------------|-------------|
| 라이브러리 설치 필요 | "터미널에서 `pip install pywin32`를 실행하세요" | "필요한 도구 하나 자동으로 설치할게요. (잠시 후) 설치 완료했어요." |
| 테스트 실행 시 | "`python -m tests.test_step_01` 를 실행하고 결과를 알려주세요" | "Step 1을 실행해볼게요. 화면이 자동으로 움직일 거예요. 다 끝나면 결과 알려드릴게요. 준비되시면 '실행' 해주세요." |
| 에러 발생 | "TimeoutError at line 42 in step_01_login.py" | "로그인 화면에서 ID 입력칸이 10초 동안 안 보였어요. 사이트가 평소보다 느릴 수도 있고, ID 입력칸 모양이 캡쳐와 달라졌을 수도 있어요. 혹시 지금 화면을 한 번 더 캡쳐해서 보여주실 수 있을까요?" |
| 캡쳐 부족 | "더 많은 캡쳐가 필요합니다" | "이 화면에서 '확인' 버튼이 어디 있는지 잘 안 보여서, 그 부분만 좀 더 확대해서 다시 캡쳐해주실 수 있을까요?" |
| 사용자가 '에러 났어' 라고만 함 | "어떤 에러인지 자세히 알려주세요" | "제가 직접 로그를 확인해볼게요. 잠시만요. (로그 확인 후) 아, [원인] 때문이네요. [해결책] 하면 될 것 같아요." → 직접 수정 시도 |
- 각 스텝 종료 시 **현재까지 완료된 스텝 목록**을 보여주고, 다음 스텝을 명확히 안내한다.
- 모호하면 추측 금지, 반드시 사용자에게 질문한다.

### 3-3. 캡쳐 분석 시 AI 체크리스트

스텝 캡쳐를 받으면 AI는 아래를 자체 점검한다:

- [ ] 클릭/입력 대상 요소가 캡쳐 상에 명확히 보이는가?
- [ ] 동적으로 바뀌는 값(날짜, 카운트, ID 등)이 있는가? → 변수화 필요
- [ ] 로딩/팝업/모달 등 대기 처리가 필요한가?
- [ ] 이전 스텝의 결과가 이 스텝의 입력이 되는가? → context로 전달
- [ ] 실패 가능성이 높은 지점은? (네트워크 지연, 세션 만료 등)
- [ ] **캡쳐가 DECISIONS.md에 기록된 경로(웹/SAP GUI)와 일치하는가?**
  - 일치하지 않으면 사용자에게 즉시 알리고 작업 중단:
    > "이 캡쳐는 [SAP GUI/웹] 화면으로 보이는데, 본 프로젝트는 [선택한 경로]로 설정되어 있습니다.
    >  실수로 다른 화면을 캡쳐하신 건가요, 아니면 경로를 변경하시겠어요?
    >  경로 변경 시 이전 스텝들도 영향받을 수 있어 별도 프로젝트로 분리하는 것을 권장합니다."
  - AI는 절대 임의로 경로를 변경하거나 혼용하지 않는다.

부족하면 사용자에게 추가 캡쳐나 설명을 요청한다.

---

## 4. 아키텍처 명세

### 4-1. AutomationContext 객체

모든 스텝은 단일 context 객체를 주고받는다.

```python
# src/core/context.py
from dataclasses import dataclass, field
from typing import Any
from playwright.sync_api import Browser, Page
from loguru import logger

@dataclass
class AutomationContext:
    config: dict                          # .env + GUI 입력값
    browser: Browser | None = None        # Playwright 브라우저
    page: Page | None = None              # 현재 활성 페이지
    sap_session: Any = None               # SAP GUI 세션 (win32com)
    shared: dict = field(default_factory=dict)  # 스텝 간 데이터 공유
    output_dir: str = "output"
    log = logger
```

### 4-2. 스텝 모듈 표준 인터페이스

```python
# src/automation/step_01_login.py
from src.core.context import AutomationContext

def run(ctx: AutomationContext) -> None:
    """
    Step 01: SAP 포털 로그인
    
    입력 (ctx.config): SAP_URL, SAP_USERNAME, SAP_PASSWORD
    출력 (ctx.shared): logged_in=True
    예외: TimeoutError, AuthenticationError
    """
    ctx.log.info("Step 01: 로그인 시작")
    # ... 구현
    ctx.shared["logged_in"] = True
    ctx.log.info("Step 01: 완료")
```

### 4-3. 메인 실행 흐름

```python
# src/main.py
from src.automation import step_01_login, step_02_search, step_03_download
from src.core.context import AutomationContext

STEPS = [
    step_01_login,
    step_02_search,
    step_03_download,
]

def run_all(ctx: AutomationContext, on_progress=None):
    for i, step in enumerate(STEPS, 1):
        if on_progress:
            on_progress(i, len(STEPS), step.__name__)
        try:
            step.run(ctx)
        except Exception as e:
            ctx.log.exception(f"Step {i} 실패: {e}")
            raise
```

### 4-4. GUI 레이아웃 (PySide6)

최소 구성:

```
┌──────────────────────────────────────────────┐
│ [프로그램명]                            _ □ × │
├──────────────────────────────────────────────┤
│                                              │
│  ┌─ 설정 ────────────────────────────────┐  │
│  │ 사용자 ID: [____________]              │  │
│  │ 비밀번호:  [____________] [ ] 저장      │  │
│  │ 조회 날짜: [2026-05-13   ▼]            │  │
│  └────────────────────────────────────────┘  │
│                                              │
│  [ ▶ 실행 ]   [ ⏹ 중지 ]   [ 결과 폴더 ]    │
│                                              │
│  진행률: ▓▓▓▓▓▓▓░░░░░ 60% (Step 3/5)        │
│                                              │
│  ┌─ 실행 로그 ──────────────────────────┐   │
│  │ [09:01:23] Step 1: 로그인 시작        │   │
│  │ [09:01:25] Step 1: 완료              │   │
│  │ [09:01:25] Step 2: 거래처 조회 시작    │   │
│  │ ...                                  │   │
│  └──────────────────────────────────────┘   │
└──────────────────────────────────────────────┘
```

**필수 요소:**
- 진행률 바 (현재 스텝/전체 스텝)
- 실시간 로그 패널 (loguru sink로 GUI에 연결)
- 중지 버튼 (백그라운드 스레드 안전 종료)
- 결과 폴더 열기 버튼
- 자격증명 저장 체크박스 (keyring 사용)

### 4-5. 스레딩

- 자동화 실행은 **QThread** 또는 **threading.Thread** 로 분리 (GUI freeze 방지)
- 로그/진행률은 **Signal/Slot**으로 GUI 스레드에 전달

---

## 5. 보안 및 자격증명

### 5-1. 금지 사항
- 코드 내 평문 비밀번호 금지
- `.env` 파일을 Git에 커밋 금지
- 로그에 비밀번호 출력 금지 (loguru에서 마스킹 필터 적용)

### 5-2. 권장 방식

```python
# src/core/credentials.py
import keyring

def get_password(service: str, username: str) -> str | None:
    return keyring.get_password(service, username)

def save_password(service: str, username: str, password: str):
    keyring.set_password(service, username, password)
```

- 첫 실행: GUI에서 입력받아 keyring에 저장
- 이후 실행: keyring에서 자동 로드, 변경 시에만 GUI에 표시

---

## 6. 에러 처리 표준

### 6-1. 예외 분류

```python
# src/core/exceptions.py
class AutomationError(Exception): pass
class AuthenticationError(AutomationError): pass
class ElementNotFoundError(AutomationError): pass
class TimeoutError(AutomationError): pass
class DataValidationError(AutomationError): pass
```

### 6-2. 각 스텝의 의무
- 명확한 예외 메시지 (사용자가 무엇이 잘못됐는지 알 수 있게)
- 실패 시 화면 캡쳐를 `logs/screenshots/`에 자동 저장
- 재시도 가능한 작업은 `tenacity`로 3회 재시도

```python
from tenacity import retry, stop_after_attempt, wait_fixed

@retry(stop=stop_after_attempt(3), wait=wait_fixed(2))
def click_with_retry(page, selector):
    page.click(selector, timeout=5000)
```

### 6-3. 사용자 피드백
- GUI 상단에 빨간 알림 바
- "Step N 실패: <짧은 설명>. 로그 폴더를 확인하거나 개발자에게 문의하세요."

---

## 7. 빌드 및 배포

### 7-1. AI가 직접 실행하는 빌드 프로세스

**사용자에게 빌드 명령을 시키지 않는다. AI가 다 한다.**

#### 빌드 시점

모든 스텝이 검증 통과하면 AI는 사용자에게 묻는다:
```
모든 자동화 단계가 정상 동작하는 걸 확인했어요.
이제 최종 실행파일(.exe)로 만들어볼게요.
다른 PC에서도 Python 설치 없이 더블클릭만으로 실행할 수 있게요.

빌드를 시작할까요? (약 2~5분 소요)
```

사용자 OK 시 AI가 직접 수행:

#### AI 행동 순서

1. **`build.spec` 파일 자동 생성** (이전에 사용자가 답한 프로젝트명, 아이콘 반영)
2. **빌드 실행** (bash로 직접):
   ```bash
   venv\Scripts\pyinstaller build.spec --clean
   ```
3. **빌드 결과 확인** (`dist/<프로그램명>.exe` 존재 여부)
4. **결과 보고**:
   ```
   빌드 완료!
   
   실행파일 위치: dist/판매실적자동화.exe
   파일 크기: 약 65MB
   
   더블클릭만 하면 실행돼요. 다른 사람에게 줄 때는 이 .exe 파일
   하나만 보내주시면 됩니다.
   
   지금 한 번 실행해보시겠어요?
   ```

#### 빌드 실패 시

| 실패 유형 | AI 행동 |
|----------|---------|
| hidden import 누락 | AI가 `hiddenimports`에 자동 추가 후 재빌드 |
| 누락된 datas (assets 등) | AI가 자동 보강 후 재빌드 |
| PyInstaller 미설치 | AI가 자동 설치 후 재빌드 |
| 디스크 공간 부족 | 사용자에게 정중히 안내 ("약 1GB 빈 공간이 필요해요") |
| 그 외 알 수 없는 에러 | AI가 에러 분석 후 한국어로 원인 설명, 가능하면 수정 시도 |

빌드는 사용자가 "그냥 잘 됐다"만 알면 되는 단계여야 한다.

### 7-2. BUILD.md (참고용 문서, AI 자동 생성)

빌드 과정이 모두 AI 자동화이지만, **나중에 다른 팀원이 인수받을 때 참고할 수 있게** AI는 `BUILD.md`도 생성한다. 내용:
- 환경 정보 (Python 버전, 주요 의존성)
- AI가 실행했던 빌드 명령 기록
- 재빌드가 필요할 때의 명령어 모음

### 7-3. README.md (최종 사용자용, AI 자동 생성)

AI는 비개발자 사용자를 위한 README를 작성한다:
- 다운로드/설치 방법 (또는 exe 위치)
- 첫 실행 시 자격증명 입력 안내 (스크린샷 위치 안내)
- 기본 사용법
- FAQ / 트러블슈팅 (자주 발생하는 에러 5개)
- 문의처

---

## 8. 품질 체크리스트 (AI 자체 검증)

**모든 스텝 완료 후, 최종 빌드 직전에 AI는 아래를 자체 점검한다.**

### 8-1. 코드 품질
- [ ] 모든 스텝 모듈에 docstring 존재
- [ ] 하드코딩된 자격증명 없음 (grep으로 `password=`, `pw=` 등 검색)
- [ ] 모든 try/except에 구체적 예외 타입 명시 (bare except 금지)
- [ ] 로그 레벨 적절성 (debug/info/warning/error 구분)
- [ ] **경로 일관성**: 모든 스텝이 DECISIONS.md에 기록된 단일 경로(웹 또는 SAP GUI)만 사용
  - 웹 프로젝트면 `win32com.GetObject("SAPGUI")` 호출 없음
  - SAP GUI 프로젝트면 `playwright`, `requests` 등 웹 자동화 코드 없음
  - grep으로 교차 검증

### 8-2. 동작
- [ ] `python -m src.main` 으로 GUI 실행됨
- [ ] 각 스텝 단독 실행 (`python -m tests.test_step_NN`) 가능
- [ ] 전체 시나리오 end-to-end 실행 성공 (최소 1회)
- [ ] 중간 실패 시 적절한 에러 메시지 표시

### 8-3. 배포
- [ ] `pyinstaller build.spec --clean` 성공
- [ ] 생성된 exe가 개발 머신 외 다른 PC에서 실행됨 (가능 시 테스트)
- [ ] README.md, BUILD.md 모두 존재

### 8-4. 문서 및 상태 파일
- [ ] PROGRESS.md에 모든 스텝 체크됨, 최종 상태=완료
- [ ] DECISIONS.md에 모든 의사결정 기록됨
- [ ] STEP_LOGS/ 에 모든 스텝별 로그 존재 (캡쳐/분석/코드/검증 4개 섹션 모두 채워짐)
- [ ] 각 스텝의 캡쳐가 captures/에 보관됨 (인수인계 자료로 활용)
- [ ] 새 세션에서 이 폴더를 열었을 때 AI가 이어받기 가능한 상태인지 자체 검증
      (PROGRESS.md만 읽고도 "마지막 완료 스텝"과 "다음 작업"이 즉시 파악되는가?)

---

## 9. 인수인계 시나리오

이 프로그램이 완성된 후, **다른 팀원이 동일한 PRD로 새 자동화를 만들 때**의 흐름:

1. 이 PRD 파일과 폴더 템플릿을 복사
2. Claude Code 또는 다른 CLI AI를 폴더에서 실행
3. AI가 `0. AI가 가장 먼저 해야 할 일` 섹션부터 자동 수행
4. 단계별 대화로 자동화 완성
5. exe 빌드 후 현업에 배포

**즉, 이 PRD 자체가 "자동화 프로그램을 만드는 자동화"의 사양서다.**

---

## 10. 부록

### 10-1. 자주 쓰는 라이브러리 import 치트시트

```python
# 웹 자동화
from playwright.sync_api import sync_playwright, expect

# SAP GUI
import win32com.client
sap_gui = win32com.client.GetObject("SAPGUI")

# 데스크탑 자동화
from pywinauto import Application, Desktop

# 이미지 기반
import pyautogui
import cv2

# GUI
from PySide6.QtWidgets import QApplication, QMainWindow
from PySide6.QtCore import QThread, Signal

# 보조
from loguru import logger
import keyring
from tenacity import retry, stop_after_attempt
```

### 10-2. requirements.txt 베이스라인

```
PySide6>=6.6
playwright>=1.40
pywinauto>=0.6.8
pyautogui>=0.9.54
opencv-python>=4.9
openpyxl>=3.1
xlwings>=0.31
pywin32>=306
loguru>=0.7
python-dotenv>=1.0
pydantic-settings>=2.1
keyring>=24.3
tenacity>=8.2
pytesseract>=0.3.10
pyinstaller>=6.3
```

### 10-3. .gitignore 베이스라인

```
.env
*.pyc
__pycache__/
venv/
.venv/
dist/
build/
*.spec.bak
logs/
output/
captures/  # 사내 화면 캡쳐는 외부 유출 금지
```

---

## 끝.

### AI에게

> 이 PRD를 받은 AI는 **섹션 0부터 순서대로** 실행하세요.
>
> **사용자는 바이브 코딩이 처음일 수 있습니다.**
> - 터미널 명령을 사용자에게 시키지 마세요. 당신이 직접 실행하세요.
> - 에러 메시지를 그대로 던지지 마세요. 한국어로 풀어서 설명하세요.
> - 전문 용어는 짧은 부연을 붙이거나 풀어서 쓰세요.
> - 매 응답 끝에 "이제 무엇을 하면 되는지" 한 줄을 두세요.
> - 사용자가 막혀하면 압박하지 말고 안심시키세요.
>
> **막히면 추측하지 말고 사용자에게 질문하세요.**
> 단, 질문하기 전에 "이걸 내가 직접 해결할 수 있나?"를 먼저 자문하세요.
>
> **그리고 매 스텝마다 PROGRESS.md, DECISIONS.md, STEP_LOGS/step_NN.md 를 갱신하세요.**
> **이 갱신을 빼먹으면 다음 세션에서 이어받을 수 없습니다.**
> **모든 응답을 마치기 직전에 "상태 파일을 갱신했는가?" 자체 점검하세요.**

### 사용자에게 (이 PRD를 사용하는 분)

> 이 PRD가 있는 폴더에서 Claude Code 같은 CLI AI 도구를 켜시면,
> AI가 알아서 모든 걸 시작합니다.
>
> 당신이 할 일은 4가지뿐입니다.
> 1. 자동화하고 싶은 업무 설명하기
> 2. 화면 캡쳐를 폴더에 넣기
> 3. AI가 묻는 것에 답하기
> 4. AI가 보여주는 결과 확인하기
>
> 터미널 명령, 코드 수정, 설치, 빌드는 **AI가 다 합니다.**
> 막히면 "막혔어" 또는 "이게 안 돼"라고만 알려주세요. AI가 도와드립니다.
