---
title: "LeetCode 253: Meeting Rooms II"
summary: "LeetCode 253 解題筆記：heap 存進行中會議的結束時間，半開區間要用 <="
description: "2026-10-15 的 LeetCode 253 解題紀錄"
date: 2026-10-15
tags: ["medium", "heap", "sorting", "intervals", "sweep-line"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-10-15
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

需要的房間數 = **同一時間最多有幾場會議在進行**。

依開始時間排序，用 min-heap 存「進行中會議的結束時間」。每場新會議開始前，先把已經結束的會議彈出，再把自己的結束時間推進去。過程中 heap 的最大長度就是答案。

## 我的第一版：`<` 應該是 `<=`

```python
while heap and heap[0] < start:      # 結束時間 == 開始時間時沒有彈出
    heapq.heappop(heap)
```

會議是半開區間 `[start, end)`：一場會議在 10 點結束，另一場 10 點開始，可以用同一間房間。所以結束時間**等於**開始時間時也要彈出，條件要用 `<=`。

## 正確解法

```python
import heapq

class Solution:
    def minMeetingRooms(self, intervals: List[List[int]]) -> int:
        intervals.sort()
        heap = []
        best = 0
        for start, end in intervals:
            while heap and heap[0] <= start:
                heapq.heappop(heap)
            heapq.heappush(heap, end)
            best = max(best, len(heap))
        return best
```

原本另外用 `count` 記錄 heap 的大小，其實 `len(heap)` 就是。

### 另一種解法：開始和結束分開排序

```python
class Solution:
    def minMeetingRooms(self, intervals: List[List[int]]) -> int:
        starts = sorted(s for s, _ in intervals)
        ends = sorted(e for _, e in intervals)
        rooms = best = j = 0
        for s in starts:
            while ends[j] <= s:          # 先釋放已經結束的
                rooms -= 1
                j += 1
            rooms += 1
            best = max(best, rooms)
        return best
```

## 複雜度

兩種解法都是時間 `O(n log n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 半開區間用 `<`：同一時刻結束和開始的會議會被當成重疊。
- 只看相鄰兩場會議有沒有重疊：要看的是「同時進行的數量」。

## 面試口說整理

需要的房間數是同時進行的會議的最大數量。我依開始時間排序，用 min-heap 存進行中會議的結束時間；每場會議開始前，先彈出結束時間小於等於它開始時間的會議，因為區間是半開的，剛好結束的房間可以重用。再把自己的結束時間推進去，heap 的最大長度就是答案。時間 `O(n log n)`。
