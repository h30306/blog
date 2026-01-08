---
title: "LeetCode 22: Generate Parentheses"
summary: "Generating all valid parentheses combinations using backtracking approach"
description: "LeetCode Daily Challenge - Generate Parentheses problem with backtracking solution"
date: 2025-08-10
tags: ["LeetCode", "daily", "medium", "backtracking", "recursion", "string", "parentheses", "combinatorics"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: Medium
First Attempt: 2025-08-10
- Total time: 00:00.00

## Intuition

This is a backtracking problem where we need to generate all valid parentheses combinations. The key insight is to ensure that the right parenthesis count is always less than or equal to the left parenthesis count in the remaining available positions. This constraint guarantees that we only generate valid parentheses strings.

## Approach

The solution uses a backtracking approach with the following key constraints:

1. **Left parenthesis constraint**: We can add a left parenthesis if `left > 0`
2. **Right parenthesis constraint**: We can add a right parenthesis only if `right > left` (ensuring validity)
3. **Base case**: When both `left` and `right` reach 0, we have a complete valid string

The backtracking function tracks:
- `left`: remaining left parentheses to place
- `right`: remaining right parentheses to place  
- `s`: current string being built

```python
class Solution:
    def generateParenthesis(self, n: int) -> List[str]:
        res = []

        def backtracking(left, right, s):

            nonlocal res

            if left == 0 and right == 0:
                res.append(s)
                return
            
            if left > 0:
                backtracking(left - 1, right, s + "(")
            if right > left:
                backtracking(left, right - 1, s + ")")

        backtracking(n, n, "")

        return res
```

**Time Complexity**: O(4^n/√n) - Catalan number growth
**Space Complexity**: O(n) for the recursion stack

## Findings

- **Backtracking efficiency**: This approach efficiently generates all valid combinations without duplicates
- **Constraint-based pruning**: The `right > left` condition ensures we never generate invalid parentheses strings
- **Catalan numbers**: The number of valid parentheses combinations follows the Catalan number sequence
- **Recursive structure**: The problem naturally fits a recursive solution due to its combinatorial nature

## Encountered Problems 
