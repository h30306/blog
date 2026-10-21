---
title: "LeetCode 383: Ransom Note"
summary: "LeetCode 383 解題筆記：ransomNote 每個字元的需求數量都不能超過 magazine 的數量；Counter 相減為空就成立"
description: "2022-08-23 的 LeetCode 383 解題紀錄"
date: 2022-08-23
tags: ["easy", "hash-table", "string", "counting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-23
- 提交紀錄：Wrong Answer → Accepted ×3

## 解題思路

數 `magazine` 每個字元有幾個（[Hash Table]({{< relref "/algorithm/Hash-Table" >}}) 模板一），再扣掉 `ransomNote` 需要的，任何一個不夠就失敗。Python 的 `Counter(a) - Counter(b)` 只保留正數，所以結果是空的就代表每個字元都夠。

## 我的嘗試

第一版回傳 `bool(Counter(ransomNote) - Counter(magazine))`，**意思剛好相反**：差集不是空的代表不夠，例如 `"a"`、`"c"` 回傳 `True`。改成 `not` 就 AC 了。

## 正確解法

```python
class Solution:
    def canConstruct(self, ransomNote: str, magazine: str) -> bool:
        return not (Counter(ransomNote) - Counter(magazine))
```

## 複雜度

時間 `O(n + m)`，空間 `O(k)`。

## 要特別避免的錯誤

- `Counter` 相減「不是空的」代表**不夠**，要回傳 `not ...`，不是 `bool(...)`。

## 面試口說整理

我把 ransomNote 的字元次數減掉 magazine 的字元次數，Counter 相減只留下正數，結果是空的就代表每個字元都夠。時間 `O(n + m)`。
