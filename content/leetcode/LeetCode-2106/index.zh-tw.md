---
title: "LeetCode 2106: Maximum Fruits Harvested After at Most K Steps"
summary: "LeetCode 2106 解題筆記：採到的一定是連續一段水果；走完 [L, R] 的最少步數是 (R - L) + min(|start - L|, |R - start|)，在水果陣列上用滑動視窗"
description: "2026-01-12 的 LeetCode 2106 解題紀錄"
date: 2026-01-12
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
第一次嘗試：2026-01-12
- 提交紀錄：Wrong Answer → Accepted ×2

## 解題思路

走過的範圍一定是一段連續區間 `[L, R]`，採到的就是這段裡的所有水果。

走完 `[L, R]` 的最少步數：先往一邊走、再折返到另一邊，

```text
steps = (R - L) + min(|start - L|, |R - start|)
```

這個式子在 `start` 落在區間外的時候也成立（例如 `start < L`，算出來是 `R - start`）。

`R` 變大時步數不會變少，所以在**水果陣列**上用滑動視窗：右端加入 `fruits[right]`，步數超過 `k` 就縮左端，記錄視窗內水果總和的最大值。

## 我的嘗試

我的寫法是在**座標**上滑動：從 `startPos - k` 掃到 `startPos + k`，再反方向掃一次，每次算「先往一邊走、再折返」時另一邊最遠能到哪。第一版折返時只用 `if` 縮一格，沒有縮到位。例如 `fruits = [[3, 1], [7, 3]]`、`startPos = 5`、`k = 5`：兩邊都拿需要 6 步，只能拿右邊的 3 個，答案是 3；這版回傳 4。

改成 `while` 就 AC 了，但座標範圍是 `2k`，比在水果陣列上滑動慢（1.4 秒）。

## 正確解法

```python
class Solution:
    def maxTotalFruits(self, fruits: List[List[int]], startPos: int, k: int) -> int:
        def steps(lo: int, hi: int) -> int:        # 走完 [lo, hi] 的最少步數
            return (hi - lo) + min(abs(startPos - lo), abs(hi - startPos))

        left = total = best = 0
        for right, (pos, amount) in enumerate(fruits):
            total += amount
            while left <= right and steps(fruits[left][0], pos) > k:
                total -= fruits[left][1]
                left += 1
            best = max(best, total)
        return best
```

`left` 可能超過 `right`（連 `fruits[right]` 自己都走不到），這時視窗是空的，`total` 是 0。

## 複雜度

時間 `O(n)`，`n` 是水果的位置數，空間 `O(1)`。

## 要特別避免的錯誤

- 只考慮「先往左」或「先往右」其中一種：要取兩者的最小值。
- 在座標上滑動：範圍是 `2k`，跟水果的數量無關。

## 面試口說整理

採到的一定是一段連續的水果。走完 `[L, R]` 的最少步數是區間長度加上起點到比較近那一端的距離，先走近的再折返。這個步數隨右端變大不會減少，所以我在水果陣列上用滑動視窗，步數超過 `k` 就縮左邊，記錄視窗總和的最大值。時間 `O(n)`。
