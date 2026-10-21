---
title: "Math"
summary: "Combinatorial counting (pairs, ways to split), building the k-th permutation digit by digit, geometry (nearest point, law of cosines, triangle inequality), problems that become formulas after sorting or an observation, plus carry arithmetic, base conversion and fast exponentiation"
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

## Template 5: Digits and simple formulas

**Extracting digits**: converting to a string is simplest; `% 10` and `// 10` also work, starting from the ones place:

```python
digits = [int(c) for c in str(n)]        # most significant first

while n:                                 # ones place first
    d = n % 10
    n //= 10
```

- **Digit sum / product** (LC 3550, 1281, 3622), **sum of squared digits** (LC 3959: each digit adds `d² - d >= 0`, so the total only grows and can return early once it qualifies).
- **The product of the two largest digits** (LC 3536), **how often a digit appears** (LC 3895, 3908).
- **Writing n as a sum of `d × 10^k` terms** (LC 3697): every non-zero digit is one term.

**Plain formulas**: `min(n², maxWeight // w)` (LC 3492), temperature conversion (LC 2469), `n` distinct integers summing to 0 (LC 1304: `1..n/2` and their negatives, plus 0 when `n` is odd), XOR of an arithmetic sequence (LC 1486).

## Template 6: Column addition and multiplication (carries)

When numbers come as strings or arrays and cannot be converted to integers, compute column by column from the lowest digit:

```python
i, j, carry, res = len(a) - 1, len(b) - 1, 0, []
while i >= 0 or j >= 0 or carry:         # carry in the condition keeps the final one
    x = int(a[i]) if i >= 0 else 0
    y = int(b[j]) if j >= 0 else 0
    carry, d = divmod(x + y + carry, 10)
    res.append(str(d))
    i, j = i - 1, j - 1
return "".join(reversed(res))
```

- **Plus one** (LC 66): from the last digit, a non-9 increments and returns, a 9 becomes 0; prepend 1 when all were 9.
- **Array plus integer** (LC 989): treat all of `k` as the carry: `k += num[i]`, take `k % 10`, then `k //= 10`.
- **String multiplication** (LC 43): add `a[i] * b[j]` into `res[i + j + 1]`, carry once at the end, and strip leading zeros.

## Template 7: Base conversion

```python
digits = []
while n:
    n, r = divmod(n, base)
    digits.append(r)                     # lowest digit first
digits.reverse()
```

- **Base 7** (LC 504): work on the absolute value and add the sign last; handle `0` separately.
- **Excel columns** (LC 168, 171): digits are `1..26` with no zero, so each step uses `divmod(n - 1, 26)`. The reverse is `res = res * 26 + value`.
- **Reversing digits** (LC 7, 9): `rev = rev * 10 + n % 10`. For palindromes reverse only the second half, until `rev >= n`.

## Template 8: Fast exponentiation

```python
def power(x, n):
    res = 1
    while n:
        if n & 1:                        # this bit is 1: multiply it in
            res *= x
        x *= x                           # x^(2^k)
        n >>= 1
    return res
```

`O(log n)` multiplications. For a negative exponent switch to `1 / x` and `-n` (LC 50). Under a modulus, apply `% MOD` after each multiplication.

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
- **`/` producing a float**: the answer must be an integer, so use `//` (LC 3492).
- **Comparing strings with integers**, and **not moving the old maximum to second place when a new maximum appears** (LC 3536).
- **Modulo the wrong way around**: `(sum + prod) % n` should be `n % (sum + prod)` (LC 3622).
- **An extra 0 for even `n`** (LC 1304).
- **`^` is XOR, not a power**: powers are `**`, and `10**len - 1 - i` needs parentheses (LC 66).
- **`str(n).split()` does not split into digits**: it splits on whitespace; use `list(str(n))` (LC 66, 989).
- **Dropping the final carry**, or appending the last sum instead of the carry (LC 415).
- **Multiplying only digits at matching positions**: each digit multiplies every digit of the other number (LC 43).
- **Subtracting 1 only for the Excel letter**: the step forward needs `n - 1` too (LC 168).
- **Not restoring the minus sign after reversing a negative** (LC 7).
- **Testing multiples with `//`**: `i // 15 == 0` means "less than 15" (LC 412).

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
- `LC 3492` Maximum Containers on a Ship
- `LC 3536` Maximum Product of Two Digits
- `LC 3550` Smallest Index With Digit Sum Equal to Index
- `LC 3622` Check Divisibility by Digit Sum and Product
- `LC 1304` Find N Unique Integers Sum up to Zero
- `LC 3697` Compute Decimal Representation
- `LC 2469` Convert the Temperature
- `LC 2235` Add Two Integers
- `LC 1486` XOR Operation in an Array
- `LC 1281` Subtract the Product and Sum of Digits of an Integer
- `LC 3908` Valid Digit Number
- `LC 3959` Check Good Integer
- `LC 3895` Count Digit Appearances
- `LC 66` Plus One
- `LC 9` Palindrome Number
- `LC 7` Reverse Integer
- `LC 415` Add Strings
- `LC 43` Multiply Strings
- `LC 989` Add to Array-Form of Integer
- `LC 168` Excel Sheet Column Title
- `LC 171` Excel Sheet Column Number
- `LC 504` Base 7
- `LC 258` Add Digits
- `LC 13` Roman to Integer
- `LC 412` Fizz Buzz
- `LC 50` Pow(x, n)
