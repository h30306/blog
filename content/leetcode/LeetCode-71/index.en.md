---
title: "LeetCode 71: Simplify Path"
summary: "LeetCode 71 note: split on /, skip empty pieces and ., pop on .. (never above root), push other names, and join with /"
description: "LeetCode 71 record from 2022-10-24"
date: 2022-10-24
tags: ["medium", "string", "stack"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-10-24
- Submissions: Runtime Error → Wrong Answer ×4 → Runtime Error ×2 → Wrong Answer ×2 → Accepted → Wrong Answer → Accepted → Wrong Answer → Accepted

## Approach

Split on `/` and handle each piece ([Stack]({{< relref "/algorithm/Stack" >}}) Template 1):

- Empty strings (from repeated `/`) and `.`: skip.
- `..`: pop if the stack is non-empty; at the root, do nothing.
- Anything else, including `...`: a directory name to push.

The answer is `"/" + "/".join(stack)`, which is exactly `"/"` for an empty stack.

## My Attempts

This took 14 submissions:

- Attempt 1 processed characters backwards with tangled rules for `.` and `/`, returning an empty string even for `/`.
- With `split('/')` and a stack, the boundaries got fixed one by one: **`..` at the root popped an empty stack** (IndexError), **empty pieces were kept** (`/` returned `//`), and **`.` was kept** (`/.` returned `/.`).
- Two 2022-11 rewrites each missed one case again, `.` and the root's `..` (`/..` returned `/..`).

## Solution

```python
class Solution:
    def simplifyPath(self, path: str) -> str:
        st = []
        for part in path.split("/"):
            if part == "..":
                if st:
                    st.pop()
            elif part and part != ".":
                st.append(part)
        return "/" + "/".join(st)
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- `split("/")` yields empty strings; skip them.
- Skip `.`, while `...` is a valid name.
- `..` at the root must neither pop an empty stack nor be pushed.

## Interview Explanation

I split on slashes, skip empty pieces and single dots, pop for double dots unless at the root, push other names, and join with slashes. Time `O(n)`.
