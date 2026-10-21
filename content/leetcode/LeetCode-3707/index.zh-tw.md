---
title: "LeetCode 3707: Equal Score Substrings"
summary: "LeetCode 3707 解題筆記：邊掃邊累加左邊的分數，右邊是總分減左邊；分數是字母順序 1 到 26，不是 ord"
description: "2025-10-11 的 LeetCode 3707 解題紀錄"
date: 2025-10-11
tags: ["easy", "prefix-sum", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2025-10-11
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

先算總分，再從左往右累加左邊的分數，右邊就是 `total - left`（[Prefix Sum]({{< relref "/algorithm/Prefix-Sum" >}}) 模板二）。分割點要讓兩邊都非空，所以最後一個字元之前就要停。

## 我的嘗試

第一版直接用 `ord(char)` 當分數。`ord` 是字母順序加 96，兩邊長度不同時會多出不同的 `96 × 長度`。例如 `"bac"`：`"ba"` 是 2 + 1 = 3、`"c"` 是 3，答案是 `True`；用 `ord` 算是 195 對 99，回傳 `False`。改成 `ord(char) - ord("a") + 1` 就 AC 了。

## 正確解法

```python
class Solution:
    def scoreBalance(self, s: str) -> bool:
        scores = [ord(c) - ord("a") + 1 for c in s]
        total, left = sum(scores), 0
        for x in scores[:-1]:
            left += x
            if left * 2 == total:
                return True
        return False
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 分數是字母順序 1 到 26，要減掉 `ord("a")` 再加 1。
- 右邊不能是空的，最後一個字元不能當分割點。

## 面試口說整理

我先算整個字串的分數，再從左邊開始累加，左邊剛好是總分一半時就能切。分數是字母順序，要用 `ord(c) - ord('a') + 1`。時間 `O(n)`。
