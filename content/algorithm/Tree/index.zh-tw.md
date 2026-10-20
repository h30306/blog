---
title: "Tree 樹的遍歷與常見技巧"
summary: "DFS 回傳值、BFS 層序、BST 上下界、往上找 LCA、樹的直徑與剪葉子"
description: "演算法學習"
date: 2026-10-20
tags: ["tree", "binary-tree", "dfs", "bfs", "bst"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 介紹

樹是「沒有環的連通圖」，所以樹的題目大致分成兩類：

- **Binary tree 題**：給 `TreeNode`，每個節點最多兩個子節點，用遞迴或層序遍歷處理。
- **一般樹題**：給 `edges`，本質上是無向圖，用 BFS、DFS 或剪葉子處理。

拿到題目時，先問自己三個問題：

1. **每個節點需要從子樹拿到什麼資訊？** → DFS 回傳值（後序）。
2. **答案跟「第幾層」有關嗎？** → BFS 層序遍歷。
3. **題目給的是 `edges` 嗎？** → 當成無向圖處理，記得建雙向邊、用 `seen` 或 `parent` 避免走回頭路。

## 模板一：DFS 回傳值（後序遍歷）

最常用的樹模板。先遞迴拿到左右子樹的結果，再組合出自己的結果：

```python
def dfs(node):
    if not node:
        return 0                      # 空節點的基本值
    left = dfs(node.left)
    right = dfs(node.right)
    return node.val + left + right    # 組合出這棵子樹的答案
```

### 主要參數說明：

- **回傳值要設計好**：可以回傳 tuple，例如 `(深度, 答案節點)`。LC 865 就是回傳 `(depth, node)`，一次 DFS 解決。
- **全域答案**：如果答案不是根節點的回傳值，例如「所有子樹和中的最佳切法」，就在 DFS 過程中更新外層變數或收集到 list。
- **不要修改輸入**：把子樹和寫回 `node.val` 雖然能 AC，但會破壞輸入，面試時最好另外存。

## 模板二：BFS 層序遍歷

答案跟「層」有關時使用，例如每層總和、最後一層、完整性檢查：

```python
from collections import deque

def bfs(root):
    q = deque([root])
    level = 0
    while q:
        level += 1
        for _ in range(len(q)):       # 這一層的節點數，先記下來
            node = q.popleft()
            # 處理 node
            if node.left:
                q.append(node.left)
            if node.right:
                q.append(node.right)
```

### 主要參數說明：

- `len(q)` 要在進入內層迴圈**之前**算好，這樣才能剛好處理一層。
- **不要把 `None` 放進 queue**，除非題目刻意需要，例如 LC 958 判斷完整二元樹就是靠「第一個 `None` 後面不能再有節點」。
- 比起「每層一次遞迴」，迭代的 BFS 不會有遞迴深度問題。

## 模板三：BST 的上下界

BST 的性質是「左子樹全部 < 根 < 右子樹全部」。很多 BST 題可以帶著上下界遞迴，做到 `O(n)`：

```python
def build(bound):                     # LC 1008：從 preorder 建 BST
    nonlocal i
    if i == len(preorder) or preorder[i] > bound:
        return None
    root = TreeNode(preorder[i])
    i += 1
    root.left = build(root.val)       # 左子樹的值都要 < root.val
    root.right = build(bound)         # 右子樹沿用原本的上界
    return root
```

把陣列切成「比根小」和「比根大」兩段再遞迴也能 AC，但遇到已排序的輸入會退化成 `O(n^2)`。

## 模板四：往上找共同祖先（LCA）

需要「兩個節點之間的路徑」時，先讓兩個節點往上走到同一個祖先：

```python
# 有 parent 指標或 parent map
while a != b:
    if depth[a] > depth[b]:
        a = parent[a]
    else:
        b = parent[b]
```

- **完全二元樹的編號**（根是 1，子節點是 `2v`、`2v+1`）：parent 就是 `v // 2`，而且值比較大的那個一定比較深或同深度，直接 `x //= 2` 往上走（LC 2509）。
- **多個節點的 LCA**：把整組節點同時往上移，直到集合只剩一個（LC 865 的 BFS 解法）。

## 模板五：樹當成圖，BFS 算距離與直徑

給 `edges` 的題目，先建無向鄰接表：

```python
from collections import deque

def bfs(start):
    dist = [-1] * n
    dist[start] = 0
    q = deque([start])
    while q:
        u = q.popleft()
        for v in adj[u]:
            if dist[v] == -1:
                dist[v] = dist[u] + 1
                q.append(v)
    return u, dist                    # 最後彈出的 u 就是離 start 最遠的點
```

**樹的直徑**：從任意點 BFS 找到最遠點 `a`，再從 `a` BFS 找到最遠點 `b`，`dist(a, b)` 就是直徑。

延伸性質：**對任何節點來說，直徑的兩個端點之中，至少有一個是離它最遠的點**（LC 3313）。兩棵樹用一條邊連起來時，最小直徑是 `max(d1, d2, ceil(d1/2) + ceil(d2/2) + 1)`（LC 3203）。

## 模板六：剪葉子（樹上的拓撲排序）

從葉子（degree 為 1）開始一層一層往內剪，常用在「找中心」或「刪掉不需要的分支」：

```python
q = deque(i for i in range(n) if deg[i] == 1 and can_remove(i))
while q:
    u = q.popleft()
    removed[u] = True
    for v in adj[u]:
        if not removed[v]:
            deg[v] -= 1
            if deg[v] == 1 and can_remove(v):
                q.append(v)
```

LC 2603 先剪掉「沒有硬幣的葉子」，再固定剪兩層，剩下的邊就是一定要走的路徑。LC 310 Minimum Height Trees 也是同一個模板。

## 模板七：樹上 DP（後序回傳子樹摘要）

每個節點需要子樹的某些資訊時，後序遍歷回傳一個「摘要」，父節點用孩子的摘要組合出自己的：

- **最大的 BST 子樹和**（LC 1373）：回傳 `(總和, 最小值, 最大值, 是不是 BST)`。是 BST 的條件是左子樹的**最大值** `<` 自己 `<` 右子樹的**最小值**；不是 BST 時讓父節點一定判斷失敗。
- **子樹裡三個數的最大乘積**（LC 2973）：答案只跟最大的三個和最小的兩個有關，每個子樹只回傳這 5 個數，合併時排序再截斷。

## 複雜度

- DFS、BFS、剪葉子都是 `O(n)`，每個節點和每條邊只處理常數次。
- 遞迴深度是樹高。Python 預設遞迴上限約 1000，退化成鏈的樹（`n = 10^4` 以上）要小心，必要時改成迭代或用 `sys.setrecursionlimit`。

## 常見錯誤

這些都是我練習時實際寫錯過的：

- **把 `None` 子節點放進下一層**：最後會多出一層總和為 0 的假層（LC 1161）。
- **把整體性質當成局部性質**：「左右子樹都是完整二元樹」不代表整棵樹完整（LC 958）。
- **給 `edges` 卻只建單向邊**：樹題的邊幾乎都是無向的（LC 1377）。
- **`seen` 加錯東西**：寫成 `seen.add(second)` 而不是 `seen.add(vertex)`。
- **複製貼上兩棵樹的程式碼**：第二棵樹的 `seen` 陣列還用第一棵的大小 `n`，`m > n` 時就越界（LC 3203）。
- **函式改名後遞迴呼叫沒跟著改**：`dfs` 裡面還在呼叫 `bfs`。
- **時間到了但節點還能走**：機率題要分清楚「停在目標」和「經過目標」（LC 1377）。

## 相關 LeetCode

- `LC 958` Check Completeness of a Binary Tree
- `LC 1008` Construct Binary Search Tree from Preorder Traversal
- `LC 1161` Maximum Level Sum of a Binary Tree
- `LC 865` Smallest Subtree with all the Deepest Nodes
- `LC 1339` Maximum Product of Splitted Binary Tree
- `LC 2196` Create Binary Tree From Descriptions
- `LC 2236` Root Equals Sum of Children
- `LC 987` Vertical Order Traversal of a Binary Tree
- `LC 1028` Recover a Tree From Preorder Traversal
- `LC 2509` Cycle Length Queries in a Tree
- `LC 3820` Pythagorean Distance Nodes in a Tree
- `LC 1377` Frog Position After T Seconds
- `LC 2421` Number of Good Paths
- `LC 2603` Collect Coins in a Tree
- `LC 3313` Find the Last Marked Nodes in Tree
- `LC 3203` Find Minimum Diameter After Merging Two Trees
- `LC 1373` Maximum Sum BST in Binary Tree
- `LC 2973` Find Number of Coins to Place in Tree Nodes
