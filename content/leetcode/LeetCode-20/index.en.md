---
title: "LeetCode 20: Valid Parentheses"
summary: "Solving the Valid Parentheses problem using stack-based approach"
description: "LeetCode Daily Challenge - Check if a string of parentheses is valid using efficient stack algorithm"
date: 2025-08-10
tags: ["daily", "easy", "string", "stack", "data-structures", "parentheses", "validation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

**Difficulty:** Easy  
**First Attempt:** 2025-08-10  
**Total Time:** 00:00.00  
**Category:** Stack, String, Validation  
**Related Topics:** Parentheses Matching, Stack Operations, String Processing

## Intuition

This is a classic stack problem. The key insight is that for every opening parenthesis, we need to find its corresponding closing parenthesis. We use a stack to keep track of opening parentheses, and when we encounter a closing parenthesis, we check if it matches the most recent opening parenthesis on the stack. We must also handle edge cases like empty stack and unmatched parentheses.

## Approach

### Using Stack with Hash Map for Parentheses Mapping

```python
class Solution:
    def isValid(self, s: str) -> bool:
        parentheses = {
            "{" : "}",
            "[": "]",
            "(": ")"
        }
        stack = []

        for char in s:
            if char in parentheses:
                stack.append(char)
            else:
                last_char = stack.pop() if stack else ""
                if parentheses.get(last_char) != char:
                    return False

        return True if not stack else False
```

**Time Complexity:** O(n) where n is the length of string s  
**Space Complexity:** O(n) for the stack in worst case

## Key Insights

1. **Stack LIFO Property:** The last opening parenthesis must be closed first (Last In, First Out)
2. **Parentheses Mapping:** Using a hash map to store opening-closing pairs makes the code cleaner
3. **Stack Empty Check:** Always check if the stack is empty before popping to avoid errors
4. **Final Validation:** After processing all characters, the stack must be empty for valid parentheses

## Findings

- The stack approach is perfect for problems involving nested structures and matching pairs
- Using a hash map for parentheses mapping makes the code more readable and maintainable
- The time complexity is optimal at O(n) since we only need to traverse the string once
- This problem is a fundamental example of how stacks can be used for validation tasks

## Encountered Problems

- Initially struggled with handling the case when the stack is empty during popping operations
- Had to think about the order of parentheses matching (LIFO principle)
- Understanding that all opening parentheses must have corresponding closing parentheses was crucial
- The final check for empty stack was important to catch cases with unmatched opening parentheses 