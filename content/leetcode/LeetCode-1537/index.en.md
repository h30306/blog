---
title: "LeetCode 1537: Get the Maximum Score"
summary: "LeetCode 1537 note: two sorted arrays can switch only at shared values; merge with two pointers, keep a running sum per path, and at a shared value set both to the larger sum plus that value"
description: "LeetCode 1537 record from 2026-02-01"
date: 2026-02-01
tags: ["hard", "dynamic-programming", "two-pointers", "greedy", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2026-02-01
- Submissions: WA ×2 → TLE ×2 → AC

## Approach

Both arrays are sorted with no repeats inside each. Switching to the other array is allowed only at **values present in both**.

Walk forward with two pointers as in a merge, keeping running sums `sum1`, `sum2`:

- `nums1[i] < nums2[j]`: only path 1 passes it, `sum1 += nums1[i]`.
- `nums1[i] > nums2[j]`: `sum2 += nums2[j]`.
- Equal: a meeting point; up to here either path can take the better route, so `sum1 = sum2 = max(sum1, sum2) + value`.

The answer is `max(sum1, sum2)` with the modulo. **Apply the modulo only at the end**; reducing midway breaks the comparisons.

## My Attempts

| Version | Problem |
|---|---|
| Attempt 1, WA | Found meeting points with `x not in nums2` and forgot the modulo, so large answers were wrong |
| Attempt 2, WA | Added the modulo as `% 10 ** 9 + 7`, which evaluates as `(x % 10**9) + 7`. For `nums1 = [3]`, `nums2 = [7]`, the answer is 7; it returned 14 |
| Two TLEs | Fixed the parentheses, but `x not in nums2` searches a list, `O(m)` each time, `O(nm)` overall |
| AC | Switched to a two-pointer merge, where comparing both sides reveals meeting points |

## Solution

```python
class Solution:
    def maxSum(self, nums1: List[int], nums2: List[int]) -> int:
        MOD = 10 ** 9 + 7
        i = j = 0
        sum1 = sum2 = 0
        n, m = len(nums1), len(nums2)
        while i < n or j < m:
            if j == m or (i < n and nums1[i] < nums2[j]):
                sum1 += nums1[i]
                i += 1
            elif i == n or nums1[i] > nums2[j]:
                sum2 += nums2[j]
                j += 1
            else:                                  # meeting point: take the better path
                sum1 = sum2 = max(sum1, sum2) + nums1[i]
                i += 1
                j += 1
        return max(sum1, sum2) % MOD               # modulo only at the end
```

## Complexity

Time `O(n + m)`, space `O(1)`.

## Mistakes to Avoid

- `% 10 ** 9 + 7` needs parentheses: `% (10 ** 9 + 7)`.
- `in` on a list is `O(n)`; the arrays are sorted, so compare with two pointers.
- No modulo midway: reduced values cannot be compared.

## Interview Explanation

Both arrays are sorted and switching happens only at shared values. I merge with two pointers, keeping a running sum per path; at a shared value I take the larger of the two sums so far and set both to it plus the shared value. The answer is the larger sum with the modulo applied only at the end. Time `O(n + m)`.
