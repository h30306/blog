---
title: "LeetCode 2999: Count the Number of Powerful Integers"
summary: "LeetCode Problem Solving"
description: "LeetCode Daily"
date: 2025-04-11
tags: ["LeetCode", "blog", "daily", "hard"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2025-04-10
- Total time: 120:00.00 (giving up after two hours orz)

## Intuition

After my first attempt without any clue, I read the [Digit Dynamic Programming]({{< relref "Digit-Dynamic-Programming.md" >}}) article and solved this problem using the template by revising the state.

Unlike most Digit DP problems, this one requires an **extra comparison after reaching the last position**. For example, even after iterating through the tight digits like `123xx`, we still need to compare the suffix `xx` with the given `s` from the problem to determine whether the current number is valid. Therefore, an additional conditional statement is necessary.


## Approach

```
class Solution:
    def numberOfPowerfulInt(self, start: int, finish: int, limit: int, s: str) -> int:

        def count_powerful(number: int):
            
            digits = list(map(int, str(number)))

            if len(digits)<len(s):
                return 0
    
            from functools import lru_cache

            @lru_cache(None)
            def dfs(position: int, is_tight: bool):
                if position==(len(digits)-len(s)):
                    return not is_tight or str(number)[position:]>=s

                max_digit = min(digits[position], limit) if is_tight else limit
                res = 0

                for d in range(max_digit+1):
                    res += dfs(
                        position + 1,
                        is_tight and d==max_digit and limit>=digits[position]
                    )
                return res

            return dfs(0, True)

        return count_powerful(finish) - count_powerful(start-1)
```
## Findings
When implementing the `max_digit` logic, the `limit` is used to constrain all digits. Therefore, when calculating the next `is_tight` value, we should include a condition to check whether `limit` is greater than or equal to `digits[position]`. 

This indicates whether the current digit `d` exceeds `digits[position]`, and determines whether the tight constraint should continue to hold.

## Encountered Problems 
N/A, can't solve in the first time