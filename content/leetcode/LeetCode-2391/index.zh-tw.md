---
title: "LeetCode 2391: Minimum Amount of Time to Collect Garbage"
summary: "LeetCode 2391 解題筆記：撿垃圾時間就是垃圾總數；每台車只要開到自己那種垃圾的最後一間，路程用前綴和"
description: "2025-07-15 的 LeetCode 2391 解題紀錄"
date: 2025-07-15
tags: ["medium", "prefix-sum", "string", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-07-15
- 提交紀錄：Accepted ×2

## 解題思路

一次只能有一台車在動，所以總時間是所有車的時間相加，拆成兩部分：

- **撿垃圾**：每單位 1 分鐘，總共就是所有字串長度的和。
- **開車**：每台車只要開到自己那種垃圾**最後出現**的那一間，路程是 `travel` 的前綴和（[Prefix Sum]({{< relref "/algorithm/Prefix-Sum" >}}) 模板四）。

## 我的解法

我當時邊掃邊為每台車累積「還沒付的路程」，遇到自己那種垃圾才把累積的加進答案；第二版把撿垃圾的時間改成最後一次加總。這裡整理成「最後出現位置 + 前綴和」：

```python
class Solution:
    def garbageCollection(self, garbage: List[str], travel: List[int]) -> int:
        prefix = [0]
        for d in travel:
            prefix.append(prefix[-1] + d)
        last = {}
        for i, g in enumerate(garbage):
            for t in set(g):
                last[t] = i
        return sum(map(len, garbage)) + sum(prefix[i] for i in last.values())
```

## 複雜度

時間 `O(總字元數 + n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 某種垃圾完全沒有時，那台車不用出發。
- 車不用開到最後一間，開到自己那種垃圾的最後一間就好。

## 面試口說整理

總時間等於撿垃圾的時間加上開車的時間。撿垃圾就是所有垃圾的數量；每台車只要開到它那種垃圾最後出現的位置，用 `travel` 的前綴和直接查。時間 `O(總字元數)`。
