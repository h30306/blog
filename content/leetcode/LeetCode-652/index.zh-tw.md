---
title: "LeetCode 652: Find Duplicate Subtrees"
summary: "LeetCode 652 解題筆記：後序把每棵子樹編碼，出現第二次時加入答案；字串編碼最差 O(n^2)，改成 (值, 左 id, 右 id) 編號可到 O(n)"
description: "2026-10-26 的 LeetCode 652 解題紀錄"
date: 2026-10-26
tags: ["medium", "hash-table", "tree", "depth-first-search", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-10-26
- 提交紀錄：Accepted ×2

## 解題思路

兩棵子樹相同，等於它們的「編碼」相同。後序 DFS（[Tree]({{< relref "/algorithm/Tree" >}}) 模板一）：先拿到左右子樹的編碼，再組出自己的編碼，用雜湊表計數（[Hash Table]({{< relref "/algorithm/Hash-Table" >}}) 模板五，正規化之後當 key）。某個編碼出現**第二次**時，把這個節點加入答案，之後再出現就不加，避免重複。

編碼要能唯一代表結構，所以空節點也要寫出來。

## 我的嘗試

兩次都一次通過：

1. 10-26：編碼是字串 `f"{val},{left},{right}"`，空節點是 `#`。
2. 10-27：改成把 `(val, 左 id, 右 id)` 映射到一個整數 id，避免字串越接越長。

## 正確解法

```python
class Solution:
    def findDuplicateSubtrees(self, root: Optional[TreeNode]) -> List[Optional[TreeNode]]:
        tree_id = {}
        count = defaultdict(int)
        res = []

        def post(node):
            if not node:
                return 0
            key = (node.val, post(node.left), post(node.right))
            if key not in tree_id:
                tree_id[key] = len(tree_id) + 1
            uid = tree_id[key]
            count[uid] += 1
            if count[uid] == 2:
                res.append(node)
            return uid

        post(root)
        return res
```

## 複雜度

| 編碼 | 時間 |
|---|---|
| 字串 | 最差 `O(n^2)`：每個節點的字串長度和子樹大小成正比 |
| `(值, 左 id, 右 id)` → id | `O(n)`：每個 key 是固定大小的 tuple |

空間都是 `O(n)`。

## 要特別避免的錯誤

- 用 `== 2` 才加入，不要用 `>= 2`，不然同一種子樹會被加很多次。
- 只用中序就算加上空節點也會撞：`[0,0]` 和 `[0,null,0]` 的中序都是 `#,0,#,0,#`。要用前序或後序。

## 面試口說整理

我用後序 DFS 幫每棵子樹做編碼，空節點也算進去，用雜湊表計數，出現第二次就把節點加入答案。字串編碼最差 `O(n^2)`，所以我把 `(值, 左子樹 id, 右子樹 id)` 映射成整數 id，每個節點只做常數工作，總共 `O(n)`。
