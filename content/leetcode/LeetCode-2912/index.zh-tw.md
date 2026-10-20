---
title: "LeetCode 2912: Number of Ways to Reach Destination in the Grid"
summary: "LeetCode 2912 解題筆記：格子太多，但相對終點只分四類：終點、同一列、同一行、都不同；每一類的總方法數一起轉移，O(k)"
description: "2026-07-30 的 LeetCode 2912 解題紀錄"
date: 2026-07-30
tags: ["hard", "dynamic-programming", "state-machine", "math", "combinatorics"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-07-30
- 提交紀錄：Wrong Answer → Accepted ×2

## 解題思路

每一步可以移到同一列或同一行的任何其他格子。格子有 `n × m` 個，但相對於終點 `(dx, dy)` 只有四類，**同一類的格子行為完全一樣**：

| 類別 | 條件 | 格子數 |
|---|---|---|
| 0 | 就是終點 | 1 |
| 1 | `x == dx`、`y != dy`（同一列） | `m - 1` |
| 2 | `x != dx`、`y == dy`（同一行） | `n - 1` |
| 3 | 都不同 | 其他 |

`dp[c]` = 走到**類別 `c` 裡所有格子**的方法數總和。從一個格子出發能到哪幾類：

- 從終點：同一列的 `m - 1` 格（類別 1）、同一行的 `n - 1` 格（類別 2）。
- 從類別 1 的格子 `(dx, y)`：終點 1 格、類別 1 的其他 `m - 2` 格、同一行的 `n - 1` 格都在類別 3。
- 從類別 2：對稱。
- 從類別 3 的格子 `(x, y)`：`(dx, y)` 是類別 1、`(x, dy)` 是類別 2，其他 `n + m - 4` 格都是類別 3。

```text
new0 = dp1 + dp2
new1 = (m - 1) dp0 + (m - 2) dp1 + dp3
new2 = (n - 1) dp0 + (n - 2) dp2 + dp3
new3 = (n - 1) dp1 + (m - 1) dp2 + (n + m - 4) dp3
```

## 我的嘗試

第一版的轉移把兩種意義混在一起：有的係數是用「某一個特定格子的方法數」推的，有的是用「整類的總和」推的，結果係數放錯位置。例如 `n = 2`、`m = 4`、`k = 2`、從 `[2, 4]` 走到 `[1, 1]`：答案是 2（經過 `[2, 1]` 或 `[1, 4]`），回傳 6。

統一成「`dp[c]` 是整類的總和」，每個係數都從「這類的一個格子能到哪幾類、各幾格」推，就對了。

## 正確解法

```python
class Solution:
    def numberOfWays(self, n: int, m: int, k: int, source: List[int], dest: List[int]) -> int:
        MOD = 10 ** 9 + 7
        sx, sy = source
        dx, dy = dest
        dp = [0, 0, 0, 0]                          # 四類各自的總方法數
        if (sx, sy) == (dx, dy):
            dp[0] = 1
        elif sx == dx:
            dp[1] = 1
        elif sy == dy:
            dp[2] = 1
        else:
            dp[3] = 1

        for _ in range(k):
            d0, d1, d2, d3 = dp
            dp = [
                (d1 + d2) % MOD,
                ((m - 1) * d0 + (m - 2) * d1 + d3) % MOD,
                ((n - 1) * d0 + (n - 2) * d2 + d3) % MOD,
                ((n - 1) * d1 + (m - 1) * d2 + (n + m - 4) * d3) % MOD,
            ]
        return dp[0]
```

## 複雜度

時間 `O(k)`，空間 `O(1)`。（4 × 4 的轉移矩陣也可以用快速冪做到 `O(log k)`。）

## 要特別避免的錯誤

- `dp` 的意義要統一：整類的總和，不是一個格子的方法數。
- 不能停在原地，所以同一類的轉移是 `m - 2`、`n - 2`，不是 `m - 1`、`n - 1`。

## 面試口說整理

格子很多，但相對終點只分四類，同一類的格子行為一樣。我讓 `dp` 存每一類所有格子的方法數總和，從一類的一個格子出發，數它能到每一類的幾個格子，就是轉移係數。走 `k` 步之後回傳終點那類。時間 `O(k)`。
