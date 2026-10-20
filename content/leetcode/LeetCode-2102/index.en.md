---
title: "LeetCode 2102: Sequentially Ordinal Rank Tracker"
summary: "LeetCode 2102 note: two heaps for \"top k\" and \"the rest\", with a custom __lt__ for reversed string order"
description: "LeetCode 2102 record from 2026-08-01"
date: 2026-08-01
tags: ["hard", "heap", "design", "two-heaps"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-08-01
- Submissions: Accepted (first try)

## Approach

The `i`-th query returns the `i`-th best location, and `i` only grows by 1 per query.

Split all locations between two heaps:

- `top`: the best `k` locations, where `k` is the number of queries so far. Its top is the **worst** of those `k`, i.e. rank `k`.
- `rest`: everything else. Its top is the **best** of them, i.e. rank `k + 1`.

Operations:

- **`add`**: put the new location into `top`, then move the worst of `top` into `rest`. `top` keeps its size, and everything in `top` stays better than everything in `rest`.
- **`get`**: `k` grows by 1, so move the best of `rest` into `top`; the top of `top` is now rank `k`.

### The ordering wrinkle

"Higher score is better; on ties, the lexicographically smaller name is better." For `rest`, taking the best is easy with `(-score, name)`. But `top` needs the **worst**: lower score is worse, and on ties the **larger** name is worse. Strings cannot be negated, so define a class with `__lt__`.

## My Solution

```python
import heapq

class WorstFirst:
    """The heap top is the worst: lower score, or larger name on equal scores."""
    def __init__(self, score: int, name: str):
        self.score = score
        self.name = name

    def __lt__(self, other: "WorstFirst") -> bool:
        if self.score != other.score:
            return self.score < other.score
        return self.name > other.name

class SORTracker:

    def __init__(self):
        self.top = []        # the best k; top is rank k
        self.rest = []       # everything else as (-score, name); top is rank k+1

    def add(self, name: str, score: int) -> None:
        heapq.heappush(self.top, WorstFirst(score, name))
        worst = heapq.heappop(self.top)
        heapq.heappush(self.rest, (-worst.score, worst.name))

    def get(self) -> str:
        neg_score, name = heapq.heappop(self.rest)
        heapq.heappush(self.top, WorstFirst(-neg_score, name))
        return self.top[0].name
```

## Complexity

`add` and `get` are both `O(log n)`; space `O(n)`.

## Mistakes to Avoid

- Putting new locations straight into `rest`: if one beats the worst of `top`, `top` stops being the real top `k`.
- Faking reversed string order with tricks such as `(score, reversed string)`; it is error-prone. A custom `__lt__` is clearer.

## Interview Explanation

The queried rank grows by one each time, so I keep two heaps: one for the top `k`, whose top is rank `k`, and one for the rest, whose top is rank `k + 1`. On add, the new location goes into the top-`k` heap and its worst element moves to the other heap; on get, the best of the other heap moves over and the top-`k` heap's top is the answer. Since "larger name is worse" cannot be expressed with negation, I define `__lt__`. Both operations are `O(log n)`.
