---
title: "LeetCode 3840: House Robber V"
summary: "LeetCode 3840 解題筆記：只有相鄰而且同色才衝突；顏色不同直接拿，同色時才做打家劫舍的取捨"
description: "2026-02-14 的 LeetCode 3840 解題紀錄"
date: 2026-02-14
tags: ["medium", "dynamic-programming", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-02-14
- 提交紀錄：Accepted（一次通過）

## 解題思路

`dp[i]` = 前 `i` 間房子能拿的最大金額。看第 `i` 間（0-indexed）：

- **跟前一間顏色不同**：拿它不會跟任何人衝突，而且金額都是正的，直接拿：`dp[i + 1] = dp[i] + nums[i]`。
- **跟前一間顏色相同**：就是原本的打家劫舍，拿它就不能拿前一間：`dp[i + 1] = max(dp[i], dp[i - 1] + nums[i])`。

## 我的解法

```python
class Solution:
    def rob(self, nums: List[int], colors: List[int]) -> int:
        n = len(nums)
        dp = [0] * (n + 1)                         # dp[i]：前 i 間的最大金額
        for i in range(n):
            if i > 0 and colors[i] == colors[i - 1]:
                dp[i + 1] = max(dp[i], dp[i - 1] + nums[i])
            else:
                dp[i + 1] = dp[i] + nums[i]        # 不會衝突，直接拿
        return dp[n]
```

## 複雜度

時間 `O(n)`，空間 `O(n)`（可以壓成兩個變數）。

## 要特別避免的錯誤

- 把它當成一般的打家劫舍：顏色不同的相鄰房子可以一起拿。

## 面試口說整理

`dp[i]` 是前 `i` 間的最大金額。如果這間跟前一間顏色不同，拿它不會衝突，金額又是正的，就直接加上去；顏色相同時才是打家劫舍，在「不拿這間」和「拿這間但跳過前一間」之間取最大值。時間 `O(n)`。
