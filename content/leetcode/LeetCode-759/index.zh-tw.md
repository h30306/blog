---
title: "LeetCode 759: Employee Free Time"
summary: "LeetCode 759 解題筆記：用 K 路合併依開始時間掃過所有工作區間，目前最晚結束時間之後的空檔就是共同空閒"
description: "2026-05-03 的 LeetCode 759 解題紀錄"
date: 2026-05-03
tags: ["hard", "heap", "k-way-merge", "intervals", "sweep-line"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-05-03
- 提交紀錄：Runtime Error（只交了空的函式）→ Accepted（2026-09-06）

## 解題思路

所有員工的工作時間合起來，**沒有被任何人佔用的有限空檔**就是答案。

依開始時間掃過所有工作區間，同時記錄「目前為止最晚的結束時間」`prev_end`：

- 下一個區間的開始時間 `> prev_end`：中間這段 `[prev_end, start]` 沒有人在工作，是共同空閒。
- 否則有重疊，更新 `prev_end = max(prev_end, end)`。

每個員工的區間本來就已經排好序，所以可以用 K 路合併依序取出，不用把全部攤平再排序。

## 我的嘗試

五月第一次打開這題時，只送出了空的函式，所以是 Runtime Error。九月回來重寫才 AC。

## 正確解法

```python
import heapq

class Solution:
    def employeeFreeTime(self, schedule: '[[Interval]]') -> '[Interval]':
        heap = [(emp[0].start, i, 0) for i, emp in enumerate(schedule) if emp]
        heapq.heapify(heap)
        if not heap:
            return []

        res = []
        prev_end = schedule[heap[0][1]][0].end
        while heap:
            start, i, j = heapq.heappop(heap)
            if start > prev_end:
                res.append(Interval(prev_end, start))
            prev_end = max(prev_end, schedule[i][j].end)
            if j + 1 < len(schedule[i]):
                heapq.heappush(heap, (schedule[i][j + 1].start, i, j + 1))
        return res
```

### 另一種寫法：攤平後排序

```python
class Solution:
    def employeeFreeTime(self, schedule: '[[Interval]]') -> '[Interval]':
        intervals = sorted((iv.start, iv.end) for emp in schedule for iv in emp)
        res = []
        prev_end = intervals[0][1]
        for start, end in intervals[1:]:
            if start > prev_end:
                res.append(Interval(prev_end, start))
            prev_end = max(prev_end, end)
        return res
```

程式碼比較短，代價是 `O(N log N)` 而不是 `O(N log k)`。

## 複雜度

K 路合併：時間 `O(N log k)`，空間 `O(k)`。攤平排序：時間 `O(N log N)`。

## 要特別避免的錯誤

- 用「上一個區間的結束時間」而不是「目前最晚的結束時間」：短區間包在長區間裡時會誤判出空檔。
- 把 `start == prev_end` 也當成空檔：長度為 0 的空檔不能算。
- 輸出的是 `Interval` 物件，不是 list。

## 面試口說整理

我把所有員工的工作區間依開始時間掃過去，同時記錄目前最晚的結束時間。如果下一個區間的開始時間比它大，中間就是所有人都沒在工作的時間，加進答案；否則更新最晚的結束時間。每個員工的區間已經排序，所以用 heap 做 K 路合併，時間 `O(N log k)`。
