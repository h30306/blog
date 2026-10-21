---
title: "LeetCode 334: Increasing Triplet Subsequence"
summary: "LeetCode 334 解題筆記：維護目前最小的 first 和「前面有比它小的數」中最小的 second，遇到比 second 大的就找到了"
description: "2022-11-17 的 LeetCode 334 解題紀錄"
date: 2022-11-17
tags: ["medium", "array", "greedy", "longest-increasing-subsequence"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-11-17
- 提交紀錄：Time Limit Exceeded → Runtime Error → Accepted → Wrong Answer

## 解題思路

貪心（[Greedy]({{< relref "/algorithm/Greedy" >}})）：`first` 是目前看過最小的數，`second` 是「前面有某個更小的數」的數裡最小的。新的數 `x`：`x <= first` 就更新 `first`；否則 `x <= second` 就更新 `second`；否則 `x > second`，找到三元組。更新 `first` 之後 `second` 不用動：它前面原本就有一個更小的數，三元組仍然成立。**比較要用 `<=`**，相等的數不能當成遞增。

## 我的嘗試

- 2022 年第一版用遞迴枚舉三個 index，指數級 TLE。之後改成上面的 `first`、`second` 貪心就 AC 了。
- 2025 年重寫時寫成 `if first > num: first, second = num, first`、`elif second > num`：
  - 用了嚴格的 `>`，**等於 `first` 的數掉到下一個分支被當成 `second`**：`[0, 0, 1]` 回傳 `True`，答案 `False`。
  - 更新 `first` 時把舊的 `first` 移給 `second`，這個想法本身也不對：舊的 `first` 前面不一定有比它小的數。

## 正確解法

```python
class Solution:
    def increasingTriplet(self, nums: List[int]) -> bool:
        first = second = float("inf")
        for x in nums:
            if x <= first:
                first = x
            elif x <= second:
                second = x
            else:
                return True
        return False
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 用 `<=`：等於 `first` 的數不能拿來當 `second`。
- 更新 `first` 時不要把舊的 `first` 移到 `second`。
- 枚舉三個 index 是 `O(n³)`。

## 面試口說整理

我維護兩個值：目前最小的 first，和前面有比它小的數之中最小的 second。新的數不大於 first 就更新 first，不大於 second 就更新 second，比 second 大就找到了。時間 `O(n)`、空間 `O(1)`。
