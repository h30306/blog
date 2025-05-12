---
title: "LeetCode 1202: Smallest String With Swaps"
summary: "LeetCode 解題紀錄"
description: "LeetCode Daily"
date: 2025-05-06
tags: ["LeetCode", "blog", "Union Find", "medium"]

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

這題要求在一系列允許的交換操作後，回傳字典序最小的字串。  
交換的條件是：只有當兩個字元的索引在同一對 pair 中時，才可以互換。  
因此，我們可以用並查集（Union Find）來將索引合併為同一群組。  
接著，對每個群組中的字元排序，並依照字典序小到大填入結果。

## 解法

```python
class Solution:
    def smallestStringWithSwaps(self, s: str, pairs: List[List[int]]) -> str:
        uf = UF(s)

        for x, y in pairs:
            uf.union(x, y)

        group_map = defaultdict(list)
        for idx in range(len(s)):
            group_map[uf.find(idx)].append(s[idx])
        
        for i in group_map:
            group_map[i] = sorted(group_map[i], reverse=True)

        s = []
        for parent in uf.parent:
            group = uf.find(parent)
            s.append(group_map[group].pop())

        return "".join(s)


class UF:
    def __init__(self, s):
        n = len(s)
        self.parent = [i for i in range(n)]
        self.ranking = [1] * n

    def find(self, num):

        if self.parent[num] != num:
            self.parent[num] = self.find(self.parent[num])

        return self.parent[num]

    def union(self, x, y):
        root_x = self.find(x)
        root_y = self.find(y)

        if root_x == root_y:
            return

        if self.ranking[root_x] > self.ranking[root_y]:
            self.parent[root_y] = self.parent[root_x]
            self.ranking[root_x] += self.ranking[root_y]

        else:
            self.parent[root_x] = self.parent[root_y]
            self.ranking[root_y] += self.ranking[root_x]
```

## 收穫

## 遇到的問題