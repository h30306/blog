---
title: "Prefix Sum"
summary: "Introduction to Prefix Sum"
description: "Algorithm Learning"
date: 2025-04-19
tags: ["prefix-sum"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Introduction

**Prefix Sum** is an algorithmic technique used to quickly calculate the sum or value of a subarray. 
For example, given an array `nums = [2, 4, 5, 7]`, if we want to find the sum from `nums[i]` to `nums[j]`, using brute force would take `O(n)` time for each query. 
However, by iterating through the array once and building a prefix sum array, we can then answer each query in `O(1)` time.


## Core Idea

The core idea is to build an array where each element stores the cumulative sum of all previous elements. 
So for index `i`, the value at `prefix[i + 1]` will be the sum of elements from index `0` to `i` in the original array.

```python
prefix = [0] * (len(nums) + 1)
for i in range(len(nums)):
    prefix[i + 1] = prefix[i] + nums[i]
```
If we want to find the sum from index `i` to `j`, we can simply use:
```python
sum_ = prefix[j+1] - prefix[i]
```
The first element in the prefix array represents an empty prefix (i.e., sum of `0` elements), so we use `prefix[j + 1]` to include the value at index `j`, and subtract `prefix[i]` to exclude the sum before index `i`.

## Template

```python
prefix = [0] * (len(nums) + 1)
for i in range(len(nums)):
    prefix[i + 1] = prefix[i] + nums[i]

sum_ = prefix[j+1] - prefix[i]
```

### Explanation of the key parameters:

## Examples

classic prefix sum
```python
class NumArray:

    def __init__(self, nums: List[int]):
        self.ps = [0]
        for num in nums:
            self.ps.append(num+self.ps[-1])

    def sumRange(self, left: int, right: int) -> int:
        return self.ps[right+1] - self.ps[left]
```

## Template 2: Prefix / suffix maximum and minimum (finding a split)

When a problem needs "something about the left part" and "something about the right part", scan once from each side, store the results, then try every split:

```python
n = len(nums)
pre_max = nums[:]                        # pre_max[i] = max(nums[0..i])
for i in range(1, n):
    pre_max[i] = max(pre_max[i - 1], nums[i])
suf_min = nums[:]                        # suf_min[i] = min(nums[i..n-1])
for i in range(n - 2, -1, -1):
    suf_min[i] = min(suf_min[i + 1], nums[i])
for i in range(n):
    score = pre_max[i] - suf_min[i]      # or prefix_sum[i] - suf_min[i + 1], etc.
```

- **Smallest stable index** (LC 3903, 3904): the first `i` with `pre_max[i] - suf_min[i] <= k`.
- **Prefix sum minus suffix minimum** (LC 3788): split `i` scores `prefix_sum[i] - suf_min[i + 1]`.
- **Maximize `(nums[i] - nums[j]) * nums[k]`** (LC 2874): fix the middle `j`, take the maximum on each side. A single pass also works, tracking the running maximum and the running best difference.
- **One cut with equal sums** (LC 3707, 3548): accumulate the left side while scanning; the right side is `total - left`. 3548 also allows discounting one cell, which must keep the section connected.

## Template 3: Prefix difference + hash map

Turn "as many 0s as 1s" into "equal prefix `ones - zeros`". Remember the **earliest** position of each difference, since longer is better:

```python
first = {0: -1}
diff = best = 0
for i, ch in enumerate(s):
    diff += 1 if ch == "1" else -1
    if diff in first:
        best = max(best, i - first[diff])
    else:
        first[diff] = i
```

- **One swap allowed** (LC 3900): a substring whose difference is off by 2 becomes balanced after swapping in a character from outside, as long as one exists. If the earliest position fails, the second earliest always works, so keep the first two positions per difference.

## Template 4: Only travel as far as needed

Each kind of item only needs to travel to its **last occurrence**, with distances from a prefix sum:

```python
last = {}
for i, items in enumerate(houses):
    for t in set(items):
        last[t] = i
prefix = [0]
for d in travel:
    prefix.append(prefix[-1] + d)
total = sum(len(items) for items in houses) + sum(prefix[i] for i in last.values())
```

- **Collecting garbage** (LC 2391): each of the three trucks only drives to the last house with its type.

## Common Mistakes

These are mistakes I actually made while practicing:

- **Off-by-one in a suffix array**: a suffix array built backward was indexed wrong, so `j` itself counted as part of the right side (LC 2874).
- **Scoring with `ord(c)`**: the score is the alphabet position 1 to 26; with different lengths, `ord` adds a different `96 × length` to each side (LC 3707).
- **Sliding window on a prefix-difference problem**: balance is not monotonic, so shrinking from the left does not necessarily help (LC 3900).

## Related LeetCode

- `LC 303` Range Sum Query - Immutable
- `LC 2874` Maximum Value of an Ordered Triplet II
- `LC 3788` Maximum Score of a Split
- `LC 3903` Smallest Stable Index I
- `LC 3904` Smallest Stable Index II
- `LC 2391` Minimum Amount of Time to Collect Garbage
- `LC 3494` Find the Minimum Amount of Time to Brew Potions
- `LC 3707` Equal Score Substrings
- `LC 3548` Equal Sum Grid Partition II
- `LC 3900` Longest Balanced Substring After One Swap
