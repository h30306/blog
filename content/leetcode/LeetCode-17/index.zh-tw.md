---
title: "LeetCode 17: Letter Combinations of a Phone Number"
summary: "LeetCode 17 解題筆記：每一層處理一個數字，枚舉它對應的字母；空字串要回傳空 list"
description: "2022-10-20 的 LeetCode 17 解題紀錄"
date: 2022-10-20
tags: ["medium", "hash-table", "string", "backtracking"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-10-20
- 提交紀錄：Runtime Error ×8 → Accepted → Runtime Error → Accepted ×2

## 解題思路

第 `i` 層處理 `digits[i]`，枚舉它對應的每個字母接到目前的字串後面，處理完所有數字就記錄（[Backtracking]({{< relref "/algorithm/Backtracking" >}}) 模板）。`digits` 是空的時要回傳 `[]`，不是 `[""]`。

## 我的嘗試

這題提交了 12 次，幾乎都是 Python 的作用域問題：

- 把遞迴寫成另一個 method，**在裡面直接用 `digits` 和 `dic`**，但它們是 `letterCombinations` 的區域變數，另一個 method 看不到（NameError），中間還夾著幾次語法錯誤。
- 2022-11 重寫時把字典存成 `self.d2l`、把 `digits` 當參數往下傳，才 AC。

## 正確解法

```python
class Solution:
    def letterCombinations(self, digits: str) -> List[str]:
        if not digits:
            return []
        letters = {"2": "abc", "3": "def", "4": "ghi", "5": "jkl",
                   "6": "mno", "7": "pqrs", "8": "tuv", "9": "wxyz"}
        res = []
        def dfs(i, path):
            if i == len(digits):
                res.append(path)
                return
            for c in letters[digits[i]]:
                dfs(i + 1, path + c)
        dfs(0, "")
        return res
```

## 複雜度

時間 `O(4^n · n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 另一個 method 讀不到這個 method 的區域變數（`digits`、`dic`），要當參數傳或用內部函式。
- 空字串回傳 `[]`。

## 面試口說整理

我用回溯，每一層處理一個數字，把它對應的每個字母接上去，處理完所有數字就記錄；輸入是空字串時直接回傳空的 list。時間 `O(4^n · n)`。
