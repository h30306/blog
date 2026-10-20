---
title: "LeetCode 2875: Minimum Size Subarray in Infinite Array"
summary: "LeetCode 2875 解題筆記：先拿掉 target // sum 個完整週期，剩下的餘數比一整圈小，一定能在兩份 nums 接起來的陣列裡用滑動視窗找到"
description: "2026-01-18 的 LeetCode 2875 解題紀錄"
date: 2026-01-18
tags: ["medium", "sliding-window", "prefix-sum", "hash-table", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-18
- 提交紀錄：Wrong Answer ×2 → Accepted

## 解題思路

設 `total = sum(nums)`、`full, rest = divmod(target, total)`。

- 長度至少 `n` 的子陣列一定包含一整圈（總和 `total`），把它拿掉，剩下的還是無限陣列裡的一段連續子陣列。所以答案 = `full × n` + **總和剛好是 `rest` 的最短子陣列**。
- `rest < total`，數字都是正的，那段子陣列長度一定 `< n`，**最多橫跨兩份 `nums`**，在 `nums + nums` 上用滑動視窗找就夠了。
- `rest == 0` 時答案就是 `full × n`。

## 我的嘗試

| 版本 | 問題 |
|---|---|
| 第一版 | 把 `target` 換成 `target % sum` 後，忘了把完整的週期加回去。例如 `nums = [1]`、`target = 6`：答案是 6，回傳 0 |
| 第二版 | 加回 `n * divisor`，但 `sum` 是在 `nums` 已經接成兩份**之後**才算的，總和多了一倍。例如 `nums = [1, 4, 2]`、`target = 24`：答案是 11，回傳 -1 |
| AC | 先算原本的總和和週期數，再把 `nums` 接成兩份 |

## 正確解法

```python
class Solution:
    def minSizeSubarray(self, nums: List[int], target: int) -> int:
        n = len(nums)
        full, rest = divmod(target, sum(nums))     # 用原本的總和
        if rest == 0:
            return full * n

        arr = nums + nums                          # 餘數那段最多跨兩份
        left = window = 0
        best = float("inf")
        for right, x in enumerate(arr):
            window += x
            while window > rest:
                window -= arr[left]
                left += 1
            if window == rest:
                best = min(best, right - left + 1)
        return -1 if best == float("inf") else full * n + best
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 只處理餘數，忘了加回完整週期。
- 先把陣列接成兩份再算總和：總和多一倍。

## 面試口說整理

很長的子陣列一定包含完整的週期，所以我先用 `target` 除以總和拿掉完整週期，每個週期是 `n` 個元素。剩下的餘數比一整圈小，數字都是正的，那段一定在兩份 `nums` 接起來的範圍內，用滑動視窗找總和剛好等於餘數的最短一段。時間 `O(n)`。
