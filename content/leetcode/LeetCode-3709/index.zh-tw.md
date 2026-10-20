---
title: "LeetCode 3709: Design Exam Scores Tracker"
summary: "LeetCode 3709 解題筆記：時間遞增，存前綴和，查詢用兩次 bisect；mid 一定要加括號"
description: "2025-10-11 的 LeetCode 3709 解題紀錄"
date: 2025-10-11
tags: ["medium", "binary-search", "prefix-sum", "design"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-10-11
- 提交紀錄：Wrong Answer → Runtime Error → Wrong Answer → Accepted

## 解題思路

`record` 的時間嚴格遞增，所以時間陣列本身就是排好序的，不需要額外排序。

- `times`：所有紀錄的時間。
- `prefix`：分數的前綴和，`prefix[i]` 是前 `i` 筆的總和，`prefix[0] = 0`。

查詢 `[start, end]` 時：

```text
左邊界 = 第一個 time >= start 的位置 = bisect_left(times, start)
右邊界 = 第一個 time >  end   的位置 = bisect_right(times, end)
總分   = prefix[右邊界] - prefix[左邊界]
```

`prefix` 前面多放一個 0，就不用處理「左邊界是 0」的特殊情況。

## 我的嘗試

### WA 和 RE：`mid` 少了括號

```python
mid = left + right // 2       # 等於 left + (right // 2)
```

`//` 的優先順序比 `+` 高，所以 `mid` 會超過正確範圍，有時找錯位置（WA），有時直接越界（RE）。

### WA：查詢區間沒有任何紀錄

修好 `mid` 之後，查詢的範圍裡如果沒有任何考試，算出來的左邊界會大於右邊界，結果變成負數或讀錯位置。最後加了一堆邊界判斷才 AC。

**根本原因是前綴和沒有在最前面放 0**，所以要一直特判「左邊界是不是 0」。改成 `prefix[0] = 0` 加上左閉右開的兩個邊界之後，這些特判都不需要了：沒有紀錄時兩個邊界相等，相減自然是 0。

## 正確解法

```python
import bisect

class ExamTracker:

    def __init__(self):
        self.times = []
        self.prefix = [0]

    def record(self, time: int, score: int) -> None:
        self.times.append(time)
        self.prefix.append(self.prefix[-1] + score)

    def totalScore(self, startTime: int, endTime: int) -> int:
        lo = bisect.bisect_left(self.times, startTime)
        hi = bisect.bisect_right(self.times, endTime)
        return self.prefix[hi] - self.prefix[lo]
```

## 複雜度

`record` 是 `O(1)`，`totalScore` 是 `O(log n)`。空間 `O(n)`。

## 要特別避免的錯誤

- `mid = left + right // 2`：少了括號。
- 前綴和沒有在最前面放 0，導致一堆特判。
- 區間內沒有紀錄時沒有回傳 0。

## 面試口說整理

紀錄的時間嚴格遞增，所以我直接存時間陣列和分數的前綴和，前綴和前面多放一個 0。查詢時用 `bisect_left` 找第一個時間不小於起點的位置、`bisect_right` 找第一個時間大於終點的位置，前綴和相減就是總分；沒有紀錄時兩個位置相同，結果自然是 0。記錄 `O(1)`，查詢 `O(log n)`。
