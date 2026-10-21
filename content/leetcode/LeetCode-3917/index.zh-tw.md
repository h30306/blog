---
title: "LeetCode 3917: Count Indices With Opposite Parity"
summary: "LeetCode 3917 解題筆記：從右往左掃，記目前看過幾個奇數、幾個偶數；每個位置的答案就是右邊奇偶相反的個數"
description: "2026-05-03 的 LeetCode 3917 解題紀錄"
date: 2026-05-03
tags: ["easy", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2026-05-03
- 提交紀錄：Accepted（一次通過）

## 解題思路

每個位置 `i` 要數右邊有幾個 `j` 的奇偶跟 `nums[i]` 相反。從右往左掃，維護「右邊有幾個偶數、幾個奇數」（[Array]({{< relref "/algorithm/Array" >}}) 模板三），每個位置直接查相反那一類的個數，再把自己加進去。

## 我的解法

```python
class Solution:
    def countOppositeParity(self, nums: List[int]) -> List[int]:
        seen = [0, 0]                          # 右邊的偶數、奇數個數
        res = [0] * len(nums)
        for i in range(len(nums) - 1, -1, -1):
            p = nums[i] % 2
            res[i] = seen[1 - p]
            seen[p] += 1
        return res
```

我當時對每個 `i` 都往右掃一次，`O(n²)`；範圍小所以也過了。

## 複雜度

時間 `O(n)`，空間 `O(n)`（輸出）。

## 要特別避免的錯誤

- 算的是**右邊**的個數，所以要從右往左掃，先查答案、再把自己加進計數。

## 面試口說整理

我從右往左掃，記右邊有幾個偶數和奇數，每個位置的答案就是相反奇偶的個數，然後把自己加進去。時間 `O(n)`。
