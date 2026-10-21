---
title: "LeetCode 169: Majority Element"
summary: "LeetCode 169 note: Boyer-Moore voting, where different values cancel in pairs and the survivor is the one appearing more than half the time"
description: "LeetCode 169 record from 2022-08-20"
date: 2022-08-20
tags: ["easy", "array", "hash-table", "divide-and-conquer", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-20
- Submissions: Wrong Answer ×5 → Accepted ×2 → Runtime Error → Accepted ×2 → Compile Error ×3

## Approach

Boyer-Moore voting: keep a candidate and a count, `+1` for equal values and `-1` otherwise, switching candidates when the count hits zero. A value appearing more than half the time cannot be cancelled out, so it is the final candidate, in `O(1)` space. Alternatives: hash-map counting ([Hash Table]({{< relref "/algorithm/Hash-Table" >}}) Template 1) or `nums[n // 2]` after sorting.

## My Attempts

On 2022-08-20 this took 13 submissions:

- Counting with a dict, attempt 1 computed `count` but **never stored it back**, so every count stayed 1 and it returned `None`; later versions used `>=`, and fixing that along with a `print` passed.
- Next, "sort and take the middle": `sorted(nums)[round(len(nums) / 2)]`. That was Python 2, where `len(nums) / 2` is integer division and `round` returns a float that cannot index (RE); wrapping it in `int` passed. **In Python 3 this is wrong**: for length 3, `round(1.5) = 2`, so `[2, 2, 3]` returns 3. I finally used `len(nums) // 2`.
- The last few pasted Java Boyer-Moore code into Python: Compile Errors.

## Solution

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

## Complexity

Time `O(n)`, space `O(1)`.

## Mistakes to Avoid

- Store `d.get(i, 0) + 1` back when counting.
- "More than half" is `>`, not `>=`.
- The middle after sorting is `len(nums) // 2`; in Python 3, `round(len(nums) / 2)` uses banker's rounding and gives index 2 for length 3.

## Interview Explanation

With Boyer-Moore voting, equal values add a vote and different ones remove a vote, switching candidates at zero; a value appearing more than half the time cannot be cancelled out, so the final candidate is the answer. Time `O(n)`, space `O(1)`.
