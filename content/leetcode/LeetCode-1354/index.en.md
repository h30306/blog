---
title: "LeetCode 1354: Construct Target Array With Multiple Sums"
summary: "LeetCode 1354 note: work backwards, since the maximum was set last; jump with a modulo when the gap is large"
description: "LeetCode 1354 record from 2026-09-07"
date: 2026-09-07
tags: ["hard", "heap", "math", "greedy"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-09-07
- Submissions: Time Limit Exceeded → Accepted

## Approach

Going forward has too many choices, so **work backwards**:

Each operation sets one position to the current total, which is larger than every other element. So **the current maximum must be the position set most recently**.

One step back: if the maximum is `mx` and the other elements sum to `rest`, that position previously held `mx - rest`.

Use a max-heap to repeatedly pop the maximum and undo one step. Succeed when everything is 1; fail if an undone value drops below 1.

## My First Attempt: undoing one step at a time

```python
preNum = preSum - (currSum - preSum)
```

For `[1, 1000000000]`, each step subtracts only 1, so it takes `10^9` iterations and times out.

## Improvement: jump with a modulo

When `mx` is much larger than `rest`, the same position is undone many times in a row, subtracting `rest` each time until it drops below `rest`. That is `mx % rest`.

Edge cases:

- `rest == 1`: e.g. `[1, x]`; subtracting 1 repeatedly always reaches 1, so return `True`. Handle it first, because `x % 1 == 0` would look like a failure.
- `rest == 0` (a single element that is not 1), or `mx <= rest`: no valid previous step, return `False`.
- `mx % rest == 0`: the undone value would be 0, which is invalid, return `False`.

## Solution

```python
import heapq

class Solution:
    def isPossible(self, target: List[int]) -> bool:
        total = sum(target)
        heap = [-x for x in target]
        heapq.heapify(heap)

        while True:
            mx = -heapq.heappop(heap)
            if mx == 1:
                return True                    # the maximum is 1, so all are 1
            rest = total - mx
            if rest == 1:
                return True
            if rest == 0 or mx <= rest:
                return False
            prev = mx % rest
            if prev == 0:
                return False
            total = rest + prev
            heapq.heappush(heap, -prev)
```

## Complexity

Time `O(n + log(S) · log n)`, where `S` is the total: the maximum is at least half the total, and the modulo leaves less than half of it, so each round shrinks the total to at most `3/4`. The loop runs only `O(log S)` times. Space `O(n)`.

## Mistakes to Avoid

- Undoing one step at a time: times out when the gap is large.
- Not handling `rest == 1` first: `x % 1 == 0` is mistaken for a failure.
- Single-element arrays: `rest == 0`, and only `[1]` is `True`.

## Interview Explanation

I work backwards: every set value is the total at that moment, so the current maximum was set last, and its previous value is the maximum minus the sum of the others. A max-heap gives the maximum each step; when the gap is large, the same position would be undone repeatedly, so a modulo does it in one jump. If the rest sums to 1 it always works; if it is 0 or not smaller than the maximum, or the modulo gives 0, it fails. Reaching all ones means success.
