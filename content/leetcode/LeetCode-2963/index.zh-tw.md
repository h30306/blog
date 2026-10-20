---
title: "LeetCode 2963: Count the Number of Good Partitions"
summary: "LeetCode 2963 解題筆記：同一個數的所有出現位置必須在同一段，用最後出現位置把陣列切成 b 個不可再分的區塊；區塊之間可切可不切，答案是 2^(b-1)"
description: "2026-09-05 的 LeetCode 2963 解題紀錄"
date: 2026-09-05
tags: ["hard", "math", "combinatorics", "hash-table", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-09-05
- 提交紀錄：Accepted ×2

## 解題思路

「沒有兩段包含同一個數」⇔ **每個數的所有出現位置都在同一段**。

1. 記下每個數最後出現的位置 `last[x]`。
2. 從左往右掃，維護目前這個區塊至少要延伸到 `reach = max(last[x])`。走到 `i == reach` 時，這個區塊結束，它不能再被切開。
3. 得到 `b` 個不可再分的區塊。相鄰兩個區塊之間有 `b - 1` 個位置，每個位置可切可不切，答案是 `2^(b - 1)`，取模。

這跟 [LeetCode 2584]({{< relref "/leetcode/LeetCode-2584" >}}) 和「劃分字母區間」是同一個想法。

## 我的解法

```python
class Solution:
    def numberOfGoodPartitions(self, nums: List[int]) -> int:
        last = {x: i for i, x in enumerate(nums)}  # 每個數最後出現的位置
        blocks = 0
        reach = 0
        for i, x in enumerate(nums):
            reach = max(reach, last[x])
            if i == reach:
                blocks += 1                        # 一個不可再分的區塊結束
        return pow(2, blocks - 1, 10 ** 9 + 7)
```

我原本的寫法是用 `while` 一次跳過整個區塊，意思一樣；用一個 `for` 迴圈維護 `reach` 比較簡潔。

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 切點數是 `b - 1`，不是 `b`。
- `2` 的次方要取模。

## 面試口說整理

同一個數的所有出現位置必須在同一段，所以我先記下每個數最後出現的位置，從左往右掃，目前區塊至少要延伸到看過的數的最後位置，走到那裡就是一個不可再分的區塊。`b` 個區塊之間的 `b - 1` 個位置可切可不切，答案是 `2^(b-1)`。時間 `O(n)`。
