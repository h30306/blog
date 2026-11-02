---
title: "LeetCode 1186: Maximum Subarray Sum with One Deletion"
summary: "LeetCode 1186 解題筆記：Kadane 加一個狀態：結尾在這裡、還沒刪過 / 已經刪過一個；答案要在每一步都更新"
description: "2026-10-22 的 LeetCode 1186 解題紀錄"
date: 2026-10-22
tags: ["medium", "array", "dynamic-programming"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-10-22
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

Kadane（[Kadane's Algorithm]({{< relref "/algorithm/Kadanes-Algorithm" >}})）多一個狀態。對每個位置 `i`，記兩個值，都是「子陣列結尾在 `i`」：

- `no_delete`：沒刪過元素的最大和。`max(no_delete + num, num)`，和一般 Kadane 一樣。
- `delete_one`：剛好刪過一個元素的最大和。兩種來源：
  - 刪掉現在這個 `num`：前面沒刪過的子陣列，和是上一步的 `no_delete`。
  - 之前已經刪過：`delete_one + num`。

兩個值要用上一步的值同時更新。子陣列至少要留一個元素，`delete_one` 從 `-inf` 開始，第一個元素不能被刪成空的。

答案是所有位置的兩個值裡的最大值，**每一步都要更新**。

## 我的嘗試

1. 只在最後回傳 `max(no_delete, delete_one)`。但這兩個狀態只代表「結尾在最後一個元素」的子陣列，最佳答案可能更早就結束了：`[1,-1,-3]` 回傳 0，答案是 1。
2. 每一步都更新答案就過了。

## 正確解法

```python
class Solution:
    def maximumSum(self, arr: List[int]) -> int:
        no_delete = -inf
        delete_one = -inf
        best = -inf
        for num in arr:
            no_delete, delete_one = max(no_delete + num, num), max(no_delete, delete_one + num)
            best = max(best, no_delete, delete_one)
        return best
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- DP 狀態是「結尾在這裡」，答案要在每一步取最大，不是只看最後一步。
- 兩個狀態要同時更新（tuple 賦值），`delete_one` 要用**舊的** `no_delete`。
- 全部是負數時答案是最大的那個元素，不能刪成空陣列，所以初始值用 `-inf` 不是 0。

## 面試口說整理

這是 Kadane 多一個狀態：結尾在 `i`、沒刪過的最大和，和結尾在 `i`、刪過一個的最大和。刪過一個的來源有兩種：刪掉現在這個，接上一步沒刪過的；或之前已經刪過，加上現在這個。因為狀態是「結尾在這裡」，答案要在每一步更新。時間 `O(n)`，空間 `O(1)`。
