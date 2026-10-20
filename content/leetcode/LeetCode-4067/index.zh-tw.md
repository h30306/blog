---
title: "LeetCode 4067: Longest Subarray With Restricted Pair Sums"
summary: "LeetCode 4067 解題筆記：合法視窗的子陣列也合法，可以滑動；加入 x 時只要檢查跟 x 有關的三元組：x 當加數（x + y 在視窗裡）或 x 當和（x - y 在視窗裡）"
description: "2026-09-27 的 LeetCode 4067 解題紀錄"
date: 2026-09-27
tags: ["medium", "sliding-window", "hash-table", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-09-27
- 提交紀錄：Accepted（一次通過）

## 解題思路

合法的視窗拿掉頭尾還是合法，所以可以用「求最長」的滑動視窗。

加入新的 `x` 之前，視窗是合法的，所以**新的衝突一定跟 `x` 有關**。對視窗裡出現過的每個值 `y`（值域只有 1 到 500）：

- **`x` 當加數**：`x + y` 也在視窗裡 → 衝突（`x + y > y`，所以 `x + y` 和 `y` 一定是不同位置）。
- **`x` 當和**：`x - y` 在視窗裡 → 衝突。如果 `x - y == y`，需要兩個不同位置的 `y`，所以數量要 `>= 2`。

有衝突就縮左邊，重新檢查，直到沒有衝突再加入 `x`。

數字都是正的，所以不會有 `y + 0 = y` 的情況。

## 我的解法

```python
class Solution:
    def maxSubarray(self, nums: List[int]) -> int:
        cnt = [0] * 501
        active = set()                             # 視窗裡出現過的值

        def conflict(x: int) -> bool:
            for y in active:
                if x + y <= 500 and cnt[x + y]:
                    return True                    # x + y = 視窗裡的某個數
                z = x - y
                if z > 0 and cnt[z] > (1 if z == y else 0):
                    return True                    # y + z = x
            return False

        left = best = 0
        for right, x in enumerate(nums):
            while left < right and conflict(x):
                y = nums[left]
                cnt[y] -= 1
                if cnt[y] == 0:
                    active.remove(y)
                left += 1
            cnt[x] += 1
            active.add(x)
            best = max(best, right - left + 1)
        return best
```

## 複雜度

每次檢查最多看 500 個值，檢查的次數最多是 `2n`（每個右端一次、每次縮左邊一次），時間 `O(500 · n)`，空間 `O(500)`。

## 要特別避免的錯誤

- `x - y == y` 的情況需要兩個 `y`。
- 每次都檢查整個視窗的所有三元組：只要檢查跟新元素有關的。

## 面試口說整理

合法視窗的子陣列也合法，所以用滑動視窗。加入新元素前視窗是合法的，所以只要檢查跟新元素 `x` 有關的情況：`x` 加上視窗裡某個 `y` 是否也在視窗裡，或 `x` 減 `y` 是否在視窗裡（剛好等於 `y` 時要有兩個）。值域只有 500，每次檢查 `O(500)`，有衝突就縮左邊。
