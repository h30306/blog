---
title: "LeetCode 572: Subtree of Another Tree"
summary: "LeetCode 572 解題筆記：對 root 的每一個節點都檢查一次「以它為根的子樹跟 subRoot 是否相同」；遞迴時要呼叫 isSubtree，不是只比左右小孩"
description: "2022-08-27 的 LeetCode 572 解題紀錄"
date: 2022-08-27
tags: ["easy", "tree", "depth-first-search", "string-matching", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-27
- 提交紀錄：Wrong Answer ×2 → Accepted ×2 → Runtime Error → Wrong Answer ×2 → Accepted ×2 → Runtime Error ×3 → Wrong Answer ×3 → Accepted ×2 → Wrong Answer → Accepted → Wrong Answer ×3 → Accepted
- 2026-10-25 重寫：Wrong Answer → Accepted ×5

## 解題思路

子樹必須從某個節點開始、一直到葉子都一樣（[Tree]({{< relref "/algorithm/Tree" >}}) 模板一）。所以對 `root` 的**每一個節點**都用 LC 100 的方法比一次：

- 以目前節點為根的樹跟 `subRoot` 相同，就是 `True`。
- 否則往左右子樹**繼續找**（呼叫 `isSubtree`，不是 `isSame`）。

## 我的嘗試

這題提交了 23 次：

- 第一版的 stack 只彈出、沒有推進小孩，也沒有真的比較樹，`[1]` 和 `[1]` 都回傳 `False`。
- 之後很多版的錯都一樣：檢查完根之後，往下只呼叫 `isSame(root.left, subRoot)`、`isSame(root.right, subRoot)`，**只比到第二層**，更深的地方沒找。例如 root 是 `[1, 1, 1, 2]`、subRoot 是 `[2]`：`2` 在第三層，答案 `True`，回傳 `False`。

## 正確解法

```python
class Solution:
    def isSubtree(self, root: Optional[TreeNode], subRoot: Optional[TreeNode]) -> bool:
        def same(a, b):
            if not a or not b:
                return a is b
            return a.val == b.val and same(a.left, b.left) and same(a.right, b.right)
        if not root:
            return False
        return same(root, subRoot) or self.isSubtree(root.left, subRoot) or self.isSubtree(root.right, subRoot)
```

## 2026-10 重寫

錯了一次，接著用兩種方法通過：

1. 把 `isSubtree` 同時當成「找」和「比」：根的值相同時，就改成拿 `root.left` 對 `subRoot.left`、`root.right` 對 `subRoot.right` 繼續呼叫 `isSubtree`。一旦值相同就不會再往下找別的起點：`root = [2,2]`、`subRoot = [2]` 時，根的值相同，接著比 `root.left` 和 `None` 失敗，回傳 `False`，但左邊那個 `2` 就是答案。
2. 拆成 `isSameTree` 和 `isSubtree` 兩個函式，就是上面的做法，過了（幾次都一樣）。
3. 最後試了序列化：前序加上 `#` 代表空節點，每個值前面加 `,`，再檢查 `sub_str in tree_str`。前面的 `,` 是為了避免 `2` 配到 `12` 這種部分數字。`in` 最壞是 `O(mn)`，要保證線性可以改用 KMP。

## 複雜度

時間 `O(m · n)`，空間 `O(h)`。用序列化加字串比對可以做到 `O(m + n)`。

## 要特別避免的錯誤

- 遞迴往下找時呼叫的是 `isSubtree`，不然只會檢查到第二層。
- `root` 是空的時候要回傳 `False`（`subRoot` 至少有一個節點）。

## 面試口說整理

我對主樹的每個節點都檢查一次以它為根的子樹是否跟目標完全相同，相同就回傳 `True`，否則繼續往左右子樹找。時間 `O(mn)`。
