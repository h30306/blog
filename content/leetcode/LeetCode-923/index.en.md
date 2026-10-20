---
title: "LeetCode 923: 3Sum With Multiplicity"
summary: "LeetCode 923 note: sort, fix the first number, and find the other two with converging pointers; equal end values are counted with a combination, different ones by multiplying each end's duplicate count"
description: "LeetCode 923 record from 2026-01-24"
date: 2026-01-24
tags: ["medium", "two-pointers", "sorting", "hash-table", "counting", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2026-01-24
- Submissions: WA → AC (counting) → WA ×4 → AC (two pointers) → WA

## Approach

I passed with counting first, then rewrote it with two pointers.

### Two pointers

Sort, fix `i`, and use converging pointers `j`, `k` over `[i + 1, n - 1]` to find `arr[j] + arr[k] == target - arr[i]`. On a hit there are two cases:

- **`arr[j] == arr[k]`**: everything in `j..k` is the same value and any two of them work, so add `m(m - 1) / 2` (`m = k - j + 1`) and finish this `i`.
- **`arr[j] != arr[k]`**: count how many copies of `arr[j]` sit on the left and of `arr[k]` on the right, multiply, and move both pointers past the duplicates.

### Counting

Values are only `0..100`, so enumerate values `a <= b <= c` and use a `Counter` with combinations: three equal is `C(cnt, 3)`, two equal is `C(cnt, 2) × the other count`, all different is the product of the three counts.

## My Attempts

Most of the mistakes were details:

| Version | Problem |
|---|---|
| Counting, WA | Forgot the modulo. For 3000 zeros and `target = 0` the answer is `C(3000, 3) mod (10^9 + 7) = 495500972`; this returned `4495501000` |
| Two pointers attempt 1, WA | The two cases were swapped (duplicate counts for equal values, the combination for different values), and `ans +=` was written `ans =` (this version did not sort yet either). For `[1, 1, 1, 1]`, `target = 3`, the answer is 4; this returned 3 |
| Attempt 2, WA | Fixed the branches but **did not sort**, so converging pointers did not apply. For `[4, 4, 0, 4, 0, 1, 1]`, `target = 4`, the answer is 3; this returned 4 |
| Attempt 3, WA | Added the sort but not the modulo, so large tests still failed |
| Attempt 4, WA | Wrote `* MOD` instead of `% MOD` |
| Last WA | Resubmitted a version without the sort after already passing |

## Solution

```python
class Solution:
    def threeSumMulti(self, arr: List[int], target: int) -> int:
        MOD = 10 ** 9 + 7
        arr.sort()
        n = len(arr)
        ans = 0
        for i in range(n - 2):
            j, k = i + 1, n - 1
            while j < k:
                s = arr[i] + arr[j] + arr[k]
                if s < target:
                    j += 1
                elif s > target:
                    k -= 1
                elif arr[j] == arr[k]:
                    m = k - j + 1                  # everything in j..k is equal
                    ans += m * (m - 1) // 2
                    break
                else:
                    cnt_j = cnt_k = 1
                    while j + 1 < k and arr[j + 1] == arr[j]:
                        j += 1
                        cnt_j += 1
                    while k - 1 > j and arr[k - 1] == arr[k]:
                        k -= 1
                        cnt_k += 1
                    ans += cnt_j * cnt_k
                    j += 1
                    k -= 1
        return ans % MOD
```

Counting version:

```python
class Solution:
    def threeSumMulti(self, arr: List[int], target: int) -> int:
        MOD = 10 ** 9 + 7
        cnt = Counter(arr)
        ans = 0
        for a in range(101):
            for b in range(a, 101):
                c = target - a - b
                if c < b or c > 100:
                    continue
                if a == b == c:
                    ans += cnt[a] * (cnt[a] - 1) * (cnt[a] - 2) // 6
                elif a == b:
                    ans += cnt[a] * (cnt[a] - 1) // 2 * cnt[c]
                elif b == c:
                    ans += cnt[a] * cnt[b] * (cnt[b] - 1) // 2
                else:
                    ans += cnt[a] * cnt[b] * cnt[c]
        return ans % MOD
```

## Complexity

- Two pointers: time `O(n^2)`, space `O(1)` apart from sorting.
- Counting: time `O(n + V^2)` with `V = 101`, space `O(V)`.

## Mistakes to Avoid

- Forgetting to sort before converging pointers.
- Forgetting the modulo, or writing `* MOD`.
- When both ends are equal, "left duplicates × right duplicates" is wrong; use the combination.

## Interview Explanation

I sort, fix the first number, and find the other two with converging pointers. On an exact sum, if both ends are equal, everything between them is that value, so I add `m(m - 1) / 2` at once; otherwise I multiply the duplicate counts at each end and skip past them. Time `O(n^2)`. Since values are 0 to 100, counting values and using combinations also works in `O(n + 101^2)`.
