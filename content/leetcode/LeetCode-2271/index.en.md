---
title: "LeetCode 2271: Maximum White Tiles Covered by a Carpet"
summary: "LeetCode 2271 note: starting the carpet at some segment's start is never worse; after sorting, two pointers sum the fully covered segments and count the last one partially"
description: "LeetCode 2271 record from 2026-01-11"
date: 2026-01-11
tags: ["medium", "sliding-window", "greedy", "sorting", "prefix-sum", "binary-search", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-11
- Submissions: Accepted ×2 (written on 2026-01-11 and 01-14)

## Approach

**The carpet can always start at some segment's start**: if its left end is on a gap or in the middle of a segment, pushing it right to the next start loses only gaps or tiles already counted on the left and can only gain on the right.

So sort the segments by start and try the carpet at each `tiles[left][0]`, ending at `start + carpetLen - 1`:

- `right` absorbs every segment that is **fully** covered (`tiles[right][1] <= end`), summing their lengths.
- The next segment `tiles[right]` may be **partially** covered: `max(0, end - tiles[right][0] + 1)`.
- Before moving to the next `left`, subtract the length of `tiles[left]`.

The carpet's end moves right with `left`, so `right` never moves back.

## My Solution

```python
class Solution:
    def maximumWhiteTiles(self, tiles: List[List[int]], carpetLen: int) -> int:
        tiles.sort()
        n = len(tiles)
        right = covered = best = 0                 # covered: total length of fully covered segments
        for left in range(n):
            end = tiles[left][0] + carpetLen - 1
            while right < n and tiles[right][1] <= end:
                covered += tiles[right][1] - tiles[right][0] + 1
                right += 1
            partial = max(0, end - tiles[right][0] + 1) if right < n else 0
            best = max(best, covered + partial)
            if right > left:
                covered -= tiles[left][1] - tiles[left][0] + 1
            else:
                right = left + 1                   # this segment itself was not fully covered
        return best
```

My original had no `else` branch: when the carpet cannot even cover `tiles[left]`, `right == left` and subtracting its length makes `covered` negative. The original still passed, because the next round corrects the value; an explicit branch is easier to read.

## Complexity

Time `O(n log n)`, space `O(1)` apart from sorting.

## Mistakes to Avoid

- Trying every possible carpet position: coordinates reach `10^9`.
- Forgetting that the last segment may be only partly covered.

## Interview Explanation

Starting the carpet at some segment's start is never worse, so I sort the segments and try each start. A second pointer sums the fully covered segments, and the next one may be partly covered, counted separately. When the left pointer moves on I subtract the segment that left, and the right pointer never moves back. Sorting dominates: `O(n log n)`.
