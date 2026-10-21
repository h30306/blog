---
title: "LeetCode 58: Length of Last Word"
summary: "LeetCode 58 解題筆記：split() 不帶參數會忽略結尾的空白，取最後一個單字的長度"
description: "2022-05-11 的 LeetCode 58 解題紀錄"
date: 2022-05-11
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
第一次嘗試：2022-05-11
- 提交紀錄：Accepted ×3 → Wrong Answer → Accepted ×3 → Runtime Error → Accepted ×3

## 解題思路

`s.split()` 會去掉頭尾空白、把連續空白當成一個分隔，最後一個元素就是最後一個單字（[String]({{< relref "/algorithm/String" >}}) 模板六）。不想切整個字串的話，可以從尾巴往前：先跳過空白，再數非空白字元。

## 我的嘗試

2022-05 有一版用了 `split(" ")[-1]`，**結尾有空白時最後一個元素是空字串**：`"a "` 回傳 0，答案 1。2022-08 重寫時把 `[-1]` 寫進了 `split(-1)` 的參數裡（TypeError）。

## 正確解法

```python
class Solution:
    def lengthOfLastWord(self, s: str) -> int:
        i = len(s) - 1
        while s[i] == " ":
            i -= 1
        n = 0
        while i >= 0 and s[i] != " ":
            n += 1
            i -= 1
        return n
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 字串可能以空白結尾，`split(" ")[-1]` 會拿到空字串。

## 面試口說整理

我從字串尾巴往前，先跳過結尾的空白，再數連續的非空白字元，就是最後一個單字的長度，空間 `O(1)`；用 split() 取最後一個也可以。
