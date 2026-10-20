---
title: "LeetCode 1339: Maximum Product of Splitted Binary Tree"
summary: "LeetCode 1339 解題筆記：先算總和，再枚舉每棵子樹的和，不要改到輸入"
description: "2026-01-09 的 LeetCode 1339 解題紀錄"
date: 2026-01-09
tags: ["medium", "tree", "binary-tree", "dfs"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-09
- 提交紀錄：Accepted（一次通過）

## 解題思路

剪掉一條邊，等於把某棵子樹整個切出去。設這棵子樹的和是 `s`、整棵樹的和是 `total`，乘積就是 `s * (total - s)`。

所以只要知道**每棵子樹的和**，枚舉一次取最大值就好。

注意題目要求「先取最大值，再取模」，不能邊算邊取模。

## 我的解法：把子樹和寫回 node.val

```python
from collections import deque

class Solution:
    def maxProduct(self, root: Optional[TreeNode]) -> int:
        def dfs(node):
            if not node:
                return 0
            node.val += dfs(node.left) + dfs(node.right)
            return node.val

        total = dfs(root)

        ans = 0
        q = deque([root])
        while q:
            node = q.popleft()
            ans = max(ans, (total - node.val) * node.val)
            if node.left:
                q.append(node.left)
            if node.right:
                q.append(node.right)
        return ans % (10 ** 9 + 7)
```

正確，而且 Python 的整數不會溢位，所以可以先比大小再取模。

可以改進的地方：

- **把子樹和寫回 `node.val` 會破壞輸入**。面試時最好另外存起來。
- 第二次的 BFS 其實不需要：DFS 時就可以把每棵子樹的和收集起來。

## 改進版：一次 DFS 收集所有子樹和

```python
class Solution:
    def maxProduct(self, root: Optional[TreeNode]) -> int:
        sums = []

        def dfs(node):
            if not node:
                return 0
            s = node.val + dfs(node.left) + dfs(node.right)
            sums.append(s)
            return s

        total = dfs(root)
        return max(s * (total - s) for s in sums) % (10 ** 9 + 7)
```

根節點的和也會在 `sums` 裡，但它的乘積是 `total * 0 = 0`，不會影響最大值。

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 邊算邊取模再比大小：取模後的值大小關係不一樣。
- Java/C++ 要用 `long`，總和最多 `5 * 10^8`，乘積最大約 `(2.5 * 10^8)^2`。
- 修改 `node.val` 卻沒有說明，面試官可能會問。

## 面試口說整理

剪掉一條邊等於切出一棵子樹，乘積是子樹和乘上剩下的和。我先用一次後序 DFS 算出整棵樹的和，同時收集每棵子樹的和，再枚舉取 `s * (total - s)` 的最大值，最後才取模。時間和空間都是 `O(n)`。
