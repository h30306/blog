---
title: "LeetCode 701: Insert into a Binary Search Tree"
summary: "LeetCode 701 解題筆記：沿著 BST 往下走到空位接上新節點；空樹要直接回傳新節點"
description: "2026-10-24 的 LeetCode 701 解題紀錄"
date: 2026-10-24
tags: ["medium", "tree", "binary-search-tree", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-10-24
- 提交紀錄：Wrong Answer → Runtime Error ×3 → Accepted

## 解題思路

新值一定可以放在某個葉子下面：從根開始，比目前節點大就往右、小就往左，走到空的位置就接上新節點（[Tree]({{< relref "/algorithm/Tree" >}}) 模板三）。題目保證新值不在樹裡。

## 我的嘗試

主要邏輯第一次就對，錯在**空樹**：

1. 沒處理空樹，`root` 是 `None` 時回傳 `None`，答案應該是只有新節點的樹。
2. 加了空樹判斷，但寫成 `node.left = TreeNode(val)`：`node` 還沒定義，Runtime Error。
3. 改成 `if not root:` 但下一行還是 `node.left`，一樣錯。
4. 改成 `root.left = ...`，可是 `root` 本身就是 `None`，AttributeError。
5. 改成 `return TreeNode(val)` 才過。

## 正確解法

```python
class Solution:
    def insertIntoBST(self, root: Optional[TreeNode], val: int) -> Optional[TreeNode]:
        if not root:
            return TreeNode(val)
        node = root
        while True:
            if val > node.val:
                if not node.right:
                    node.right = TreeNode(val)
                    break
                node = node.right
            else:
                if not node.left:
                    node.left = TreeNode(val)
                    break
                node = node.left
        return root
```

遞迴版更短：

```python
class Solution:
    def insertIntoBST(self, root: Optional[TreeNode], val: int) -> Optional[TreeNode]:
        if not root:
            return TreeNode(val)
        if val > root.val:
            root.right = self.insertIntoBST(root.right, val)
        else:
            root.left = self.insertIntoBST(root.left, val)
        return root
```

## 複雜度

時間 `O(h)`。迭代版空間 `O(1)`，遞迴版 `O(h)`。

## 要特別避免的錯誤

- 空樹時「接到某個節點下面」不成立，要直接回傳新節點。
- 碰到 `None` 時不能再取它的屬性。

## 面試口說整理

我從根往下走，新值比節點大就往右、小就往左，走到空的位置接上新節點，最後回傳原本的根。空樹時直接回傳新節點。時間 `O(h)`，迭代寫法空間 `O(1)`。
