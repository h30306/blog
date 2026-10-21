---
title: "LeetCode 287: Find the Duplicate Number"
summary: "LeetCode 287 note: treat i -> nums[i] as a linked list; the duplicate is the cycle entry, found with Floyd's algorithm in O(1) space without modifying the array"
description: "LeetCode 287 record from 2022-10-29"
date: 2022-10-29
tags: ["medium", "array", "two-pointers", "binary-search", "bit-manipulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-10-29
- Submissions: Wrong Answer → Accepted ×3

## Approach

Values are in `1..n` with `n + 1` of them; treat `i -> nums[i]` as "node points to next". Two indices pointing at the same value make that value **the cycle entry** ([Linked List]({{< relref "/algorithm/Linked-List" >}}) Template 3, LC 142):

1. Fast and slow pointers start at 0 and meet inside the cycle.
2. Send one back to 0 and step both one at a time; they meet at the entry, the duplicate.

## My Attempts

Attempt 1 used `sum(nums) - sum(set(nums))`, which works only when the duplicate appears exactly twice: `[2, 2, 2, 2]` should be 2; it returned 6.

## Solution

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

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- The duplicate may appear more than twice; `sum(nums) - sum(set(nums))` works only for exactly two.

## Interview Explanation

Pointing each index at `nums[i]` forms a list with a cycle whose entry is the duplicate. With Floyd's algorithm, fast and slow pointers meet, then one restarts and both step together until they meet at the answer. Time `O(n)`, space `O(1)`.
