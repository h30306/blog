---
title: "LeetCode 2102: Sequentially Ordinal Rank Tracker"
summary: "LeetCode 2102 解題筆記：雙 heap 維持「前 k 名」和「其他」，自訂 __lt__ 處理字串的反向比較"
description: "2026-08-01 的 LeetCode 2102 解題紀錄"
date: 2026-08-01
tags: ["hard", "heap", "design", "two-heaps"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-08-01
- 提交紀錄：Accepted（一次通過）

## 解題思路

第 `i` 次查詢要回傳第 `i` 好的地點，而且 `i` 每次查詢只會加 1。

用兩個 heap，把所有地點分成兩邊：

- `top`：目前最好的 `k` 個地點，`k` 是已經查詢的次數。堆頂是這 `k` 個裡**最差**的，也就是第 `k` 名。
- `rest`：其他地點，堆頂是其中**最好**的，也就是第 `k + 1` 名。

操作：

- **`add`**：新地點先放進 `top`，再把 `top` 裡最差的移到 `rest`。這樣 `top` 的大小不變，而且保證 `top` 裡的都比 `rest` 好。
- **`get`**：`k` 加 1，把 `rest` 最好的移進 `top`，這時 `top` 的堆頂就是第 `k` 名。

### 排序規則的麻煩

「分數高比較好，分數相同時名字字典序小比較好」。`rest` 要取最好的，可以用 `(-score, name)`。但 `top` 要取**最差**的：分數低比較差，分數相同時名字**大**比較差。字串沒辦法取負號，所以自訂一個 class 的 `__lt__`。

## 我的解法

```python
import heapq

class WorstFirst:
    """heap 頂端是最差的：分數低，或分數相同時名字大。"""
    def __init__(self, score: int, name: str):
        self.score = score
        self.name = name

    def __lt__(self, other: "WorstFirst") -> bool:
        if self.score != other.score:
            return self.score < other.score
        return self.name > other.name

class SORTracker:

    def __init__(self):
        self.top = []        # 前 k 名，堆頂是第 k 名
        self.rest = []       # 其他，(-score, name)，堆頂是第 k+1 名

    def add(self, name: str, score: int) -> None:
        heapq.heappush(self.top, WorstFirst(score, name))
        worst = heapq.heappop(self.top)
        heapq.heappush(self.rest, (-worst.score, worst.name))

    def get(self) -> str:
        neg_score, name = heapq.heappop(self.rest)
        heapq.heappush(self.top, WorstFirst(-neg_score, name))
        return self.top[0].name
```

## 複雜度

`add` 和 `get` 都是 `O(log n)`，空間 `O(n)`。

## 要特別避免的錯誤

- `add` 時直接放進 `rest`：如果新地點比 `top` 裡最差的還好，`top` 就不再是真正的前 `k` 名。
- 想用 `(score, 反轉的字串)` 之類的技巧模擬字串的反向比較，很容易出錯。自訂 `__lt__` 比較清楚。

## 面試口說整理

查詢的名次每次只加 1，所以我用兩個 heap：一個存前 `k` 名，堆頂是第 `k` 名；另一個存其他，堆頂是第 `k + 1` 名。新增時先放進前 `k` 名那邊，再把最差的移到另一邊；查詢時把另一邊最好的移過來，前 `k` 名的堆頂就是答案。因為「名字大比較差」沒辦法用負號表示，我自訂 `__lt__`。兩個操作都是 `O(log n)`。
