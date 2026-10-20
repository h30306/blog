---
title: "LeetCode 220: Contains Duplicate III"
summary: "LeetCode 220 解題筆記：桶大小設成 valueDiff + 1，同一個桶裡的兩個數一定符合；只要再看相鄰兩個桶。視窗只保留最近 indexDiff 個數，所以每個桶最多一個數"
description: "2026-01-10 的 LeetCode 220 解題紀錄"
date: 2026-01-10
tags: ["hard", "sliding-window", "bucket-sort", "ordered-set", "sorting", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-01-10
- 提交紀錄：Wrong Answer ×2 → Output Limit Exceeded → Accepted

## 解題思路

兩個條件：index 差 `<= indexDiff`、值差 `<= valueDiff`。

- **index 條件**用滑動視窗：只保留最近 `indexDiff` 個數。
- **值條件**用分桶：桶大小 `size = valueDiff + 1`，`x` 放在第 `x // size` 個桶。
  - 同一個桶裡的兩個數，差一定 `<= valueDiff`，直接回傳 `True`。所以**每個桶最多只會有一個數**。
  - 差 `<= valueDiff` 的數也可能在相鄰的桶，所以再檢查 `b - 1` 和 `b + 1` 兩個桶。
  - 更遠的桶，差一定 `> valueDiff`。

視窗移動時，把 `nums[i - indexDiff - 1]` 所在的桶刪掉。

Python 的 `//` 對負數是往下取整，`-1 // 3 == -1`，負數也能正確分桶。

## 我的嘗試

| 版本 | 問題 |
|---|---|
| 第一、二版 | 刪除過期元素時用 **index** 當 key（`del buckets[i - indexDiff - 1]`），但桶的 key 是值除以大小；相鄰桶的比較寫成 `< valueDiff`，少了等於。例如 `nums = [2, 5]`、`indexDiff = 2`、`valueDiff = 3`：`|2 - 5| = 3`，答案是 `True`，這兩版回傳 `False` |
| 第三版 OLE | 修好了，但留著 `print(buckets)` |
| AC | 拿掉 `print` |

## 正確解法

```python
class Solution:
    def containsNearbyAlmostDuplicate(self, nums: List[int], indexDiff: int, valueDiff: int) -> bool:
        size = valueDiff + 1
        buckets = {}                               # 桶編號 -> 桶裡唯一的數
        for i, x in enumerate(nums):
            if i > indexDiff:
                del buckets[nums[i - indexDiff - 1] // size]   # 移出視窗
            b = x // size
            if b in buckets:
                return True                        # 同一個桶，差一定 <= valueDiff
            if b - 1 in buckets and x - buckets[b - 1] <= valueDiff:
                return True
            if b + 1 in buckets and buckets[b + 1] - x <= valueDiff:
                return True
            buckets[b] = x
        return False
```

過期的那個數當初一定有放進桶裡，而且沒被覆蓋（覆蓋代表同桶，早就回傳了），所以 `del` 一定找得到。

## 複雜度

時間 `O(n)`，空間 `O(min(n, indexDiff))`。另一種做法是用有序集合（`SortedList`）維護視窗，查詢 `>= x - valueDiff` 的最小值，時間 `O(n log k)`。

## 要特別避免的錯誤

- 刪除時用 index 當 key：桶的 key 是 `值 // size`。
- 相鄰桶的比較要用 `<=`。
- 桶大小是 `valueDiff + 1`，不是 `valueDiff`（`valueDiff = 0` 時會除以 0）。
- 提交前留著 `print`。

## 面試口說整理

index 條件用滑動視窗，只保留最近 `indexDiff` 個數；值的條件用分桶，桶大小是 `valueDiff + 1`。同一個桶裡兩個數一定符合，所以每個桶最多一個數；再檢查左右兩個相鄰的桶，更遠的桶不可能符合。視窗移動時刪掉過期數字所在的桶。時間 `O(n)`。
