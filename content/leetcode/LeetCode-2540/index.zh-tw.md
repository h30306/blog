---
title: "LeetCode 2540: Minimum Common Value"
summary: "LeetCode 2540 解題筆記：兩個排序好的陣列各一個指針，比較小的那邊往前，第一次相等就是答案"
description: "2026-01-31 的 LeetCode 2540 解題紀錄"
date: 2026-01-31
tags: ["easy", "two-pointers", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2026-01-31
- 提交紀錄：Accepted（一次通過）

## 解題思路

兩個陣列都已排序。兩邊各一個指針，從小開始比：

- 相等：這就是最小的共同值，直接回傳。
- 不相等：比較小的那個不可能出現在另一個陣列裡更後面的位置（後面只會更大），所以把比較小的那邊往前。

## 我的解法

```python
class Solution:
    def getCommon(self, nums1: List[int], nums2: List[int]) -> int:
        i = j = 0
        while i < len(nums1) and j < len(nums2):
            if nums1[i] == nums2[j]:
                return nums1[i]
            if nums1[i] < nums2[j]:
                i += 1
            else:
                j += 1
        return -1
```

原本的版本在往前移之前，先檢查「是不是已經是最後一個」，是的話就 `break`。其實不需要：移到結尾之後，`while` 的條件就會讓迴圈停下來。

## 複雜度

時間 `O(n + m)`，空間 `O(1)`。

## 要特別避免的錯誤

- 把比較大的那邊往前：會跳過答案。
- 用 set 取交集再取最小值：可以，但空間 `O(n)`，也沒用到排序的條件。

## 面試口說整理

兩個陣列都排好序，所以我用兩個指針從頭比。相等就是最小的共同值；不相等時，比較小的那個在另一邊也找不到了，所以把它那邊往前。任一邊走完還沒找到就回傳 `-1`，時間 `O(n + m)`、空間 `O(1)`。
