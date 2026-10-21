---
title: "LeetCode 981: Time Based Key-Value Store"
summary: "LeetCode 981 note: store a (timestamp, value) list per key, with timestamps increasing; get binary searches the last timestamp <= the query"
description: "LeetCode 981 record from 2022-10-28"
date: 2022-10-28
tags: ["medium", "hash-table", "string", "binary-search", "design"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2022-10-28
- Submissions: Runtime Error ×4 → Time Limit Exceeded ×2 → Runtime Error → Time Limit Exceeded → Wrong Answer → Time Limit Exceeded ×2 → Runtime Error → Time Limit Exceeded ×2 → Wrong Answer → Time Limit Exceeded ×2 → Output Limit Exceeded → Time Limit Exceeded ×3 → Runtime Error → Output Limit Exceeded → Wrong Answer → Time Limit Exceeded ×2 → Runtime Error → Time Limit Exceeded → Accepted → Wrong Answer → Runtime Error → Accepted ×2

## Approach

`set` timestamps are strictly increasing, so each key's list is already sorted ([Binary Search]({{< relref "/algorithm/Binary-Search" >}}) Template 1). `get` wants the last `timestamp <= t`, which is the first position `> t` minus one, found with `bisect_right`. A missing key or no match returns the empty string.

## My Attempts

This took 33 submissions:

- The binary search wrote `l += 1` / `r -= 1`, moving one step at a time, effectively linear, and kept hitting TLE.
- `get` on an unseen key used `self.map[key]` directly: KeyError.
- Tuples were stored as `(timestamp, value)` but read as `(value, timestamp)`; a few versions left debug `print`s in and hit Output Limit Exceeded.

## Solution

```python
class TimeMap:
    def __init__(self):
        self.times = defaultdict(list)
        self.values = defaultdict(list)

    def set(self, key: str, value: str, timestamp: int) -> None:
        self.times[key].append(timestamp)
        self.values[key].append(value)

    def get(self, key: str, timestamp: int) -> str:
        i = bisect.bisect_right(self.times[key], timestamp)
        return self.values[key][i - 1] if i else ""
```

## Complexity

`set` is `O(1)`, `get` is `O(log n)`, space `O(n)`.

## Mistakes to Avoid

- `get` on an unseen key returns the empty string, not KeyError.
- Binary search must jump (`l = mid + 1`); moving one step at a time (`l += 1`) degrades to linear and TLEs.

## Interview Explanation

Timestamps increase, so each key keeps a list of timestamps and values, and `get` uses `bisect_right` to find the last one not after the query. `set` is `O(1)`, `get` is `O(log n)`.
