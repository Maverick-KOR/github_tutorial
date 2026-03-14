# Project Mail Graph for Outlook — 개발 작업지시서

## 1) 프로젝트 개요

**프로젝트명:** Project Mail Graph for Outlook  
**한 줄 정의:** Outlook 메일을 프로젝트 단위 타임라인과 관계 그래프로 재구성하는 실무형 인텔리전스 애드온

기존 Outlook의 메일/스레드 중심 UI를 넘어서, 본 애드온은 이메일을 다음 관점으로 다룬다.
- 프로젝트 진행 이력
- 의사결정 근거
- 이해관계자 네트워크
- 이슈/문서 연결점
- 후속 action의 원인과 경과

---

## 2) 개발 목표

다음 4가지를 MVP 핵심 목표로 한다.
1. **프로젝트별 타임라인화**: 메일을 사건(event) 단위로 배열
2. **관계 연결**: 메일/사람/프로젝트/이슈를 사용자 수동으로 연결
3. **속성 구조화**: 태그/상태/중요도 등 부여 및 검색 가능화
4. **네트워크 가시화**: 사람 중심 커뮤니케이션 구조 파악

> 이 도구의 목적은 받은편지함 정리가 아니라, **프로젝트 기록/복기/분석**이다.

---

## 3) MVP 범위 (Phase 1)

### 포함
1. Outlook 메일 선택 시 Add-in 우측 패널 표시
2. 메일 ↔ 프로젝트 연결
3. 메일 속성/태그 편집
4. 프로젝트별 타임라인 조회
5. 메일 간 관계 수동 연결
6. 프로젝트별 사람 네트워크 시각화(기본)
7. 필터 및 검색

### 제외
- AI 자동 요약 고도화
- 본문 의미 기반 자동 분류 고도화
- 첨부 OCR/문서 구조 해석
- 외부 협업툴 연동
- 모바일 앱

---

## 4) 화면 구조

Outlook 우측 패널 탭 구성:
1. **Overview**
2. **Timeline**
3. **Relations**
4. **Network**
5. **Properties**

### 4.1 Overview
- 표시: 제목, 발신자/수신자, 수신일시, 연결 프로젝트/이슈, 중요도, 상태, 관계 링크 수
- 액션: 프로젝트 연결, 관계 추가, 속성 편집, 타임라인에서 보기

### 4.2 Timeline
- 기준: 선택 프로젝트
- 필수: 날짜순 정렬, 중요 이벤트 강조, 필터링, 클릭 시 원문 이동, 유형별 아이콘/색 구분
- 카드 정보: 날짜/시간, 제목, 관련 인물/프로젝트/이슈, 중요도, 후속 여부

### 4.3 Relations
- 가능 작업: 메일↔메일/프로젝트/이슈/사람 연결, 관계 유형 지정/삭제
- 관계 유형 예시:
  - `follows`
  - `relates_to`
  - `belongs_to_project`
  - `concerns_issue`
  - `involves_person`
  - `decision_for`
  - `response_to`
- 원칙: 자동 추론보다 **사용자 수동 등록 우선**

### 4.4 Network
- 기준: 선택 프로젝트
- 최소 요소:
  - 노드: 사람
  - 엣지: 메일 송수신 관계
  - 노드 크기: 빈도/중심성
  - 내부/외부 구분
  - hover 상세 정보
- 필터: 기간, 내부만, 외부만, 특정 이슈, 특정 사람 중심

### 4.5 Properties
- 메일/관계 객체 속성 편집
- 메일 속성 예시: 프로젝트명, 단계, 이슈 카테고리, 중요도, 보안등급, 내부/외부, action needed, decision relevance, owner
- 프로젝트 속성 예시: 프로젝트명, 코드명, 상태, 시작일, 담당자, 관련 조직
- 사람 속성 예시: 소속, 역할, 내부/외부, 분류(자문사/상대방/내부)

---

## 5) 데이터 모델 (Graph 중심)

### Node 타입
- `Email`
- `Person`
- `Project`
- `Issue`
- `Attachment`

### Edge 타입
- `SENT_TO`
- `SENT_FROM`
- `CC_TO`
- `BELONGS_TO_PROJECT`
- `RELATES_TO`
- `FOLLOWS`
- `CONCERNS`
- `INVOLVES`
- `HAS_ATTACHMENT`

### 주요 필드

