---
title: "LeetCode 26: Remove Duplicates from Sorted Array"
summary: "LeetCode 26 解題筆記：快慢指針原地覆寫，慢指針指向下一個要寫的位置；遇到跟前一個寫入的值不同才寫"
description: "2020-01-30 的 LeetCode 26 解題紀錄"
date: 2020-01-30
tags: ["easy", "array", "two-pointers"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2020-01-30
- 提交紀錄：Compile Error → Output Limit Exceeded → Accepted → Runtime Error ×5 → Wrong Answer ×2 → Runtime Error → Wrong Answer → Accepted → Runtime Error → Wrong Answer → Runtime Error ×3 → Accepted ×2

## 解題思路

已排序，重複的值相鄰。用一個寫入指標 `k`（[Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) 模板五）：掃過每個數，跟最後寫入的 `nums[k - 1]` 不一樣才寫到 `nums[k]`，`k += 1`。最後回傳 `k`，前 `k` 個就是不重複的值。

## 我的嘗試

這是我 2020、2022 年最早寫的幾題之一，前面的錯大多是沒看懂題目要什麼：回傳了 tuple 或新的 list、算出來的 `k` 是重複的個數而不是剩下的個數。之後一版寫入的條件不對，重複的值沒有被跳過，例如 `[2, 2, 4]` 前兩個是 `[2, 2]`。

## 正確解法

```python
class Solution:
    def removeDuplicates(self, nums: List[int]) -> int:
        k = 1
        for x in nums[1:]:
            if x != nums[k - 1]:
                nums[k] = x
                k += 1
        return k
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 要**原地修改**陣列並回傳長度，不是回傳新的 list。

## 面試口說整理

陣列已排序，我用寫入指標，只有跟上一個寫入的值不同時才寫進去並前進，最後回傳寫入的個數。時間 `O(n)`、空間 `O(1)`。
