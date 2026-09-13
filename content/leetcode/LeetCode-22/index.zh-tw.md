---
title: "LeetCode 22: Generate Parentheses"
summary: "使用回溯法生成所有有效的括號組合"
description: "LeetCode 每日挑戰 - 生成括號問題的回溯解法"
date: 2025-08-10
tags: ["leetcode", "daily", "medium", "string", "backtracking", "recursion", "combinatorics", "parentheses"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: Medium
第一次嘗試： 2025-08-10
- 總花費時間：00:00.00

## 解題思路

這是一個回溯問題，我們需要生成所有有效的括號組合。關鍵洞察是確保在剩餘可用的位置中，右括號的數量始終小於或等於左括號的數量。這個約束條件保證了我們只生成有效的括號字串。

## 解法

這個解決方案使用回溯方法，具有以下關鍵約束：

1. **左括號約束**：如果 `left > 0`，我們可以添加左括號
2. **右括號約束**：只有當 `right > left` 時，我們才能添加右括號（確保有效性）
3. **基本情況**：當 `left` 和 `right` 都達到 0 時，我們有一個完整的有效字串

回溯函數追蹤：
- `left`：剩餘要放置的左括號數量
- `right`：剩餘要放置的右括號數量
- `s`：正在構建的當前字串

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

**時間複雜度**：O(4^n/√n) - 卡塔蘭數增長
**空間複雜度**：O(n) 用於遞迴堆疊

## 收穫

- **回溯效率**：這種方法有效地生成所有有效組合而不重複
- **基於約束的剪枝**：`right > left` 條件確保我們永遠不會生成無效的括號字串
- **卡塔蘭數**：有效括號組合的數量遵循卡塔蘭數序列
- **遞迴結構**：由於其組合性質，這個問題自然地適合遞迴解決方案

## 遇到的問題
