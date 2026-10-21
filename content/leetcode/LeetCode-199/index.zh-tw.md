---
title: "LeetCode 199: Binary Tree Right Side View"
summary: "LeetCode 199 解題筆記：層序遍歷，每一層最右邊的節點就是從右邊看得到的"
description: "2022-10-29 的 LeetCode 199 解題紀錄"
date: 2022-10-29
tags: ["medium", "tree", "depth-first-search", "breadth-first-search", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-10-29
- 提交紀錄：Time Limit Exceeded → Accepted → Runtime Error → Accepted ×2

## 解題思路

從右邊看，每一層只看得到最右邊那個節點（[Tree]({{< relref "/algorithm/Tree" >}}) 模板二）。BFS 一層一層走，記錄每層最後一個。

## 我的嘗試

第一版的迴圈沒有前進到下一層，只有一個節點 `[6]` 就無限迴圈（TLE）；一版沒處理空樹。

## 正確解法

```python
class Solution:
    def rightSideView(self, root: Optional[TreeNode]) -> List[int]:
        res, level = [], [root] if root else []
        while level:
            res.append(level[-1].val)
            level = [c for n in level for c in (n.left, n.right) if c]
        return res
```

## 複雜度

時間 `O(n)`，空間 `O(w)`。

## 要特別避免的錯誤

- 最右邊的不一定是右小孩：右子樹比較矮時，看得到的是左子樹更深的節點。

## 面試口說整理

從右邊看到的是每層最右邊的節點，所以我用 BFS 一層一層走，每層記錄最後一個。時間 `O(n)`。
