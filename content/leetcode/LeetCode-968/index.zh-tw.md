---
title: "LeetCode 968: Binary Tree Cameras"
summary: "LeetCode 968 解題筆記：後序貪心，每個節點三種狀態：有相機、被覆蓋、沒被覆蓋；有小孩沒被覆蓋才放相機，最後根沒被覆蓋要補一台"
description: "2026-10-30 的 LeetCode 968 解題紀錄"
date: 2026-10-30
tags: ["hard", "dynamic-programming", "tree", "depth-first-search", "binary-tree", "dp-on-trees"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-10-30
- 提交紀錄：Wrong Answer ×3 → Accepted → Wrong Answer ×2 → Accepted

## 解題思路

貪心的直覺：**葉子不放相機**，放在葉子的父節點比較划算，因為父節點的相機能同時蓋到葉子、父節點自己和祖父。所以由下往上（後序，[Tree]({{< relref "/algorithm/Tree" >}}) 模板七）決定，每個節點回傳三種狀態之一：

| 狀態 | 意思 |
|---|---|
| 有相機 | 自己放了相機 |
| 被覆蓋 | 沒放相機，但被小孩的相機蓋到 |
| 沒被覆蓋 | 交給父節點處理 |

規則，順序很重要：

1. 有任一個小孩**沒被覆蓋**：自己一定要放相機。
2. 否則有任一個小孩**有相機**：自己被覆蓋。
3. 否則：自己沒被覆蓋，交給父節點。

空節點當成「被覆蓋」，這樣葉子會回傳「沒被覆蓋」，相機就放在它的父節點。最後根如果沒被覆蓋，沒有父節點可以幫忙，要補一台。

## 我的嘗試

錯了五次：

1. 只用 `True` / `False` 兩種狀態（需要被覆蓋 / 不需要）。這樣「被小孩的相機蓋到」和「沒被覆蓋」混在一起，根沒被覆蓋時也沒補：`[0]` 回傳 0，答案是 1。第二次交了幾乎一樣的程式碼。
2. 加上「根是葉子就加一」的特例：`[0,0,0,0,null,0,0,0]` 回傳 3，答案是 2。問題是兩種狀態不夠，特例補不完。
3. 改成三種狀態就過了。
4. 之後再重寫一次：規則對了，但忘了最後補根的相機（`[0]` 回傳 0）；接著把補根的條件寫成檢查「被覆蓋」，應該是檢查「沒被覆蓋」。修正之後過了。

## 正確解法

```python
class Solution:
    def minCameraCover(self, root: Optional[TreeNode]) -> int:
        CAMERA, COVERED, NOT_COVERED = 0, 1, 2
        self.count = 0

        def dfs(node):
            if not node:
                return COVERED
            left = dfs(node.left)
            right = dfs(node.right)
            if left == NOT_COVERED or right == NOT_COVERED:
                self.count += 1
                return CAMERA
            if left == CAMERA or right == CAMERA:
                return COVERED
            return NOT_COVERED

        if dfs(root) == NOT_COVERED:
            self.count += 1
        return self.count
```

我當時是回傳三個布林值的 tuple，意思一樣，用一個狀態碼比較好讀。

## 複雜度

時間 `O(n)`，空間 `O(h)`。

## 要特別避免的錯誤

- 兩種狀態不夠，「被覆蓋但沒相機」和「沒被覆蓋」必須分開。
- 空節點要當成「被覆蓋」，不然葉子會被迫放相機。
- 規則 1 要先檢查：小孩沒被覆蓋時，就算另一個小孩有相機，自己也一定要放。
- 最後根沒被覆蓋要補一台。

## 面試口說整理

我用後序貪心，每個節點回傳三種狀態：有相機、被覆蓋、沒被覆蓋。空節點算被覆蓋，所以葉子不放相機，交給父節點。有小孩沒被覆蓋就放相機；否則有小孩有相機就算被覆蓋；都不是就交給父節點。最後根沒被覆蓋要補一台。時間 `O(n)`。
