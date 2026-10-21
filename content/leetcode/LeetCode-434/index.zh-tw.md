---
title: "LeetCode 434: Number of Segments in a String"
summary: "LeetCode 434 解題筆記：split() 不帶參數會忽略多餘的空白，切出來的數量就是答案"
description: "2022-08-24 的 LeetCode 434 解題紀錄"
date: 2022-08-24
tags: ["easy", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-24
- 提交紀錄：Accepted（一次通過）

## 解題思路

segment 是連續的非空白字元。`split()` 不帶參數時會把連續空白當成一個分隔、去掉頭尾空白，空字串會得到空 list，所以 `len(s.split())` 就是答案（[String]({{< relref "/algorithm/String" >}}) 模板六）。

## 我的解法

```python
class Solution:
    def countSegments(self, s: str) -> int:
        return len(s.split())
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- `split(" ")` 會留下空字串，數量會多。

## 面試口說整理

我用不帶參數的 split 切開字串，它會忽略多餘的空白，切出來的數量就是答案；如果要 `O(1)` 空間，可以數「自己不是空白、前一個是空白或在開頭」的位置。
