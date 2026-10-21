---
title: "LeetCode 1410: HTML Entity Parser"
summary: "LeetCode 1410 note: scan left to right, trying all six entities at each position and skipping past a match; chained replace does not work"
description: "LeetCode 1410 record from 2025-07-15"
date: 2025-07-15
tags: ["medium", "hash-table", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-07-15
- Submissions: Wrong Answer → Runtime Error ×2 → Accepted

## Approach

Scan left to right, trying the six entities at each position with `startswith` ([String]({{< relref "/algorithm/String" >}}) Template 2):

- On a match, output the character and jump `i` past the entity.
- Otherwise output the original character and `i += 1`.

Output is never rescanned, so a replacement cannot combine with what follows into a new entity.

## My Attempts

1. **Attempt 1** chained `replace` calls. `"&amp;gt;"` should become `"&gt;"`, but after `&amp;` turns into `&`, it joins the following `gt;` into a new `&gt;` that becomes `>`.
2. **Attempts 2 and 3** used two pointers to look ahead for `;` without a bound check: with `&` at the end, `text[right]` went out of range, so `"&"` raised IndexError.
3. Adding `right < len(text)` passed.

## Solution

```python
class Solution:
    def entityParser(self, text: str) -> str:
        table = {"&quot;": '"', "&apos;": "'", "&amp;": "&",
                 "&gt;": ">", "&lt;": "<", "&frasl;": "/"}
        out, i = [], 0
        while i < len(text):
            for pattern, ch in table.items():
                if text.startswith(pattern, i):
                    out.append(ch)
                    i += len(pattern)
                    break
            else:
                out.append(text[i])
                i += 1
        return "".join(out)
```

## Complexity

Time `O(n · E)` with `E` the total entity length (a constant), space `O(n)`.

## Mistakes to Avoid

- Do not chain `replace`; one replacement's output is visible to the next.
- Check bounds before looking ahead; `startswith` handles it for you.

## Interview Explanation

I scan left to right and try to match the six entities at each position, outputting the character and skipping the entity on a match, or the original character otherwise. Output is never rescanned, so there is none of the chained-`replace` problem where a produced `&` forms a new entity. Time `O(n)`.
