---
title: "LeetCode 1128: Number of Equivalent Domino Pairs"
summary: "LeetCode 1128 解題筆記：把每張骨牌正規化成 (小, 大) 當 key 計數，每個 key 有 c 張就有 c(c - 1) / 2 對"
description: "2022-10-18 的 LeetCode 1128 解題紀錄"
date: 2022-10-18
tags: ["easy", "array", "hash-table", "counting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-10-18
- 提交紀錄：Runtime Error ×2 → Wrong Answer ×3 → Accepted

## 解題思路

`[a, b]` 和 `[b, a]` 是同一種，所以先正規化成 `(min, max)` 當 key（[Hash Table]({{< relref "/algorithm/Hash-Table" >}}) 模板五）。同一個 key 有 `c` 張，任選兩張就是一對：`c(c - 1) / 2`。也可以邊掃邊加：每張骨牌跟之前同 key 的每一張都成對，答案加上目前的次數。

## 我的嘗試

- 前兩版用 `sorted(dominoe)`（list）當 dict 的 key，**list 不能 hash**（TypeError），而且回傳的是 `max(d.values())`。
- 改成 `tuple(dominoe)` 之後**沒有排序**，`[1, 3]` 和 `[3, 1]` 被當成兩種；配對數也寫成 `(i * i - 1) // 2`。改成 `tuple(sorted(...))` 和 `v * (v - 1) // 2` 才 AC。

## 正確解法

```python
class Solution:
    def numEquivDominoPairs(self, dominoes: List[List[int]]) -> int:
        cnt = Counter()
        pairs = 0
        for a, b in dominoes:
            key = (min(a, b), max(a, b))
            pairs += cnt[key]
            cnt[key] += 1
        return pairs
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- list 不能當 dict 的 key，要轉成 tuple。
- 要正規化順序，`[1, 3]` 和 `[3, 1]` 是同一種。
- 配對數是 `c(c - 1) / 2`。

## 面試口說整理

我把每張骨牌正規化成小的在前的 tuple 當 key，邊掃邊把答案加上之前同一種的張數，再把這種的次數加一。時間 `O(n)`。
