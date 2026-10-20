---
title: "LeetCode 1023: Camelcase Matching"
summary: "LeetCode 1023 解題筆記：雙指針逐字比對，pattern 以外多出來的只能是小寫字母"
description: "2026-03-19 的 LeetCode 1023 解題紀錄"
date: 2026-03-19
tags: ["medium", "two-pointers", "string", "trie"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-03-19
- 提交紀錄：Accepted（一次通過）

## 解題思路

query 符合 pattern 的條件是：可以在 pattern 裡插入**小寫字母**變成 query。換句話說：

1. pattern 是 query 的子序列。
2. query 裡不屬於這個子序列的字元，**全部都是小寫**。

用雙指針比對：

- 字元相同：兩邊都往前。
- 不同，而且 query 這個字元是大寫：不能插入大寫，直接失敗。
- 不同，而且是小寫：視為插入的字元，只移動 query 的指針。

最後 pattern 要用完，query 剩下的也必須全是小寫。

LeetCode 把這題標成 Trie，但每個 query 只跟 pattern 比一次，雙指針就夠了。

## 我的解法

```python
class Solution:
    def camelMatch(self, queries: List[str], pattern: str) -> List[bool]:
        def match(q: str) -> bool:
            j = 0
            for ch in q:
                if j < len(pattern) and ch == pattern[j]:
                    j += 1
                elif ch.isupper():
                    return False
            return j == len(pattern)

        return [match(q) for q in queries]
```

原本的版本用 `while` 跑兩個指針，最後再檢查 `query[r:]` 剩下的部分是不是全小寫。改成 `for` 掃過整個 query 之後，「剩下的字元必須是小寫」也一起在迴圈裡檢查了。

## 複雜度

時間 `O(所有 query 的總長度)`，空間 `O(1)`，不算輸出。

## 要特別避免的錯誤

- 只檢查 pattern 是不是子序列，忘記多出來的字元不能是大寫。
- pattern 用完之後，沒有檢查 query 剩下的部分。

## 面試口說整理

query 符合的條件是 pattern 為它的子序列，而且多出來的字元都是小寫。我對每個 query 掃一遍，跟 pattern 目前的字元相同就推進 pattern 的指針，不同的話如果是大寫就直接失敗。最後 pattern 要剛好用完。每個 query 線性時間，不需要 Trie。
