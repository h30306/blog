---
title: "LeetCode 169: Majority Element"
summary: "LeetCode 169 解題筆記：Boyer-Moore 投票，不同的數兩兩抵消，最後留下的就是出現超過一半的那個"
description: "2022-08-20 的 LeetCode 169 解題紀錄"
date: 2022-08-20
tags: ["easy", "array", "hash-table", "divide-and-conquer", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-20
- 提交紀錄：Wrong Answer ×5 → Accepted ×2 → Runtime Error → Accepted ×2 → Compile Error ×3

## 解題思路

Boyer-Moore 投票：維護一個候選人和票數，遇到相同的數 `+1`，不同的 `-1`，票數歸零就換成目前的數。超過一半的數不可能被其他數抵消完，最後的候選人就是它，`O(1)` 空間。其他寫法：雜湊表計數（[Hash Table]({{< relref "/algorithm/Hash-Table" >}}) 模板一），或排序後取 `nums[n // 2]`。

## 我的嘗試

這題 2022-08-20 提交了 13 次：

- 用 dict 計數時，第一版算出 `count` 卻**沒有存回 dict**，次數永遠是 1，回傳 `None`；後來幾版用了 `>=`，加上 `print` 一起改掉才 AC。
- 接著試「排序後取中間」：寫成 `sorted(nums)[round(len(nums) / 2)]`，當時用的是 Python 2，`len(nums) / 2` 是整數除法，`round` 回傳浮點數不能當 index（RE），包上 `int` 就 AC 了。**在 Python 3 這個寫法是錯的**：長度 3 時 `round(1.5) = 2`，`[2, 2, 3]` 會回傳 3。最後改成 `len(nums) // 2`。
- 最後幾次是把 Java 的 Boyer-Moore 直接貼進 Python，Compile Error。

## 正確解法

```python
class Solution:
    def majorityElement(self, nums: List[int]) -> int:
        cand, count = None, 0
        for x in nums:
            if count == 0:
                cand = x
            count += 1 if x == cand else -1
        return cand
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 計數時要把 `d.get(i, 0) + 1` 存回去。
- 「超過一半」是 `>`，不是 `>=`。
- 排序後的中間是 `len(nums) // 2`；在 Python 3 寫 `round(len(nums) / 2)` 會四捨六入五成雙，長度 3 時拿到 index 2。

## 面試口說整理

我用 Boyer-Moore 投票，相同的數加一票、不同的減一票，票數歸零就換候選人；出現超過一半的數不可能被抵消完，所以最後的候選人就是答案。時間 `O(n)`、空間 `O(1)`。
