---
title: "LeetCode 1627: Graph Connectivity With Threshold"
summary: "LeetCode 1627 解題筆記：不用兩兩算 GCD；對每個 z > threshold，把 z 的所有倍數連起來，總共 O(n log n) 次合併"
description: "2026-09-05 的 LeetCode 1627 解題紀錄"
date: 2026-09-05
tags: ["hard", "math", "number-theory", "union-find", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-09-05
- 提交紀錄：Time Limit Exceeded → Accepted

## 解題思路

`x` 和 `y` 相連 ⇔ 有一個 `z > threshold` 同時整除兩者。

反過來想：**對每個 `z > threshold`，`z, 2z, 3z, ...` 這些數全部都相連**（它們都被 `z` 整除）。所以把每個 `z` 的倍數都跟 `z` 合併就好。

- 合併次數是 `Σ n / z`，調和級數，`O(n log n)`。
- `threshold == 0` 時 `z = 1` 整除所有數，全部相連。
- `z > n / 2` 時 `z` 沒有其他倍數在範圍內，不用處理。

查詢就是看兩個城市是不是同一個根。

## 我的嘗試

第一版對所有城市兩兩算 GCD，`O(n^2 log n)`，`n = 10^4` 時 TLE。改成「每個 `z` 連它的倍數」就 AC 了，44ms。

## 正確解法

```python
class Solution:
    def areConnected(self, n: int, threshold: int, queries: List[List[int]]) -> List[bool]:
        parent = list(range(n + 1))

        def find(a: int) -> int:
            while parent[a] != a:
                parent[a] = parent[parent[a]]
                a = parent[a]
            return a

        for z in range(threshold + 1, n // 2 + 1):
            for multiple in range(2 * z, n + 1, z):  # z 的倍數都相連
                parent[find(multiple)] = find(z)

        return [find(a) == find(b) for a, b in queries]
```

`threshold == 0` 時 `z` 從 1 開始，1 的倍數就是所有數，迴圈自然會把全部連起來，不用另外特判。

## 複雜度

時間 `O(n log n · α(n) + q)`，空間 `O(n)`。

## 要特別避免的錯誤

- 兩兩算 GCD：`O(n^2)`。
- 條件是 `z` **嚴格大於** `threshold`。

## 面試口說整理

我不兩兩算 GCD，而是反過來：對每個大於門檻的 `z`，它的所有倍數都相連，所以把倍數跟 `z` 用 Union-Find 合併。合併次數是調和級數 `O(n log n)`，查詢就是比較兩個根。
