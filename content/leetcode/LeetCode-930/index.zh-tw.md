---
title: "LeetCode 930: Binary Subarrays With Sum"
summary: "LeetCode 930 解題筆記：「和剛好是 goal」= 「和最多 goal」−「和最多 goal - 1」；或用前綴和 + 雜湊表"
description: "2026-01-20 的 LeetCode 930 解題紀錄"
date: 2026-01-20
tags: ["medium", "sliding-window", "prefix-sum", "hash-table", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-20
- 提交紀錄：Accepted（一次通過）

## 解題思路

跟 [LeetCode 1248]({{< relref "/leetcode/LeetCode-1248" >}}) 一樣：陣列裡有 0，「和剛好是 `goal`」時視窗加入 0 總和不變，不單調。改成兩次「最多」相減。

`goal = 0` 時，`at_most(-1)` 要回傳 0（不能讓視窗縮成負的長度）。

## 我的解法

```python
class Solution:
    def numSubarraysWithSum(self, nums: List[int], goal: int) -> int:
        def at_most(limit: int) -> int:
            if limit < 0:
                return 0
            left = total = count = 0
            for right, x in enumerate(nums):
                total += x
                while total > limit:
                    total -= nums[left]
                    left += 1
                count += right - left + 1
            return count

        return at_most(goal) - at_most(goal - 1)
```

前綴和的寫法：`count[prefix - goal]` 加總，跟 1248 一樣。

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- `goal = 0` 時 `at_most(-1)` 要特判回傳 0。

## 面試口說整理

陣列裡有 0，剛好等於 `goal` 不單調，所以我算「和最多 `goal`」減「和最多 `goal - 1`」，最多型用滑動視窗，以右端結尾的合法子陣列有 `right - left + 1` 個。`goal` 是 0 時，最多 -1 的數量是 0。也可以用前綴和加雜湊表。時間 `O(n)`。
