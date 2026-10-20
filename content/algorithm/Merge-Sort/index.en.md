---
title: "Merge Sort and Divide-and-Conquer Counting"
summary: "Merge sort templates, where to count in inversion-style problems, the linked list version, and common mistakes"
description: "Algorithm Learning"
date: 2026-10-20
tags: ["merge-sort", "divide-and-conquer", "sorting", "counting"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Introduction

Merge sort is a stable sort that runs in `O(n log n)` even in the worst case. Interviews more often test its extension: **merge sort counting**, also called divide-and-conquer counting or inversion-style problems.

Signals that a problem belongs to this family:

- You need to count pairs where `i < j` and `a[i]`, `a[j]` satisfy some ordering condition.
- `n` is around `10^5`, so `O(n^2)` times out.
- The statement involves prefix sums, differences, or one array minus another. That usually means you transform the condition first, and the result is back in this family.

## Core Idea

Merge sort has two steps:

1. **Split**: cut the range in half and recurse until one element is left. A single element is already sorted.
2. **Merge**: combine two ranges that are **already sorted** into one.

Three properties matter:

- **Merge only merges; it does not sort.** Each step compares the two fronts, and it never reorders elements within the same half. Both halves must be sorted by recursion first, or the merge result is wrong.
- **Every cross pair already satisfies `i < j`.** During a merge, everything in the left half was originally an `i` and everything in the right half was a `j`. Sorting only reorders elements inside one half; it never swaps left and right.
- **Both halves are sorted, so counting can use monotonic two pointers.** As `i` moves right in the left half, its value only grows, and the matching range in the right half only moves in one direction. Counting costs `O(n)` per level.

## Template 1: Array Merge Sort (LC 912)

```python
class Solution:
    def sortArray(self, nums: list[int]) -> list[int]:
        n = len(nums)
        temp = [0] * n                       # one shared buffer for every merge

        def sort(low: int, high: int):       # sort nums[low:high] (half-open)
            if high - low <= 1:
                return

            mid = (low + high) // 2
            sort(low, mid)
            sort(mid, high)

            i, j, k = low, mid, low
            while i < mid or j < high:
                if j >= high or (i < mid and nums[i] <= nums[j]):
                    temp[k] = nums[i]
                    i += 1
                else:
                    temp[k] = nums[j]
                    j += 1
                k += 1

            nums[low:high] = temp[low:high]  # copy back

        sort(0, n)
        return nums
```

### Key Parameters:

- `low`, `high`: the half-open range `[low, high)`. The base case is `high - low <= 1`.
- `mid`: the left half is `[low, mid)` and the right half is `[mid, high)`.
- `temp`: **write only** during the merge; `nums` is **read only** during the merge. Copy from `temp` back to `nums` once the merge is done.
- `<=`: take the left element on ties so the sort is **stable**. Counting problems rely on this.

## Template 2: Counting Skeleton

Every counting problem has this shape; only the counting block changes:

```python
def solve(low: int, high: int) -> int:      # number of pairs inside nums[low:high]
    if high - low <= 1:
        return 0

    mid = (low + high) // 2
    count = solve(low, mid) + solve(mid, high)

    # ── only this block changes per problem ──
    j = mid
    for i in range(low, mid):               # both halves are sorted
        while j < high and <condition(nums[i], nums[j])>:
            j += 1
        count += <amount based on j>
    # ─────────────────────────────────────────

    nums[low:high] = sorted(nums[low:high])  # or a hand-written merge
    return count
```

`sorted()` detects the two sorted runs, so it is close to linear here and passes. If the interviewer asks for a hand-written merge, use the merge from Template 1.

## Where to Count

Ask two questions before writing the counting block:

1. **Is the counting condition the same as the sort order?** If yes, you can count during the merge. If not, **scan once to count, then merge**.
2. **After rewriting the condition as "`nums[j]` compared to some value", are the matching `j` a prefix, a suffix, or a middle segment of the right half?**

| Problem | Condition | How to count | Amount |
|---|---|---|---|
| LCR 170 inversions | `a[i] > a[j]` | count when the merge takes from the **right** | `mid - i`: left elements still waiting |
| LC 315 | how many smaller elements are to the right of each element | count when the merge takes from the **left**, carrying the original index | `j - mid`: right elements already taken |
| LC 493 | `a[i] > 2 * a[j]` | scan then merge; matches form a **prefix** | `j - mid` |
| LC 2426 | `d[i] - d[j] <= diff` | scan then merge; matches form a **suffix** | `high - j` |
| LC 327 / 4051 | subarray sum within a range | scan then merge; matches form a **middle segment** | `r - l`, two pointers |

Rule of thumb: **count for an element at the moment that element is taken.**

## Template 3: Linked List Merge Sort (LC 148 / LC 23)

On a linked list, merging only rewires pointers, so no `temp` is needed:

```python
def merge(a, b):                             # LC 21
    dummy = tail = ListNode()
    while a and b:
        if a.val <= b.val:
            tail.next = a
            a = a.next
        else:
            tail.next = b
            b = b.next
        tail = tail.next
    tail.next = a or b                       # attach the rest in one step
    return dummy.next

def sortList(head):                          # LC 148
    if not head or not head.next:
        return head
    slow, fast = head, head.next             # fast starts one step ahead
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next
    mid = slow.next
    slow.next = None                         # cut the list here
    return merge(sortList(head), sortList(mid))
```

`fast` starts at `head.next` because **to cut a list, you must stand on the node before the cut**. If unsure, try two nodes and check that the list splits into `[1]` and `[2]`.

LC 23 treats each list as one element and runs merge sort over the lists. The merge step is still LC 21.

## Complexity

- Time `O(n log n)`: `log n` levels, and the merge and counting work per level adds up to `O(n)`. Best and worst cases are the same.
- Space `O(n)`: the `temp` buffer for arrays, plus `O(log n)` recursion depth. The linked list version only needs the recursion depth.

## When Not to Use Merge Sort

- **The question asks whether, not how many**: LC 775 asks whether global and local inversions are equal. Local inversions are a subset of global ones, so you only need to check whether an inversion at distance ≥ 2 exists. That takes `O(n)`.
- **Updates and queries are interleaved**: merge sort only works offline. Problems like LC 307 that update and query alternately need a BIT (Fenwick Tree) or a segment tree.
- **BIT is the second solution for the same counting problems**: scan from right to left and ask the BIT how many seen values fall in a range. Compress coordinates first when values are large.

## Common Mistakes

These are all mistakes I actually made while practicing:

- **Not recursing into the right half**: writing `sort(mid, lo)` makes the right half return immediately, so the merge receives unsorted data.
- **Reading the wrong array during merge**: writing `temp[k] = temp[i]`. The left side of the assignment is always `temp`; the right side is always `nums`.
- **Copying someone else's index formula**: the closed-interval version is `m - i + 1`; with half-open ranges it becomes `mid - i`.
- **Assigning where you should accumulate**: `bad = r - l` overwrites the recursive results and earlier counts. It should be `bad += r - l`.
- **Using `<` instead of `<=`**: inversion counting then includes equal pairs.
- **Mixing up prefix and suffix**: in LC 2426 the matches form a suffix, so reusing LC 493's `j - mid` is wrong.
- **Skipping extreme inputs**: in LC 4051, when `k = 0` the two-pointer count `r - l` becomes negative.
- **Updating an outer int from a nested function**: `count += x` assigns to the name, so it needs `nonlocal` or a return value. `tmp[k] = x` mutates the object and does not.
- **Shadowing a built-in name**: typing `list` instead of `lists`. `list[low]` does not fail immediately; the `AttributeError` only appears later when `.val` is read.

## Related LeetCode

Practice ladder, in order of difficulty:

- `LC 88` Merge Sorted Array
- `LC 912` Sort an Array
- `LC 21` Merge Two Sorted Lists
- `LC 148` Sort List
- `LCR 170` Reverse Pairs in an Array (Sword Offer 51)
- `LC 315` Count of Smaller Numbers After Self
- `LC 493` Reverse Pairs
- `LC 327` Count of Range Sum
- `LC 2426` Number of Pairs Satisfying Inequality
- `LC 4051` Count Subarrays with Distant Sums
- `LC 23` Merge k Sorted Lists
- `LC 775` Global and Local Inversions
