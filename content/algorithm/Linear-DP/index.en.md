---
title: "Linear DP"
summary: "One-dimensional DP, state-machine DP, DP with a monotonic deque, interval scheduling DP after sorting, deduplicated subsequence counting, and DP-tagged problems where an observation or greedy is faster"
description: "Algorithm Learning"
date: 2026-10-20
tags: ["dynamic-programming", "state-machine", "monotonic-queue", "binary-search"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Introduction

Linear DP moves in one direction (array index, time, length) one step at a time, and `dp[i]` depends only on earlier states.

The standard routine:

1. **Define the state**: what does `dp[i]` mean? "Ending at `i`" or "the first `i`"?
2. **Transition**: how does `dp[i]` come from earlier states?
3. **Base case** and **where the answer is** (`dp[-1]` or `max(dp)`).
4. When only the last one or two states matter, compress to a few variables.

| Form | State | Example |
|---|---|---|
| 1D DP | `dp[i]`: best over the first `i` | House Robber |
| State machine DP | `dp[i][state]`: step `i` in some state | attendance records, vowel strings, painting |
| DP + monotonic deque | `dp[i]` depends on the max of the previous `k` | Jump Game VI |
| Interval scheduling DP | sorted by end time, `dp` with binary search | job scheduling |
| Subsequence counting | grouped by last character to avoid duplicates | distinct subsequences |

## Template 1: 1D DP

```python
dp = [0] * (n + 1)                       # dp[i]: best over the first i
for i in range(n):
    dp[i + 1] = max(dp[i], dp[i - 1] + nums[i] if i > 0 else nums[i])
```

- **A House Robber variant** (LC 3840): two houses conflict only when adjacent with the same color. With different colors take it, `dp[i + 1] = dp[i] + nums[i]`; only with the same color is it the House Robber `max`.
- **LIS style** (LC 3989): `dp[j]` = the longest valid sequence ending at `j`; try every earlier `i` and, if compatible, `dp[j] = max(dp[j], dp[i] + 1)`, `O(n^2)`.

## Template 2: State machine DP

Each step has only a few states; list which states each one can move to:

```python
dp = counts for the initial states
for _ in range(n):
    ndp = [0] * number_of_states
    for s in all_states:
        for t in states_reachable_from(s):
            ndp[t] += dp[s]
    dp = ndp
return sum(dp)
```

- **Attendance records** (LC 552): state = "A used (0, 1) × trailing L run (0, 1, 2)", 6 states.
- **Vowel strings** (LC 1220): state = the last vowel, transitions by the rules.
- **Painting an n × 3 grid** (LC 1411): a row has only two patterns, `ABA` (ends match) and `ABC` (all different), 6 colorings each, with transitions `ABA → 3 ABA + 2 ABC` and `ABC → 2 ABA + 2 ABC`.
- **Moving tokens** (LC 3952): state = "did the token at this index move left".
- **Merging states by class** (LC 2912): there are many cells, but relative to the destination only four classes (the destination, same row, same column, neither), and each class's total moves together.
- **Typing with two fingers** (LC 1320): one finger is always on the previous letter, so the state only needs **the other finger's** position (26 letters or unused).
- **Two paths switching at common values** (LC 1537): keep a running sum per array, and at a shared value the paths may swap, so set both sums to the larger one.

## Template 3: DP + monotonic deque

`dp[i] = nums[i] + max(dp[i-k..i-1])`: the max of the previous `k` is a sliding window maximum, available in `O(1)` from a monotonic deque:

```python
from collections import deque

dq = deque([0])                          # indices, dp values decreasing
for i in range(1, n):
    if dq[0] < i - k:
        dq.popleft()                     # expired
    dp[i] = nums[i] + dp[dq[0]]
    while dq and dp[dq[-1]] <= dp[i]:
        dq.pop()                         # dominated
    dq.append(i)
```

(LC 1696; LC 1425 has the same structure, see [Sliding Window]({{< relref "/algorithm/Sliding-Window" >}})).

## Template 4: Interval scheduling DP

Jobs have start, end and profit; pick non-overlapping ones. **Sort by end time**, and let `best[j]` = the best profit using the first `j` jobs; when taking job `j`, binary-search the last job ending `<=` its start:

```python
from bisect import bisect_right

jobs = sorted(zip(end, start, profit))
ends, best = [0], [0]
for e, s, p in jobs:
    i = bisect_right(ends, s) - 1        # last job with end <= s
    best.append(max(best[-1], best[i] + p))
    ends.append(e)
return best[-1]
```

Times can reach `10^9`, so **never index by time**; index by job (LC 1235). With at most two jobs, `best` becomes a prefix maximum (LC 2054).

## Template 5: Deduplicated subsequence counting

To count distinct subsequences, group them by **last character**: distinct subsequences ending with `c` = every current distinct subsequence with `c` appended, plus `c` itself. The new value **replaces** the old `end[c]` (the old ones are all included in the new):

```python
end = {}
for c in s:
    end[c] = (sum(end.values()) + 1) % MOD
return sum(end.values()) % MOD
```

(LC 940)

## Template 6: Prefix and suffix computed separately

When the answer is "some part chosen on the left, some on the right", compute the best left value for every cut from left to right, the best right value from right to left, then try every cut:

```python
left_best = [...]                         # left_best[i]: best using only [0..i]
right_best = [...]                        # right_best[i]: best using only [i..n-1]
ans = min(left_best[k - 1] - right_best[k] for k in cut_points)
```

- **Remove n numbers to minimize the difference of the halves** (LC 2163): the left keeps its `n` smallest (a max-heap), the right keeps its `n` largest (a min-heap).

## Tagged DP, but an observation or greedy is faster

These carry a DP tag on LeetCode, but once the structure is clear they need no DP:

- **Differences** (LC 1526): every rise `target[i] > target[i - 1]` costs `target[i] - target[i - 1]` extra operations.
- **Sort then greedy** (LC 1402): add dishes from most satisfying down; each addition shifts all chosen dishes one slot later, raising the total by the current chosen sum, so keep adding while that sum is positive.
- **Math** (LC 2745): `AA` and `BB` must alternate, and every `AB` can be appended.
- **Cut as soon as possible** (LC 3638): once a value below the segment's maximum appears, end the segment.
- **Prefix max / suffix min** (LC 3660): when the prefix max exceeds the minimum to its right, the two sides connect.

## Key Parameters

- With `dp[i]` as "the first `i`", the array has length `n + 1` and `dp[0]` is the empty state.
- State machine DP needs a fresh `ndp` each round; updating `dp` in place lets transitions in the same round interfere.
- Counting problems need the modulo, applied at every step.

## Complexity

1D DP `O(n)`; state machine DP `O(n · states · transitions)`; DP + monotonic deque `O(n)`; interval scheduling `O(n log n)`.

## Common Mistakes

These are all mistakes I actually made while practicing:

- **A mistyped modulus**: `10 % 9 + 7` should be `10 ** 9 + 7`, and the final sum needs the modulo too (LC 1220).
- **The wrong start**: Jump Game VI must start at index 0, but my `dp` let any of the first `k` cells be a start (LC 1696).
- **Jobs ending at the same time overwriting each other**: `dp[i] = max(dp[i - 1], ...)` on the second job discarded the first job's result (LC 1235).
- **Indexing by time**: times reach `10^9`, MLE / TLE (LC 1235).
- **Greedy comparing against the wrong value**: it should compare with the segment's maximum, but I kept comparing with the segment's first value (LC 3638).

## Related LeetCode

- `LC 3840` House Robber V
- `LC 552` Student Attendance Record II
- `LC 1220` Count Vowels Permutation
- `LC 1411` Number of Ways to Paint N × 3 Grid
- `LC 3952` Maximum Total Value of Covered Indices
- `LC 1696` Jump Game VI
- `LC 1235` Maximum Profit in Job Scheduling
- `LC 2054` Two Best Non-Overlapping Events
- `LC 940` Distinct Subsequences II
- `LC 1526` Minimum Number of Increments on Subarrays to Form a Target Array
- `LC 1402` Reducing Dishes
- `LC 2745` Construct the Longest New String
- `LC 3638` Maximum Balanced Shipments
- `LC 3660` Jump Game IX
- `LC 1320` Minimum Distance to Type a Word Using Two Fingers
- `LC 1537` Get the Maximum Score
- `LC 2163` Minimum Difference in Sums After Removal of Elements
- `LC 3989` Maximum Consistent Columns in a Grid
- `LC 2912` Number of Ways to Reach Destination in the Grid
