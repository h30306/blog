---
title: "Number Theory"
summary: "GCD, primality tests, the sieve of Eratosthenes / linear sieve / smallest prime factor (SPF), connecting numbers by prime factors with Union-Find, and splitting an array by the last occurrence of prime factors"
description: "Algorithm Learning"
date: 2026-10-20
tags: ["math", "number-theory", "prime", "sieve", "union-find", "gcd"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Introduction

Number theory in interviews mostly combines a few fixed tools:

| Tool | Use | Complexity |
|---|---|---|
| GCD (Euclid) | greatest common divisor, least common multiple | `O(log min(a, b))` |
| Trial division | primality of one number, factorization | `O(√n)` |
| Sieve | all primes / smallest prime factors up to `N` at once | `O(N log log N)` or `O(N)` |
| Prime factors + Union-Find | connectivity of "share a factor" | `O(log x)` per number with SPF |

"`gcd(a, b) > 1`" is equivalent to "**sharing a prime factor**", the key rewrite in many problems: instead of pairwise GCDs (`O(n^2)`), connect each number to its prime factors.

## Template 1: GCD and LCM

```python
def gcd(a: int, b: int) -> int:
    while b:
        a, b = b, a % b
    return a

lcm = a // gcd(a, b) * b                 # divide first to keep values small
```

Python also has `math.gcd` and `math.lcm`.

- **GCD of the smallest and largest** (LC 1979).
- **LCM of 2 and n** (LC 2413): `n` if even, `2n` if odd.

## Template 2: Primality test

```python
from math import isqrt

def is_prime(x: int) -> bool:
    if x < 2:
        return False
    if x % 2 == 0:
        return x == 2
    for d in range(3, isqrt(x) + 1, 2):
        if x % d == 0:
            return False
    return True
```

Use `isqrt` rather than `x ** 0.5` to avoid floating-point error, and test divisibility with `%`, not by comparing `x // d == x / d`.

- **Sum of primes in a range** (LC 3918), **elements at prime indices** (LC 3618).
- **The closest two primes in a range** (LC 2523): scan right from `left` and stop at a gap of 2, since nothing smaller exists apart from `[2, 3]`.

## Template 3: Sieves

**Sieve of Eratosthenes**: each prime crosses out its multiples.

```python
is_prime = [True] * (N + 1)
is_prime[0] = is_prime[1] = False
for i in range(2, isqrt(N) + 1):
    if is_prime[i]:
        for j in range(i * i, N + 1, i):
            is_prime[j] = False
```

**Smallest prime factor (SPF)**: record each number's smallest prime factor while sieving; factoring any `x <= N` then takes `O(log x)`:

```python
spf = list(range(N + 1))
for i in range(2, isqrt(N) + 1):
    if spf[i] == i:                      # i is prime
        for j in range(i * i, N + 1, i):
            if spf[j] == j:
                spf[j] = i               # spf[j], not spf[i]

def factorize(x):                        # distinct prime factors
    primes = []
    while x > 1:
        p = spf[x]
        primes.append(p)
        while x % p == 0:
            x //= p
    return primes
```

**Linear sieve**: each composite is crossed out exactly once, by its smallest prime factor, `O(N)`. The outer loop runs over **every `i`** (not only primes), and the inner loop stops when `i % p == 0`:

```python
primes, spf = [], [0] * (N + 1)
for i in range(2, N + 1):
    if spf[i] == 0:
        spf[i] = i
        primes.append(i)
    for p in primes:                     # runs for every i, not inside the if
        if i * p > N:
            break
        spf[i * p] = p
        if i % p == 0:
            break
```

- **Prime pairs summing to n** (LC 2761): after sieving, try `x` in increasing order and keep pairs where both `x` and `n - x` are prime.

### Extension: problems that only need a GCD or prime factors

- **Group size** (LC 914): groups of `X` must divide every count, so check whether the GCD of all counts is `>= 2`; comparing with the smallest count is not enough.
- **Only factors 2, 3 and 5** (LC 263): divide those primes out and check that 1 remains.
- **Powers of three** (LC 326): since 3 is prime, every divisor of `3^19` is a power of three, so test `3**19 % n == 0`.
- **Proper divisor sum** (LC 507): divisors pair up; enumerate to `√n` and add the square root once.

## Template 4: Prime factors + Union-Find

"Connected when sharing a factor": put each number in the same group as its prime factors. Either make Union-Find nodes **values** (prime factors and numbers share ids), or remember "the first index owning each prime factor" and union later owners with it:

```python
owner = {}                               # prime factor -> first index that has it
for i, x in enumerate(nums):
    for p in factorize(x):
        if p in owner:
            union(i, owner[p])
        else:
            owner[p] = i
```

- **Largest component** (LC 952), **can every pair of indices reach each other** (LC 2709), **can the array be sorted by swapping numbers that share a factor** (LC 1998: each position's value before and after sorting must be in one group).
- **Common divisors above a threshold** (LC 1627): no factoring; for each `z > threshold` connect `z, 2z, 3z, ...`, `O(n log n)` overall.

`1` has no prime factors and connects to nothing; handle it specially.

## Template 5: Last occurrence of prime factors

**Split into two parts with coprime products** (LC 2584): the products are coprime ⇔ no prime factor appears in both parts. Record each prime factor's **last index**, scan left to right tracking `reach`, the furthest any prime seen so far extends; a split right after `i` is valid when `reach == i`. This is the same idea as "partition labels".

## Key Parameters

- The sieve limit `N` is the array's maximum (or the given range).
- Trial division only needs to reach `√x`; whatever `x > 1` remains afterwards is prime.
- With values as Union-Find nodes, the arrays have size `max(nums) + 1`.

## Complexity

Trial division `O(√x)`; Eratosthenes `O(N log log N)`; linear sieve `O(N)`; factoring with SPF `O(log x)`.

## Common Mistakes

These are all mistakes I actually made while practicing:

- **Pairwise GCDs**: `O(n^2)`, TLE (LC 952, 2709, 1627).
- **Testing divisibility with `x // d == x / d`**: `2` divides itself, so 2 was judged composite (LC 3918).
- **Writing `spf[i] = i` in the SPF sieve**: it should be `spf[j] = i`; the factoring loop also modified the original `num`, so the value later passed to union was wrong (LC 1998).
- **Putting the linear sieve's inner loop inside `if prime`**: composites never cross out their multiples, so 8 was treated as prime (LC 1998, LC 4081).
- **Forgetting that `1` has no prime factors**: two 1s in `[1, 1]` cannot reach each other, but `[1]` alone is `True` (LC 2709). Starting `reach` at `-1` meant no split when the first number was 1 (LC 2584).
- **A wrong index for the closest prime pair**: `prime[i + 1] - prime[i - 1]` (LC 2523).
- **No path compression**: `find` written as `return find(parent[a])` without storing it back, three times slower on the same problem (LC 952).
- **Crossing out multiples of every number in a sieve**: only primes are needed, and the outer loop stops at `√n` (LC 204).
- **Inverting the linear sieve's condition**: a number joins the prime list when it is not composite (LC 204).
- **Judging groups by the smallest count only**: use the GCD of all counts (LC 914).

## Related LeetCode

- `LC 1979` Find Greatest Common Divisor of Array
- `LC 2413` Smallest Even Multiple
- `LC 3918` Sum of Primes Between Number and Its Reverse
- `LC 3618` Split Array by Prime Indices
- `LC 2523` Closest Prime Numbers in Range
- `LC 2761` Prime Pairs With Target Sum
- `LC 952` Largest Component Size by Common Factor
- `LC 2709` Greatest Common Divisor Traversal
- `LC 1998` GCD Sort of an Array
- `LC 1627` Graph Connectivity With Threshold
- `LC 2584` Split the Array to Make Coprime Products
- `LC 4081` Prime Subset Selection II
- `LC 204` Count Primes
- `LC 263` Ugly Number
- `LC 914` X of a Kind in a Deck of Cards
- `LC 326` Power of Three
- `LC 507` Perfect Number
