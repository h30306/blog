---
title: "LeetCode 637: Average of Levels in Binary Tree"
summary: "LeetCode 637 解題筆記：層序遍歷，每層加總除以節點數"
description: "2022-08-29 的 LeetCode 637 解題紀錄"
date: 2022-08-29
tags: ["easy", "tree", "depth-first-search", "breadth-first-search", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-29
- 提交紀錄：Runtime Error ×2 → Accepted ×2 → Time Limit Exceeded → Runtime Error → Wrong Answer → Accepted ×5

## 解題思路

BFS 一層一層走（[Tree]({{< relref "/algorithm/Tree" >}}) 模板二），每層把值加起來除以節點數。Python 3 的 `/` 會得到浮點數，剛好是題目要的。

## 我的嘗試

前兩版存值的方式寫錯（IndexError、TypeError），之後幾版在整理寫法時又改壞過幾次（其中一版無限迴圈），最後回到一層一層的寫法。

## 正確解法

```python
class Solution:
    def averageOfLevels(self, root: Optional[TreeNode]) -> List[float]:
        res, level = [], [root]
        while level:
            res.append(sum(n.val for n in level) / len(level))
            level = [c for n in level for c in (n.left, n.right) if c]
        return res
```

## 複雜度

時間 `O(n)`，空間 `O(w)`。

## 要特別避免的錯誤

- 題目保證至少有一個節點，所以不用處理空樹；要處理的話初始值要改成空 list。

## 面試口說整理

我用 BFS 一層一層走，每層的總和除以節點數就是平均。時間 `O(n)`。
