---
title: "Linear DP 線性 DP"
summary: "一維 DP、狀態機 DP、DP + 單調佇列、排序後的區間排程 DP、子序列計數去重，以及標了 DP 但用觀察或貪心更快的題目"
description: "演算法學習"
date: 2026-10-20
tags: ["dynamic-programming", "state-machine", "monotonic-queue", "binary-search"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 介紹

線性 DP 是沿著一個方向（陣列的 index、時間、長度）一格一格往前算，`dp[i]` 只依賴前面的狀態。

寫 DP 的固定流程：

1. **定義狀態**：`dp[i]` 代表什麼？「以 `i` 結尾」還是「前 `i` 個」？
2. **轉移**：`dp[i]` 怎麼從前面的狀態來？
3. **初始值**和**答案在哪裡**（`dp[-1]` 還是 `max(dp)`）。
4. 只依賴前一兩格時，可以壓成幾個變數。

| 形式 | 狀態 | 例子 |
|---|---|---|
| 一維 DP | `dp[i]`：前 `i` 個的最佳值 | 打家劫舍 |
| 狀態機 DP | `dp[i][state]`：第 `i` 步、處於某個狀態 | 出席紀錄、母音排列、塗色 |
| DP + 單調佇列 | `dp[i]` 依賴前 `k` 個的最大值 | Jump Game VI |
| 區間排程 DP | 依結束時間排序，`dp` 搭配二分搜尋 | 工作排程 |
| 子序列計數 | 依「結尾字元」分類，避免重複 | 不同的子序列 |

## 模板一：一維 DP

```python
dp = [0] * (n + 1)                       # dp[i]：前 i 個的最佳值
for i in range(n):
    dp[i + 1] = max(dp[i], dp[i - 1] + nums[i] if i > 0 else nums[i])
```

- **打家劫舍的變形**（LC 3840）：只有相鄰而且顏色相同時才不能一起拿。顏色不同就直接拿，`dp[i + 1] = dp[i] + nums[i]`；相同時才是打家劫舍的 `max`。

## 模板二：狀態機 DP

每一步的「狀態」只有少數幾種，列出每種狀態能轉移到哪些狀態：

```python
dp = 初始狀態的計數
for _ in range(n):
    ndp = [0] * 狀態數
    for s in 所有狀態:
        for t in 從 s 能到的狀態:
            ndp[t] += dp[s]
    dp = ndp
return sum(dp)
```

- **出席紀錄**（LC 552）：狀態是「A 用了幾次（0、1）× 結尾連續幾個 L（0、1、2）」，共 6 種。
- **母音排列**（LC 1220）：狀態是最後一個母音，轉移照題目規則。
- **塗 n × 3 格子**（LC 1411）：一列只有兩種樣式：`ABA`（兩端同色）和 `ABC`（三色都不同），各 6 種塗法，下一列的轉移是 `ABA → 3 ABA + 2 ABC`、`ABC → 2 ABA + 2 ABC`。
- **代幣移不移動**（LC 3952）：狀態是「這一格的代幣有沒有往左移」。

## 模板三：DP + 單調佇列

`dp[i] = nums[i] + max(dp[i-k..i-1])`，前 `k` 個的最大值就是滑動視窗最大值，用單調佇列 `O(1)` 取得：

```python
from collections import deque

dq = deque([0])                          # index，dp 值遞減
for i in range(1, n):
    if dq[0] < i - k:
        dq.popleft()                     # 過期
    dp[i] = nums[i] + dp[dq[0]]
    while dq and dp[dq[-1]] <= dp[i]:
        dq.pop()                         # 被支配
    dq.append(i)
```

（LC 1696；LC 1425 是同一個結構，見 [Sliding Window]({{< relref "/algorithm/Sliding-Window" >}})）。

## 模板四：區間排程 DP

工作有開始、結束時間和收益，選不重疊的工作。**依結束時間排序**，`best[j]` = 只用前 `j` 個工作的最大收益；選第 `j` 個時，用二分搜尋找最後一個結束時間 `<= 開始時間` 的工作：

```python
from bisect import bisect_right

jobs = sorted(zip(end, start, profit))
ends, best = [0], [0]
for e, s, p in jobs:
    i = bisect_right(ends, s) - 1        # 最後一個 end <= s 的工作
    best.append(max(best[-1], best[i] + p))
    ends.append(e)
return best[-1]
```

時間軸可能到 `10^9`，**不能用時間當 index**，要用工作的編號（LC 1235）。只能選兩個時，`best` 換成前綴最大值（LC 2054）。

## 模板五：子序列計數去重

數不同的子序列時，依**最後一個字元**分類：以 `c` 結尾的不同子序列 = 目前所有不同子序列後面接 `c`，再加上 `c` 本身。新的值直接**覆蓋**舊的 `end[c]`（舊的都被包含在新的裡面）：

```python
end = {}
for c in s:
    end[c] = (sum(end.values()) + 1) % MOD
return sum(end.values()) % MOD
```

（LC 940）

## 標了 DP，但觀察或貪心更快

這幾題 LeetCode 有 DP 標籤，但想清楚結構後可以不用 DP：

- **差分**（LC 1526）：每次 `target[i] > target[i - 1]` 都要多 `target[i] - target[i - 1]` 次操作。
- **排序後貪心**（LC 1402）：從滿意度大的開始加，每加一道菜，前面選的都往後一格，總和增加「目前選的總和」，總和還是正的就繼續加。
- **數學**（LC 2745）：`AA` 和 `BB` 要交替，`AB` 可以全部接上。
- **能切就切**（LC 3638）：一段一旦出現比最大值小的數，馬上結束這段。
- **前綴最大 / 後綴最小**（LC 3660）：前綴最大值大於後面的最小值時，兩邊連得起來。

## 主要參數說明

- `dp[i]` 用「前 `i` 個」時，陣列長度是 `n + 1`，`dp[0]` 是空的狀態。
- 狀態機 DP 每一輪要用新的 `ndp`，不能直接改 `dp`（不然同一輪的轉移會互相影響）。
- 計數題記得取模，而且每一步都取。

## 複雜度

一維 DP `O(n)`；狀態機 DP `O(n · 狀態數 · 轉移數)`；DP + 單調佇列 `O(n)`；區間排程 `O(n log n)`。

## 常見錯誤

這些都是我練習時實際寫錯過的：

- **模數打錯**：`10 % 9 + 7` 應該是 `10 ** 9 + 7`，而且最後的加總也要取模（LC 1220）。
- **起點搞錯**：Jump Game VI 一定要從 index 0 出發，我的 `dp` 讓任何前 `k` 格都能當起點（LC 1696）。
- **同一時間結束的工作互相覆蓋**：`dp[i] = max(dp[i - 1], ...)` 處理第二個工作時把第一個的結果蓋掉了（LC 1235）。
- **用時間當 index**：時間到 `10^9`，MLE / TLE（LC 1235）。
- **貪心比較錯對象**：要跟這一段的最大值比，我一直跟這段的第一個數比（LC 3638）。

## 相關 LeetCode

- `LC 3840` House Robber V
- `LC 552` Student Attendance Record II
- `LC 1220` Count Vowels Permutation
- `LC 1411` Number of Ways to Paint N × 3 Grid
- `LC 3952` Maximum Total Value of Covered Indices
- `LC 1696` Jump Game VI
- `LC 1235` Maximum Profit in Job Scheduling
- `LC 2054` Two Best Non-Overlapping Events
- `LC 940` Distinct Subsequences II
- `LC 1526` Minimum Number of Increments on Subarrays to Form a Target Array
- `LC 1402` Reducing Dishes
- `LC 2745` Construct the Longest New String
- `LC 3638` Maximum Balanced Shipments
- `LC 3660` Jump Game IX
