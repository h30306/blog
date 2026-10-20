---
title: "LeetCode 2044: Count Number of Maximum Bitwise-OR Subsets"
summary: "LeetCode 2044 解題筆記：最大 OR 就是全部 OR 起來；回溯時一旦達到最大值，剩下的直接算 2^k"
description: "2025-07-29 的 LeetCode 2044 解題紀錄"
date: 2025-07-29
tags: ["medium", "backtracking", "bit-manipulation", "enumeration"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-07-29
- 提交紀錄：Accepted → Accepted（位元遮罩版）→ Accepted（回溯版重寫）

## 解題思路

1. **最大的 OR 一定是全部元素 OR 起來**：OR 只會讓位元變多，不會變少，所以選越多不會越小。
2. 接著數有幾個非空子集合的 OR 等於這個最大值。

`n <= 16`，子集合最多 `2^16 = 65536` 個，全部枚舉也可以。

## 解法一：回溯 + 剪枝

每個元素選或不選。**一旦目前的 OR 已經等於最大值，剩下的元素不管怎麼選，OR 都不會變**，所以剩下 `n - i` 個元素有 `2^(n - i)` 種選法，直接回傳。

```python
class Solution:
    def countMaxOrSubsets(self, nums: List[int]) -> int:
        n = len(nums)
        max_or = 0
        for x in nums:
            max_or |= x

        def backtrack(i: int, cur: int) -> int:
            if cur == max_or:
                return 1 << (n - i)               # 剩下的隨便選
            if i == n:
                return 0
            return backtrack(i + 1, cur | nums[i]) + backtrack(i + 1, cur)

        return backtrack(0, 0)
```

`cur` 從 0 開始，空集合的 OR 是 0。只要 `max_or > 0`，空集合就不會被算到；題目保證 `nums[i] >= 1`，所以 `max_or` 一定大於 0。

## 解法二：位元遮罩枚舉

```python
class Solution:
    def countMaxOrSubsets(self, nums: List[int]) -> int:
        n = len(nums)
        max_or = 0
        for x in nums:
            max_or |= x
        res = 0
        for mask in range(1, 1 << n):
            cur = 0
            for i in range(n):
                if mask >> i & 1:
                    cur |= nums[i]
            res += cur == max_or
        return res
```

這是 `O(n · 2^n)`，我交的時候跑了 1320ms，比回溯版慢很多。

## 複雜度

| 解法 | 時間 |
|---|---|
| 回溯 + 剪枝 | 最壞 `O(2^n)`，實際上剪枝很有效 |
| 位元遮罩 | `O(n · 2^n)` |

## 要特別避免的錯誤

- 以為最大 OR 要另外搜尋：全部 OR 起來就是。
- 把空集合也算進去。
- 位元運算的優先順序：`mask & 1 << i` 是 `mask & (1 << i)`，可以用但容易誤讀，建議加括號或寫成 `mask >> i & 1`。

## 面試口說整理

OR 只會增加位元，所以最大的 OR 就是所有元素 OR 起來。接著用回溯枚舉每個元素選或不選，一旦目前的 OR 已經等於最大值，剩下的元素怎麼選都不會改變結果，直接加上 `2^(剩下的個數)`。`n` 最多 16，最壞 `O(2^n)`。
