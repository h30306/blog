---
title: "LeetCode 2973: Find Number of Coins to Place in Tree Nodes"
summary: "LeetCode 2973 解題筆記：三個數的最大乘積只可能是「最大的三個」或「最小的兩個 × 最大的一個」；每個子樹只回傳最小 2 個和最大 3 個，後序合併"
description: "2026-09-12 的 LeetCode 2973 解題紀錄"
date: 2026-09-12
tags: ["hard", "dynamic-programming", "tree-dp", "depth-first-search", "sorting", "heap", "tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-09-12
- 提交紀錄：Wrong Answer ×3 → Accepted ×2

## 解題思路

子樹裡選三個不同節點的最大乘積，只有兩種可能：

- **最大的三個相乘**。
- **最小的兩個（可能是兩個負數）× 最大的一個**。

所以每個子樹只需要知道**最小的 2 個和最大的 3 個**，最多 5 個數。後序遍歷：把自己和所有孩子回傳的數合在一起、排序，算答案，再截斷成 5 個往上回傳。

- 子樹大小 `< 3`：放 1 個硬幣。
- 乘積是負的：放 0 個。

邊是無向的，要建雙向的鄰接表，DFS 時記住父節點。

## 我的嘗試

| 版本 | 問題 |
|---|---|
| 第一版 | 用 heap 收集子樹的值，但葉子回傳的是正的 `cost`，內部節點回傳的是取負號的 heap，**正負號混在一起**。例如邊 `[[0, 1], [1, 2], [0, 3]]`、`cost = [1, 2, 3, 1]`：根的答案是 `3 × 2 × 1 = 6`，回傳 0 |
| 第二版 | 修好正負號，但只拿最大的三個相乘，漏掉兩個負數。例如邊 `[[0, 1], [0, 2], [1, 3]]`、`cost = [6, -5, 0, -4]`：`6 × (-5) × (-4) = 120`，回傳 0 |
| 第三版 | 乘積修好，但鄰接表只建了 `u → v`，假設每條邊都是「父 → 子」。題目的邊沒有方向，例如 `[[1, 0]]` 這種寫法，節點 0 找不到孩子 |
| AC | 建雙向的鄰接表，DFS 帶父節點 |

## 正確解法

```python
class Solution:
    def placedCoins(self, edges: List[List[int]], cost: List[int]) -> List[int]:
        adj = defaultdict(list)
        for u, v in edges:
            adj[u].append(v)
            adj[v].append(u)                       # 邊沒有方向
        res = [0] * len(cost)

        def dfs(node: int, parent: int) -> List[int]:
            vals = [cost[node]]
            for child in adj[node]:
                if child != parent:
                    vals.extend(dfs(child, node))
            vals.sort()
            if len(vals) < 3:
                res[node] = 1
            else:
                res[node] = max(0, vals[-1] * vals[-2] * vals[-3], vals[0] * vals[1] * vals[-1])
            return vals if len(vals) <= 5 else vals[:2] + vals[-3:]   # 只留最小 2 個、最大 3 個

        dfs(0, -1)
        return res
```

## 複雜度

每個節點合併的數最多是 `5 × 孩子數 + 1`，排序成本是常數倍，總共 `O(n log n)` 左右。DFS 深度最多 `n`（一條鏈時），`n = 2 × 10^4` 可能要調高遞迴上限或改成迭代。

## 要特別避免的錯誤

- 只看最大的三個：兩個負數相乘會變正。
- 正負號在 heap 裡混用。
- 把邊當成有方向的。

## 面試口說整理

三個數的最大乘積只可能是最大的三個相乘，或最小的兩個乘最大的一個，所以每個子樹只要回傳最小 2 個和最大 3 個。我後序遍歷，把自己和孩子回傳的數合在一起排序算答案，再截斷成 5 個往上傳。邊是無向的，要建雙向鄰接表。時間大約 `O(n log n)`。
