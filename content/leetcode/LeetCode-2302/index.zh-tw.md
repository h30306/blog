---
title: "LeetCode 2302: Count Subarrays With Score Less Than K"
summary: "LeetCode 2302 解題筆記：分數 = 總和 × 長度，都是正數，視窗越大分數越大；分數 >= k 就縮左邊，以 right 結尾的合法子陣列有 right - left + 1 個"
description: "2026-01-18 的 LeetCode 2302 解題紀錄"
date: 2026-01-18
tags: ["hard", "sliding-window", "prefix-sum", "binary-search", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-01-18
- 提交紀錄：Accepted（一次通過）

## 解題思路

`score = sum × length`，所有數都是正的，所以視窗變大時總和和長度都變大，**分數單調遞增**。

用「數子陣列」的滑動視窗：

- 右端加入，分數 `>= k` 就縮左邊。
- 以 `right` 結尾的合法子陣列有 `right - left + 1` 個。

## 我的解法

```python
class Solution:
    def countSubarrays(self, nums: List[int], k: int) -> int:
        left = total = count = 0
        for right, x in enumerate(nums):
            total += x
            while total * (right - left + 1) >= k:
                total -= nums[left]
                left += 1
            count += right - left + 1
        return count
```

`left` 可能超過 `right`（單一元素的分數就 `>= k`），這時 `right - left + 1` 是 0，視窗是空的，下一輪會從 `left` 重新開始。

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 題目是嚴格小於 `k`，縮視窗的條件是 `>= k`。
- 用暴力枚舉：`n` 到 `10^5`。

## 面試口說整理

分數是總和乘長度，數字都是正的，所以視窗越大分數越大。我用滑動視窗，分數大於等於 `k` 就縮左邊，以右端結尾的合法子陣列有 `right - left + 1` 個，全部加起來。時間 `O(n)`。
