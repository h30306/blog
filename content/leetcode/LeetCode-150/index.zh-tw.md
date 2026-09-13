---
title: "LeetCode 150: Evaluate Reverse Polish Notation"
summary: "使用堆疊解決逆波蘭表示法求值問題"
description: "LeetCode 每日挑戰 - 使用高效的堆疊演算法求值逆波蘭表示法的數學表達式"
date: 2025-08-10
tags: ["daily", "medium", "stack", "data-structures", "expression-evaluation", "math", "postfix-notation", "reverse-polish-notation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

**難易度:** Medium  
**第一次嘗試:** 2025-08-10  
**總花費時間:** 00:00.00  
**分類:** 堆疊、表達式求值、數學  
**相關主題:** 逆波蘭表示法、後綴表示法、數學運算、堆疊操作

## 解題思路

這是一個經典的堆疊問題，用於求值逆波蘭表示法（RPN）。關鍵洞察是 RPN 通過將運算符放在運算數之後來消除對括號的需求。我們使用堆疊來追蹤數字，當遇到運算符時，我們彈出頂部的兩個數字，執行運算，並將結果推回堆疊。記住在計算和返回結果時要處理資料類型轉換。

## 解法

### 使用堆疊進行 RPN 求值

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

**時間複雜度:** O(n) 其中 n 是 tokens 陣列的長度  
**空間複雜度:** O(n) 用於堆疊的最壞情況

## 關鍵洞察

1. **堆疊 LIFO 特性:** 最後推入堆疊的兩個數字是下一個運算的運算數
2. **運算符順序:** 當遇到運算符時，我們彈出頂部的兩個數字並執行運算
3. **資料類型處理:** 在執行計算時始終將 tokens 轉換為整數
4. **結果轉換:** 最終結果應該轉換回整數

## 收穫

- 堆疊方法非常適合涉及表達式求值和數學運算的問題
- RPN 消除了對括號和運算符優先級規則的需求
- 時間複雜度在 O(n) 是最佳的，因為我們只需要遍歷 tokens 一次
- 這個問題展示了堆疊如何用於高效求值數學表達式

## 遇到的問題

- 最初難以理解執行減法和除法時運算數的順序
- 必須思考堆疊順序以及如何正確處理運算數
- 在視覺化每個運算符如何處理頂部兩個數字後，堆疊方法變得清晰
- 理解堆疊的 LIFO 特性對於正確的運算數順序至關重要