---
title: "LeetCode 150: Evaluate Reverse Polish Notation"
summary: "Solving the Reverse Polish Notation evaluation problem using stack-based approach"
description: "LeetCode Daily Challenge - Evaluate mathematical expressions in Reverse Polish Notation using efficient stack algorithm"
date: 2025-08-10
tags: ["daily", "medium", "stack", "data-structures", "expression-evaluation", "math", "postfix-notation", "reverse-polish-notation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

**Difficulty:** Medium  
**First Attempt:** 2025-08-10  
**Total Time:** 00:00.00  
**Category:** Stack, Expression Evaluation, Mathematics  
**Related Topics:** Reverse Polish Notation, Postfix Notation, Mathematical Operations, Stack Operations

## Intuition

This is a classic stack problem for evaluating Reverse Polish Notation (RPN). The key insight is that RPN eliminates the need for parentheses by placing operators after their operands. We use a stack to keep track of numbers, and when we encounter an operator, we pop the top two numbers, perform the operation, and push the result back onto the stack. Remember to handle data type conversion when calculating and returning the result.

## Approach

### Using Stack for RPN Evaluation

```python
class Solution:
    def evalRPN(self, tokens: List[str]) -> int:
        stack = []
        for token in tokens:
            if token in "+-*/":
                num1 = int(stack.pop())
                num2 = int(stack.pop())
                if token == "+":
                    stack.append(num1 + num2)
                elif token == "-":
                    stack.append(num2 - num1)
                elif token == "*":
                    stack.append(num2 * num1)
                else:
                    stack.append(num2 / num1)
            else:
                stack.append(token)

        return int(stack[-1])
```

**Time Complexity:** O(n) where n is the length of tokens array  
**Space Complexity:** O(n) for the stack in worst case

## Key Insights

1. **Stack LIFO Property:** The last two numbers pushed onto the stack are the operands for the next operation
2. **Operator Order:** When encountering an operator, we pop the top two numbers and perform the operation
3. **Data Type Handling:** Always convert tokens to integers when performing calculations
4. **Result Conversion:** The final result should be converted back to an integer

## Findings

- The stack approach is perfect for problems involving expression evaluation and mathematical operations
- RPN eliminates the need for parentheses and operator precedence rules
- The time complexity is optimal at O(n) since we only need to traverse the tokens once
- This problem demonstrates how stacks can be used to evaluate mathematical expressions efficiently

## Encountered Problems

- Initially struggled with understanding the order of operands when performing subtraction and division
- Had to think about the stack order and how to handle the operands correctly
- The stack approach became clear after visualizing how each operator processes the top two numbers
- Understanding the LIFO nature of the stack was crucial for correct operand ordering 