---
title: "LeetCode 547: Number of Provinces"
summary: "LeetCode 解題紀錄"
description: "LeetCode Daily"
date: 2025-05-04
tags: ["LeetCode", "Union Find", "medium"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試： 2025-05-04
- 總花費時間：00:00.00

## 解題思路

經典的 Union-Find 題目。一開始我沒想到可以直接用 `isConnected` 的長度來建立 `parent` 跟 `rank` 陣列。我以為要先遍歷 `isConnected` 才知道有幾個節點，所以一開始用 dictionary 來記錄這些資訊。之後就變成經典的 Union-Find 做法：遍歷 `isConnected`，做 union 操作，最後就能找出所有聯通群組。


## 解法

### Union Find
```python
class Solution:
    def findCircleNum(self, isConnected: List[List[int]]) -> int:
        parents = {}
        rank = {}

        def find(x: int):
            root = parents.get(x, x)

            if root != x:
                parent = find(root)
                parents[x] = parent
                return parent  
            else:
                parents[x] = x
                return x

        def union(x, y):
            x_root = find(x)
            y_root = find(y)

            if x_root == y_root:
                return

            x_rank = rank.get(x_root, 1)
            y_rank = rank.get(y_root, 1)

            if x_rank > y_rank:
                rank[x_root] += y_rank
                parents[y_root] = x_root
            
            else:
                
                rank[y_root] = rank.get(y_root, 1) + x_rank
                parents[x_root] = y_root

        for i in range(len(isConnected)):
            for j in range(len(isConnected[0])):
                if isConnected[i][j]:
                    union(i, j)

        return len(set(find(i) for i in range(len(isConnected))))
```
### Union Find w/ known the size
```python
class Solution:
    def findCircleNum(self, isConnected: List[List[int]]) -> int:
        n = len(isConnected)
        parents = [i for i in range(n)]
        rank = [1 for _ in range(n)]

        def find(x: int):
            root = parents[x]

            if root != x:
                parent = find(root)
                parents[x] = parent
                return parent
            else:
                parents[x] = x
                return x

        def union(x, y):
            x_root = find(x)
            y_root = find(y)

            if x_root == y_root:
                return

            x_rank = rank[x_root]
            y_rank = rank[y_root]

            if x_rank > y_rank:
                rank[x_root] += y_rank
                parents[y_root] = x_root
            
            else:
                
                rank[y_root] = rank[y_root] + x_rank
                parents[x_root] = y_root

        for i in range(len(isConnected)):
            for j in range(len(isConnected[0])):
                if isConnected[i][j]:
                    union(i, j)

        return len(set(find(i) for i in range(n)))
```

### DFS
```python
class Solution:
    def findCircleNum(self, isConnected: List[List[int]]) -> int:
        n = len(isConnected)
        seen = set()
        ans = 0

        def dfs(x):
            for idx in range(n):
                if not isConnected[x][idx] or idx in seen:
                    continue
                seen.add(idx)
                dfs(idx)

        for idx in range(n):
            if idx not in seen:
                ans += 1
                dfs(idx)

        return ans
```


## 收穫

## 遇到的問題


一開始我用下面這段程式碼來算最後結果的集合大小：
```python
return len(set(parents.values()))
```
但這裡有個盲點，就是在我們遍歷完所有連線關係後，`parents` 中的每個值不一定都是最終的 root node。舉例來說：

若連線如下：
- a ↔ b  
- c ↔ d  
- d ↔ e  
- e ↔ b  

當處理第一個連線時，可能會記錄 a 的 root 是 b，但在處理到最後一個連線後，b 的 root 變成了 e。此時如果直接用 `parents.values()` 去算會算錯。所以最後一定要對每個節點呼叫 `find()` 來確保取得正確的 root。
