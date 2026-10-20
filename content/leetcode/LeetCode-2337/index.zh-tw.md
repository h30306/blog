---
title: "LeetCode 2337: Move Pieces to Obtain a String"
summary: "LeetCode 2337 解題筆記：跳過空格後兩邊的棋子順序必須一樣；L 只能往左、R 只能往右，所以每顆 L 在 start 的位置要 >= target，R 要 <="
description: "2026-02-01 的 LeetCode 2337 解題紀錄"
date: 2026-02-01
tags: ["medium", "two-pointers", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-02-01
- 提交紀錄：Runtime Error → Accepted

## 解題思路

`L` 只能往左移進空格、`R` 只能往右移進空格，而且棋子**不能互相穿越**。所以：

1. 把空格拿掉之後，`start` 和 `target` 的棋子序列必須完全一樣。
2. 第 k 顆棋子如果是 `L`，它在 `start` 的位置必須 `>=` 在 `target` 的位置（只能往左）；如果是 `R`，必須 `<=`（只能往右）。

這兩個條件也是充分的：棋子順序一樣、每顆的移動方向都合法，就能依序把它們推到定位。

用兩個指針分別在 `start` 和 `target` 上跳過空格、找下一顆棋子，配對比較。

## 我的嘗試

第一版 RE：迴圈條件是 `left < n or right < n`，跳過空格後，如果只有一邊走到底，接著讀 `start[left]` 或 `target[right]` 就越界。例如 `start = "L"`、`target = "_"`：`target` 跳過空格後 `right == n`，`start[0]` 還有一顆 `L`，讀 `target[1]` 直接 IndexError。

補上「只有一邊走完就回傳 `False`」之後 AC。

## 正確解法

```python
class Solution:
    def canChange(self, start: str, target: str) -> bool:
        n = len(start)
        i = j = 0
        while True:
            while i < n and start[i] == "_":
                i += 1
            while j < n and target[j] == "_":
                j += 1
            if i == n or j == n:
                return i == n and j == n          # 兩邊要同時沒有棋子
            if start[i] != target[j]:
                return False                      # 棋子順序不同
            if start[i] == "L" and i < j:
                return False                      # L 不能往右
            if start[i] == "R" and i > j:
                return False                      # R 不能往左
            i += 1
            j += 1
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 只比較棋子數量：順序和方向都要檢查。
- 一邊棋子用完、另一邊還有棋子時沒處理，直接越界。

## 面試口說整理

棋子不能互相穿越，所以拿掉空格後兩邊的棋子序列必須一樣。我用兩個指針各自跳過空格，配對第 k 顆棋子：種類要一樣，`L` 在 `start` 的位置不能比 `target` 左邊，`R` 不能比 `target` 右邊。最後兩邊要同時用完。時間 `O(n)`，空間 `O(1)`。

延伸：[LeetCode 777]({{< relref "/leetcode/LeetCode-777" >}}) 是同一題，只是空格寫成 `X`。
