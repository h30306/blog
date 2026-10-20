---
title: "LeetCode 1458: Max Dot Product of Two Subsequences"
summary: "LeetCode 1458 解題筆記：兩個前綴的 DP；dp[i][j] 可以配對 nums1[i]、nums2[j]（接在 dp[i-1][j-1] 後面或自己開頭），或跳過其中一個"
description: "2026-01-11 的 LeetCode 1458 解題紀錄"
date: 2026-01-11
tags: ["hard", "dynamic-programming", "longest-common-subsequence", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-01-11
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

跟 LCS 一樣是兩個前綴的 DP（見 [String DP]({{< relref "/algorithm/String-DP" >}})）。`dp[i][j]` = 用 `nums1[:i]` 和 `nums2[:j]` 的非空子序列能得到的最大點積：

- **配對 `nums1[i-1]` 和 `nums2[j-1]`**：`p = nums1[i-1] × nums2[j-1]`，可以接在前面的最佳值後面 `dp[i-1][j-1] + p`，或自己開頭 `p`（前面都是負的時候比較好）。
- **跳過 `nums1[i-1]`**：`dp[i-1][j]`。
- **跳過 `nums2[j-1]`**：`dp[i][j-1]`。

子序列不能是空的，所以初始值是負無限大，不是 0。這也是為什麼要有「自己開頭」的選項：如果所有乘積都是負的，答案是最大的那個負數，不是 0。

## 我的嘗試

第一版只有「配對」和 `dp[i-1][j-1]`（兩個都跳過），**沒有只跳過其中一個**的轉移。這樣 `dp[i][j]` 只看得到兩邊同時往前的情況，`nums1[i]` 沒辦法跟 `nums2` 前面的元素配對之後再繼續。例如 `nums1 = [3, 1, 3]`、`nums2 = [3, 4]`：`3 × 3 + 3 × 4 = 21`，這版回傳 15。

## 正確解法

```python
class Solution:
    def maxDotProduct(self, nums1: List[int], nums2: List[int]) -> int:
        n, m = len(nums1), len(nums2)
        NEG = float("-inf")
        dp = [[NEG] * (m + 1) for _ in range(n + 1)]   # 子序列不能是空的
        for i in range(1, n + 1):
            for j in range(1, m + 1):
                p = nums1[i - 1] * nums2[j - 1]
                dp[i][j] = max(
                    p,                             # 從這一對開始
                    dp[i - 1][j - 1] + p,          # 接在前面後面
                    dp[i - 1][j],                  # 跳過 nums1[i-1]
                    dp[i][j - 1],                  # 跳過 nums2[j-1]
                )
        return dp[n][m]
```

## 複雜度

時間 `O(nm)`，空間 `O(nm)`。

## 要特別避免的錯誤

- 少了「只跳過其中一個」的轉移。
- 初始值用 0：子序列不能是空的，全部都是負數時答案是負的。

## 面試口說整理

這是兩個前綴的 DP。`dp[i][j]` 可以配對這兩個元素，接在前面的最佳值後面或自己開頭；也可以跳過其中一邊的元素。因為子序列不能是空的，初始值用負無限大，而且要保留「自己開頭」的選項，處理全部都是負數的情況。時間 `O(nm)`。
