---
title: "Math"
summary: "Combinatorial counting (pairs, ways to split), building the k-th permutation digit by digit, geometry (nearest point, law of cosines, triangle inequality), and problems that become formulas after sorting or an observation"
description: "Algorithm Learning"
date: 2026-10-20
tags: ["math", "combinatorics", "geometry", "brainteaser"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Introduction

Math problems vary a lot, but a few ideas keep coming back:

| Idea | Example |
|---|---|
| Count directly instead of enumerating | pairs of equal values, ways to split |
| Decide position by position | the k-th permutation |
| Geometry formulas | nearest point, law of cosines, triangle inequality |
| Observe the structure first | take fixed positions after sorting, an answer depending only on the ends |

Primes, GCD and sieves are covered in [Number Theory]({{< relref "/algorithm/Number-Theory" >}}).

## Template 1: Combinatorial counting

**Pairing equal items**: `c` copies of a kind give `c × (c - 1) / 2` pairs. Counting while scanning is simpler:

```python
cnt = Counter()
pairs = 0
for x in items:
    pairs += cnt[x]                      # pairs with every earlier equal item
    cnt[x] += 1
```

- **Pairs of equal numbers** (LC 1512).
- **Strings equal up to a Caesar shift** (LC 3805): **normalize** each string first (shift so its first letter is `a`), making equivalent strings identical, then count pairs.

**Ways to split**: if the array must be cut into `b` indivisible blocks, each boundary between adjacent blocks may be cut or not, `2^(b - 1)` ways (LC 2963). Blocks come from "each value's last index", as in [LeetCode 2584]({{< relref "/leetcode/LeetCode-2584" >}}).

## Template 2: The k-th permutation (position by position)

Decide positions left to right: try each available character, count "how many arrangements remain after placing it here", skip it if `k` is larger (subtract that count from `k`), otherwise place it.

```python
k -= 1                                   # 0-indexed
digits = list(range(1, n + 1))
res = []
for i in range(n - 1, -1, -1):
    block = factorial(i)                 # arrangements of the remaining i numbers
    idx, k = divmod(k, block)
    res.append(digits.pop(idx))
```

- **The `k`-th permutation of `1..n`** (LC 60).
- **The `k`-th palindromic permutation** (LC 3518): a palindrome is determined by its left half, making this "the `k`-th permutation of a multiset". The remaining count is `total! / Π cnt!`, and after placing character `c` it becomes `current count × cnt[c] / remaining length`, an `O(1)` update.

## Template 3: Geometry

- **Do a circle and a rectangle overlap** (LC 1401): the rectangle's nearest point to the center is the center **clamped** into the rectangle; compare its distance with the radius:

```python
nx = min(max(xc, x1), x2)
ny = min(max(yc, y1), y2)
overlap = (nx - xc) ** 2 + (ny - yc) ** 2 <= r * r
```

- **Angles of a triangle** (LC 3899): check the triangle inequality first, then use the law of cosines `cos A = (b² + c² - a²) / 2bc`.
- **Largest perimeter triangle** (LC 976): after sorting, sides `a <= b <= c` form a triangle ⇔ `a + b > c`. Check consecutive triples from the largest down; the first valid one is the answer.

## Template 4: Observe the structure first

- **Three equal binary parts** (LC 927): every part has the same number of 1s, so count them first. The third part always ends at the array's end (trailing zeros belong to it), so it fixes every part's length.
- **Picking triples for medians** (LC 3627): after sorting, each step takes the two largest and the smallest, and the median is the second largest; the answer takes every other value from the end.
- **The last remaining element** (LC 3828): Alice's first move can delete everything but the first or the last element, and so can Bob's, so the answer is `max(first, last)`.
- **Sensor coverage** (LC 3648): each sensor covers a width of `2k + 1`, so take a **ceiling division** in each direction and multiply.

## Key Parameters

- Ceiling division: `-(-a // b)` or `(a + b - 1) // b`, never floating point.
- Count permutations with integers; Python's big integers are fine, other languages need overflow care or a modulus.

## Complexity

Mostly `O(n)`, or `O(n log n)` with sorting; the `k`-th multiset permutation is `O(n · alphabet)`.

## Common Mistakes

These are all mistakes I actually made while practicing:

- **The all-zeros case**: with no 1s, any split into three parts works (LC 927).
- **The wrong middle character of a palindrome**: a character appearing 3 times is odd too and goes in the middle (LC 3518).
- **Not removing used digits for the `k`-th permutation** (LC 60).
- **Ceiling division as `a // b + 1`**: one too many when it divides evenly (LC 3648).
- **A geometry comparison pointing the wrong way**: with the center above the rectangle the top edge matters, but the condition used `<` (LC 1401).
- **Forgetting to sort the output** (LC 3899).
- **`pop(0)` from the front**: `O(n)` each time, TLE (LC 3627).

## Related LeetCode

- `LC 1512` Number of Good Pairs
- `LC 3805` Count Caesar Cipher Pairs
- `LC 2963` Count the Number of Good Partitions
- `LC 60` Permutation Sequence
- `LC 3518` Smallest Palindromic Rearrangement II
- `LC 1401` Circle and Rectangle Overlapping
- `LC 3899` Angles of a Triangle
- `LC 976` Largest Perimeter Triangle
- `LC 927` Three Equal Parts
- `LC 3627` Maximum Median Sum of Subsequences of Size 3
- `LC 3828` Final Element After Subarray Deletions
- `LC 3648` Minimum Sensors to Cover Grid
