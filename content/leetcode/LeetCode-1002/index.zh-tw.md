---
title: "LeetCode 1002: Find Common Characters"
summary: "LeetCode 1002 解題筆記：每個單字各自計數，對所有 Counter 取交集（每個字元取最小次數），再展開"
description: "2022-09-27 的 LeetCode 1002 解題紀錄"
date: 2022-09-27
tags: ["easy", "array", "hash-table", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-27
- 提交紀錄：Runtime Error → Accepted ×3

## 解題思路

答案中每個字元的次數，是它在**每個單字**中出現次數的最小值（[Hash Table]({{< relref "/algorithm/Hash-Table" >}}) 模板一）。Python 的 `Counter & Counter` 就是逐字元取最小值，對所有單字做完後用 `elements()` 展開。

## 我的嘗試

第一版用 `set` 跟字串取交集（`set & str`，TypeError），而且 `set` 本來就會**丟掉重複的次數**，`["bb"]` 應該回傳兩個 `b`。之後改用 `Counter &` 才 AC。

## 正確解法

```python
class Solution:
    def commonChars(self, words: List[str]) -> List[str]:
        common = Counter(words[0])
        for w in words[1:]:
            common &= Counter(w)
        return list(common.elements())
```

## 複雜度

時間 `O(總字元數)`，空間 `O(k)`。

## 要特別避免的錯誤

- 用 `set` 會丟掉重複次數：`["bb"]` 的答案是 `["b", "b"]`。
- `set & str` 型別不同，會 TypeError。

## 面試口說整理

我對每個單字計數，然後對所有 Counter 取交集，也就是每個字元取最小的次數，最後展開成 list。時間是所有單字的總長度。
