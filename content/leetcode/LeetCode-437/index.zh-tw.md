---
title: "LeetCode 437: Path Sum III"
summary: "LeetCode 437 解題筆記：樹上的前綴和 + 雜湊表：先查 prefix - target 再把自己加進去，離開節點時要扣回來"
description: "2026-10-28 的 LeetCode 437 解題紀錄"
date: 2026-10-28
tags: ["medium", "tree", "depth-first-search", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-10-28
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

路徑只能往下走，所以每條路徑都是「根到某節點」的一段。和陣列的「和為 K 的子陣列」一樣（[Prefix Sum]({{< relref "/algorithm/Prefix-Sum" >}}) 模板三）：

- DFS 時維護根到目前節點的前綴和 `prefix`。
- 以目前節點結尾、和為 `target` 的路徑數，等於祖先中前綴和是 `prefix - target` 的個數。
- 用雜湊表記錄**目前這條根到節點路徑上**各前綴和出現的次數，一開始放 `{0: 1}`（代表從根開始的路徑）。

離開節點時要把自己的前綴和扣回去，不然別的分支會用到不是祖先的前綴和。

## 我的嘗試

1. 先把自己的前綴和加進雜湊表，再查 `prefix - target`：`target = 0` 時會查到自己，等於數到一條長度 0 的路徑。例如 `[-2]`、`target = 0`，回傳 1，答案是 0。
2. 把「查」和「加」的順序對調就過了。

## 正確解法

```python
class Solution:
    def pathSum(self, root: Optional[TreeNode], targetSum: int) -> int:
        count = defaultdict(int)
        count[0] = 1
        res = 0

        def dfs(node, prefix):
            nonlocal res
            if not node:
                return
            prefix += node.val
            res += count[prefix - targetSum]
            count[prefix] += 1
            dfs(node.left, prefix)
            dfs(node.right, prefix)
            count[prefix] -= 1

        dfs(root, 0)
        return res
```

## 複雜度

時間 `O(n)`，空間 `O(h)`（遞迴和雜湊表裡同時只有一條路徑）。暴力法對每個節點往下找是 `O(n^2)`。

## 要特別避免的錯誤

- 先查再加。先加的話 `target = 0` 會數到空路徑。
- 回溯時要 `count[prefix] -= 1`，雜湊表只能有祖先的前綴和。
- `{0: 1}` 不能漏，否則從根開始的路徑都不會被數到。

## 面試口說整理

路徑只能往下，所以是根到節點路徑上的一段，可以用前綴和。DFS 時維護前綴和，以目前節點結尾的答案數是祖先中前綴和等於 `prefix - target` 的個數，用雜湊表記，起始放 `{0: 1}`。先查再把自己加進去，離開節點時扣回來，保證表裡只有祖先。時間 `O(n)`。
