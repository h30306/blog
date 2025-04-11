---
title: "Digit Dynamic Programming"
summary: "Introduction to Digit Dynamic Programming"
description: "Algorithm Learning"
date: 2025-04-11
tags: ["algorithm"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Introduction

Digit Dynamic Programming (Digit DP) is a powerful technique used to solve problems related to **counting numbers with certain properties** within a range.

Typically, you are given a number range from `start` to `finish`, and a set of digit-based constraints. The goal is to count how many numbers within the range satisfy the conditions. 

For example, given `start = 10` and `finish = 25`, we may be asked to return the count of numbers in this range whose digit sum is even, or that do not contain repeated digits, etc.

Unlike standard DP which focuses on elements in a list or matrix, Digit DP focuses on the **digits** of numbers — handling them one-by-one from the most significant digit to the least.

---

## Core Idea

Digit DP is essentially a **top-down recursive DFS with memoization**. The key idea is to build numbers **digit by digit**, while maintaining constraints at each level.

The most important concept in Digit DP is the `tight` (or `is_tight`) parameter, which tells us whether we are **still bound by the original number’s digits**.

For example, suppose we are building a number from left to right and the target number is `125`. As long as we choose the digits that match `1`, `2`, ... etc., we are still *tight*. The moment we choose a smaller digit (like `0` instead of `1`), we are **no longer tight**, and future digits can range freely from 0 to 9.

---

## Template

Here is a generic template for a Digit DP function:

```python
def digit_dp(n: int):
    digits = list(map(int, str(n)))

    from functools import lru_cache

    @lru_cache(None)
    def dfs(pos: int, tight: bool, some_state):
        if pos == len(digits):
            return base_case_result

        max_digit = digits[pos] if tight else 9
        res = 0

        for d in range(0, max_digit + 1):
            res += dfs(
                pos + 1,
                tight and d == max_digit,
                update_state(some_state, d)
            )
        return res

    return dfs(0, True, initial_state)
```
### Explanation of the key parameters:

- `pos`: the current digit position (starting from 0, left to right).

- `tight`: whether the current number prefix matches the original number `n`. If `tight` is `True`, the current digit must be ≤ `digits[pos]`.

- `some_state`: this is the custom state you define based on the problem. It could be:
  - digit sum
  - number of 1s
  - previous digit (for checking repetition)
  - whether a pattern has occurred
  - etc.

## Examples

### Count Digit Sum

```python
def count_digit_sum(n: int , target: int):
    digits = list(map(int, str(n)))

    from functools import lru_cache

    @lru_cache(None)
    def dfs(position: int, tight: bool, digit_sum: int) -> int:
        if position == len(digits):
            return int(digit_sum == target)
        
        max_digit = digits[position] if tight else 9
        result = 0
        
        for digit in range(0, max_digit+1):
            result += dfs(
                position + 1,
                tight and (digit==max_digit),
                digit_sum + digit
            )
        
        return result
    
    return dfs(0, True, 0)
```
### Non Continuos Duplicate Number
```python
def non_duplicate_number(number: int):
    digits = list(map(int, str(number)))

    from functools import lru_cache


    @lru_cache(None)
    def dfs(position: int, tight: bool, prev_digit: int, leading_zero: bool):
        if position==len(digits):
            return 1
        
        max_digit = digits[position] if tight else 9
        res = 0

        for d in range(max_digit+1):
            if d == prev_digit and not leading_zero:
                continue
            res += dfs(
                position +1,
                tight and d==max_digit,
                d,
                leading_zero and not d
            )
        
        return res
    
    return dfs(0, True, -1, True)
```

### Even Number
```python
def even_number(number: int):
    digits = list(map(int, str(number)))

    from functools import lru_cache

    @lru_cache(None)
    def dfs(position: int, tight:bool, parity:int):
        if position==len(digits):
            return int(parity == 0)
        
        max_digit = digits[position] if tight else 9
        res = 0
        for d in range(max_digit+1):
            res += dfs(
                position+1,
                tight and (d==max_digit),
                (parity + d) % 2
            )

        return res
    
    return dfs(0, True, 0)
```