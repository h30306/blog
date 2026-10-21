---
title: "LeetCode 116: Populating Next Right Pointers in Each Node"
summary: "LeetCode 116 解題筆記：完美二元樹，用上一層已經接好的 next 走過這一層：left.next = right，right.next = next.left；O(1) 額外空間"
description: "2022-11-18 的 LeetCode 116 解題紀錄"
date: 2022-11-18
tags: ["medium", "linked-list", "tree", "depth-first-search", "breadth-first-search"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-11-18
- 提交紀錄：Runtime Error → Wrong Answer ×2 → Accepted → Wrong Answer → Runtime Error → Accepted ×2

## 解題思路

完美二元樹每個節點都有兩個小孩（除了葉子），所以下一層的連線只有兩種（[Linked List]({{< relref "/algorithm/Linked-List" >}})「其他」、[Tree]({{< relref "/algorithm/Tree" >}}) 模板二）：

- 同一個父節點的兩個小孩：`node.left.next = node.right`。
- 相鄰父節點之間：`node.right.next = node.next.left`。

上一層的 `next` 已經接好了，就可以沿著它走過整層，不用佇列。從最左邊的節點一層一層往下。

## 我的嘗試

前幾版是遞迴的寫法，但**沒有回傳 `root`**，例如只有一個節點 `[8]` 時回傳 `None`；有一版沒處理空樹。我當時 AC 的是遞迴版本（`O(log n)` 的遞迴深度），這裡改成沿著 `next` 走的迭代版。

## 正確解法

```python
class Solution:
    def connect(self, root: 'Optional[Node]') -> 'Optional[Node]':
        leftmost = root
        while leftmost and leftmost.left:
            node = leftmost
            while node:                              # 沿著上一層的 next 走
                node.left.next = node.right
                if node.next:
                    node.right.next = node.next.left
                node = node.next
            leftmost = leftmost.left
        return root
```

## 複雜度

時間 `O(n)`，額外空間 `O(1)`。

## 要特別避免的錯誤

- 函式要回傳 `root`。
- 這個寫法依賴「完美二元樹」，不完美的樹（LC 117）要另外處理缺少的小孩。

## 面試口說整理

完美二元樹的下一層只有兩種連線：同一個父節點的左右小孩，以及相鄰父節點之間右小孩接左小孩。我沿著上一層已經接好的 `next` 走，一層一層往下，不用佇列。時間 `O(n)`、額外空間 `O(1)`。
