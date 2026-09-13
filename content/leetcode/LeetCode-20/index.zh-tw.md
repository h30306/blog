---
title: "LeetCode 20: Valid Parentheses"
summary: "使用堆疊解決有效括號問題"
description: "LeetCode 每日挑戰 - 使用高效的堆疊演算法檢查括號字串是否有效"
date: 2025-08-10
tags: ["daily", "easy", "string", "stack", "data-structures", "parentheses", "validation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

**難易度:** Easy  
**第一次嘗試:** 2025-08-10  
**總花費時間:** 00:00.00  
**分類:** 堆疊、字串、驗證  
**相關主題:** 括號匹配、堆疊操作、字串處理

## 解題思路

這是一個經典的堆疊問題。關鍵洞察是對於每個開括號，我們需要找到其對應的閉括號。我們使用堆疊來追蹤開括號，當遇到閉括號時，我們檢查它是否與堆疊頂部最近的開括號匹配。我們還必須處理邊界情況，如空堆疊和未匹配的括號。

## 解法

### 使用堆疊配合雜湊表進行括號映射

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

**時間複雜度:** O(n) 其中 n 是字串 s 的長度  
**空間複雜度:** O(n) 用於堆疊的最壞情況

## 關鍵洞察

1. **堆疊 LIFO 特性:** 最後的開括號必須先被關閉（後進先出）
2. **括號映射:** 使用雜湊表儲存開括號-閉括號對使程式碼更清晰
3. **堆疊空檢查:** 在彈出操作前始終檢查堆疊是否為空以避免錯誤
4. **最終驗證:** 處理完所有字元後，堆疊必須為空才表示括號有效

## 收穫

- 堆疊方法非常適合涉及巢狀結構和匹配對的問題
- 使用雜湊表進行括號映射使程式碼更易讀和維護
- 時間複雜度在 O(n) 是最佳的，因為我們只需要遍歷字串一次
- 這個問題是堆疊如何用於驗證任務的基本範例

## 遇到的問題

- 最初難以處理彈出操作時堆疊為空的情況
- 必須思考括號匹配的順序（LIFO 原則）
- 理解所有開括號都必須有對應的閉括號是關鍵
- 最終檢查空堆疊對於捕獲未匹配開括號的情況很重要