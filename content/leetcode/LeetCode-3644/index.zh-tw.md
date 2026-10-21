---
title: "LeetCode 3644: Maximum K to Sort a Permutation"
summary: "LeetCode 3644 解題筆記：每個不在正確位置的數都一定要被交換，k 的每一位它們都要有；答案是所有要移動的數的 AND"
description: "2025-08-10 的 LeetCode 3644 解題紀錄"
date: 2025-08-10
tags: ["medium", "bit-manipulation", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-08-10
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

交換 `nums[i]` 和 `nums[j]` 的條件是 `nums[i] & nums[j] == k`，所以參與交換的數一定包含 `k` 的所有位元（[Bit Manipulation]({{< relref "/algorithm/Bit-Manipulation" >}}) 模板一）。

- 不在正確位置的數一定要被交換至少一次，所以 `k` 的每一位，這些數都要有：`k` 最大只能是它們全部 AND 起來。
- 這個值也做得到：`k` 本身也在陣列裡（值是 `0..n-1`，而 `k` 不會比任何要移動的數大），而 `k & x == k` 對每個要移動的 `x` 都成立，所以可以把 `k` 當成「中轉站」，每次都跟它交換，就能把每個循環排好。
- 已經排好就回傳 0。

## 我的嘗試

第一版想模擬：每個位置 `i` 如果不對，就取 `i & nums[i]` 的最大值，再把正確的數換過來。但 `k` 是同一個值，要讓**所有**要移動的數都能交換，取最大值是錯的。例如 `[2, 3, 0, 1]`：四個數都要移動，`2 & 3 & 0 & 1 = 0`，答案 0；這版回傳 1。改成全部 AND 起來就 AC 了。

## 正確解法

```python
class Solution:
    def sortPermutation(self, nums: List[int]) -> int:
        k = -1                                     # -1 的每一位都是 1
        for i, x in enumerate(nums):
            if x != i:
                k &= x
        return 0 if k == -1 else k
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- `k` 要讓**每一個**要移動的數都能交換，所以是 AND，不是對每個位置取最大值。
- AND 的初始值是 -1（每一位都是 1），不是 0。

## 面試口說整理

每個不在正確位置的數都一定要參與交換，而交換的兩個數 AND 要等於 `k`，所以 `k` 的每一位這些數都要有。最大的 `k` 就是所有要移動的數的 AND，已經排好就是 0。時間 `O(n)`。
