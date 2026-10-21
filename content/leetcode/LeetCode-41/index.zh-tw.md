---
title: "LeetCode 41: First Missing Positive"
summary: "LeetCode 41 解題筆記：答案一定在 1..n+1；把不可能的值換成 n+1（不能用 0），用 nums[v-1] 的負號標記 v 出現過"
description: "2026-01-31 的 LeetCode 41 解題紀錄"
date: 2026-01-31
tags: ["hard", "hash-table", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-01-31
- 提交紀錄：Wrong Answer ×4 → Accepted ×2；2026-07-07 重寫：Accepted ×2 → Wrong Answer → Accepted

## 解題思路

長度 `n` 的陣列最多放下 `1..n`，所以答案一定在 `1..n + 1`。要 `O(1)` 額外空間，就把陣列本身當雜湊表（[Hash Table]({{< relref "/algorithm/Hash-Table" >}}) 模板二）：

1. `<= 0` 的值不可能影響答案，換成 `n + 1`。
2. 對每個值 `v`（取絕對值，因為可能已經被標記成負的），如果 `1 <= v <= n`，把 `nums[v - 1]` 變成負的，代表「`v` 出現過」。
3. 第一個還是正的位置 `i`，答案就是 `i + 1`；全部都是負的，答案是 `n + 1`。

## 我的嘗試

前四版都把 `<= 0` 的值換成 **0**，問題就出在 0：

| 版本 | 問題 |
|---|---|
| 第一版 | 全部都在時回傳 `n`，應該是 `n + 1`。例如 `[1]`：答案 2，回傳 1 |
| 第二版 | 改成回傳「最大值 + 1」，但最大值是在換成 0 **之前**算的。`[-1]`：答案 1，回傳 0 |
| 第三版 | 最大值移到之後算，但位置上的 0 不是正的，被當成「出現過」。`[0, 3]`：答案 1，回傳 2 |
| 第四版 | 改成檢查 `>= 0`，但 **0 加負號還是 0**，真的出現過的值也標不上去。`[0, 1]`：答案 2，回傳 1 |
| AC | 換成 `n + 1`，負號就能正常標記 |

半年後重寫時又漏了最後的 `return`，`[1]` 回傳 `None`。

## 正確解法

```python
class Solution:
    def firstMissingPositive(self, nums: List[int]) -> int:
        n = len(nums)
        for i in range(n):
            if nums[i] <= 0:
                nums[i] = n + 1                    # 不能用 0：0 沒辦法加負號
        for x in nums:
            v = abs(x)
            if v <= n:
                nums[v - 1] = -abs(nums[v - 1])    # 標記 v 出現過
        for i in range(n):
            if nums[i] > 0:
                return i + 1
        return n + 1
```

## 複雜度

時間 `O(n)`，額外空間 `O(1)`。

## 要特別避免的錯誤

- 「不可能的值」不能用 0，負號標記不了。
- 讀值時要取絕對值，它可能已經被標記成負的。
- `1..n` 全部都在時答案是 `n + 1`。

## 面試口說整理

答案一定在 1 到 `n + 1`。我先把非正數換成 `n + 1`，再用 `nums[v - 1]` 的負號記錄 `v` 有沒有出現，讀值時記得取絕對值。最後第一個還是正的位置就是答案，都負的話是 `n + 1`。時間 `O(n)`、額外空間 `O(1)`。
