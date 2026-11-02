---
title: "LeetCode 117: Populating Next Right Pointers in Each Node II"
summary: "LeetCode 117 解題筆記：BFS 一層一層接 next；不是完全二元樹時，只看隔壁節點的小孩會斷掉"
description: "2022-11-18 的 LeetCode 117 解題紀錄"
date: 2022-11-18
tags: ["medium", "linked-list", "tree", "depth-first-search", "breadth-first-search", "binary-tree"]
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
- 提交紀錄：Wrong Answer → Runtime Error → Wrong Answer → Accepted

## 解題思路

每個節點的 `next` 要指向同一層右邊的節點。用 BFS 一層一層處理（[Tree]({{< relref "/algorithm/Tree" >}}) 模板二）：處理一層的時候，佇列裡下一個節點就是同一層右邊的那個，所以除了每層最後一個，`node.next = q[0]`。

## 我的嘗試

2022 年寫了三次遞迴，都沒過：

- 想法是在 `root` 這層幫小孩接 `next`：右邊的小孩接到 `root.next` 的小孩。問題是 **`root.next` 可能沒有小孩**，這時應該繼續往 `root.next.next` 找，我的寫法直接放棄。例如 `[1,2,3,4,null,5,6,7,8,null,null,null,9]`：8 的 `next` 應該跳過沒有小孩的 5，接到 6 的小孩 9，結果是 `None`。
- 中間一次是把 `root` 打成 `node`，Runtime Error。

2026-10-24 改用 BFS，一次就過。

## 正確解法

```python
class Solution:
    def connect(self, root: 'Node') -> 'Node':
        if not root:
            return None
        q = deque([root])
        while q:
            n = len(q)
            for i in range(n):
                node = q.popleft()
                if i < n - 1:
                    node.next = q[0]
                if node.left:
                    q.append(node.left)
                if node.right:
                    q.append(node.right)
        return root
```

## 進階：O(1) 額外空間

上一層的 `next` 接好之後，上一層本身就是一條串列，可以沿著它走，用 dummy head 把下一層的小孩串起來（[Linked List]({{< relref "/algorithm/Linked-List" >}}) 模板一）：

```python
class Solution:
    def connect(self, root: 'Node') -> 'Node':
        head = root
        while head:
            dummy = tail = Node(0)
            cur = head
            while cur:
                for child in (cur.left, cur.right):
                    if child:
                        tail.next = child
                        tail = child
                cur = cur.next
            head = dummy.next
        return root
```

## 複雜度

BFS：時間 `O(n)`，空間 `O(w)`（最寬那層）。串列版：時間 `O(n)`，額外空間 `O(1)`。

## 要特別避免的錯誤

- 不是完全二元樹時，隔壁節點可能沒有小孩，要一直往右找到有小孩的節點。
- 每層最後一個節點不要接到下一層的第一個。

## 面試口說整理

我用 BFS 一層一層處理，同一層裡佇列的下一個就是右邊的節點，所以除了最後一個都接 `node.next = q[0]`，時間 `O(n)`。如果要 `O(1)` 空間，可以利用已經接好的上一層 `next` 當串列走，用 dummy head 把下一層的小孩依序串起來。
