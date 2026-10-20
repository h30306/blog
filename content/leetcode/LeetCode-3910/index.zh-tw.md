---
title: "LeetCode 3910: Count Connected Subgraphs with Even Node Sum"
summary: "LeetCode 3910 解題筆記：n 很小，用位元遮罩枚舉所有子集合，先檢查和是不是偶數，再檢查誘導子圖是否連通"
description: "2026-04-26 的 LeetCode 3910 解題紀錄"
date: 2026-04-26
tags: ["hard", "bit-manipulation", "enumeration", "graph", "union-find"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-04-26
- 提交紀錄：Accepted → Accepted（整理一次）

## 解題思路

數有幾個非空的節點子集合，滿足：

1. 只保留子集合裡的節點和它們之間的邊（誘導子圖），而且這個子圖是連通的。
2. 子集合裡節點值的和是偶數。

節點數很小，可以**用位元遮罩枚舉全部 `2^n - 1` 個子集合**，每個子集合：

1. 先檢查和是不是偶數，比較便宜，不符合就跳過。
2. 再檢查誘導子圖是不是連通：從子集合裡任一點開始 BFS，只走子集合內的邊，看能不能走到所有點。

## 我的解法

原本是用 Union-Find 檢查連通：只合併兩端都在子集合裡的邊，最後看子集合的點是不是都在同一個根底下。這裡改用 BFS，邏輯一樣，但不用每個子集合都重建 `parent` 陣列：

```python
class Solution:
    def evenSumSubgraphs(self, nums: List[int], edges: List[List[int]]) -> int:
        n = len(nums)
        adj = [0] * n                              # 鄰居也用位元遮罩表示
        for u, v in edges:
            adj[u] |= 1 << v
            adj[v] |= 1 << u

        count = 0
        for mask in range(1, 1 << n):
            if sum(nums[i] for i in range(n) if mask >> i & 1) % 2:
                continue
            start = (mask & -mask).bit_length() - 1     # 最低位的點
            seen = 1 << start
            frontier = seen
            while frontier:
                nxt = 0
                for i in range(n):
                    if frontier >> i & 1:
                        nxt |= adj[i]
                nxt &= mask & ~seen                # 只走子集合內、還沒拜訪的點
                seen |= nxt
                frontier = nxt
            if seen == mask:
                count += 1
        return count
```

鄰居用位元遮罩存，「只走子集合內的點」就是一個 `& mask`。

LeetCode 的題目敘述裡要求在函式中途建立一個指定名稱的變數來存輸入，原本交的版本有照做；它不影響演算法，這裡省略。

## 複雜度

時間 `O(2^n · n^2)`：每個子集合 BFS 最多 `n` 層，每層掃 `n` 個點。空間 `O(n)`。

## 要特別避免的錯誤

- 檢查連通時用了子集合外的邊或點：只能走「兩端都在子集合裡」的邊。
- 空集合也算進去：遮罩要從 1 開始。
- 先檢查連通再檢查和：和的檢查比較便宜，先做就能提早跳過不符合的子集合。

## 面試口說整理

節點數很小，所以我用位元遮罩枚舉所有非空子集合。每個子集合先檢查節點值的和是不是偶數，不是就跳過；是的話，從子集合裡任一點做 BFS，只走子集合內的點，最後走到的點等於整個子集合就是連通的。鄰居存成位元遮罩，限制在子集合內只要一個 `& mask`。時間 `O(2^n · n^2)`。
