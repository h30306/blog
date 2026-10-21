---
title: "LeetCode 476: Number Complement"
summary: "LeetCode 476 note: build an all-ones mask as long as num; num ^ mask is the complement"
description: "LeetCode 476 record from 2022-08-24"
date: 2022-08-24
tags: ["easy", "bit-manipulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-24
- Submissions: Wrong Answer → Accepted ×2

## Approach

The complement flips only significant bits; plain `~num` also flips the leading zeros and goes negative. `mask = (1 << num.bit_length()) - 1` is all ones over `num`'s length, and `num ^ mask` is the answer ([Bit Manipulation]({{< relref "/algorithm/Bit-Manipulation" >}})).

## My Attempts

Attempt 1 used the example's `bin(5)` and **never switched to `num`**, always returning 5's complement, 2.

## Solution

```python
class Solution:
    def findComplement(self, num: int) -> int:
        return num ^ ((1 << num.bit_length()) - 1)
```

## Complexity

Time `O(1)`, space `O(1)`.

## Mistakes to Avoid

- `~num` flips every bit and yields a negative number.

## Interview Explanation

The complement flips only significant bits, so I build an all-ones mask of num's bit length and XOR. Time `O(1)`.
