---
title: "LeetCode 2563: Count the Number of Fair Pairs"
summary: "LeetCode 2563 解題筆記：把「和落在 [lower, upper]」拆成「和 <= upper」減「和 <= lower - 1」，每個都用排序後的對撞指針 O(n) 數"
description: "2026-01-25 的 LeetCode 2563 解題紀錄"
date: 2026-01-25
tags: ["medium", "two-pointers", "sorting", "binary-search", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-25
- 提交紀錄：WA → TLE → WA → TLE → AC

## 解題思路

配對 `(i, j)` 跟順序無關（只看兩個數的和），所以可以先排序。

直接數「和落在 `[lower, upper]`」時，一個上界、一個下界，兩個條件的指針移動方向會打架。**拆成兩個單邊條件**：

```text
count(lower <= sum <= upper) = count(sum <= upper) - count(sum <= lower - 1)
```

`count(sum <= limit)` 用對撞指針：

- `nums[left] + nums[right] > limit`：`right` 太大，往左。
- 否則 `left` 跟 `left + 1..right` 每一個配都成立，加上 `right - left`，`left` 往右。

## 我的嘗試

| 版本 | 問題 |
|---|---|
| 第一版 WA | 對每個 `i` 用同一組 `left`、`right` 找另一個數的範圍，但沒限制 `j > i`，會配到自己、也會兩個方向都算。例如 `[1, 1]`、`lower = upper = 2`：答案是 1，這版回傳 4 |
| 第二、四版 TLE | 每個 `i` 都把指針重設成 `i + 1`、`n - 1` 再往內走，`O(n^2)` |
| 第三版 WA | 改成 `left = max(i + 1, left)`，讓 `left` 只往右，但 `nums[i]` 變大時，**下界對應的位置其實要往左移**，`left` 不能只往右。例如 `[-2, -1, -1, -1]`、`lower = upper = -2`：三個 `-1` 兩兩配對都是 `-2`，答案是 3，這版回傳 2 |

這幾版的問題都是同時處理上下界。拆成兩個單邊計數就 AC 了。

## 正確解法

```python
class Solution:
    def countFairPairs(self, nums: List[int], lower: int, upper: int) -> int:
        nums.sort()

        def count_at_most(limit: int) -> int:     # 和 <= limit 的配對數
            left, right = 0, len(nums) - 1
            count = 0
            while left < right:
                if nums[left] + nums[right] > limit:
                    right -= 1
                else:
                    count += right - left
                    left += 1
            return count

        return count_at_most(upper) - count_at_most(lower - 1)
```

也可以對每個 `i` 在 `i + 1..n - 1` 用 `bisect` 找上下界，一樣是 `O(n log n)`。

## 複雜度

時間 `O(n log n)`，空間 `O(1)`（不算排序）。

## 要特別避免的錯誤

- 沒限制 `j > i`：配到自己或重複計算。
- 同時用兩個指針處理上下界：下界的位置不是單調往右。
- 每個 `i` 重設指針：`O(n^2)`。

## 面試口說整理

配對只看和，所以先排序。範圍條件拆成「和 `<= upper`」減掉「和 `<= lower - 1`」。單邊的計數用對撞指針：兩端和太大就把右端往左，否則左端跟中間每一個都能配，加上 `right - left` 再把左端往右。兩次都是 `O(n)`，總時間由排序決定，`O(n log n)`。
