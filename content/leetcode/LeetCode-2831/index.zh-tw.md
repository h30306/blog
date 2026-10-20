---
title: "LeetCode 2831: Find the Longest Equal Subarray"
summary: "LeetCode 2831 解題筆記：對每個值，把它出現的位置列出來；在位置列表上滑動視窗，要刪的數量 = 位置跨度 − 這個值的個數"
description: "2026-01-11 的 LeetCode 2831 解題紀錄"
date: 2026-01-11
tags: ["medium", "sliding-window", "hash-table", "binary-search", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-11
- 提交紀錄：Wrong Answer → Time Limit Exceeded ×2 → Accepted

## 解題思路

最後留下來的是同一個值 `v`。**分別對每個值處理**：

- 列出 `v` 出現的位置 `pos = [p0, p1, ...]`。
- 如果要保留 `pos[l..r]` 這幾個 `v`，它們之間的其他元素都要刪掉：要刪的數量是 `(pos[r] - pos[l] + 1) - (r - l + 1)`。
- 在 `pos` 上用滑動視窗：要刪的超過 `k` 就縮左邊，答案是 `r - l + 1` 的最大值。

所有值的位置列表加起來長度是 `n`，總共 `O(n)`。

## 我的嘗試

| 版本 | 問題 |
|---|---|
| 第一版 WA | 在原陣列上滑動，用 `長度 - 出現最多次的數 > k` 判斷，最後回傳 `最長視窗 - k`。但視窗裡不一定剛好刪了 `k` 個。例如 `nums = [2]`、`k = 2`：答案是 1，這版回傳 `1 - 2 = -1` |
| 第二、三版 TLE | 改成回傳 `max(freq.values())`，邏輯對了，但每一步都對整個計數表取 `max`，`O(n · 不同值的數量)` |
| AC | 改成對每個值的位置列表各自滑動 |

## 正確解法

```python
class Solution:
    def longestEqualSubarray(self, nums: List[int], k: int) -> int:
        positions = defaultdict(list)
        for i, v in enumerate(nums):
            positions[v].append(i)

        best = 0
        for pos in positions.values():
            left = 0
            for right in range(len(pos)):
                while (pos[right] - pos[left] + 1) - (right - left + 1) > k:
                    left += 1                      # 中間要刪的太多
                best = max(best, right - left + 1)
        return best
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 用 `視窗長度 - k` 當答案：視窗裡實際刪掉的數量不一定是 `k`。
- 每一步都對計數表取 `max`：`O(n · distinct)`。

## 面試口說整理

最後留下的是同一個值，所以我對每個值分開處理：列出它出現的位置，保留其中連續幾個時，要刪的是位置跨度減掉個數。在位置列表上用滑動視窗，要刪的超過 `k` 就縮左邊，視窗裡的個數就是候選答案。所有列表加起來長度是 `n`，時間 `O(n)`。
