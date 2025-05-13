---
title: "LeetCode 1319: Number of Operations to Make Network Connected"
summary: "LeetCode 解題紀錄"
description: "LeetCode Daily"
date: 2025-05-06
tags: ["LeetCode", "Union Find", "medium"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試： 2025-05-06
- 總花費時間：10:00.00

## 解題思路

若要讓所有電腦互相連接，最少需要 `n - 1` 條線，其中 `n` 是電腦數量。  
如果現有的線（`m` 條）少於 `n - 1`，則不可能讓所有電腦都連起來。  
因此，我們可以使用並查集（Union Find）來把所有已經連接的電腦合併成一組。  
合併完成後，我們就可以知道總共有多少個獨立的群組，也就知道還需要多少額外的線來連接這些群組。  

在 union 的過程中，如果發現兩台電腦已經在同一個群組，那就代表這條線是多餘的，我們可以把它記錄下來作為可移動的線。  
最後，我們只需要判斷多餘的線是否足夠連接剩下的獨立群組（也就是 `獨立群組數量 - 1`），如果夠就回傳需要的操作次數，否則回傳 `-1`。


## 解法

```python
class Solution:
    def makeConnected(self, n: int, connections: List[List[int]]) -> int:
        parent = [i for i in range(n)]
        ranking = [0 for _ in range(n)]
        extra = 0
        needed = 0

        def find(n):
            if parent[n] != n:
                parent[n] = find(parent[n])
            return parent[n]

        def union(x, y):
            nonlocal extra
            root_x = find(x)
            root_y = find(y)

            if root_x == root_y:
                extra += 1
                return

            if ranking[root_x] > ranking[root_y]:
                parent[root_y] = parent[root_x]
                ranking[root_x] += ranking[root_y]
            else:
                parent[root_x] = parent[root_y]
                ranking[root_y] += ranking[root_x]

        for x, y in connections:
            union(x, y)

        for i in range(n):
            if parent[i] == i:
                needed += 1
        
        return needed - 1 if (needed - 1) <= extra else -1
```

## 收穫

## 遇到的問題