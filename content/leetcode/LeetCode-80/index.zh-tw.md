---
title: "LeetCode 80: Remove Duplicates from Sorted Array II"
summary: "LeetCode 80 解題筆記：每個值最多留兩個：跟寫入位置往前第二個 nums[k - 2] 比，不一樣才寫"
description: "2022-10-26 的 LeetCode 80 解題紀錄"
date: 2022-10-26
tags: ["medium", "array", "two-pointers"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-10-26
- 提交紀錄：Wrong Answer ×3 → Runtime Error → Accepted ×4

## 解題思路

跟 LC 26 一樣用寫入指標（[Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) 模板五），只是允許兩個。新的數 `x` 可以寫，條件是 `k < 2` 或 `x != nums[k - 2]`：如果跟往前第二個一樣，代表已經寫了兩個。

## 我的嘗試

前幾版用計數器 `c` 記目前這個值出現幾次，`i`、`j` 兩個指標的更新條件很複雜，例如 `[0, 0, 0]` 回傳 3（應該是 2）、只有一個元素時回傳 0。

## 正確解法

```python
class Solution:
    def removeDuplicates(self, nums: List[int]) -> int:
        k = 0
        for x in nums:
            if k < 2 or x != nums[k - 2]:
                nums[k] = x
                k += 1
        return k
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 比的是**已經寫入**的 `nums[k - 2]`，不是原陣列的 `nums[i - 2]`（可能已被覆寫）。

## 面試口說整理

每個值最多兩個，所以我用寫入指標，新的數跟寫入位置往前第二個不一樣才寫。這個寫法改成最多 `m` 個時只要把 2 換成 `m`。時間 `O(n)`。
