---
title: "LeetCode 3439: Reschedule Meetings for Maximum Free Time (Sliding Window)"
summary: "LeetCode 解題紀錄"
description: "LeetCode Daily"
date: 2025-08-09
tags: ["LeetCode", "daily", "medium", "sliding-window", "two-pointers", "intervals", "array"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: Medium
第一次嘗試： 2025-08-09
- 總花費時間：00:00.00

## 解題思路

會議已排序且不重疊。若把最多 k 個連續會議移到其他時間，留下的空檔介於「區塊左側上一個會議的結束」與「區塊右側下一個會議的開始」之間（或日程邊界）。空檔長度 = 右邊界 − 左邊界 −（區塊內所有會議的總時長）。

為了 O(1) 地移動視窗，維護「區塊內會議總時長」：
- 先計算前 k 場的總時長作為初始視窗；若 n ≤ k，代表可移走全部會議，答案為 `eventTime - sum(endTime) + sum(startTime)`。
- 若 k < n，初始答案為 `startTime[k] - meeting_time`。
- 接著令 i 從 k 迭代到 n-1：每一步把第 i 場加入、把第 i-k 場移出，更新 `meeting_time`。
- 邊界：`left = endTime[i - k]`，`right = startTime[i + 1]`（若 i 為最後一場，`right = eventTime`）。
- 用 `right - left - meeting_time` 更新最大空檔。

## 解法

- 使用滑動視窗代表要移動的會議區塊，維護區塊大小與區塊內總時長。
- 當視窗超過 k，就從左側移出最舊的會議並從總時長扣除。
- 左邊界：`0` 或 `endTime[idx - k]`；右邊界：`eventTime` 或 `startTime[idx + 1]`。
- 每一步用 `right - left - meeting_times` 更新答案。

### Directly iterate the meeting times
```python
class Solution:
    def maxFreeTime(self, eventTime: int, k: int, startTime: List[int], endTime: List[int]) -> int:

        meeting_times = meeting_counts = max_free = 0
        for idx, (s, e) in enumerate(zip(startTime, endTime)):
            meeting_times += e - s
            meeting_counts += 1
            
            if meeting_counts > k:
                meeting_counts -= 1
                meeting_times -= endTime[idx - k] - startTime[idx - k]

            left = 0 if (idx - k + 1) <= 0 else endTime[idx - k]
            right = eventTime if idx == len(startTime) - 1 else startTime[idx + 1]
            max_free = max(max_free, right - left - meeting_times)

        return max_free
```

### Count the first window and slide the window
```python
class Solution:
    def maxFreeTime(self, eventTime: int, k: int, startTime: List[int], endTime: List[int]) -> int:
        n = len(startTime)
        if n <= k:
            return eventTime - sum(endTime) + sum(startTime)

        meeting_time = 0
        for i in range(k):
            meeting_time += endTime[i] - startTime[i]
        
        max_free = startTime[k] - meeting_time

        for i in range(k, n):
            meeting_time += endTime[i] - startTime[i]
            meeting_time -= endTime[i - k] - startTime[i - k]

            right = startTime[i + 1] if i < n - 1 else eventTime
            left = endTime[i - k]

            max_free = max(max_free, right - left - meeting_time)

        return max_free
```

## 複雜度

- 時間複雜度：O(n)
- 空間複雜度：O(1)

## 收穫

- 維護區塊內總時長讓視窗移動的更新是 O(1)。
- 空檔由視窗兩側邊界決定，扣掉視窗內的會議總長度即可。

## 遇到的問題