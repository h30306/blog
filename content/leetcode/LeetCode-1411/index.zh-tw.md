---
title: "LeetCode 1411: Number of Ways to Paint N × 3 Grid"
summary: "LeetCode 1411 解題筆記：一列的塗法只分兩種樣式：ABA（兩端同色）和 ABC（三色不同），各 6 種；下一列 ABA → 3 ABA + 2 ABC、ABC → 2 ABA + 2 ABC"
description: "2026-07-05 的 LeetCode 1411 解題紀錄"
date: 2026-07-05
tags: ["hard", "dynamic-programming", "state-machine", "graph-coloring"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-07-05
- 提交紀錄：Accepted ×2（暴力列舉 → 樣式分類）

## 解題思路

一列 3 格、3 種顏色、相鄰不同色，共 12 種塗法，分成兩種樣式：

- **ABA**：兩端同色，例如紅黃紅，6 種。
- **ABC**：三格都不同，例如紅黃綠，6 種。

下一列要跟上一列每一格都不同色。只要看樣式，數得出固定的轉移數（例如上一列是 `ABA` 紅黃紅，下一列可以是 黃紅黃、綠紅綠、黃綠黃 三種 ABA，以及 黃紅綠、綠紅黃 兩種 ABC）：

```text
新 ABA = 3 × ABA + 2 × ABC
新 ABC = 2 × ABA + 2 × ABC
```

## 我的嘗試

第一版直接用 `dp[row][c1][c2][c3]`，每一列枚舉所有合法的塗法，再枚舉上一列所有合法塗法檢查是否相容，`O(n · 27 · 27)`，跑了 1.3 秒才過。

把 12 種塗法歸成兩種樣式之後，轉移只剩 4 個係數，`O(n)`。

## 正確解法

```python
class Solution:
    def numOfWays(self, n: int) -> int:
        MOD = 10 ** 9 + 7
        aba = abc = 6
        for _ in range(n - 1):
            aba, abc = (3 * aba + 2 * abc) % MOD, (2 * aba + 2 * abc) % MOD
        return (aba + abc) % MOD
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 轉移係數最好親手列一次確認（或像第一版那樣用暴力驗證），不要用猜的。

## 面試口說整理

一列的 12 種塗法只分兩種樣式：兩端同色的 ABA 和三色都不同的 ABC，各 6 種。下一列跟上一列的相容數量只看樣式：ABA 可以接 3 種 ABA、2 種 ABC，ABC 可以接 2 種 ABA、2 種 ABC。用這兩個數一列一列往下推，時間 `O(n)`。
