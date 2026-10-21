---
title: "Union Find"
summary: "Union Find 介紹"
description: "演算法學習"
date: 2025-04-28
tags: ["union-find"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 介紹

Union-Find（又稱 Disjoint Set Union，並查集）是一種用來追蹤一組不重疊集合的資料結構。  
它支援兩種主要操作：
- **Find（查找）**：判斷某個元素屬於哪個集合。
- **Union（合併）**：將兩個集合合併為一個集合。

為了最佳化效能，我們常使用 **路徑壓縮（Path Compression）** 與 **按秩合併（Union by Rank）**（或 **按大小合併 Union by Size**）來將操作時間複雜度降到近乎常數時間。

### 何時使用 Union-Find vs. DFS/BFS

- 適合使用 **Union-Find** 的情境：
  - 你需要**動態合併**集合或追蹤**元素是否相連**。
  - 題目問你：**兩個節點是否在同一個集合中？**
  - 處理邊的時候是一筆一筆進來（例如：**Kruskal 最小生成樹**）。
  - 屬於**離線處理問題**（例如：批次查詢聯通性）。

- 適合使用 **DFS/BFS** 的情境：
  - 你需要**遍歷整個圖**，從一個點探索到其他點。
  - 你想要**找出所有聯通分量**，或者標記不同區塊。
  - 處理**有方向、有權重的圖**（Union-Find 無法處理邊的方向性或邊權重）。
  - 解決最短路徑等探索型問題。

---

> 簡而言之：
> - 若你重複在問「**這兩個東西連在一起嗎？**」、「**可以合併嗎？**」→ 用 **Union-Find**。
> - 若你在探索「**從這裡可以到哪裡？**」、「**有哪些節點我可以走到？**」→ 用 **DFS/BFS**。

## 核心概念

Union-Find 的核心操作流程：

1. 使用 `union(x, y)` 將包含 `x` 和 `y` 的兩個集合合併。
2. 使用 `find(x)` 找到 `x` 所屬集合的代表元素（根）。
3. 若要判斷兩個元素是否屬於同一個集合，只需比較它們的根是否相同。

加上「路徑壓縮」與「按秩合併 / 按大小合併」後，  
`find()` 與 `union()` 的時間複雜度為：

```
O(α(n))
```

其中 α 是 Ackermann 函數的反函數，成長極慢，  
在實務中可以視為常數時間（n 在實際應用中幾乎不可能大到讓 α(n) > 5）。

> ✅ 沒有優化時，`find` 可能退化為 O(n)，  
> 但加上優化後，操作時間幾乎為 O(1)。

---

### 範例

給定 10 個人：`a, b, c, d, e, f, g, h, i, j`  
有以下關係：

```
a - b  
b - d  
c - e  
c - f  
g - h  
h - i
```

經過 Union-Find 操作後，會得到以下四個不相交集合：

```
{a, b, d}  
{c, e, f}  
{g, h, i}  
{j}
```

---

## 基本實作（無優化）

### 第一步：初始化 parent 陣列

將每個元素的父節點設為自己。  
這個 parent 陣列會幫助我們追蹤每個元素所屬的集合。

```python
class UnionFind:
    def __init__(self, size: int):
        self.parent: list[int] = list(range(size))
```

### 第二步：實作 `find`

`find(i)` 回傳元素 `i` 的根節點（代表元素）。  
當 parent[i] 不是自己時，我們遞迴查找其父節點。

```python
def find(self, i: int) -> int:
    if self.parent[i] == i:
        return i
    return self.find(self.parent[i])
```

### 第三步：實作 `union`

`union(i, j)` 將 `i` 和 `j` 所屬的集合合併，若兩者已經屬於同一集合則不處理。

```python
def union(self, i: int, j: int):
    root_i = self.find(i)
    root_j = self.find(j)

    if root_i == root_j:
        return  # 已在同一集合

    self.parent[root_i] = root_j
```

---

### 完整無優化版本

```python
class UnionFind:
    def __init__(self, size: int):
        self.parent = list(range(size))

    def find(self, i: int) -> int:
        if self.parent[i] == i:
            return i
        return self.find(self.parent[i])

    def union(self, i: int, j: int):
        root_i = self.find(i)
        root_j = self.find(j)

        if root_i == root_j:
            return

        self.parent[root_i] = root_j
```

最壞情況下會退化為鏈狀結構（如 `D → C → B → A`），  
查找操作時間會變成 **O(n)**。

---

## 路徑壓縮（Path Compression）

路徑壓縮優化 `find()` 操作，會將所有經過的節點直接指向根節點，  
使整個集合結構更扁平，未來查找會更快。

```python
def find(self, i: int) -> int:
    if self.parent[i] != i:
        self.parent[i] = self.find(self.parent[i])
    return self.parent[i]
```

> 現在 `find()` 操作幾乎為 O(1) 時間。

---

## 按秩合併（Union by Rank）

用一個 `rank` 陣列記錄每個樹的「深度」，  
合併時讓秩較小的樹掛在秩較大的樹下，  
避免讓樹變得更高，影響查找效率。

```python
class UnionFind:
    def __init__(self, n):
        self.parent = list(range(n))
        self.rank = [0] * n

    def find(self, x):
        if self.parent[x] != x:
            self.parent[x] = self.find(self.parent[x])
        return self.parent[x]

    def union(self, x, y):
        root_x = self.find(x)
        root_y = self.find(y)

        if root_x == root_y:
            return

        if self.rank[root_x] < self.rank[root_y]:
            self.parent[root_x] = root_y
        elif self.rank[root_x] > self.rank[root_y]:
            self.parent[root_y] = root_x
        else:
            self.parent[root_y] = root_x
            self.rank[root_x] += 1
```

> 📌 注意：`rank` 並不一定是壓縮後的真實高度，但足以當作平衡依據。

---

## 按大小合併（Union by Size）

使用子集合的大小來決定哪棵樹掛在哪棵樹底下。  
比起 rank，size 更能真實反映子樹的重量，有時效果更好。

```python
class UnionFind:
    def __init__(self, n):
        self.parent = list(range(n))
        self.size = [1] * n

    def find(self, x):
        if self.parent[x] != x:
            self.parent[x] = self.find(self.parent[x])
        return self.parent[x]

    def union(self, x, y):
        root_x = self.find(x)
        root_y = self.find(y)

        if root_x == root_y:
            return

        if self.size[root_x] < self.size[root_y]:
            self.parent[root_x] = root_y
            self.size[root_y] += self.size[root_x]
        else:
            self.parent[root_y] = root_x
            self.size[root_x] += self.size[root_y]
```

---
## 模板

```python
class UnionFind:
    def __init__(self, n):
        self.parent = list(range(n))
        self.rank = [1] * n  # 可作為 rank 或 size 使用

    def find(self, x):
        if self.parent[x] != x:
            self.parent[x] = self.find(self.parent[x])  # 路徑壓縮
        return self.parent[x]

    def union(self, x, y):
        root_x = self.find(x)
        root_y = self.find(y)

        if root_x == root_y:
            return

        # 按大小合併
        if self.rank[root_x] < self.rank[root_y]:
            self.parent[root_x] = root_y
            self.rank[root_y] += self.rank[root_x]
        else:
            self.parent[root_y] = root_x
            self.rank[root_x] += self.rank[root_y]
```

### 主要參數說明：

- `parent[i]`：紀錄節點 `i` 的父節點，初始為自己。
- `find(x)`：查找 `x` 所屬集合的代表（根節點），同時進行路徑壓縮。
- `union(x, y)`：將兩個集合合併，透過秩或大小判斷哪個樹掛到哪個樹上。
- `rank[i]`：可代表秩或集合大小，用來優化合併策略。

---

## 變形

### 數連通塊個數

`union` 回傳「有沒有真的合併」，每次成功合併 `groups -= 1`：

```python
def union(x, y) -> bool:
    rx, ry = find(x), find(y)
    if rx == ry:
        return False
    parent[rx] = ry                      # 接的是根，不是 x 本身
    return True

groups = n
for u, v in edges:
    if union(u, v):
        groups -= 1
```

- **動態加陸地**（LC 305）：每加一格 `groups += 1`，跟四周已經是陸地的格子合併，成功一次就減 1。同一格重複加要跳過，但答案還是要記一次。

### 邊依權重排序（Kruskal 的想法）

```python
edges.sort(key=lambda e: e[2])
groups = n
for u, v, w in edges:
    if union(u, v):
        groups -= 1
        if groups == k:                  # 連到只剩 k 塊，最大的邊就是 w
            return w
```

- **最多 `k` 塊，最大邊權最小**（LC 3613）：由小到大加邊，剛好剩 `k` 塊時的邊權就是答案；`n <= k` 時一條邊都不用，回傳 0。
- **刪掉時間 `<= t` 的邊後至少 `k` 塊**（LC 3608）：倒過來想，從時間大的邊開始加回去，第一次讓塊數 `< k` 的那條邊的時間就是答案。

### 倒著做：刪除變成加入

Union-Find 只能合併、不能拆開。題目是一個一個刪除時，倒著處理就變成一個一個加入：

```python
res, best = [], 0
for i in reversed(removeQueries):
    res.append(best)                     # 加回 i 之前的答案
    alive[i] = True
    total[i] = nums[i]
    for j in (i - 1, i + 1):
        if 0 <= j < n and alive[j]:
            rj, ri = find(j), find(i)
            parent[rj] = ri
            total[ri] += total[rj]       # 根上記整個集合的總和
    best = max(best, total[find(i)])     # 只會變大，不用每次重算 max
return res[::-1]
```

- **刪除後的最大區段和**（LC 2382）：根上記區段總和；倒著加回去時最大值只會變大。

### 用「第一個出現的代表」合併

點跟點「共用某個 key」就相連時，不要兩兩比較（`O(n²)`），用字典記每個 key 第一次出現的點，之後的點跟它合併：

```python
first = {}
for i, key in enumerate(keys):
    if key in first:
        union(i, first[key])
    else:
        first[key] = i
```

- **同一個 x 或同一個 y 就相連**（LC 3873）：x 和 y 各一個字典。加一個新點最多能接上兩塊（一塊共用 x、一塊共用 y），答案是最大的兩塊加 1。

## 常見錯誤

這些都是我練習時實際寫錯過的：

- **`union` 接的是節點不是根**：寫成 `parent[x] = root_y`，`x` 被拉出原本的集合，之後會多算合併（LC 3608）。
- **一開始就已經符合條件**：`n == k` 時迴圈裡永遠不會剛好等於 `k`，函式沒有回傳值（LC 3613）。
- **用迴圈的 index 合併**：要合併的是集合裡的元素，我寫成 `union(i - 1, i)`（LC 3873）。
- **重複的位置**：同一格加兩次會多算一塊；跳過時還是要把答案加進結果（LC 305）。
- **`find` 沒有走到根**：路徑減半要用 `while`，寫成 `if` 只走一步，回傳的不是根（LC 305）。
- **每一步都重算所有集合的最大值**：`max(group_sum.values())` 讓整體變成 `O(n²)`，TLE（LC 2382）。

## 範例

## LeetCode

- `LC 952` Largest Component Size by Common Factor
- `LC 2709` Greatest Common Divisor Traversal
- `LC 1998` GCD Sort of an Array
- `LC 1627` Graph Connectivity With Threshold
- `LC 305` Number of Islands II
- `LC 3608` Minimum Time for K Connected Components
- `LC 3613` Minimize Maximum Component Cost
- `LC 2382` Maximum Segment Sum After Removals
- `LC 3873` Maximum Points Activated with One Addition
