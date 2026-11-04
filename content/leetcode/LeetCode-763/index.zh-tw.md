---
title: "LeetCode 763: Partition Labels"
summary: "LeetCode 763 解題筆記：先記每個字母最後出現的位置，掃描時把這段的結尾延伸到最遠，走到結尾就切"
description: "2026-11-03 的 LeetCode 763 解題紀錄"
date: 2026-11-03
tags: ["medium", "hash-table", "two-pointers", "string", "greedy"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-11-03
- 提交紀錄：Accepted（一次通過）

## 解題思路

同一個字母只能出現在一段裡，所以一段的結尾，至少要到段內每個字母**最後一次出現**的位置（[Greedy]({{< relref "/algorithm/Greedy" >}})）：
1. 先掃一遍，記下每個字母最後出現的位置 `last`。
2. 再掃一遍，維護目前這段的結尾 `end = max(end, last[c])`。
3. 走到 `i == end`：段內所有字母都不會再出現，可以切。

每段都在最早能切的地方切，段數就最多。

## 我的嘗試

一次通過。我的寫法是在下一個 `i` 超過 `end` 時才切，迴圈結束後再補最後一段。下面改成在 `i == end` 當下就切，不用另外補最後一段。

## 正確解法

```python
class Solution:
    def partitionLabels(self, s: str) -> List[int]:
        last = {c: i for i, c in enumerate(s)}
        res = []
        start = end = 0
        for i, c in enumerate(s):
            end = max(end, last[c])
            if i == end:              # 段內的字母後面都不會再出現
                res.append(end - start + 1)
                start = i + 1
        return res
```

## 複雜度

時間 `O(n)`，空間 `O(1)`（最多 26 個字母）。

## 要特別避免的錯誤

- 用第一次出現的位置：決定能不能切的是字母**最後**出現在哪裡。
- 只看目前字母的 `last[c]` 判斷能不能切：要用整段累積的 `end`，不然前面字母的結尾會被忽略。

## 面試口說整理

同一個字母只能在一段裡，所以我先記下每個字母最後出現的位置。接著掃描字串，把目前這段的結尾延伸到段內字母最後出現位置的最大值；走到結尾時，段內的字母後面都不會再出現，就在這裡切。每段都盡早切，段數就最多。時間 `O(n)`，空間 `O(1)`。
