---
title: "LeetCode 2874: Maximum Value of an Ordered Triplet II"
summary: "LeetCode 2874 解題筆記：枚舉中間的 j，左邊取前綴最大、右邊取後綴最大；也可以一次掃描維護最大值和最大差"
description: "2025-07-31 的 LeetCode 2874 解題紀錄"
date: 2025-07-31
tags: ["medium", "prefix-sum", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-07-31
- 提交紀錄：Wrong Answer → Output Limit Exceeded → Accepted

## 解題思路

數字都是正的，所以固定中間的 `j` 時，`nums[i]` 要越大越好、`nums[k]` 也要越大越好（[Prefix Sum]({{< relref "/algorithm/Prefix-Sum" >}}) 模板二）：

- `i < j`：取 `nums[0..j-1]` 的最大值。
- `k > j`：取 `nums[j+1..n-1]` 的最大值。

更省空間的寫法是一次掃描：掃到 `x` 時，把它當成 `k`，用「目前看過的最大差 `nums[i] - nums[j]`」乘上它；再把它當成 `j` 更新最大差；最後當成 `i` 更新最大值。順序不能反，才能保證 `i < j < k`。

## 我的嘗試

我用前綴最大和反著建的後綴最大陣列。第一版後綴陣列的位置寫成 `n - j - 1`，對應到的是 `nums[j..]` 的最大值，**把 `j` 自己也算進右邊**。例如 `[6, 2, 1]`：唯一的三元組是 `(6 - 2) × 1 = 4`，這版拿 `nums[j] = 2` 當 `k`，回傳 8。改成 `n - j - 2` 之後，因為留著 debug 的 `print` 吃了一次 Output Limit Exceeded，拿掉就 AC 了。

## 正確解法

```python
class Solution:
    def maximumTripletValue(self, nums: List[int]) -> int:
        res = max_i = max_diff = 0
        for x in nums:
            res = max(res, max_diff * x)          # x 當 k
            max_diff = max(max_diff, max_i - x)   # x 當 j
            max_i = max(max_i, x)                 # x 當 i
        return res
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 反著建的後綴陣列，index 要算清楚，不能包含 `j` 自己。
- 一次掃描時，先用、再更新，順序是 `k`、`j`、`i`。
- 送出前拿掉 `print`。

## 面試口說整理

數字都是正的，固定中間的 `j`，左邊要最大、右邊也要最大。我一次掃描，維護目前的最大值和目前最大的差 `nums[i] - nums[j]`，每個數先當 `k` 算答案，再當 `j` 更新最大差，最後當 `i` 更新最大值。時間 `O(n)`、空間 `O(1)`。
