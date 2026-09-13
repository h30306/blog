---
title: "LeetCode 516: Longest Palindromic Subsequence"
summary: "LeetCode 516 解題筆記，依照原始 learning note 重新整理"
description: "2026-07-11 的 LeetCode 516 學習紀錄，包含筆記修正點與正確解法"
date: 2026-07-11
tags: ["medium", "dynamic-programming", "string", "palindrome"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-07-11
來源：Day 36 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 筆記中提到的相關提醒

- `LC 516` tests whether you can switch from prefix-style DP to interval-style DP cleanly.
- `LC 516`: partial pass after teaching repair
- explain `LC 516` with exact interval-based state and fill order

## 當天筆記摘錄

#### Problem 2 - LC 516 Longest Palindromic Subsequence
- **Pattern:** interval DP on substrings.

#### Why This Fits
This is not a two-string prefix table.

The right question is:
```text
what is the longest palindromic subsequence inside s[left:right+1]?
```

That naturally gives an interval DP.

#### Core State / Invariant
```text
dp[left][right] = length of the longest palindromic subsequence inside s[left:right+1]
```

#### Base Cases
Single character:
```text
dp[i][i] = 1
```

Reason:
```text
one character is already a palindrome of length 1
```

#### Transition
If the two ends match:
```text
s[left] == s[right]
=> dp[left][right] = dp[left + 1][right - 1] + 2
```

If they do not match:
```text
dp[left][right] = max(dp[left + 1][right], dp[left][right - 1])
```

#### Fill Order
The interval depends on smaller inner intervals, so fill by:
- increasing substring length
or
- `left` decreasing, `right` increasing

#### Complexity
```text
Time: O(n^2)
Space: O(n^2)
```

#### Common Mistakes
- confusing subsequence with substring
- filling the table in the wrong order
- forgetting `dp[i][i] = 1`
- assuming matching ends always means the whole interval is a palindrome substring

#### Strong Spoken Explanation
I define `dp[left][right]` as the length of the longest palindromic subsequence inside that substring interval. A single character is length `1`, so `dp[i][i] = 1`. If the two ends match, I can wrap the best inner answer with those two characters and add `2`. If they do not match, one of the ends is not used in the optimal subsequence, so I take the better answer from dropping the left side or dropping the right side. The key implementation detail is fill order, because each state depends on smaller inner intervals.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
class Solution:
    def longestPalindromeSubseq(self, s: str) -> int:
        n = len(s)
        dp = [[0] * n for _ in range(n)]

        for l in range(n - 1, -1, -1):
            dp[l][l] = 1
            for r in range(l + 1, n):
                if s[l] == s[r]:
                    dp[l][r] = 2 + dp[l + 1][r - 1]
                else:
                    dp[l][r] = max(dp[l + 1][r], dp[l][r - 1])

        return dp[0][n - 1] if n else 0
```

## 複雜度

Time O(n^2), Space O(n^2).

## 要特別避免的錯誤

- Using substring logic instead of subsequence logic.
- Filling intervals in the wrong order.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
