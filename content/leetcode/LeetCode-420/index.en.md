---
title: "LeetCode 420: Strong Password Checker"
summary: "LeetCode 420 note: three length cases; when too long, delete from runs with len % 3 == 0 first to cancel replacements"
description: "LeetCode 420 record from 2026-09-02"
date: 2026-09-02
tags: ["hard", "greedy", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-09-02
- Submissions: Wrong Answer → Runtime Error ×3 → Wrong Answer → Accepted

## Approach

Three conditions: length 6 to 20, contains a lowercase letter, an uppercase letter, and a digit, and no three identical characters in a row. You may insert, delete, or replace.

First compute two things:

- `missing`: how many character types are missing, 0 to 3.
- The length `L` of each run of identical characters (only runs with `L >= 3`). Fixing a run of length `L` by replacement takes `L // 3` replacements.

Then split by length:

**1. Length < 6**: you must insert `6 - n` characters. Insertions can add missing types and break runs at the same time, so the answer is `max(6 - n, missing)`.

**2. Length 6 to 20**: no insertions or deletions needed. Each replacement can break a run and add a type, so the answer is `max(replacements, missing)`.

**3. Length > 20**: you must delete `n - 20` characters. Deletions also reduce the replacements needed; the key is **where deleting pays off most**:

- Runs with `L % 3 == 0`: deleting **1** character saves 1 replacement (e.g. 3 → 2 needs 0 instead of 1).
- Runs with `L % 3 == 1`: deleting **2** saves 1 replacement.
- Everything else: every **3** deletions save 1 replacement.

Spend the deletion budget on these three in order. The answer is `(n - 20) + max(remaining replacements, missing)`.

## My Attempts

### Attempt 1: the wrong model

It counted repeats with a stack and combined them in one formula, without separating the three length cases or using deletions to cancel replacements.

### Runtime Error ×3: typos in variable names

After switching to case analysis, three REs in a row:

1. Using `remainDelete` before defining it.
2. Changing it to `remainDelete = maxDelete`, then misspelling `missingType` on the next line.
3. `max(replaceCount + missingTypes)`: `max` was given a single int.

### Wrong Answer: the remaining deletion budget

```python
remainDelete = maxDelete              # should be deleteCount - maxDelete
```

After using `maxDelete` deletions, the remaining budget is "total deletions minus those used", not "the number used".

## Solution

```python
class Solution:
    def strongPasswordChecker(self, password: str) -> int:
        n = len(password)
        missing = 3 - (any(c.islower() for c in password)
                       + any(c.isupper() for c in password)
                       + any(c.isdigit() for c in password))

        repeats = []
        i = 0
        while i < n:
            j = i
            while j < n and password[j] == password[i]:
                j += 1
            if j - i >= 3:
                repeats.append(j - i)
            i = j

        if n < 6:
            return max(6 - n, missing)

        replace = sum(L // 3 for L in repeats)
        if n <= 20:
            return max(replace, missing)

        delete = n - 20
        remain = delete
        mod0 = sum(1 for L in repeats if L % 3 == 0)
        mod1 = sum(1 for L in repeats if L % 3 == 1)

        used = min(remain, mod0)              # 1 deletion per run saves 1 replacement
        replace -= used
        remain -= used

        used = min(remain, mod1 * 2)          # 2 deletions per run save 1 replacement
        replace -= used // 2
        remain -= used

        replace -= remain // 3                # every other 3 deletions save 1
        return delete + max(replace, missing)
```

`replace` can drop below zero, but it is compared with `missing` (at least 0) at the end, so the answer is unaffected.

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Trying to solve it with one formula instead of three length cases.
- Not spending deletions in `L % 3` priority order.
- Setting the remaining budget to "the amount used".
- Renaming a variable without checking every use.

## Interview Explanation

I count the missing character types and the runs of length at least 3. Below length 6, insertions add types and break runs at once, so the answer is `max(6 - n, missing)`; between 6 and 20 it is `max(replacements, missing)`. Above 20, `n - 20` deletions are mandatory, and they reduce replacements: first runs with `L % 3 == 0` (1 deletion saves 1), then `L % 3 == 1` (2 save 1), then every 3 deletions save 1. The answer adds the deletions to `max(remaining replacements, missing)`. Time `O(n)`.
