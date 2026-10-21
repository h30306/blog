---
title: "LeetCode 944: Delete Columns to Make Sorted"
summary: "LeetCode 944 解題筆記：用 zip(*strs) 取出每一欄，數有幾欄不是非遞減的"
description: "2022-09-26 的 LeetCode 944 解題紀錄"
date: 2022-09-26
tags: ["easy", "array", "string", "longest-increasing-subsequence"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-26
- 提交紀錄：Wrong Answer ×2 → Accepted

## 解題思路

`zip(*strs)` 會把每一欄變成一個 tuple。一欄需要刪掉，代表它不是非遞減的，也就是存在 `col[i] > col[i + 1]`。數這樣的欄有幾個。

## 我的嘗試

- 第一版忘了 `return`。
- 第二版寫成 `sum(sorted(s) == s ...)`，**數的是排好的欄**，意思剛好相反；而且 `s` 是 tuple、`sorted(s)` 是 list，兩者永遠不相等，所以一直回傳 0：`["c", "b"]` 答案 1。
- 改成 `sorted(s) != list(s)` 就 AC 了。

## 正確解法

```python
class Solution:
    def minDeletionSize(self, strs: List[str]) -> int:
        return sum(any(a > b for a, b in zip(col, col[1:])) for col in zip(*strs))
```

## 複雜度

時間 `O(總字元數)`，空間 `O(m)`。

## 要特別避免的錯誤

- `zip` 產生的是 tuple，`sorted` 回傳 list，直接用 `==` 比永遠不相等。
- 要數的是**沒排好**的欄。

## 面試口說整理

我用 zip 取出每一欄，檢查有沒有相鄰兩個字元是遞減的，有的話這欄就要刪，最後數有幾欄。時間是總字元數。
