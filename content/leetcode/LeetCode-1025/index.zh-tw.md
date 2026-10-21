---
title: "LeetCode 1025: Divisor Game"
summary: "LeetCode 1025 解題筆記：dp[i] = 存在 i 的因數 x 讓 dp[i - x] 是輸；觀察後答案就是 n 是偶數"
description: "2022-09-27 的 LeetCode 1025 解題紀錄"
date: 2022-09-27
tags: ["easy", "math", "dynamic-programming", "brainteaser", "game-theory"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-27
- 提交紀錄：Accepted ×2 → Runtime Error ×2 → Wrong Answer → Accepted ×3

## 解題思路

博弈 DP：`dp[i]` 表示面對 `i` 時先手會不會贏，只要存在 `x | i`、`x < i` 讓 `dp[i - x]` 是 `False`（對手輸）就贏。跑出來會發現 `dp[i]` 剛好就是 `i` 是偶數（[Linear DP]({{< relref "/algorithm/Linear-DP" >}}) 裡的「標了 DP，但觀察更快」）：偶數可以拿 1 讓對手面對奇數；奇數的因數都是奇數，拿完一定剩偶數給對手。

## 我的嘗試

2022-09 第一次就用 `n % 2 == 0` AC 了。2022-11 想練 DP 版本：

- 先寫成 `[False] * len(n)`（整數沒有長度），接著 index 超出範圍。
- 修好之後外層迴圈是 `range(n)`，**`dp[n]` 本身沒有算到**，永遠是 `False`：`n = 2` 回傳 `False`。改成 `range(n + 1)` 就 AC 了。

## 正確解法

```python
class Solution:
    def divisorGame(self, n: int) -> bool:
        return n % 2 == 0
```

## 複雜度

時間 `O(1)`，空間 `O(1)`；DP 版本是 `O(n²)`。

## 要特別避免的錯誤

- DP 的迴圈要包含 `n` 本身：`range(n + 1)`。
- 陣列長度是 `n + 1`，不是 `len(n)`。

## 面試口說整理

可以用 DP，dp[i] 是存在一個因數 x 讓對手面對 i - x 會輸；但觀察後發現偶數可以拿 1 讓對手面對奇數，而奇數的因數都是奇數，拿完一定剩偶數，所以答案就是 n 是不是偶數。
