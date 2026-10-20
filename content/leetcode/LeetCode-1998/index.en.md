---
title: "LeetCode 1998: GCD Sort of an Array"
summary: "LeetCode 1998 note: numbers in one component can be permuted freely; union each number with its prime factors via SPF, and the array sorts iff each position's old and new values share a group"
description: "LeetCode 1998 record from 2026-10-12"
date: 2026-10-12
tags: ["hard", "math", "number-theory", "union-find", "sieve", "sorting", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-10-12
- Submissions: AC → RE → WA → AC → WA ×2 → AC ×2 (three sieves practiced the same day)

## Approach

Two numbers sharing a factor may be swapped. Within one connected component, a sequence of swaps achieves **any permutation** (as with "swappable positions form components, each sortable freely").

So:

1. Use Union-Find to join each number with its prime factors (values as nodes, as in [LeetCode 2709]({{< relref "/leetcode/LeetCode-2709" >}})).
2. After sorting, the original `nums[i]` and the sorted `sorted[i]` at each position must be in **the same component**, or it cannot be swapped into place.

## My Attempts

I first passed with "trial division + `owner[p]`, index nodes", then practiced SPF sieves:

| Version | Problem |
|---|---|
| RE | A misspelled variable (`sorted_unms`) |
| WA | The SPF sieve wrote `spf[i] = i` instead of `spf[j] = i`, so composites kept themselves as SPF; factoring also modified `num` directly, so the value later unioned was wrong. For `[9, 3]`, 9 and 3 share 3 and can be swapped into order, so the answer is `True`; it returned `False` |
| AC | Fixed both |
| Two WAs | Switched to a linear sieve with the inner loop inside `if spf[i] == 0` (primes only), so **only primes crossed out multiples** and something like `8 = 4 × 2` was never handled and was treated as prime. For `[8, 2]` the answer is `True`; it returned `False` |
| AC ×2 | Moved the inner loop out so it runs for every `i` |

## Solution

```python
class Solution:
    def gcdSort(self, nums: List[int]) -> bool:
        m = max(nums)
        spf = list(range(m + 1))
        for i in range(2, int(m ** 0.5) + 1):
            if spf[i] == i:
                for j in range(i * i, m + 1, i):
                    if spf[j] == j:
                        spf[j] = i                 # spf[j]

        parent = list(range(m + 1))                # nodes are values

        def find(a: int) -> int:
            while parent[a] != a:
                parent[a] = parent[parent[a]]
                a = parent[a]
            return a

        for x in nums:
            v = x                                  # factor a copy, keep x for the union
            while v > 1:
                p = spf[v]
                parent[find(x)] = find(p)
                while v % p == 0:
                    v //= p

        return all(find(a) == find(b) for a, b in zip(nums, sorted(nums)))
```

## Complexity

Time `O(M log log M + n log M + n log n)`, space `O(M)`.

## Mistakes to Avoid

- Writing `spf[i]` inside the SPF sieve.
- Modifying the original variable while factoring, so the union uses the wrong value.
- The linear sieve's inner loop must run for every `i`.

## Interview Explanation

Numbers in one component can be permuted freely through swaps, so I use an SPF sieve to union each number with its prime factors, sort the array, and check that each position's original and sorted values are in the same group. Time `O(M log log M + n log n)`.
