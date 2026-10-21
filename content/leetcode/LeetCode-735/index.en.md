---
title: "LeetCode 735: Asteroid Collision"
summary: "LeetCode 735 note: scan left to right with a stack; only a right-moving top meeting a left-moving asteroid collides, the smaller explodes and equal sizes both do"
description: "LeetCode 735 record from 2024-04-18"
date: 2024-04-18
tags: ["medium", "array", "stack", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2024-04-18
- Submissions: Wrong Answer → Runtime Error → Wrong Answer → Output Limit Exceeded → Accepted

## Approach

Scanning left to right ([Stack]({{< relref "/algorithm/Stack" >}}) Template 2), a collision happens only when the stack top moves right (`> 0`) and the current asteroid moves left (`< 0`):

- A smaller top explodes, and the comparison continues with the new top.
- Equal sizes both explode.
- A larger top destroys the current one.

A surviving asteroid is pushed. A left-mover meeting an empty stack or a left-moving top never collides.

## My Attempts

In 2024 I scanned **right to left** with a second stack for left-movers:

- Attempt 1 **never added the remaining left-movers back to the answer**: `[-4, 2]` returned `[2]`.
- After that, it compared against `rev_stack[0]`, the farthest one, **instead of the nearest `rev_stack[-1]`**: `[2, -4, -1]` returned `[-4]` instead of `[-4, -1]`. Using `[-1]` passed, after one Output Limit Exceeded from a `print`.

## Solution

```python
class Solution:
    def asteroidCollision(self, asteroids: List[int]) -> List[int]:
        st = []
        for a in asteroids:
            alive = True
            while alive and a < 0 and st and st[-1] > 0:
                if st[-1] < -a:
                    st.pop()
                elif st[-1] == -a:
                    st.pop()
                    alive = False
                else:
                    alive = False
            if alive:
                st.append(a)
        return st
```

## Complexity

Time `O(n)`, space `O(n)`.

## Mistakes to Avoid

- Only a right-mover on the left meeting a left-mover on the right collides; `[-4, 2]` does not.
- Compare with the **nearest** asteroid, the top `st[-1]`, not `st[0]`.

## Interview Explanation

Scanning left to right with a stack, only a right-moving top and a left-moving current asteroid collide: a smaller top explodes and the check continues, equal sizes both vanish, and a larger top stops the current one; survivors are pushed. Each asteroid enters and leaves once, so time is `O(n)`.
