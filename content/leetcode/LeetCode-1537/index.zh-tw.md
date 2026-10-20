---
title: "LeetCode 1537: Get the Maximum Score"
summary: "LeetCode 1537 解題筆記：兩個排序陣列只在共同的值可以換路；雙指針合併，兩條路各自累加，遇到共同的值時兩邊都取較大的那個再加上它"
description: "2026-02-01 的 LeetCode 1537 解題紀錄"
date: 2026-02-01
tags: ["hard", "dynamic-programming", "two-pointers", "greedy", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-02-01
- 提交紀錄：WA ×2 → TLE ×2 → AC

## 解題思路

兩個陣列都排好序、各自沒有重複。只有在**兩邊都有的值**可以換到另一個陣列。

用雙指針像合併排序一樣往前走，兩條路各自維護累計和 `sum1`、`sum2`：

- `nums1[i] < nums2[j]`：只有第一條路經過它，`sum1 += nums1[i]`。
- `nums1[i] > nums2[j]`：`sum2 += nums2[j]`。
- 相等：這是交會點，到這裡之前兩條路可以選比較好的那條，`sum1 = sum2 = max(sum1, sum2) + 值`。

最後答案是 `max(sum1, sum2)`，取模。**取模只能在最後做**，中間取模會讓比較大小出錯。

## 我的嘗試

| 版本 | 問題 |
|---|---|
| 第一版 WA | 用 `x not in nums2` 找交會點，而且忘了取模，大數答案錯 |
| 第二版 WA | 加了取模，但寫成 `% 10 ** 9 + 7`，運算順序是 `(x % 10**9) + 7`。例如 `nums1 = [3]`、`nums2 = [7]`：答案是 7，回傳 14 |
| 兩次 TLE | 括號修好了，但 `x not in nums2` 是在 list 裡找，每次 `O(m)`，總共 `O(nm)` |
| AC | 改成雙指針合併，比較兩邊的大小就知道是不是交會點 |

## 正確解法

```python
class Solution:
    def maxSum(self, nums1: List[int], nums2: List[int]) -> int:
        MOD = 10 ** 9 + 7
        i = j = 0
        sum1 = sum2 = 0
        n, m = len(nums1), len(nums2)
        while i < n or j < m:
            if j == m or (i < n and nums1[i] < nums2[j]):
                sum1 += nums1[i]
                i += 1
            elif i == n or nums1[i] > nums2[j]:
                sum2 += nums2[j]
                j += 1
            else:                                  # 交會點：選比較好的那條路
                sum1 = sum2 = max(sum1, sum2) + nums1[i]
                i += 1
                j += 1
        return max(sum1, sum2) % MOD               # 最後才取模
```

## 複雜度

時間 `O(n + m)`，空間 `O(1)`。

## 要特別避免的錯誤

- `% 10 ** 9 + 7` 要加括號：`% (10 ** 9 + 7)`。
- 在 list 上用 `in`：`O(n)`。陣列是排序的，用雙指針比較就好。
- 中間不能取模：取模後的值不能拿來比大小。

## 面試口說整理

兩個陣列都排序，只能在共同的值換路。我用雙指針合併，兩條路各自累加，遇到共同的值時，前面兩段選比較大的那個，兩邊都設成這個值加上交會點。最後取兩者的最大值再取模，中間不能取模。時間 `O(n + m)`。
