---
title: "LeetCode 316: Remove Duplicate Letters"
summary: "LeetCode 316 note: a monotonic stack with last positions; pop a larger top that appears again later, and skip letters already on the stack"
description: "LeetCode 316 record from 2026-07-13"
date: 2026-07-13
tags: ["medium", "stack", "monotonic-stack", "greedy", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-07-13
- Submissions: Accepted → Accepted (retyped 07-27) → Wrong Answer → Accepted
- Same problem: LC 1081 Smallest Subsequence of Distinct Characters

## Approach

Keep **exactly one** of each letter so that the result is lexicographically smallest.

Build the answer left to right. On character `c`, if the top of the stack is larger than `c` **and appears again later**, pop it: the later copy can be used instead, and putting `c` first is smaller.

Three ingredients:

1. `last[ch]`: each letter's last position, to know whether it appears again.
2. `seen`: letters already on the stack. **If `c` is already on the stack, skip it**: each letter is kept once, and it already sits in a better position.
3. A monotonic stack: pop larger letters that can be restored later.

## My Attempt: reusing the LC 3816 approach

On 07-27 I solved LC 3816 first, then came back to rewrite this one the same way:

```python
cnt = Counter(s)
for ch in s:
    while stack and stack[-1] > ch and cnt[stack[-1]] > 1:
        cnt[stack.pop()] -= 1
    stack.append(ch)
```

WA. This version **allows a letter to appear on the stack several times** and only guarantees at least one of each, which is LC 3816's requirement. 316 wants exactly one, so a `seen` set must skip letters already on the stack.

## Solution

```python
class Solution:
    def removeDuplicateLetters(self, s: str) -> str:
        last = {ch: i for i, ch in enumerate(s)}
        stack, seen = [], set()
        for i, ch in enumerate(s):
            if ch in seen:
                continue
            while stack and stack[-1] > ch and last[stack[-1]] > i:
                seen.remove(stack.pop())
            stack.append(ch)
            seen.add(ch)
        return "".join(stack)
```

## Complexity

Time `O(n)`: each character is pushed and popped at most once. Space `O(alphabet size)`.

## Mistakes to Avoid

- No `seen`: a letter can end up twice.
- Checking "appears later" with `>=` instead of `>`: `last[ch] == i` means this is the last copy and it cannot be removed.
- Confusing it with LC 3816: that one is "at least one", this one is "exactly one".

## Interview Explanation

I record each letter's last position and build the answer left to right with a monotonic stack. Letters already on the stack are skipped; otherwise, while the top is larger than the current letter and appears again later, I pop it, since the later copy can be used. The stack is the answer. Each character enters and leaves once, so time is `O(n)`.
