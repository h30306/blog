---
title: "LeetCode 2509: Cycle Length Queries in a Tree"
summary: "LeetCode 2509 解題筆記：完全二元樹的編號，parent 就是 v // 2，比較大的往上爬到 LCA"
description: "2026-09-11 的 LeetCode 2509 解題紀錄"
date: 2026-09-11
tags: ["hard", "tree", "binary-tree", "lca"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-09-11
- 提交紀錄：Accepted（一次通過）

## 解題思路

在 `a`、`b` 之間加一條邊，形成的環就是「樹上 `a` 到 `b` 的路徑」再加上新的那條邊。所以：

```text
環長 = dist(a, b) + 1
```

這棵樹的編號跟 heap 一樣：根是 1，`v` 的子節點是 `2v` 和 `2v + 1`，parent 是 `v // 2`。

要算 `dist(a, b)`，就讓兩個節點往上爬到最低共同祖先（LCA）。**值比較大的節點一定在同一層或更深**，所以每次把比較大的那個除以 2，直到兩者相等，爬了幾步就是距離。

## 我的解法

```python
class Solution:
    def cycleLengthQueries(self, n: int, queries: List[List[int]]) -> List[int]:
        res = []
        for x, y in queries:
            step = 1                  # 新加的那條邊
            while x != y:
                if x > y:
                    x //= 2
                else:
                    y //= 2
                step += 1
            res.append(step)
        return res
```

## 複雜度

每個查詢最多爬 `2n` 步（樹高是 `n`），時間 `O(m * n)`，`n <= 30`。空間 `O(1)`，不算輸出。

## 要特別避免的錯誤

- 真的把樹建出來再跑 BFS：樹有 `2^30` 個節點，建不出來。
- 忘記加上新增的那條邊，答案少 1。
- 只讓其中一個節點往上爬：要每次移動比較深的那個。

## 面試口說整理

加一條邊形成的環，長度是樹上兩點距離加 1。這棵樹的編號跟 heap 一樣，parent 是 `v // 2`，而且值比較大的節點一定不會比較淺，所以每次把比較大的除以 2，直到兩點相同，爬的步數就是距離。每次查詢最多 `O(n)` 步，`n` 最多 30。
