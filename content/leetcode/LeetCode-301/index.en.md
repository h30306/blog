---
title: "LeetCode 301: Remove Invalid Parentheses"
summary: "LeetCode 301 note: compute the minimum left and right deletions before backtracking, or BFS one deletion per level and stop at the first valid level"
description: "LeetCode 301 record from 2026-09-10"
date: 2026-09-10
tags: ["hard", "backtracking", "bfs", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-09-10
- Submissions: Time Limit Exceeded → Accepted ×2 (backtracking) → Accepted ×2 (BFS)

## Approach

Delete the **fewest** parentheses to make the string valid, and return every possible result.

### Step 1: compute the minimum deletions

Scan left to right with a counter of unmatched `(`:

- `(`: increment the counter.
- `)`: if there is an unmatched `(`, match it and decrement; otherwise this `)` must be deleted, so `r_rem += 1`.
- After the scan, the remaining unmatched `(` count is `l_rem`.

### Step 2: backtrack, deleting exactly `l_rem` `(` and `r_rem` `)`

Each parenthesis can be deleted or kept:

- Delete: only while the matching budget remains.
- Keep a `)`: only if more `(` than `)` have been kept so far; otherwise the prefix is already invalid.

At the end, if both budgets are used up exactly, record the string. A set removes duplicates.

## My Attempt: no deletion budget, TLE

The first version tried deleting or keeping every character and compared deletion counts only at the end. That enumerates all `2^n` subsequences, too slow at `n = 25`.

Computing `l_rem` and `r_rem` first lets branches that cannot be minimal be pruned early.

## Solution 1: backtracking with deletion budgets

```python
class Solution:
    def removeInvalidParentheses(self, s: str) -> List[str]:
        l_rem = r_rem = 0
        for ch in s:
            if ch == "(":
                l_rem += 1
            elif ch == ")":
                if l_rem > 0:
                    l_rem -= 1
                else:
                    r_rem += 1

        n = len(s)
        res = set()

        def backtrack(i: int, cur: str, open_count: int, l_rem: int, r_rem: int) -> None:
            if i == n:
                if l_rem == 0 and r_rem == 0:
                    res.add(cur)
                return
            ch = s[i]
            if ch == "(" and l_rem > 0:
                backtrack(i + 1, cur, open_count, l_rem - 1, r_rem)        # delete
            if ch == ")" and r_rem > 0:
                backtrack(i + 1, cur, open_count, l_rem, r_rem - 1)        # delete
            if ch == "(":
                backtrack(i + 1, cur + ch, open_count + 1, l_rem, r_rem)   # keep
            elif ch == ")":
                if open_count > 0:
                    backtrack(i + 1, cur + ch, open_count - 1, l_rem, r_rem)
            else:
                backtrack(i + 1, cur + ch, open_count, l_rem, r_rem)

        backtrack(0, "", 0, l_rem, r_rem)
        return list(res)
```

`open_count` is "kept `(` minus kept `)`"; my original code used two counters, `l_count` and `r_count`, for the same thing.

## Solution 2: BFS, one deletion per level

```python
class Solution:
    def removeInvalidParentheses(self, s: str) -> List[str]:
        def is_valid(t: str) -> bool:
            count = 0
            for ch in t:
                if ch == "(":
                    count += 1
                elif ch == ")":
                    count -= 1
                    if count < 0:
                        return False
            return count == 0

        level = {s}
        while level:
            valid = [t for t in level if is_valid(t)]
            if valid:
                return valid
            level = {t[:i] + t[i + 1:] for t in level for i in range(len(t)) if t[i] in "()"}
        return [""]
```

Level `k` holds every string with `k` parentheses removed, so the first level containing a valid string has the minimum deletions. This version ran much faster than backtracking (61ms vs 1356ms), because the minimum deletion count is usually small and the BFS stops early.

## Complexity

Both are exponential in the worst case, `O(2^n · n)`. In practice, backtracking prunes with the budgets and BFS stops early.

## Mistakes to Avoid

- Enumerating every subsequence without first computing the minimum deletions.
- Keeping a `)` without checking that the prefix is still valid.
- Not deduplicating: deleting either of two adjacent identical parentheses gives the same string.

## Interview Explanation

One scan gives the minimum number of `(` and `)` to delete: every unmatched `)` must go, and so must every `(` left unmatched at the end. Then I backtrack: a parenthesis may be deleted while its budget remains, or kept (a `)` only if there is an unmatched `(` before it), and strings that end with both budgets at zero go into a set. Alternatively, BFS deletes one parenthesis per level and returns the first level with a valid string.
