---
title: "LeetCode 312: Burst Balloons"
summary: "LeetCode 312 解題筆記：枚舉區間 (i, j) 裡「最後一個」戳破的氣球 k，這時它的鄰居就是 i 和 j，左右兩邊的子問題互相獨立"
description: "2026-06-26 的 LeetCode 312 解題紀錄"
date: 2026-06-26
tags: ["hard", "dynamic-programming", "interval-dp", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-06-26
- 提交紀錄：Runtime Error → Accepted ×2

## 解題思路

如果枚舉「第一個」戳破的氣球，戳完之後左右兩邊的氣球變成鄰居，子問題就不獨立了。

**改成枚舉最後一個**：兩端補上 1，`val = [1] + nums + [1]`。`dp[i][j]` = 把**開區間** `(i, j)` 裡的氣球全部戳破的最大分數。如果 `k` 是 `(i, j)` 裡最後一個戳破的：

- 戳 `k` 的時候，`(i, k)` 和 `(k, j)` 都已經戳完了，`k` 的鄰居就是 `i` 和 `j`，得分 `val[i] × val[k] × val[j]`。
- `(i, k)` 和 `(k, j)` 戳的過程中，`k` 一直都在，所以兩邊互不影響。

```text
dp[i][j] = max over k in (i, j) of dp[i][k] + dp[k][j] + val[i] × val[k] × val[j]
```

答案是 `dp[0][n + 1]`。

## 我的嘗試

第一版變數名稱打錯：宣告的是 `max_coin`，迴圈裡卻寫 `max_coins = max(max_coins, coins)`，UnboundLocalError。改成一致就 AC 了。

## 正確解法

```python
class Solution:
    def maxCoins(self, nums: List[int]) -> int:
        val = [1] + nums + [1]
        n = len(val)
        dp = [[0] * n for _ in range(n)]           # dp[i][j]：開區間 (i, j)
        for length in range(2, n):
            for i in range(n - length):
                j = i + length
                dp[i][j] = max(dp[i][k] + dp[k][j] + val[i] * val[k] * val[j]
                               for k in range(i + 1, j))
        return dp[0][n - 1]
```

我 AC 的版本是記憶化遞迴 `dfs(i, j)`，跑了 3.5 秒；改成由短到長填表的迴圈版本會快一些。

## 複雜度

時間 `O(n^3)`，空間 `O(n^2)`。

## 要特別避免的錯誤

- 枚舉第一個戳破的：子問題不獨立。
- 用閉區間：鄰居會不好處理，開區間加上兩端補 1 最乾淨。

## 面試口說整理

我枚舉區間裡最後一個戳破的氣球，因為那時候左右都已經戳完，它的鄰居就是區間的兩端，而且左右兩邊的子問題互相獨立。兩端補 1，`dp[i][j]` 是開區間的最大分數，等於左邊加右邊加上 `val[i] × val[k] × val[j]`。依長度由短到長填表，時間 `O(n^3)`。
