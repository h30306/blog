---
title: "LeetCode 338: Counting Bits"
summary: "LeetCode 338 解題筆記：dp[i] = dp[i >> 1] + (i & 1)，或 dp[i] = dp[i - 最高位的 2 的次方] + 1"
description: "2022-11-15 的 LeetCode 338 解題紀錄"
date: 2022-11-15
tags: ["easy", "dynamic-programming", "bit-manipulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-11-15
- 提交紀錄：Wrong Answer ×4 → Runtime Error → Accepted → Wrong Answer ×2 → Accepted

## 解題思路

`i` 右移一位就是去掉最低位，所以 `bits(i) = bits(i >> 1) + (i & 1)`，`i >> 1 < i` 已經算過了（[Linear DP]({{< relref "/algorithm/Linear-DP" >}}) 模板一，配合 [Bit Manipulation]({{< relref "/algorithm/Bit-Manipulation" >}})）。另一種寫法是去掉最高位：`offset` 是不超過 `i` 的最大 2 的次方，`bits(i) = bits(i - offset) + 1`；`i` 是 2 的次方（`i & (i - 1) == 0`）時更新 `offset`。

## 我的嘗試

2022-11-15 用的是「去掉最高位」的寫法：

- 前四版在**每個偶數**都更新 offset（`if i % 2 == 0: count = i`），但 offset 應該是最高位的 2 的次方：例如 `6` 的 offset 被設成 6，`dp[6] = dp[0] + 1 = 1`，答案 2。
- 改成 `i & (i - 1) == 0` 判斷 2 的次方之後，`n = 0` 時 `ans[1]` 超出範圍；補上特例就 AC 了。
- 2022-11-27 又換了一種計數寫法錯了兩次才 AC。

## 正確解法

```python
class Solution:
    def countBits(self, n: int) -> List[int]:
        dp = [0] * (n + 1)
        for i in range(1, n + 1):
            dp[i] = dp[i >> 1] + (i & 1)
        return dp
```

## 複雜度

時間 `O(n)`，空間 `O(n)`（輸出）。

## 要特別避免的錯誤

- 最高位的 offset 只在 2 的次方時更新，不是每個偶數。
- `n = 0` 時陣列只有一格，不能直接設 `dp[1]`。

## 面試口說整理

i 右移一位就是去掉最低位，那個數比 i 小、已經算過，所以 dp[i] 等於 dp[i >> 1] 加上 i 的最低位。時間 `O(n)`。