#### Email
- `email_id`
- `internet_message_id`
- `subject`
- `sender`
- `recipients`
- `cc`
- `sent_datetime`
- `received_datetime`
- `conversation_id`
- `preview`
- `project_ids[]`
- `issue_ids[]`
- `importance`
- `status`
- `tags[]`
- `notes`
- `created_by_user`
- `updated_at`

#### Person
- `person_id`
- `name`
- `email`
- `organization`
- `role`
- `internal_external_flag`

#### Project
- `project_id`
- `project_name`
- `code_name`
- `description`
- `status`
- `owner`
- `tags[]`

#### Issue
- `issue_id`
- `issue_name`
- `category`
- `description`
- `status`

---

## 6) 기술 스택 제안

### 프론트엔드
- Outlook Add-in
- Office.js
- React
- TypeScript

### 백엔드
- Node.js 또는 .NET (팀 표준 우선)
- Microsoft Graph API
- Microsoft 365 인증 기반

### 저장소
- 우선 검토: **Neo4j** (관계 중심 탐색/분석에 유리)
- 운영 단순화용 혼합안:
  - 메타데이터: PostgreSQL
  - 관계탐색: Neo4j

---

## 7) 자동화 범위

### 1차 자동화 (MVP)
- 메일 기본 메타데이터 자동 수집
- `conversation_id` 기반 기본 연결
- 발신/수신자 자동 Person 노드 생성
- 프로젝트 연결 시 타임라인 자동 반영

### 2차 후보
- 제목/첨부명 유사도 기반 관련 메일 추천
- 본문 키워드 기반 이슈 추천
- action item 감지
- 의사결정 메일 후보 추천

---

## 8) UX 원칙

1. **입력 속도**: 메일-프로젝트 연결 + 태깅 5초 이내
2. **원문 접근성**: 타임라인/그래프에서 원메일 즉시 이동
3. **관계 등록 단순성**: 유형 선택 + 대상 검색 + 즉시 저장
4. **검색력**: 프로젝트/사람/태그/기간/중요도 필터
5. **실무 정보 밀도**: 과도한 카드형 UI 지양, 고밀도/고속 우선

---

## 9) 보안/운영 요구사항

- 사내 계정 인증 기반 접근
- 프로젝트별 접근 제어 검토
- 최소 메타데이터 저장 원칙
- 본문 저장 정책 별도 검토
- 감사 가능한 로그 구조
- 민감 태그/`confidential` 분류 지원

권장:
- 초기에는 본문 전문 저장 지양
- 링크 + 요약 + 메타데이터 중심
- 필요 시 본문 일부만 인덱싱

---

## 10) 단계별 개발 로드맵

### Phase 1 (MVP)
- Add-in 패널
- 프로젝트 연결
- 속성 입력
- 타임라인
- 관계 수동 연결
- 기본 네트워크

### Phase 2
- 자동 추천
- 고급 필터
- 대시보드
- 중요 이벤트 자동 추출
- 프로젝트 요약

### Phase 3
- AI 이슈 분류
- 의사결정 메일 자동 탐지
- 첨부파일 연결
- 보고자료 export

---

## 11) 수용 기준 (Acceptance Criteria)

1. Outlook에서 메일 열람 중 프로젝트 지정 가능
2. 지정 즉시 프로젝트 타임라인 반영
3. 메일↔메일/이슈 연결 가능
4. 프로젝트 메일 흐름의 시간순 조회 가능
5. 프로젝트 사람 네트워크 조회 가능
6. 태그/중요도/상태 속성 수정 및 저장 가능
7. 재실행 시 데이터 유지
8. 원문 메일로 빠른 이동 가능

---

## 12) 프로그래머 전달용 핵심 문구

> 이 프로젝트는 **“Outlook 메일을 프로젝트별 타임라인과 관계 그래프로 재구성하는 실무용 애드온”**이다.  
> 받은편지함을 꾸미는 것이 아니라 프로젝트 기록, 관계 추적, 이슈 복기, 커뮤니케이션 구조 파악이 목적이다.

---

## 13) 아주 짧은 요약

- 메일을 프로젝트에 연결
- 메일에 속성 부여
- 메일/사람/이슈 연결
- 프로젝트별 타임라인 조회
- 사람 네트워크 조회

즉, 이메일을 **메시지(message)**가 아니라 **프로젝트 사건(event)**으로 다룬다.
