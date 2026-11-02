---
title: "LeetCode 4097: Minimum Value of Merged Integers"
summary: "LeetCode 4097 解題筆記：只合併 (0,1)、(2,3)… 這些固定的配對，步長是 2，不是每對相鄰元素"
description: "2026-11-02 的 LeetCode 4097 解題紀錄"
date: 2026-11-02
tags: ["easy", "array", "string", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2026-11-02
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

題目指定配對方式：`nums[0]` 和 `nums[1]`、`nums[2]` 和 `nums[3]`……每一對把兩個數字的十進位接起來，取最小值。照做就好：`i` 每次加 2，把 `str(nums[i]) + str(nums[i + 1])` 轉成整數比較。

也可以不轉字串：`b` 有 `d` 位數的話，接起來是 `a * 10^d + b`。

## 我的嘗試

1. `i` 每次加 1，把**每一對相鄰**元素都合併了，多算了題目沒有的配對：`[70,41,91,11]` 回傳 4191（41 和 91 接起來），答案是 7041。
2. 改成步長 2 就過了。

## 正確解法

```python
class Solution:
    def minMergedInteger(self, nums: List[int]) -> int:
        return min(int(str(nums[i]) + str(nums[i + 1])) for i in range(0, len(nums), 2))
```

## 複雜度

時間 `O(n)`（每個數字最多 4 位數），空間 `O(1)`。

## 要特別避免的錯誤

- 看清楚配對是固定的 `(0,1)`、`(2,3)`，不是所有相鄰的兩個。

## 面試口說整理

配對是固定的，所以我用步長 2 走過陣列，把每一對接成一個整數，取最小值。時間 `O(n)`。
