---
title: "LeetCode 3873: Maximum Points Activated with One Addition"
summary: "LeetCode 3873 解題筆記：同 x 或同 y 的點用 Union-Find 合併成塊；新加的點最多接上兩塊，答案是最大的兩塊加 1"
description: "2026-07-29 的 LeetCode 3873 解題紀錄"
date: 2026-07-29
tags: ["hard", "union-find", "hash-table", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-07-29
- 提交紀錄：Time Limit Exceeded → Wrong Answer → Accepted ×2

## 解題思路

啟動會沿著「同 x 或同 y」一直傳下去，所以一個點被啟動，它所在的整塊都會被啟動。先用 Union-Find 把點分成塊。

新加的點 `(x, y)` 只能透過它的 x 接上一塊、透過它的 y 接上一塊，**最多兩塊**。挑最大的兩塊 A、B：x 取 A 裡某個點的 x，y 取 B 裡某個點的 y。這個座標一定沒有點，因為如果有，它會同時跟 A、B 相連，A 和 B 就是同一塊了。只有一塊時就是那塊加 1。

合併時不要兩兩比較，用字典記每個 x（和每個 y）第一次出現的點，之後的點跟它合併（[Union-Find]({{< relref "/algorithm/Union-Find" >}}) 的「用第一個出現的代表合併」）。

## 我的嘗試

1. **第一版**兩兩比較所有點，`O(n²)`，TLE。
2. **第二版**把同 x、同 y 的點收集到集合裡，但合併時寫成 `union(i - 1, i)`，**用的是迴圈的 index，不是集合裡的點**。例如 `[[0, 0], [1, 2], [3, 3], [3, 0]]`：`(0, 0)`、`(3, 0)`、`(3, 3)` 是一塊，加上 `(1, 2)` 那一塊，答案是 5，這版回傳 4。
3. 改成合併集合裡的元素就 AC 了；再改成用字典記第一個出現的點，更快。

## 正確解法

```python
class Solution:
    def maxActivated(self, points: List[List[int]]) -> int:
        n = len(points)
        parent = list(range(n))

        def find(x):
            while parent[x] != x:
                parent[x] = parent[parent[x]]
                x = parent[x]
            return x

        first_x, first_y = {}, {}
        for i, (x, y) in enumerate(points):
            for first, key in ((first_x, x), (first_y, y)):
                if key in first:
                    parent[find(i)] = find(first[key])
                else:
                    first[key] = i
        sizes = sorted(Counter(find(i) for i in range(n)).values(), reverse=True)
        return sum(sizes[:2]) + 1
```

## 複雜度

時間 `O(n · α(n) + n log n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 不要兩兩比較，用字典記代表點。
- 合併的是集合裡的元素，不是迴圈的 index。

## 面試口說整理

啟動會傳遍整個連通塊，所以我先用 Union-Find 把同 x 或同 y 的點合併，合併時用字典記每個座標第一次出現的點。新點最多透過 x 接一塊、透過 y 接一塊，而且挑兩個不同塊的 x、y 組出來的位置一定是空的，所以答案是最大的兩塊加 1。時間 `O(n log n)`。
