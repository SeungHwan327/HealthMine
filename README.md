# 🏋️ HealthMine

> 나만의 운동 기록을 저장하고 운동 데이터를 분석할 수 있는 iOS 헬스 관리 앱

## 📱 Introduction

**HealthMine**은 사용자의 운동 기록을 날짜별로 관리하고, 축적된 운동 데이터를 분석할 수 있는 iOS 애플리케이션입니다.

운동 종목별 무게와 반복 횟수를 기록하고, 이를 바탕으로 운동 볼륨을 계산하여 자신의 운동량과 운동 패턴을 확인할 수 있습니다.

---

## ✨ Features

### 📝 Workout Log

* 날짜별 운동 기록 관리
* Push / Pull / Legs(PPL) 운동 분할
* 운동 종목별 세트 기록
* 무게 및 반복 횟수 입력
* 이전 운동 기록을 활용한 빠른 운동 기록

### 📊 Workout Analysis

* 운동 종목별 운동 볼륨 계산
* 날짜별 운동 데이터 확인
* Push / Pull / Legs별 평균 운동 볼륨 분석
* 최고 운동 볼륨(PR) 확인
* Swift Charts를 활용한 데이터 시각화

### 👤 Profile

* 사용자 체중 설정
* 맨몸 운동 시 체중을 고려한 운동 볼륨 계산

### 💾 Local Storage

* 운동 기록 로컬 저장
* 앱을 종료한 후에도 운동 기록 유지

---

## 🛠 Tech Stack

| Category | Technology   |
| :------- | :----------- |
| Language | Swift        |
| UI       | SwiftUI      |
| Chart    | Swift Charts |
| Storage  | UserDefaults |
| IDE      | Xcode        |

---

## 📂 Project Structure

```text
HealthMine
├── Models
│   ├── DailyLog
│   ├── Exercise
│   └── UserProfile
│
├── Views
│   ├── Home
│   ├── Workout
│   ├── Calendar
│   ├── Analysis
│   └── Profile
│
└── HealthMineApp.swift
```

---

## 🎯 Goal

HealthMine은 복잡한 운동 관리 서비스보다 개인이 자신의 운동을 쉽고 빠르게 기록할 수 있도록 만드는 것을 목표로 합니다.

단순히 운동 데이터를 저장하는 것에서 끝나는 것이 아니라, 축적된 데이터를 활용하여 운동 볼륨과 운동 패턴을 분석하고 자신의 운동 성과를 확인할 수 있도록 구현했습니다.

---

## 🚀 Future Improvements

* [ ] 단백질 섭취량 관리
* [ ] 캘린더 기능 개선
* [ ] 사용자 프로필 데이터 영구 저장
* [ ] 운동 기록 수정 및 삭제 기능 개선
* [ ] 주간 / 월간 운동 통계
* [ ] 운동 루틴 관리
* [ ] 데이터 백업 및 동기화

---

## 👨‍💻 Developer

**HealthMine**

Personal iOS Project built with **SwiftUI**
