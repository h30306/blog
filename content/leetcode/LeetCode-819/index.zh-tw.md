---
title: "LeetCode 819: Most Common Word"
summary: "LeetCode 819 解題筆記：標點換成空白、全部轉小寫再切單字，計數後找出不在 banned 裡的最多的那個"
description: "2022-09-14 的 LeetCode 819 解題紀錄"
date: 2022-09-14
tags: ["easy", "array", "hash-table", "string", "counting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-14
- 提交紀錄：Wrong Answer ×2 → Runtime Error → Wrong Answer → Accepted ×2 → Wrong Answer → Accepted

## 解題思路

先正規化：把不是字母的字元**換成空白**（不是刪掉，不然 `a,b` 會黏成 `ab`），再全部轉小寫、`split()`（[String]({{< relref "/algorithm/String" >}}) 模板四）。banned 放進集合，計數時跳過（[Hash Table]({{< relref "/algorithm/Hash-Table" >}}) 模板一），最後取次數最多的。

## 我的嘗試

這題提交了 8 次，每次錯在正規化的一個細節：

- 第一版用 `paragraph[:-1]` 想去掉結尾的標點，**但段落不一定有標點**，`"a"` 被切成空字串。
- 第二版直接**刪掉**標點：`"a'a"` 變成 `"aa"`，答案是 `"a"`。
- 改成把標點換成空白後，有一版變數名稱打錯（NameError），另外兩版**忘了轉小寫**：`"Bob"` 回傳 `"Bob"`，答案 `"bob"`。

## 正確解法

```python
class Solution:
    def mostCommonWord(self, paragraph: str, banned: List[str]) -> str:
        words = "".join(c.lower() if c.isalpha() else " " for c in paragraph).split()
        ban = set(banned)
        cnt = Counter(w for w in words if w not in ban)
        return cnt.most_common(1)[0][0]
```

## 複雜度

時間 `O(n + b)`，空間 `O(n + b)`。

## 要特別避免的錯誤

- 標點要換成空白，不能直接刪掉。
- 大小寫視為相同，要轉小寫。
- 不要切掉最後一個字元：段落不一定以標點結尾。

## 面試口說整理

我先把非字母換成空白、轉小寫再切成單字，banned 放進集合，計數時跳過，最後回傳次數最多的單字。時間 `O(n + b)`。
