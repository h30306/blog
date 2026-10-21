---
title: "LeetCode 1047: Remove All Adjacent Duplicates In String"
summary: "LeetCode 1047 note: if the stack top equals the current character both vanish, otherwise push it; after a removal the new top may cancel with the next character"
description: "LeetCode 1047 record from 2022-09-30"
date: 2022-09-30
tags: ["easy", "string", "stack"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-09-30
- Submissions: Runtime Error → Accepted → Wrong Answer → Runtime Error → Accepted ×3

## Approach

Interact with the previous character ([Stack]({{< relref "/algorithm/Stack" >}}) Template 2): if the stack top equals the current character, `pop` (both vanish), otherwise `push`. After a removal the new top becomes "the previous character", so chained removals happen automatically.

## My Attempts

Attempt 1 read `stack[-1]` without checking for emptiness (IndexError). One version added a `temp` to skip runs of equal characters, **removing all three in `"aaa"`**: it returned an empty string instead of `"a"`.

## Solution

```python
class Solution:
    def removeDuplicates(self, s: str) -> str:
        st = []
        for c in s:
            if st and st[-1] == c:
                st.pop()
            else:
                st.append(c)
        return "".join(st)
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Check the stack is non-empty before reading `st[-1]`.
- Remove one pair at a time: `"aaa"` leaves `"a"`.

## Interview Explanation

With a stack, a character equal to the top cancels with it and otherwise is pushed; the new top then meets the next character, handling chains. Time `O(n)`.
