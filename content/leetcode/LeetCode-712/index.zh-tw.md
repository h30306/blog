---
title: "LeetCode 712: Minimum ASCII Delete Sum for Two Strings"
summary: "LeetCode 712 解題筆記，依照原始 learning note 重新整理"
description: "2026-07-21 的 LeetCode 712 學習紀錄，包含筆記修正點與正確解法"
date: 2026-07-21
tags: ["medium", "dynamic-programming", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-07-21
來源：Day 39 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 筆記中提到的相關提醒

- `LC 712`: pass after repair
- explain `LC 712` with exact weighted delete-cost state, ASCII-sum base cases, and mismatch branches

## 當天筆記摘錄

#### Problem 1 - LC 712 Minimum ASCII Delete Sum for Two Strings
- **Pattern:** 2D DP on two prefixes with weighted delete-only cost.

#### Why This Fits
The real question is:
```text
what is the minimum total ASCII delete cost needed
to make s1[:i] and s2[:j] equal?
```

That is still a two-prefix table, but now:
- mismatch cost is not always `1`
- it depends on which character is deleted

#### Core State / Invariant
```text
dp[i][j] = minimum ASCII delete cost needed to make s1[:i] and s2[:j] equal
```

#### Base Cases
If `s2` is empty:
```text
dp[i][0] = sum(ASCII values of s1[:i])
```

Reason:
```text
every character in s1[:i] must be deleted
```

If `s1` is empty:
```text
dp[0][j] = sum(ASCII values of s2[:j])
```

Reason:
```text
every character in s2[:j] must be deleted
```

#### Transition
If the current characters already match:
```text
s1[i - 1] == s2[j - 1]
=> dp[i][j] = dp[i - 1][j - 1]
```

If they do not match:
```text
dp[i][j] = min(
    dp[i - 1][j] + ASCII(s1[i - 1]),
    dp[i][j - 1] + ASCII(s2[j - 1])
)
```

#### Why This Works
On mismatch, the final equal strings cannot keep both current characters.

So one of them must be deleted first:
- delete from `s1`
- or delete from `s2`

Then solve the smaller prefix problem.

Unlike `LC 72`, there is:
- no replace
- no insert

Unlike `LC 583`, the delete cost is:
- weighted by character value
- not unit cost

#### Alternative View
There is also a relation to keeping the maximum ASCII-sum common subsequence:
```text
answer = sumASCII(s1) + sumASCII(s2) - 2 * maxKeptCommonASCII
```

Interview-safe rule:
- the direct delete-cost DP is easier to derive correctly in real time
- mention the reduction only if asked for a connection to `LCS`

#### Complexity
```text
Time: O(m * n)
Space: O(m * n)
```

Can be compressed to:
```text
Space: O(n)
```

#### Common Mistakes
- copying `LC 583` and leaving base cases as prefix lengths instead of ASCII prefix sums
- adding a diagonal mismatch branch because edit distance is still in your head
- saying `delete the cheaper side` greedily without DP
- forgetting that match means no extra delete cost
- mixing up character value with index value

#### Strong Spoken Explanation
I define `dp[i][j]` as the minimum total ASCII delete cost needed to make `s1[:i]` and `s2[:j]` equal. If one prefix is empty, the only option is to delete every character from the other prefix, so the first row and first column are prefix ASCII sums, not prefix lengths. If the current characters match, I can keep both and take the diagonal with no extra cost. If they do not match, one of the two current characters must be deleted first, so I try deleting from `s1` or deleting from `s2` and add that character's ASCII value. The answer is `dp[m][n]`.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
class Solution:
    def minimumDeleteSum(self, s1: str, s2: str) -> int:
        n = len(s2)
        dp = [0] * (n + 1)
        for j in range(1, n + 1):
            dp[j] = dp[j - 1] + ord(s2[j - 1])

        for i in range(1, len(s1) + 1):
            prev_diag = dp[0]
            dp[0] += ord(s1[i - 1])
            for j in range(1, n + 1):
                old = dp[j]
                if s1[i - 1] == s2[j - 1]:
                    dp[j] = prev_diag
                else:
                    dp[j] = min(dp[j] + ord(s1[i - 1]), dp[j - 1] + ord(s2[j - 1]))
                prev_diag = old

        return dp[n]
```

## 複雜度

Time O(mn), Space O(n).

## 要特別避免的錯誤

- Using unit-cost LC 583 recurrence.
- Forgetting weighted base cases.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
