---
title: "String"
summary: "Simulation by building a list, parsing by trying every pattern at each position, all substrings of length k, counting by character class, checking balanced substrings from a fixed start, and splitting into words"
description: "Algorithm Learning"
date: 2026-10-21
tags: ["string", "simulation", "hash-table"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Introduction

Most string problems need no special algorithm; the hard part is **details**: index bounds, the order of operations, and immutable Python strings. A few fixed patterns:

| Form | How | Examples |
|---|---|---|
| Simulation | Build the result in a list used as a stack, `join` at the end | Special-character operations, merging close characters |
| Parsing | Try every pattern at each position, skip past a match | HTML entities |
| Substrings of length `k` | Enumerate starts, collect in a set | All binary codes, three equal digits |
| Character classes | Count vowels / consonants / digits separately | Most frequent vowel and consonant, sorting vowels |
| Fixed start, extend right | Maintain counts incrementally | Every character with the same count |
| Split into words | Process each word after `split()` | Last word, Goat Latin, most common word |

DP on strings (LCS, edit distance) is in [String DP]({{< relref "/algorithm/String-DP" >}}).

## Template 1: Simulate with a list

Python strings are immutable, so `s += c` copies every time. Build a list and `"".join` at the end:

```python
res = []
for ch in s:
    if ch == "*":
        if res:                          # check inside, not as ch == "*" and res
            res.pop()
    elif ch == "#":
        res += res
    elif ch == "%":
        res.reverse()
    else:
        res.append(ch)
return "".join(res)
```

- **Special-character operations** (LC 3612): the code above.
- **Merging close equal characters** (LC 4019): kept characters never change again, so record each character's last position **in the result**; a new character within `k` of it is dropped.
- **Largest even number** (LC 3798): keep deleting trailing 1s.

## Template 2: Try matching at each position

```python
i, out = 0, []
while i < len(text):
    for pattern, rep in table.items():
        if text.startswith(pattern, i):  # never goes out of range
            out.append(rep)
            i += len(pattern)
            break
    else:
        out.append(text[i])
        i += 1
```

- **HTML entities** (LC 1410): a chain of `replace` calls does not work: an `&` produced by one replacement can form a new entity with what follows.
- **`s + s` contains every rotation** (LC 796, 459): `goal` is a rotation of `s` ⇔ equal lengths and `goal in s + s`; `s` has a repeating period ⇔ `s in (s + s)[1:-1]`.

## Template 3: All substrings of length `k`

```python
seen = {s[i:i + k] for i in range(len(s) - k + 1)}   # the last start is len(s) - k
```

- **All binary codes of length `k`** (LC 1461): the set must reach `2^k`; with fewer than `2^k` substrings (`len(s) - k + 1`) it cannot.
- **Three equal digits** (LC 2264): only 10 candidates; check `in num` from `"999"` down.

## Template 4: Counting by character class

```python
vowels = set("aeiou")
cnt = Counter(s)
best_vowel = max((cnt[c] for c in vowels), default=0)
best_consonant = max((v for c, v in cnt.items() if c not in vowels), default=0)
```

- **Most frequent vowel plus most frequent consonant** (LC 3541): the code above.
- **Vowel-to-consonant score** (LC 3813): count letters only; spaces and digits do not count.
- **Sorting vowels by frequency** (LC 3913): extract only the vowels, sort by `(-count, first occurrence)`, and put them back into the vowel positions.
- **Distinct characters in each prefix** (LC 3803): add each character to a set while scanning.
- **Adjacent digit differences** (LC 3931): compare neighbors directly.

## Template 5: Fixed start, extend right

```python
for i in range(n):
    cnt = Counter()
    max_freq = 0
    for j in range(i, n):
        cnt[s[j]] += 1
        max_freq = max(max_freq, cnt[s[j]])
        if max_freq * len(cnt) == j - i + 1:     # every character appears max_freq times
            best = max(best, j - i + 1)
```

- **Every character with the same count** (LC 3713): "all equal" means "highest count × number of kinds = length", an `O(1)` check per step.

## Template 6: Split into words, then process

```python
words = s.split()                      # no argument: runs of spaces are one separator, ends trimmed
res = []
for i, w in enumerate(words):
    res.append(transform(w, i))
return " ".join(res)
```

- **Counting words, the last word** (LC 434, 58): `len(s.split())`, `s.split()[-1]`. `split(" ")` produces empty strings for consecutive or trailing spaces.
- **Per-word transforms** (LC 824, 557): handle each word separately, with `enumerate` when the position matters.
- **Consecutive words** (LC 1078): when checking `words[i]` and `words[i + 1]`, loop only to `len(words) - 2`.
- **Normalize, then split** (LC 819, 929): **replace** punctuation with spaces before splitting; for emails, split at `@`, process only the first half, and keep the `@` when rejoining.

## Key Parameters

- `s[i:j]` excludes `j`; the last start of a length-`k` substring is `len(s) - k`.
- `str.startswith(p, i)` matches from `i` and returns `False` past the end instead of raising.

## Complexity

Simulation and counting are `O(n)`; collecting all length-`k` substrings is `O(n · k)`; fixed start and extend is `O(n²)`.

## Common Mistakes

These are mistakes I actually made while practicing:

- **Chained `replace`**: `"&amp;gt;"` became `"&gt;"` and then `">"` (LC 1410).
- **Looking ahead without a bound check**: with `&` at the end, `text[right]` went out of range (LC 1410).
- **Writing the condition as `ch == "*" and res`**: with an empty result the condition fails and `*` falls through to the final `else`, getting appended (LC 3612).
- **An off-by-one substring range**: `s[right - k: right]` never collected the last window (LC 1461).
- **Converting original indices to current positions**: miscounting deletions gives wrong distances; recording positions in the result is simpler (LC 4019).
- **An unnecessary extra loop**: also enumerating 26 "numbers of kinds" outside caused TLE (LC 3713).
- **Taking the last word with `split(" ")`**: trailing spaces yield an empty string (LC 58).
- **Deleting punctuation instead of replacing it with spaces**: `a'a` becomes `aa` (LC 819).
- **Losing the separator when rejoining**: `"a@bx.com"` and `"ab@x.com"` join into the same string (LC 929).
- **Bound-checking `i + 1` but reading `i + 2`** (LC 1078).
- **Counting digits as consonants**: a consonant must be a letter (LC 3136).
- **Slicing a single character**: in `for c in s`, `c[:3]` is always one character (LC 551).
- **An off-by-one counter when grouping every `k` from the back**, or a stray separator (LC 482).
- **Returning nothing when the loop finishes**: if the whole shortest string is the common prefix, it returns `None` (LC 14).
- **`goal in s + s` without checking equal lengths**: `"aa"` is inside `"a" + "a"` (LC 796).
- **Comparing a tuple with a list**: `zip` yields tuples and `sorted` returns lists, so `==` is always `False` (LC 944).
- **Lexicographic order depends only on the first differing character**, and a shorter prefix must come first: `["ll", "l"]` is unsorted (LC 953).
- **Resetting a run to 0**: the new character is itself a run of 1 (LC 1446).
- **Comparing characters with integers**: `'1' == 1` is always `False` (LC 1869).
- **Wrapping when the line is exactly full**: width 100 stays on the line (LC 806).
- **Identical strings still need one swap**: impossible without a repeated character (LC 859).

## Related LeetCode

- `LC 1410` HTML Entity Parser
- `LC 3803` Count Residue Prefixes
- `LC 4019` Merge Close Characters II
- `LC 1461` Check If a String Contains All Binary Codes of Size K
- `LC 3541` Find Most Frequent Vowel and Consonant
- `LC 3713` Longest Balanced Substring I
- `LC 2264` Largest 3-Same-Digit Number in String
- `LC 3798` Largest Even Number
- `LC 3931` Check Adjacent Digit Differences
- `LC 3612` Process String with Special Operations I
- `LC 3813` Vowel-Consonant Score
- `LC 3913` Sort Vowels by Frequency
- `LC 28` Find the Index of the First Occurrence in a String
- `LC 187` Repeated DNA Sequences
- `LC 696` Count Binary Substrings
- `LC 821` Shortest Distance to a Character
- `LC 819` Most Common Word
- `LC 929` Unique Email Addresses
- `LC 804` Unique Morse Code Words
- `LC 434` Number of Segments in a String
- `LC 599` Minimum Index Sum of Two Lists
- `LC 482` License Key Formatting
- `LC 520` Detect Capital
- `LC 824` Goat Latin
- `LC 1078` Occurrences After Bigram
- `LC 58` Length of Last Word
- `LC 1108` Defanging an IP Address
- `LC 500` Keyboard Row
- `LC 709` To Lower Case
- `LC 3136` Valid Word
- `LC 551` Student Attendance Record I
- `LC 14` Longest Common Prefix
- `LC 796` Rotate String
- `LC 859` Buddy Strings
- `LC 944` Delete Columns to Make Sorted
- `LC 953` Verifying an Alien Dictionary
- `LC 1446` Consecutive Characters
- `LC 1869` Longer Contiguous Segments of Ones than Zeros
- `LC 459` Repeated Substring Pattern
- `LC 521` Longest Uncommon Subsequence I
- `LC 657` Robot Return to Origin
- `LC 806` Number of Lines To Write String
