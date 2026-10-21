---
title: "LeetCode 287: Find the Duplicate Number"
summary: "LeetCode 287 解題筆記：把 i -> nums[i] 看成鏈結串列，重複的值就是環的入口，用 Floyd 判圈；O(1) 空間、不改陣列"
description: "2022-10-29 的 LeetCode 287 解題紀錄"
date: 2022-10-29
tags: ["medium", "array", "two-pointers", "binary-search", "bit-manipulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-10-29
- 提交紀錄：Wrong Answer → Accepted ×3

## 解題思路

值在 `1..n`、共 `n + 1` 個，把 `i -> nums[i]` 當成「節點指向下一個」。有兩個 index 指向同一個值，那個值就是**環的入口**（[Linked List]({{< relref "/algorithm/Linked-List" >}}) 模板三，LC 142）：

1. 快慢指針從 0 出發，相遇在環裡。
2. 一個回到 0，兩個都一次一步，再相遇的地方就是入口，也就是重複的數。

## 我的嘗試

第一版用 `sum(nums) - sum(set(nums))`，只在重複剛好兩次時才對，例如 `[2, 2, 2, 2]`：答案 2，回傳 6。

## 正確解法

```python
class Solution:
    def findDuplicate(self, nums: List[int]) -> int:
        slow = fast = 0
        while True:
            slow, fast = nums[slow], nums[nums[fast]]
            if slow == fast:
                break
        slow = 0
        while slow != fast:
            slow, fast = nums[slow], nums[fast]
        return slow
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 重複的數可能出現不只兩次，`sum(nums) - sum(set(nums))` 只在剛好兩次時才對。

## 面試口說整理

把每個 index 指向 `nums[i]` 會形成一條有環的串列，重複的值就是環的入口。我用 Floyd 判圈：快慢指針先相遇，再讓一個回到起點，兩個一起一步一步走，相遇的地方就是答案。時間 `O(n)`、空間 `O(1)`。
