---
title: "LeetCode 269: Alien Dictionary"
summary: "LeetCode note for Alien Dictionary, rebuilt from the original learning note"
description: "Cleaned LeetCode 269 article from 2026-04-26 with note repair points and final solution"
date: 2026-04-26
tags: ["hard", "graph", "topological-sort"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-04-26
Source: Day 12 learning note

## Study Context

This article is rebuilt from the exact LeetCode section in the learning note. I kept the note's repair points, comparison points, and common mistakes, while removing unrelated non-LeetCode material from the same day.

## Related Reminders From The Note

- **LC 269 Alien Dictionary:** Good enough explanation; implementation can still be cleaned up with set adjacency later.

## Learning Note Extract

#### Problem 2 - LC 269 Alien Dictionary Review
- **Status:** Good enough pattern recognition; implementation detail still needs care.
- **Pattern:** Topological sort on characters.

#### Correct Graph Construction
- initialize all characters as graph nodes
- compare adjacent word pairs only
- use only the first different character
- invalid prefix case:
```text
["abc", "ab"] -> ""
```

#### Cycle Detection
Use Kahn's topological sort.

If the result length is smaller than the number of unique characters:
```text
cycle exists -> return ""
```

#### Important Implementation Detail
Today’s code using list adjacency is still workable, because duplicate indegree increments are matched by duplicate decrements later.

But interview-cleaner version is:
```text
use set adjacency to avoid parallel-edge bookkeeping
```

That is easier to explain and less fragile.

#### Interview-Ready Explanation
I build a directed graph over characters using adjacent word pairs only. For each pair, the first different character gives the ordering edge. If the first word is a strict prefix extension of the second, the order is invalid and I return an empty string. Then I run Kahn's topological sort. If I cannot process all characters, there is a cycle.

## Clean Solution

The note above captures the reasoning and the mistakes to avoid. The implementation below is the version I would submit.

```python
from collections import deque
from typing import List

class Solution:
    def alienOrder(self, words: List[str]) -> str:
        graph = {c: set() for word in words for c in word}
        indeg = {c: 0 for c in graph}

        for w1, w2 in zip(words, words[1:]):
            if len(w1) > len(w2) and w1.startswith(w2):
                return ''
            for a, b in zip(w1, w2):
                if a != b:
                    if b not in graph[a]:
                        graph[a].add(b)
                        indeg[b] += 1
                    break

        q = deque(c for c in indeg if indeg[c] == 0)
        order = []
        while q:
            c = q.popleft()
            order.append(c)
            for nei in graph[c]:
                indeg[nei] -= 1
                if indeg[nei] == 0:
                    q.append(nei)

        return ''.join(order) if len(order) == len(indeg) else ''
```

## Complexity

Time O(total characters + edges), Space O(unique characters + edges).

## Mistakes To Watch

- Using every differing character instead of only the first.
- Missing invalid prefix case like abc before ab.

## Final Interview Explanation

Start from the state definition, then explain why the transition preserves that state. If there is a loop direction, state compression, or a similar-looking problem with a different answer shape, call that out explicitly because that is where this problem family usually breaks down.
