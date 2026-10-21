---
title: "LeetCode 929: Unique Email Addresses"
summary: "LeetCode 929 note: split at @, normalize only the local part (drop everything after +, remove dots), rejoin with the domain and collect in a set"
description: "LeetCode 929 record from 2022-09-26"
date: 2022-09-26
tags: ["easy", "array", "hash-table", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-26
- Submissions: Runtime Error → Wrong Answer ×3 → Accepted ×2

## Approach

Normalize each address into a set ([Hash Table]({{< relref "/algorithm/Hash-Table" >}}) Template 5): split at `@` into local and domain, cut the local part at the first `+`, then remove every `.`; leave the domain alone. **Put the `@` back** when rejoining, or different addresses can produce the same string.

## My Attempts

- Attempt 1 misspelled `replace` (AttributeError).
- The next two rejoined with `"".join(email)`, **dropping the `@`**: `["a@bx.com", "ab@x.com"]` both became `"abx.com"`, so the answer 2 came out as 1.
- The one after wrote `emails[0] + '@' + emails[1]`, mixing up `email` and `emails`, and raised IndexError with a single address.

## Solution

```python
class Solution:
    def numUniqueEmails(self, emails: List[str]) -> int:
        seen = set()
        for e in emails:
            local, domain = e.split("@")
            local = local.split("+")[0].replace(".", "")
            seen.add(local + "@" + domain)
        return len(seen)
```

## Complexity

Time `O(total characters)`, space `O(total characters)`.

## Mistakes to Avoid

- The rules apply only to the local part; keep the domain's dots.
- Keep the `@` when rejoining: `"a@bx.com"` and `"ab@x.com"` are different addresses.

## Interview Explanation

I split each address at @, cut the local part at + and drop its dots, keep the domain, rejoin, and count distinct results with a set. Time is linear in the total length.
