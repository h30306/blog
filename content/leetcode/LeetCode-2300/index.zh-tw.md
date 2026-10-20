---
title: "LeetCode 2300: Successful Pairs of Spells and Potions"
summary: "LeetCode 2300 解題筆記：藥水排序，每個咒語用 bisect 找門檻，門檻用整數 ceil 避免浮點誤差"
description: "2025-10-08 的 LeetCode 2300 解題紀錄"
date: 2025-10-08
tags: ["medium", "binary-search", "sorting", "two-pointers"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-10-08
- 提交紀錄：Time Limit Exceeded → Accepted

## 解題思路

咒語強度 `s` 和藥水強度 `p` 成功的條件是 `s * p >= success`，也就是 `p >= success / s`。

把藥水排序後，對每個咒語找「第一個 `>= 門檻` 的位置」，後面的藥水全部都成功，個數是 `m - 位置`。

## 我的嘗試：每個咒語都掃一遍藥水

```python
for spell in spells:
    min_potion = success / spell
    res.append(sum(map(lambda x: x >= min_potion, potions)))
```

`O(n * m)`，`n` 和 `m` 都到 `10^5`，TLE。

AC 版先排序藥水，再手寫 lower bound。

## 正確解法

```python
import bisect

class Solution:
    def successfulPairs(self, spells: List[int], potions: List[int], success: int) -> List[int]:
        potions.sort()
        m = len(potions)
        res = []
        for s in spells:
            need = (success + s - 1) // s            # ceil(success / s)，全程用整數
            res.append(m - bisect.bisect_left(potions, need))
        return res
```

原本的版本用 `success / spell` 浮點數除法當門檻。這題的範圍內剛好沒出錯，但 `success` 到 `10^10`，**用整數的 ceil 比較保險**：`p >= success / s` 等價於 `p >= ceil(success / s)`，因為 `p` 是整數。

### 另一種解法：咒語也排序，用雙指針

咒語越強，門檻越低，所以把咒語排序後，藥水的分界點只會往左移，可以用一個指針掃過去，時間主要花在排序。要記得把答案放回原本的順序。

## 複雜度

時間 `O((n + m) log m)`，空間 `O(1)`，不算輸出和排序。

## 要特別避免的錯誤

- 對每個咒語線性掃描所有藥水：`O(n * m)`。
- 用浮點數除法當門檻：數字大時可能有誤差。
- Java/C++ 的 `s * p` 會溢位：要用 `long`，或改成比較門檻。

## 面試口說整理

成功條件是 `p >= success / s`，所以我把藥水排序，對每個咒語算出整數門檻 `ceil(success / s)`，用 `bisect_left` 找到第一個不小於門檻的藥水，後面的全部都成功。門檻用整數計算，避免浮點誤差。時間 `O((n + m) log m)`。
