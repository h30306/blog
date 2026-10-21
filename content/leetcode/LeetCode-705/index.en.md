---
title: "LeetCode 705: Design HashSet"
summary: "LeetCode 705 note: a fixed number of buckets, with the key modulo the bucket count choosing the bucket and a list per bucket handling collisions"
description: "LeetCode 705 record from 2022-08-31"
date: 2022-08-31
tags: ["easy", "array", "hash-table", "linked-list", "design"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: easy
First Attempt: 2022-08-31
- Submissions: Runtime Error ×2 → Accepted

## Approach

The problem asks you to build it without the built-in `set`. The most basic hash table ([Hash Table]({{< relref "/algorithm/Hash-Table" >}}); [Linked List]({{< relref "/algorithm/Linked-List" >}}), Others):

- Allocate a fixed number of buckets (a prime such as 1009 spreads keys more evenly).
- `key % bucket_count` chooses the bucket.
- Different keys may share a bucket (a collision), so each bucket is a list searched on every operation.

## My Attempts

I originally just wrapped the built-in `set`: attempt 1's `remove` called itself (infinite recursion); attempt 2 used `set.remove`, raising KeyError for a missing key; attempt 3 switched to `discard` and passed. Here it is a real implementation.

## Solution

```python
class MyHashSet:
    def __init__(self):
        self.size = 1009
        self.buckets = [[] for _ in range(self.size)]

    def add(self, key: int) -> None:
        b = self.buckets[key % self.size]
        if key not in b:
            b.append(key)

    def remove(self, key: int) -> None:
        b = self.buckets[key % self.size]
        if key in b:
            b.remove(key)

    def contains(self, key: int) -> bool:
        return key in self.buckets[key % self.size]
```

## Complexity

Each operation averages `O(n / buckets)`, space `O(buckets + n)`.

## Mistakes to Avoid

- Removing a missing key must not raise.
- A prime bucket count keeps keys from clustering in a few buckets.

## Interview Explanation

I allocate a fixed number of buckets, place each key by its remainder, and use a list per bucket for collisions, checking membership before adding or removing. Each operation averages `O(n / buckets)`.
