---
title: "LeetCode 947: Most Stones Removed with Same Row or Column"
summary: "LeetCode 解題紀錄"
description: "LeetCode Daily"
date: 2025-05-10
tags: ["LeetCode", "Union Find", "medium"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試： 2025-05-10
- 總花費時間：20:00.00

## 解題思路

移除石頭的條件是：在同一列或同一欄有其他石頭存在。  
因此，我們可以使用並查集（Union Find）將具有相同 `x` 或 `y` 座標的石頭歸為同一組。  
分組完成後，每一組都可以移除 `(組大小 - 1)` 顆石頭，總和即為結果。

一開始我嘗試用最大座標值來初始化 parent 陣列，但遇到 MLE（記憶體超出限制），因為若有一個離群的座標 `k`，就會從 1 ~ `k` 分配大量不必要的記憶體。  
為了解決這個問題，我改用字典作為 parent 結構，並將每個座標轉成字串（例如 `"x,y"`）作為 key 來處理。

## 解法

### Basic Union Find 

```python
class Solution:
    def removeStones(self, stones: List[List[int]]) -> int:

        parents = {}

        def find(x):
            if parents.get(x, x) != x:
                parents[x] = find(parents[x])
            else:
                parents[x] = x
            return parents[x]

        def union(x, y):
            root_x = find(x)
            root_y = find(y)
            if root_x == root_y:
                return 
            parents[root_x] = parents[root_y]

        for x in stones:
            for y in stones:
                if x == y:
                    continue
                if x[0] == y[0] or x[1] == y[1]:
                    coordinate_x = ",".join(map(str, x))
                    coordinate_y = ",".join(map(str, y))
                    union(coordinate_x, coordinate_y)

        seen = set()
        res = 0
        for stone in stones:
            coordinate = ",".join(map(str, stone))
            group = find(coordinate)
            if group in seen:
                res += 1
            else:
                seen.add(group)

        return res
```

# Optimize Union Find

這題的精髓在於：將二維座標扁平化為一維的 Union Find 結構。  
我一開始嘗試用 `"x,y"` 字串當作 key，但這導致需要雙層迴圈（時間複雜度 O(n²)），且在座標稀疏或很大的情況下會造成記憶體浪費。  

後來我學到一個更聰明的做法：**將 row 和 column index 統一在同一個 1D 鍵值空間**。  
具體做法是，row 用原本的 x，column 則取 `~y`（位元反轉）來避免與 x 衝突。

這個方法的思路是：把每顆石頭視為連接一個 row index 和一個 column index 的節點。  
如果兩顆石頭在同一 row 或 column，則它們對應的 index 就會被 Union 起來。  
最後統計有幾個獨立的群組（也就是「島嶼」數量），因為每個群組至少要保留一顆石頭不被移除。  
所以最終答案為：  
`總石頭數 - 群組數量（島嶼數）`

以下是這種做法的簡潔 Python 實作：

```python
class Solution:
    def removeStones(self, stones: List[List[int]]) -> int:
        parent = {}

        def find(x):
            if x != parent.setdefault(x, x):
                parent[x] = find(parent[x])
            return parent[x]

        def union(x, y):
            parent[find(x)] = find(y)

        for x, y in stones:
            union(x, ~y)

        return len(stones) - len({find(x) for x in parent})
```

## 收穫

## 遇到的問題

一開始我用 `f"{x}{y}"` 來生成座標字串，但這樣會產生碰撞問題。
例如 `[12, 3]` 和 `[1, 23]` 都會變成 `"123"`。
為了解決這個問題，我改用逗號分隔的方式來產生唯一的 key（例如 `"12,3"`）。