---
title: "LeetCode 2009: Minimum Number of Operations to Make Array Continuous"
summary: "LeetCode 2009 解題筆記：最後的陣列是長度 n 的連續整數；去重排序後，用滑動視窗找值域寬度 <= n - 1 的最多不同值，其他都要改"
description: "2026-01-14 的 LeetCode 2009 解題紀錄"
date: 2026-01-14
tags: ["hard", "sliding-window", "hash-table", "binary-search", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-01-14
- 提交紀錄：TLE → WA → RE → AC → WA → AC

## 解題思路

最後的陣列是 `[x, x + 1, ..., x + n - 1]`。原本的數如果落在這個範圍裡、而且不重複，就可以保留，其他都要改。

所以要找：**哪個長度 `n` 的值域區間 `[x, x + n - 1]` 裡，原本的不同值最多**。

1. 去重後排序。
2. 滑動視窗：右端是 `vals[right]`，左端縮到 `vals[right] - vals[left] <= n - 1`。視窗裡的值都能留。
3. 答案是 `n - 最多能留的數量`。

區間的左端可以假設就是某個原本的值（往右推到第一個原本的值不會變差），所以只要以每個 `vals[left]` 當起點。

## 我的嘗試

| 版本 | 問題 |
|---|---|
| 第一版 TLE | 在整個值域 `0..max` 上滑動，還用 `in nums`（list）檢查，值可以到 `10^9` |
| 第二版 WA | 改成在排序後的陣列上滑動，但**沒去重**，重複的值也被算成「可以保留」。例如 `[1, 1]`：其中一個要改成 2，答案是 1，回傳 0 |
| 第三版 RE | 加上重複計數，但變數名稱打錯（`deplicate`） |
| 第四版 AC | 修好拼字，用 `duplicate` 扣掉視窗內的重複 |
| 第五版 WA | 想簡化又把去重拿掉了 |
| 第六版 AC | 直接 `sorted(set(nums))`，最乾淨 |

## 正確解法

```python
class Solution:
    def minOperations(self, nums: List[int]) -> int:
        n = len(nums)
        vals = sorted(set(nums))                   # 重複的值只能留一個
        left = best = 0
        for right, x in enumerate(vals):
            while x - vals[left] > n - 1:
                left += 1
            best = max(best, right - left + 1)     # 這些值都能留
        return n - best
```

注意視窗寬度用的是**原本的** `n`，不是去重後的長度。

## 複雜度

時間 `O(n log n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 沒去重：重複的值只能留一個。
- 視窗寬度用了去重後的長度：最後的陣列長度還是原本的 `n`。

## 面試口說整理

最後是長度 `n` 的連續整數，原本落在範圍裡而且不重複的值都能留下。所以我先去重排序，用滑動視窗找最大值減最小值不超過 `n - 1` 的最多個值，答案是 `n` 減掉它。寬度要用原本的 `n`。時間 `O(n log n)`。
