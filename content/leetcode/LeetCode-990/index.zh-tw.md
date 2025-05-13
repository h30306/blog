---
title: "LeetCode 990: Satisfiability of Equality Equations"
summary: "LeetCode 解題紀錄"
description: "LeetCode Daily"
date: 2025-05-12
tags: ["LeetCode", "daily", "medium"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試： 2025-05-12
- 總花費時間：10:00.00

## 解題思路

這是一道並查集（Union Find）問題。  
首先我們遍歷所有等式，如果遇到 `==`，就表示兩個字元應屬於同一個集合，因此對它們進行 union 操作。  

完成所有 union 後，再次遍歷等式，這次檢查 `!=` 的情況。  
如果兩個應該不相等的字元卻在同一集合中，則說明條件被違反，回傳 `False`。  

為了便於操作，我們使用 `ord()` 將字元轉為數字，並減去 `ord('a')`，使其從 0 開始編號。

## 解法

```python
class Solution:
    def equationsPossible(self, equations: List[str]) -> bool:
        parent = [i for i in range(26)]

        def find(ord_x):
            if parent[ord_x] != ord_x:
                parent[ord_x] = find(parent[ord_x])

            return parent[ord_x]

        def union(ord_x, ord_y):

            root_x = find(ord_x)
            root_y = find(ord_y)

            if root_x == root_y:
                return
            
            parent[root_x] = parent[root_y]

        for equation in equations:
            if equation[1] == "!":
                continue
            ord_x = ord(equation[0])-ord("a")
            ord_y = ord(equation[3])-ord("a")
            
            union(ord_x, ord_y)

        for equation in equations:
            if equation[1] == "!" and find(ord(equation[0])-ord("a")) == find(ord(equation[3])-ord("a")):
                return False
        return True
```

## 收穫

## 遇到的問題