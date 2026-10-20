---
title: "LeetCode 1353: Maximum Number of Events That Can Be Attended"
summary: "LeetCode 1353 解題筆記：每天參加「最早結束」的活動，用 min-heap 存結束日"
description: "2025-07-07 的 LeetCode 1353 解題紀錄"
date: 2025-07-07
tags: ["medium", "heap", "greedy", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-07-07
- 提交紀錄：Wrong Answer → Accepted → Accepted（整理過一次）

## 解題思路

每個活動可以在 `[start, end]` 之間任選一天參加，一天只能參加一個。

貪心：**每天在「已經開始、還沒結束」的活動裡，參加最早結束的那個。** 晚結束的活動之後還有機會，早結束的錯過就沒了。

做法：

1. 依開始日排序。
2. 用 min-heap 存「已經開始的活動的結束日」。
3. 每天先把今天開始的活動推進 heap，丟掉已經過期的，再參加堆頂那個。

## 我的第一版：一天對應一個活動

```python
events.sort(key=lambda x: x[0])
for s, e in events:
    if time >= s and time <= e:
        res += 1
    time += 1
```

這等於強迫第 `i` 個活動在第 `i` 天參加，完全沒有選擇的空間。像 `[[1,5],[1,5],[1,5]]` 可以參加 3 個，這版可以算對；但如果活動之間有空檔，`time` 不會跳到下一個活動開始的那天，結果就會錯。

## 正確解法

```python
import heapq

class Solution:
    def maxEvents(self, events: List[List[int]]) -> int:
        events.sort()
        heap = []
        res = i = day = 0
        n = len(events)

        while i < n or heap:
            if not heap:
                day = events[i][0]                 # 沒有可參加的活動，直接跳到下一個開始日
            while i < n and events[i][0] <= day:
                heapq.heappush(heap, events[i][1])
                i += 1

            heapq.heappop(heap)                    # 參加最早結束的
            res += 1
            day += 1

            while heap and heap[0] < day:          # 丟掉已經結束的
                heapq.heappop(heap)
        return res
```

## 複雜度

時間 `O(n log n)`：排序加上每個活動進出 heap 一次。空間 `O(n)`。

## 要特別避免的錯誤

- 依開始日排序後直接一對一配對，沒有選擇「最早結束」的機制。
- 沒有丟掉已經過期的活動：堆頂可能是早就結束的活動。
- 一天一天往前走，沒有在 heap 空的時候跳到下一個開始日：天數最多 `10^5`，跳過可以省時間。

## 面試口說整理

我的貪心是每天參加已經開始的活動中最早結束的那個，因為晚結束的之後還有機會。依開始日排序，用 min-heap 存結束日：每天把開始的活動加進來，丟掉已經過期的，再取堆頂參加。heap 空的時候直接跳到下一個活動的開始日。時間 `O(n log n)`。
