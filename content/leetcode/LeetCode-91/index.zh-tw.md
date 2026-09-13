---
title: "LeetCode 91: Decode Ways"
summary: "LeetCode 91 解題筆記，依照原始 learning note 重新整理"
description: "2026-04-28 的 LeetCode 91 學習紀錄，包含筆記修正點與正確解法"
date: 2026-04-28
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
第一次嘗試：2026-04-28
來源：Day 15 learning note

## 學習脈絡

這篇是從 learning note 裡該 LeetCode 題目的段落重新整理出來的版本。我保留當天筆記中的修正點、比較點、容易犯錯的地方，並移除同一天其他非 LeetCode 主題，避免文章內容混題。

## 當天筆記摘錄

#### Problem 2 - LC 91 Decode Ways
- **Status:** Good enough after index repair.
- **Pattern:** Counting DP on prefixes.

#### Why DP Fits
The number of ways to decode a prefix depends on whether the last one-digit or two-digit chunk is valid, so the total count can be built from smaller prefixes.

#### State
```text
dp[i] = number of ways to decode s[:i]
```

#### Base Case
```text
dp[0] = 1
```

Meaning:
```text
there is one base way to decode the empty prefix for counting DP
```

Also:
```text
if s[0] == "0", return 0
```

#### Transition
```text
dp[i] = 0
if s[i - 1] is valid:
    dp[i] += dp[i - 1]
if s[i - 2:i] is valid:
    dp[i] += dp[i - 2]
```

Valid one-digit chunk:
```text
"1" to "9"
```

Valid two-digit chunk:
```text
"10" to "26"
```

#### Complexity
```text
Time: O(n)
Space: O(n)
```

#### Main Repair Today
The repeated slip was:
```text
mixing dp indexing with string indexing
```

Must remember:
- `dp[i]` corresponds to `s[:i]`
- one-digit check uses `s[i - 1]`
- two-digit check uses `s[i - 2:i]`

#### Interview-Ready Explanation
I define `dp[i]` as the number of ways to decode the prefix `s[:i]`. At each position, I check whether the last one-digit chunk is valid and add `dp[i-1]`, and whether the last two-digit chunk is valid and add `dp[i-2]`. This is a counting DP problem, so `dp[0] = 1` is the correct base for the empty prefix.

## 正確解法

上面的筆記保留了推理脈絡和當天需要修正的點。下面是我會提交的版本。

```python
class Solution:
    def numDecodings(self, s: str) -> int:
        if not s or s[0] == '0':
            return 0
        prev2, prev1 = 1, 1

        for i in range(1, len(s)):
            curr = 0
            if s[i] != '0':
                curr += prev1
            two = int(s[i - 1:i + 1])
            if 10 <= two <= 26:
                curr += prev2
            prev2, prev1 = prev1, curr

        return prev1
```

## 複雜度

Time O(n), Space O(1).

## 要特別避免的錯誤

- Treating 0 as a valid standalone digit.
- Missing 10 and 20 as valid two-digit codes.

## 面試口說整理

先講清楚 state definition，再說 transition 為什麼維持這個 state。只要這題有 loop direction、狀態壓縮、或題型相似但 answer shape 不同的地方，就要主動講出來，因為那通常就是這類題最容易出錯的點。
