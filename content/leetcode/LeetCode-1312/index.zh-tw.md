---
title: "LeetCode 1312: Minimum Insertion Steps to Make a String Palindrome"
summary: "LeetCode 1312 解題筆記，依照原始 learning note 重新整理"
description: "2026-07-21 的 LeetCode 1312 學習紀錄，包含筆記修正點與正確解法"
date: 2026-07-21
tags: ["hard", "dynamic-programming", "string", "palindrome"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-07-21
來源：Day 39 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 筆記中提到的相關提醒

- `LC 1312`: pass after repair
- explain `LC 1312` with exact interval state and why mismatch is `1 + min(...)`

## 當天筆記摘錄

#### Problem 2 - LC 1312 Minimum Insertion Steps to Make a String Palindrome
- **Pattern:** interval DP on substrings with minimum repair cost.

#### Why This Fits
The real question is:
```text
what is the minimum number of insertions needed
to make s[left:right+1] a palindrome?
```

That is an interval question because:
- the problem is about both ends of one substring
- each decision shrinks the interval

#### Core State / Invariant
```text
dp[left][right] = minimum insertions needed to make s[left:right+1] a palindrome
```

#### Base Cases
Single character:
```text
dp[i][i] = 0
```

Reason:
```text
a single character is already a palindrome
```

Empty interval can be treated as:
```text
0
```

#### Transition
If the ends already match:
```text
s[left] == s[right]
=> dp[left][right] = dp[left + 1][right - 1]
```

If they do not match:
```text
dp[left][right] = 1 + min(
    dp[left + 1][right],
    dp[left][right - 1]
)
```

#### Why This Works
If the ends match:
- no new insertion is needed at the boundary
- just repair the inner interval

If the ends do not match:
- one insertion is needed now
- either insert a copy of `s[left]` near the right side
- or insert a copy of `s[right]` near the left side

Then solve the remaining smaller interval.

#### Fill Order
Solve shorter intervals first, usually by:
- increasing interval length
- or moving `left` backward while `right` moves forward

#### Alternative View Through LPS
You can also say:
```text
answer = len(s) - LPS(s)
```

Reason:
```text
the longest palindromic subsequence is what you keep;
all missing mirrored characters must be inserted
```

Interview-safe rule:
- direct interval DP is the stronger Day 4 answer
- `n - LPS` is a good pattern-transfer remark if asked

#### Complexity
```text
Time: O(n^2)
Space: O(n^2)
```

#### Common Mistakes
- using substring-removal wording instead of insertion wording
- saying mismatch is `1 + dp[left + 1][right - 1]`
- forgetting that matching ends need no extra insertion
- using prefix DP when the real dependency is on an interval
- being unable to explain what the insertion is actually mirroring

#### Strong Spoken Explanation
I define `dp[left][right]` as the minimum insertions needed to make `s[left:right+1]` a palindrome. A single character needs zero insertions. If the two ends already match, I do not need a new insertion at the boundary and I just solve the inner interval. If they do not match, I must insert one mirrored character, so I choose the cheaper of repairing `s[left+1:right+1]` or `s[left:right]` and add one. I fill shorter intervals first and the final answer is `dp[0][n - 1]`.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
class Solution:
    def minInsertions(self, s: str) -> int:
        n = len(s)
        dp = [[0] * n for _ in range(n)]

        for length in range(2, n + 1):
            for l in range(n - length + 1):
                r = l + length - 1
                if s[l] == s[r]:
                    dp[l][r] = dp[l + 1][r - 1]
                else:
                    dp[l][r] = 1 + min(dp[l + 1][r], dp[l][r - 1])

        return dp[0][n - 1] if n else 0
```

## 複雜度

Time O(n^2), Space O(n^2).

## 要特別避免的錯誤

- Confusing this with edit distance; only insertions are allowed.
- Filling intervals in the wrong order.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
