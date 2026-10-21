---
title: "Bit Manipulation"
summary: "Common bit operations, AND only removes bits while OR only adds them, finding adjacent ones with n & (n >> 1), and all-ones numbers 2^k - 1"
description: "Algorithm Learning"
date: 2026-10-21
tags: ["bit-manipulation"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Introduction

The key to a bit problem is usually one property; once you see it, the code is a few lines:

| Property | Where it is used |
|---|---|
| More AND means fewer bits, more OR means more bits | Bits shared by a group, the union of all bits |
| `n & (n >> 1)` keeps bits whose left neighbor is also 1 | Two adjacent ones |
| `x & (x - 1)` clears the lowest 1 | Checking for a single 1, counting ones |
| All-ones numbers are `2^k - 1` | Numbers whose bits are all the same |

Bitmask DP is in [Linear DP]({{< relref "/algorithm/Linear-DP" >}}).

## Common operations

```python
x & 1              # lowest bit (parity)
(x >> k) & 1       # bit k
x | (1 << k)       # set bit k
x & ~(1 << k)      # clear bit k
x & (x - 1)        # clear the lowest 1; 0 means x had a single 1 (or x was 0)
x & -x             # keep only the lowest 1
x.bit_length()     # position of the highest bit + 1
bin(x).count("1")  # number of ones
```

## Template 1: Accumulating AND / OR

```python
acc_or = 0
for x in nums:
    acc_or |= x                          # bits that any number has

acc_and = -1                             # -1 has every bit set: the identity for AND
for x in nums:
    acc_and &= x                         # bits that every number has
```

- **OR of the even numbers** (LC 3688): OR only the even numbers; with none, the starting value 0 is the answer.
- **Largest `k` that sorts a permutation** (LC 3644): every misplaced number must be swapped, and two swapped numbers must AND to `k`, so every bit of `k` belongs to every number that moves. The answer is the AND of all misplaced numbers (0 if already sorted).

## Template 2: Adjacent bits

Bit `i` of `n & (n >> 1)` is 1 exactly when bits `i` and `i + 1` of `n` are both 1:

```python
pairs = n & (n >> 1)                     # each 1 marks a pair of adjacent ones
exactly_one = pairs != 0 and pairs & (pairs - 1) == 0
```

- **Exactly one adjacent pair of ones** (LC 3950): `111` has two (overlapping) pairs, so `pairs` is `11`, more than one 1.

## Template 3: All-ones numbers

Numbers with every bit 1 are `1, 3, 7, 15, ...`, i.e. `2^k - 1`. `2^k - 1 <= n` means `2^k <= n + 1`, so `k` goes up to `(n + 1).bit_length() - 1`:

```python
count = (n + 1).bit_length()             # how many of 1, 3, 7, ..., plus 0
```

- **Numbers whose bits are all equal** (LC 3827): all zeros is just 0, and all ones is `2^k - 1`.

## Key Parameters

- Python integers have no fixed width, and `~x` equals `-x - 1`; apply `& mask` yourself when a fixed width matters.
- `>>` and `&` bind tighter than comparisons but looser than `+` and `-`; add parentheses when unsure.

## Complexity

Mostly `O(n)` or `O(log x)`.

## Common Mistakes

These are mistakes I actually made while practicing:

- **Assuming elements can be swapped into place one at a time**: I took the maximum of `i & nums[i]` over positions. But `k` must let **every** misplaced number swap, so it is the AND (LC 3644).

## Related LeetCode

- `LC 3644` Maximum K to Sort a Permutation
- `LC 3688` Bitwise OR of Even Numbers in an Array
- `LC 3950` Exactly One Consecutive Set Bits Pair
- `LC 3827` Count Monobit Integers
