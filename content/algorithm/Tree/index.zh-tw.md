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

## 模板八：迭代遍歷（前序、中序、後序）

遞迴的三種遍歷都可以用 stack 自己模擬：

```python
# 中序：一路往左推，彈出時記錄，再轉向右子樹
stack, cur = [], root
while cur or stack:
    while cur:
        stack.append(cur)
        cur = cur.left
    cur = stack.pop()
    visit(cur)
    cur = cur.right

# 後序：第一次彈出時標記後放回去，第二次彈出才記錄
stack = [(root, False)]
while stack:
    node, done = stack.pop()
    if not node:
        continue
    if done:
        visit(node)
    else:
        stack += [(node, True), (node.right, False), (node.left, False)]   # 左邊最後推，最先處理
```

- **前序**（LC 144）：彈出就記錄，先推右再推左。
- **中序**（LC 94）：上面第一段；BST 的中序是由小到大，第 `k` 小（LC 230）、最小差（LC 530、783）、眾數（LC 501）、攤平成鏈（LC 897）都是邊走邊處理。
- **後序**（LC 145）：上面第二段。N 叉樹的後序（LC 590）可以做「根、小孩由右到左」再整個反轉。

## 模板九：由遍歷結果建樹

前序（或後序）決定**誰是根**，中序決定**左右子樹各有哪些節點**：

```python
pos = {v: i for i, v in enumerate(inorder)}
it = iter(preorder)                      # 後序的話用 reversed(postorder)
def build(lo, hi):                       # 中序的範圍
    if lo > hi:
        return None
    root = TreeNode(next(it))
    root.left = build(lo, pos[root.val] - 1)     # 後序版本要先建右子樹
    root.right = build(pos[root.val] + 1, hi)
    return root
```

- **前序 + 中序**（LC 105）、**中序 + 後序**（LC 106）。
- **排序陣列 / 排序串列轉平衡 BST**（LC 108、109）：中間的元素當根。

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

- **只看根或只比父子**：直徑只算經過根的那條（LC 543）、平衡只檢查根（LC 110）、BST 只比較父節點和小孩（LC 98）、子樹只比到第二層（LC 572）。
- **空樹沒處理**：大部分 Runtime Error 都是 `root` 是 `None` 時直接取 `root.left`。
- **只有一邊有小孩時把空的那邊當成葉子**：最小深度變成 1（LC 111）。
- **拿節點本身跟整數或布林值比**：`root == targetSum`（LC 112）、`node.val == self.isUnivalTree(...)`（LC 965）。
- **分兩行交換左右子樹**：第二行用到的已經是新的左子樹（LC 226）。
- **值可以是負的卻提早剪枝**（LC 113）。
- **用 BFS 收集「由左到右」的葉子**：BFS 是一層一層，不是由左到右（LC 872）。

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
- `LC 94` Binary Tree Inorder Traversal
- `LC 144` Binary Tree Preorder Traversal
- `LC 145` Binary Tree Postorder Traversal
- `LC 102` Binary Tree Level Order Traversal
- `LC 107` Binary Tree Level Order Traversal II
- `LC 103` Binary Tree Zigzag Level Order Traversal
- `LC 199` Binary Tree Right Side View
- `LC 637` Average of Levels in Binary Tree
- `LC 104` Maximum Depth of Binary Tree
- `LC 111` Minimum Depth of Binary Tree
- `LC 559` Maximum Depth of N-ary Tree
- `LC 589` N-ary Tree Preorder Traversal
- `LC 590` N-ary Tree Postorder Traversal
- `LC 226` Invert Binary Tree
- `LC 100` Same Tree
- `LC 101` Symmetric Tree
- `LC 572` Subtree of Another Tree
- `LC 110` Balanced Binary Tree
- `LC 112` Path Sum
- `LC 113` Path Sum II
- `LC 129` Sum Root to Leaf Numbers
- `LC 257` Binary Tree Paths
- `LC 404` Sum of Left Leaves
- `LC 1022` Sum of Root To Leaf Binary Numbers
- `LC 988` Smallest String Starting From Leaf
- `LC 543` Diameter of Binary Tree
- `LC 563` Binary Tree Tilt
- `LC 965` Univalued Binary Tree
- `LC 671` Second Minimum Node In a Binary Tree
- `LC 872` Leaf-Similar Trees
- `LC 993` Cousins in Binary Tree
- `LC 1448` Count Good Nodes in Binary Tree
- `LC 337` House Robber III
- `LC 2331` Evaluate Boolean Binary Tree
- `LC 222` Count Complete Tree Nodes
- `LC 1379` Find a Corresponding Node of a Binary Tree in a Clone of That Tree
- `LC 98` Validate Binary Search Tree
- `LC 108` Convert Sorted Array to Binary Search Tree
- `LC 230` Kth Smallest Element in a BST
- `LC 235` Lowest Common Ancestor of a Binary Search Tree
- `LC 236` Lowest Common Ancestor of a Binary Tree
- `LC 530` Minimum Absolute Difference in BST
- `LC 783` Minimum Distance Between BST Nodes
- `LC 938` Range Sum of BST
- `LC 501` Find Mode in Binary Search Tree
- `LC 653` Two Sum IV - Input is a BST
- `LC 700` Search in a Binary Search Tree
- `LC 703` Kth Largest Element in a Stream
- `LC 897` Increasing Order Search Tree
- `LC 105` Construct Binary Tree from Preorder and Inorder Traversal
- `LC 106` Construct Binary Tree from Inorder and Postorder Traversal
- `LC 606` Construct String from Binary Tree
- `LC 116` Populating Next Right Pointers in Each Node
- `LC 109` Convert Sorted List to Binary Search Tree
