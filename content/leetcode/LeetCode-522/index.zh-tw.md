---
title: "LeetCode 522: Longest Uncommon Subsequence II"
summary: "LeetCode 522 解題筆記：最長的特殊子序列一定是某個完整字串；依長度由長到短檢查，只要不是其他夠長字串的子序列就是答案"
description: "2026-04-05 的 LeetCode 522 解題紀錄"
date: 2026-04-05
tags: ["medium", "two-pointers", "string", "sorting", "array", "hash-table"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-04-05
- 提交紀錄：Accepted（一次通過）

## 解題思路

**關鍵觀察：如果某個字串的子序列是「特殊」的（不是其他任何字串的子序列），那這個字串本身也是特殊的。** 子序列能放進別的字串，它的母字串不一定能；反過來，母字串若能放進別的字串，它所有子序列也都能。所以只需要檢查每個完整字串。

`strs[i]` 是特殊的條件：對所有 `j != i`，`strs[i]` 都不是 `strs[j]` 的子序列。

- 比 `strs[i]` 短的字串不可能包含它，不用檢查。
- 依長度由長到短排序，第一個符合條件的就是答案；都不符合回傳 `-1`。

判斷子序列用同向雙指針：`i` 走短字串、`j` 走長字串，字元相同 `i` 才前進，`j` 每步都前進，最後看 `i` 有沒有走完。

## 我的解法

```python
class Solution:
    def findLUSlength(self, strs: List[str]) -> int:
        def is_subsequence(s: str, t: str) -> bool:    # s 是不是 t 的子序列
            i = 0
            for ch in t:
                if i < len(s) and s[i] == ch:
                    i += 1
            return i == len(s)

        strs.sort(key=len, reverse=True)
        n = len(strs)
        for i in range(n):
            uncommon = True
            for j in range(n):
                if len(strs[j]) < len(strs[i]):
                    break                              # 後面都更短，不可能包含 strs[i]
                if i != j and is_subsequence(strs[i], strs[j]):
                    uncommon = False
                    break
            if uncommon:
                return len(strs[i])
        return -1
```

重複的字串會互相是子序列，所以自然被排除，不需要特別處理。

## 複雜度

時間 `O(n^2 · L)`，`L` 是字串長度；空間 `O(1)`（排序除外）。

## 要特別避免的錯誤

- 去列舉每個字串的所有子序列：指數級。
- 只跟比自己長的字串比：一樣長、內容相同的字串也要比。

## 面試口說整理

如果某個子序列是特殊的，包含它的完整字串也一定是特殊的，所以答案一定是某個完整字串的長度。我把字串依長度由長到短排序，檢查每個字串是不是其他長度不小於它的字串的子序列，用雙指針判斷；第一個不是的就是答案，都是就回傳 `-1`。時間 `O(n^2 · L)`。
