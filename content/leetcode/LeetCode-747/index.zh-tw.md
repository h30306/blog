---
title: "LeetCode 747: Largest Number At Least Twice of Others"
summary: "LeetCode 747 解題筆記：掃一次找最大和第二大，最大 >= 2 × 第二大就回傳最大值的 index；用乘法避免除以 0"
description: "2022-09-03 的 LeetCode 747 解題紀錄"
date: 2022-09-03
tags: ["easy", "array", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-03
- 提交紀錄：Runtime Error → Wrong Answer → Runtime Error ×2 → Wrong Answer → Accepted → Runtime Error ×2 → Wrong Answer → Runtime Error → Accepted → Runtime Error → Wrong Answer ×2 → Runtime Error → Accepted ×2

## 解題思路

只要最大值至少是第二大的兩倍，就一定至少是其他每個數的兩倍（[Greedy]({{< relref "/algorithm/Greedy" >}}) 模板一）。掃一次記錄最大值、它的 index 和第二大：新的數比最大值大，舊的最大值就變第二大；**否則**才跟第二大比。比較用 `max >= 2 * second`，不用除法，第二大是 0 也沒問題。

## 我的嘗試

這題提交了 17 次：

- 一開始用除法 `max_ / max(nums)`，其他數是 0 時 **ZeroDivisionError**，用 `set(nums) == {0}` 特判才 AC。
- 改寫成一次掃描找最大和第二大，第二個判斷寫成 `if` 而不是 `elif`，**最大值剛更新完又被拿去更新第二大**，第二大變成最大值本身：`[7, 0]` 回傳 -1，答案 0。另外幾版回傳了值而不是 index，或還在用除法。改成 `elif` 和 `max_ >= 2 * sec_max` 才 AC。

## 正確解法

```python
class Solution:
    def dominantIndex(self, nums: List[int]) -> int:
        first = second = -1
        idx = -1
        for i, x in enumerate(nums):
            if x > first:
                first, second, idx = x, first, i
            elif x > second:
                second = x
        return idx if first >= 2 * second else -1
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 用乘法比較，除法遇到 0 會出錯。
- 更新第二大要用 `elif`，不然最大值會被當成第二大。
- 回傳的是 index，不是值。

## 面試口說整理

最大值只要至少是第二大的兩倍，就一定至少是其他每個數的兩倍，所以我掃一次記錄最大值、它的 index 和第二大，最後用乘法比較，避免除以 0。時間 `O(n)`、空間 `O(1)`。
