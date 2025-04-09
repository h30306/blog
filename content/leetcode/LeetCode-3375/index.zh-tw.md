---
title: "LeetCode 3375: Minimum Operations to Make Array Values Equal to K"
summary: "LeetCode 解題紀錄"
description: "LeetCode Daily"
date: 2025-04-09
tags: ["LeetCode", "blog", "daily"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

第一次嘗試：2025/04/09
- 總花費時間：08:41.14

## 解題思路

題目描述了一個情境：我們需要找到一個整數 `h`，使得所有大於 `h` 的整數都是一樣的 —— 但這實際上是一個障眼法。  
我們可以把問題簡化為：陣列中不會有重複的數字，並且我們每次找到的 `h`都等於陣列中最大的數。

所以實際的問題就變成了：我們找幾次 `h` 會等於 `k`？

為了解這個問題，我們可以用一個集合來追蹤已經出現過的數，並遍歷 `nums` 陣列。  
當目前的數字大於 `k` 且不在集合中時，我們就把它加入集合並計一次操作。

當遍歷結束後，我們就知道總共需要幾次操作了。  
唯一需要特別處理的情況是：當數字等於 `k` 的時候 —— 這種情況不需要額外的操作。  
因此我們只需要專注在那些大於 `k` 的數字上。

## 我的解法

```python
class Solution:
    def minOperations(self, nums: List[int], k: int) -> int:
        seen = set()
        op = 0
        for num in nums:
            if num > k and num not in seen:
                seen.add(num)
                op+=1
            elif num<k:
                return -1

        return op

```
## 遇到的問題
一開始有一些測資失敗，是因為我在處理 num == k 的情況時嘗試使用一個 equal 變數來紀錄是否有出現過 num == k，然後回傳 op + (not equal)。但這樣的寫法會在不必要的情況下多加 1，導致測資失敗。
