---
title: "LeetCode 1028: Recover a Tree From Preorder Traversal"
summary: "LeetCode 1028 解題筆記：用 stack 維護從根到目前節點的路徑，stack 長度就是深度"
description: "2026-09-12 的 LeetCode 1028 解題紀錄"
date: 2026-09-12
tags: ["hard", "tree", "binary-tree", "dfs", "stack", "string"]
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
- 提交紀錄：Accepted（遞迴）→ Accepted（stack）→ Accepted（遞迴，重寫一次）

## 解題思路

字串的格式是「`D` 個破折號 + 數字」，`D` 是節點深度，順序是 preorder。

每讀到一個 `(深度, 值)`，要決定它接在誰下面。答案是：**它的 parent 是「目前路徑上深度為 `D - 1` 的那個節點」。**

## 解法一：stack 維護目前路徑

讓 stack 存「從根到目前節點的路徑」，那麼 stack 的長度就是下一個節點應該在的深度：

1. 讀出深度 `depth` 和值。
2. 把 stack 彈到長度剛好是 `depth`，這時 stack 頂端就是 parent。
3. parent 沒有左子節點就接左邊，不然接右邊（題目保證只有一個子節點時一定是左子節點）。
4. 把新節點推進 stack。

```python
class Solution:
    def recoverFromPreorder(self, traversal: str) -> Optional[TreeNode]:
        stack = []
        i, n = 0, len(traversal)
        while i < n:
            depth = 0
            while i < n and traversal[i] == "-":
                depth += 1
                i += 1

            val = 0
            while i < n and traversal[i].isdigit():
                val = val * 10 + int(traversal[i])
                i += 1

            node = TreeNode(val)
            while len(stack) > depth:
                stack.pop()
            if stack:
                if stack[-1].left:
                    stack[-1].right = node
                else:
                    stack[-1].left = node
            stack.append(node)

        return stack[0]
```

## 解法二：遞迴，帶著「預期深度」

遞迴的寫法是：`dfs(d)` 先偷看接下來的破折號數量，如果不是 `d`，代表下一個節點不屬於這裡，回傳 `None`，**而且不消耗字元**；是的話才讀值、建節點，再遞迴建左右子樹。

```python
class Solution:
    def recoverFromPreorder(self, traversal: str) -> Optional[TreeNode]:
        self.i = 0
        n = len(traversal)

        def dfs(expected_depth: int) -> Optional[TreeNode]:
            j, dashes = self.i, 0
            while j < n and traversal[j] == "-":
                j += 1
                dashes += 1
            if dashes != expected_depth:
                return None                      # 只偷看，不移動 self.i

            self.i = j
            val = 0
            while self.i < n and traversal[self.i].isdigit():
                val = val * 10 + int(traversal[self.i])
                self.i += 1

            node = TreeNode(val)
            node.left = dfs(expected_depth + 1)
            node.right = dfs(expected_depth + 1)
            return node

        return dfs(0)
```

關鍵是**先用暫時的 `j` 偷看**，確認深度符合才更新 `self.i`。

## 複雜度

兩種解法都是時間 `O(len(traversal))`，空間 `O(h)`。

## 要特別避免的錯誤

- 只讀一位數：值最大到 `10^9`，要一直讀到不是數字為止。
- 遞迴版深度不符時就已經移動了指標，字元會被吃掉。
- stack 版彈過頭：要彈到長度**等於**深度，不是小於。

## 面試口說整理

字串是 preorder，破折號數量就是深度。我用 stack 存從根到目前節點的路徑，所以 stack 長度就是下一個節點的深度：每讀一個節點，先把 stack 彈到長度等於它的深度，頂端就是 parent，沒有左子節點就接左邊，否則接右邊，再把新節點推進去。每個字元只讀一次，時間是字串長度。
