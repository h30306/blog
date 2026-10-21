---
title: "Hash Table"
summary: "Counting and frequency of frequencies, using the array itself as a hash table (sign marking), counting several keys at once (rows, columns, diagonals), incremental counts from a fixed left end, and grouping by a normalized key"
description: "Algorithm Learning"
date: 2026-10-21
tags: ["hash-table", "counting", "array"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Introduction

A hash table makes "have I seen this, and how many times?" `O(1)`. Most problems just replace an `O(n)` linear search with a hash lookup; the key is **choosing the right key**:

| Idea | The key | Examples |
|---|---|---|
| Counting | The value | Counts divisible by `k`, odd counts |
| Frequency of frequencies | The count | First element with a unique count |
| The array as a hash table | `index = value - 1` | First missing positive, duplicates |
| Several keys | Row, column, `r - c`, `r + c` | Cells lit by lamps |
| Normalized key | Sorted string, prefix | Anagrams, same first `k` characters |

## Template 1: Counting and frequency of frequencies

```python
from collections import Counter

cnt = Counter(nums)                      # value -> count
freq_of_freq = Counter(cnt.values())     # count -> how many values have it
for x in nums:                           # first one from the left
    if freq_of_freq[cnt[x]] == 1:
        return x
```

- **Sum of elements whose count is divisible by `k`** (LC 3712): `sum(x * c for x, c in cnt.items() if c % k == 0)`.
- **First element with a unique count** (LC 3843): the code above.
- **Toggling bulbs** (LC 3842): bulbs toggled an odd number of times stay on; toggle in a set or count parity, then sort.
- **Groups with the same first `k` characters** (LC 3839): the key is `word[:k]`, and words shorter than `k` do not count.
- **Three-digit even numbers from given digits** (LC 2094): enumerate the even numbers 100 to 998 instead and check that the digits needed are available. `Counter` subtraction keeps only positives, so `not (need - have)` means "enough".
- **Missing numbers in a range** (LC 3731): convert to a set first so lookups are `O(1)`.

## Template 2: The array itself as a hash table

When values lie in `[1, n]`, the **sign** of `nums[v - 1]` can record "`v` was seen" with no extra space:

```python
for x in nums:
    i = abs(x) - 1                       # the value may already be negated
    if nums[i] < 0:
        ...                              # i + 1 appears a second time
    else:
        nums[i] = -nums[i]
```

- **Numbers appearing twice** (LC 442): the code above.
- **Missing numbers** (LC 448): after marking everything, each `i` still positive means `i + 1` never appeared.
- **First missing positive** (LC 41): the answer is in `1..n + 1`. Replace values `<= 0` with `n + 1` (**not 0**: negating 0 gives 0, so it cannot be marked), mark `1..n`, and the first position `i` still positive gives the answer `i + 1`.

### Extension: complement lookups, run starts, voting

- **Two Sum** (LC 1): store "value → index", **checking `target - x` before storing `x`**, so no element pairs with itself.
- **Longest consecutive sequence** (LC 128): put everything in a set and count upward only from starts whose `x - 1` is absent, in `O(n)`.
- **Majority element** (LC 169, 229): Boyer-Moore voting, where different values cancel; above `n / 3`, keep two candidates and recount at the end.

## Template 3: Counting several keys at once

A lamp lights its row, column, and both diagonals. Keep a counter for each; cells on one diagonal share `r - c` and on the anti-diagonal share `r + c`:

```python
row, col, diag, anti = Counter(), Counter(), Counter(), Counter()
on = set()
for r, c in lamps:
    if (r, c) not in on:                 # the same lamp can repeat
        on.add((r, c))
        row[r] += 1; col[c] += 1; diag[r - c] += 1; anti[r + c] += 1
lit = row[qr] or col[qc] or diag[qr - qc] or anti[qr + qc]   # is query (qr, qc) lit?
```

Turning a lamp off decrements all four counters, and only for lamps that are actually on (LC 1001).

## Template 4: Fixed left end, incremental counts

With a small `n`, fix the left end and extend right; each new number updates `O(1)` counts:

```python
for i in range(n):
    cnt, freq = {}, Counter()            # value -> count, count -> how many
    for j in range(i, n):
        c = cnt.get(nums[j], 0)
        if c:
            freq[c] -= 1
            if freq[c] == 0:
                del freq[c]              # delete so len(freq) is the number of distinct counts
        cnt[nums[j]] = c + 1
        freq[c + 1] += 1
```

- **Only counts `f` and `2f`** (LC 3960): `len(freq) == 2 and max(freq) == 2 * min(freq)`, or a single value.

## Template 5: Normalize, then use as the key

- **Anagrams** (LC 2273): equal `sorted(word)` means anagrams. Repeatedly deleting a word that is an anagram of the previous one is the same as keeping only words that are not anagrams of the last kept word.
- **Custom sort** (LC 3606): filter the valid ones, then sort by `(category order, code)`.
- **Grouping** (LC 49): use `"".join(sorted(s))` as the key in a `defaultdict(list)`. `set(s)` does not work: `"bb"` and `"b"` share a set.
- **Bijection** (LC 205, 290): `len(set(a)) == len(set(b)) == len(set(zip(a, b)))`. When encoding with first-occurrence indices, separate the numbers.

### Counter Arithmetic

| Expression | Meaning | Examples |
|---|---|---|
| `not (Counter(a) - Counter(b))` | `b` covers every character of `a` | LC 383, 1160, 748 |
| `c1 & c2` | per-character minimum | LC 1002 |
| `min(cnt[c] // need[c] for c in need)` | how many copies can be built | LC 1189 |

## Key Parameters

- Looking up a missing key in a `Counter` returns 0 **without** inserting it; a `defaultdict` lookup inserts.
- Delete a count when it reaches 0 so `len()` is the number of kinds.

## Complexity

Building is `O(n)`; each lookup is `O(1)` on average.

## Common Mistakes

These are mistakes I actually made while practicing:

- **Using `in` on a list**: `O(n)` each time, `O(n²)` overall, TLE (LC 442).
- **Using 0 as the "impossible" value**: negating 0 gives 0, so it cannot be marked, and with everything present the answer is `n + 1` (LC 41).
- **The wrong counter after copy-paste**: querying `row_count[col]` and decrementing `row_count[nc]` when turning off, so the column counts were never right (LC 1001).
- **Looking up with the wrong key**: checking a count against the "value -> count" table (LC 3960).
- **The wrong variable in a repeat check**: with `j == k` the check should be `counter[j]`; I wrote `counter[i]` (LC 2094).
- **Forgetting to sort**: a set converted to a list has no order (LC 3842).
- **Counting words that are too short**: `word[:k]` shorter than `k` cannot form a group (LC 3839).
- **A character range missing its last letter**: `range(ord("a"), ord("z"))` excludes `z`; I also had the sort key in the wrong order (LC 3606).
- **`d.get(x, 0) + 1` without storing it**: the map stays empty (LC 242).
- **Checking only that the counts sum to 0**: positives and negatives cancel; check each one (LC 242).
- **Reading a `Counter` difference backwards**: a non-empty difference means a shortfall (LC 383).
- **Using `set` for anagrams or common characters**: it drops multiplicity (LC 49, 1002).
- **Storing and reading keys in different cases**: store `B`, look up `b`, never found (LC 748, 3121).
- **Turning a list into a `set` before searching**: order is lost, so "earliest on ties" is impossible (LC 748).
- **Index encodings without a separator**: `1` + `12` and `11` + `2` both read `112` (LC 205).
- **Filtering by raw count before dividing**: when `l` is needed twice, compare `cnt // 2` (LC 1189).
- **Finding indices with `nums.index(x)` in Two Sum**: equal values get the same index (LC 1).
- **Inverted conditions**: `len(set(nums)) == len(nums)` means "no duplicate" (LC 217); two limits need `min`, not `max` (LC 575).
- **Taking only `most_common()[0]`**: several values may share the highest count (LC 697).
- **Ordering leftovers by frequency**: they go in ascending order, keeping multiplicities (LC 1122).
- **Lists as dict keys**: use tuples, normalized in order first (LC 1128).
- **Overwriting the length and ignoring duplicates when scanning sorted runs** (LC 128).
- **`round(n / 2)` uses banker's rounding in Python 3**: take the middle with `n // 2` (LC 169).

## Related LeetCode

- `LC 41` First Missing Positive
- `LC 442` Find All Duplicates in an Array
- `LC 1001` Grid Illumination
- `LC 3712` Sum of Elements With Frequency Divisible by K
- `LC 3843` First Element with Unique Frequency
- `LC 3960` Frequency Balance Subarray
- `LC 2094` Finding 3-Digit Even Numbers
- `LC 3731` Find Missing Elements
- `LC 3842` Toggle Light Bulbs
- `LC 3839` Number of Prefix Connected Groups
- `LC 3606` Coupon Code Validator
- `LC 2273` Find Resultant Array After Removing Anagrams
- `LC 594` Longest Harmonious Subsequence
- `LC 219` Contains Duplicate II
- `LC 187` Repeated DNA Sequences
- `LC 242` Valid Anagram
- `LC 49` Group Anagrams
- `LC 383` Ransom Note
- `LC 1189` Maximum Number of Balloons
- `LC 1160` Find Words That Can Be Formed by Characters
- `LC 1002` Find Common Characters
- `LC 771` Jewels and Stones
- `LC 884` Uncommon Words from Two Sentences
- `LC 819` Most Common Word
- `LC 409` Longest Palindrome
- `LC 3120` Count the Number of Special Characters I
- `LC 3121` Count the Number of Special Characters II
- `LC 748` Shortest Completing Word
- `LC 290` Word Pattern
- `LC 205` Isomorphic Strings
- `LC 1` Two Sum
- `LC 217` Contains Duplicate
- `LC 575` Distribute Candies
- `LC 169` Majority Element
- `LC 229` Majority Element II
- `LC 961` N-Repeated Element in Size 2N Array
- `LC 448` Find All Numbers Disappeared in an Array
- `LC 128` Longest Consecutive Sequence
- `LC 1122` Relative Sort Array
- `LC 697` Degree of an Array
- `LC 1128` Number of Equivalent Domino Pairs
