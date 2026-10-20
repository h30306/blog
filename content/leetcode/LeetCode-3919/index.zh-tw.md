---
title: "LeetCode 3919: Minimum Cost to Move Between Indices"
summary: "LeetCode 3919 解題筆記：一步一步走，每一步成本是 1（下一格是 closest）或差值；直接跳不會更便宜，用前綴和回答查詢"
description: "2026-05-03 的 LeetCode 3919 解題紀錄"
date: 2026-05-03
tags: ["medium", "greedy", "prefix-sum", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-05-03
- 提交紀錄：Accepted ×2

## 解題思路

`nums` 嚴格遞增，所以從 `l` 跳到 `r` 的成本 `|nums[l] - nums[r]|` 就是中間每一段差值的總和。一步一步走時，每一步 `i → i + 1` 的成本是：

- 1，如果 `closest(i) == i + 1`；
- 否則是差值 `nums[i + 1] - nums[i]`（差值至少是 1）。

每一步都不會比差值貴，所以**一步一步走一定不比直接跳差**；往反方向繞路只會多花。往右走和往左走各建一個前綴和，每個查詢 `O(1)`（[Greedy]({{< relref "/algorithm/Greedy" >}}) 模板五）。

## 我的解法

```python
class Solution:
    def minCost(self, nums: List[int], queries: List[List[int]]) -> List[int]:
        n = len(nums)
        closest = [0] * n
        closest[0], closest[-1] = 1, n - 2  # 兩端只有一個鄰居
        for i in range(1, n - 1):
            closest[i] = i - 1 if nums[i] - nums[i - 1] <= nums[i + 1] - nums[i] else i + 1
        right = [0] * n                        # right[i]：從 0 走到 i 的成本
        for i in range(1, n):
            right[i] = right[i - 1] + (1 if closest[i - 1] == i else nums[i] - nums[i - 1])
        left = [0] * n                         # left[i]：從 n-1 走到 i 的成本
        for i in range(n - 2, -1, -1):
            left[i] = left[i + 1] + (1 if closest[i + 1] == i else nums[i + 1] - nums[i])
        return [right[r] - right[l] if l <= r else left[r] - left[l] for l, r in queries]
```

## 複雜度

時間 `O(n + q)`，空間 `O(n)`。

## 要特別避免的錯誤

- 往右和往左的成本不一樣（`closest` 不對稱），要建兩個前綴和。
- 距離相同時 `closest` 選較小的 index，所以比較要用 `<=`。

## 面試口說整理

陣列嚴格遞增，直接跳的成本等於中間差值的總和，而一步一步走時每一步最多花差值、遇到 closest 只花 1，所以一步一步走最好。往右、往左各建前綴和，每個查詢相減就好。時間 `O(n + q)`。
