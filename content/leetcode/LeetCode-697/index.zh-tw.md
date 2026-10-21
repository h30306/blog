---
title: "LeetCode 697: Degree of an Array"
summary: "LeetCode 697 解題筆記：記錄每個數的出現次數、第一次和最後一次出現的位置；次數最多的數中，取跨度最短的"
description: "2022-08-30 的 LeetCode 697 解題紀錄"
date: 2022-08-30
tags: ["easy", "array", "hash-table"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-30
- 提交紀錄：Wrong Answer ×3 → Runtime Error ×2 → Accepted ×5

## 解題思路

子陣列的 degree 要跟整個陣列一樣，就必須包含某個次數最多的數的**所有**出現位置，最短就是 `last[x] - first[x] + 1`。次數最多的數可能不只一個，要全部比較取最小（[Hash Table]({{< relref "/algorithm/Hash-Table" >}}) 模板一）。一次掃描就能記錄次數、第一次和最後一次的位置。

## 我的嘗試

這題提交了 10 次：

- 前三版只用 `most_common()[0]` 拿**一個**次數最多的數，次數相同的其他數沒有比；長度用負數 index 算，差了一：`[2]` 回傳 -1、0。
- 改成記錄每個數所有出現的位置之後，又有 `d.values` 少了括號、拿 list 跟長度比較的錯誤，最後比較「位置 list 的長度」才 AC。

## 正確解法

```python
class Solution:
    def findShortestSubArray(self, nums: List[int]) -> int:
        cnt, first, last = Counter(), {}, {}
        for i, x in enumerate(nums):
            cnt[x] += 1
            first.setdefault(x, i)
            last[x] = i
        degree = max(cnt.values())
        return min(last[x] - first[x] + 1 for x in cnt if cnt[x] == degree)
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 次數最多的數可能有好幾個，要全部比較。
- 長度是 `last - first + 1`。

## 面試口說整理

子陣列要包含某個次數最多的數的所有出現位置，所以我掃一次記錄每個數的次數、第一次和最後一次出現的位置，在次數最多的數裡取跨度最短的。時間 `O(n)`。
