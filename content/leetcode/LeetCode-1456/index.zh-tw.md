---
title: "LeetCode 1456: Maximum Number of Vowels in a Substring of Given Length"
summary: "LeetCode 解題紀錄 - 固定大小滑動窗口與元音計數"
description: "LeetCode Daily - 使用滑動窗口尋找給定長度子串中的最大元音數量"
date: 2025-08-03
tags: ["LeetCode", "daily", "medium", "sliding window", "string", "vowel counting", "fixed window"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試： 2025-08-03
- 總花費時間：00:00.00

## 解題思路

這是一個經典的固定大小滑動窗口問題。我們需要維持一個大小為 `k` 的窗口並計算窗口內元音的數量。當我們滑動窗口時，我們添加新的元音並移除舊的元音以維持正確的計數。關鍵洞察是我們只需要追蹤當前窗口內的元音計數，並在每次有完整窗口時更新最大計數。

## 解法

### 固定大小滑動窗口與元音計數
```python
class Solution:
    def maxVowels(self, s: str, k: int) -> int:
        count = 0
        max_count = 0
        vowel = "aeiou"

        for i in range(len(s)):
            # 如果當前字符是元音，則添加
            if s[i] in vowel:
                count += 1
            
            # 移除落在窗口外的字符
            if i - k >= 0 and s[i - k] in vowel:
                count -= 1
            
            # 更新最大計數
            max_count = max(max_count, count)

        return max_count
```

## 演算法分析

### 時間複雜度
- **時間**: O(n)，其中 n 是輸入字符串的長度
- **空間**: O(1)，因為我們只使用常數量的額外空間

### 關鍵洞察
1. **固定窗口大小**: 我們維持一個恰好大小為 `k` 的窗口
2. **元音計數**: 我們只需要追蹤元音，而不是所有字符
3. **窗口管理**: 隨著窗口滑動，添加新元音並移除舊元音

## 收穫

1. **固定大小滑動窗口**: 這道題展示了經典的固定大小滑動窗口技巧，我們維持一個恰好大小為 `k` 的窗口並在字符串中滑動。

2. **元音計數策略**: 我們只需要追蹤窗口中元音的數量，而不是所有字符。這簡化了邏輯並使解決方案更高效。

3. **窗口管理**: 關鍵洞察是通過添加新元音和移除舊元音來維持正確的窗口大小，當窗口超過大小 `k` 時。

4. **字符集優化**: 使用字符串 `"aeiou"` 來檢查元音比使用集合或多個 if 語句更高效。

5. **最大值追蹤**: 每當我們有一個完整窗口（在前 `k` 個字符之後）時，我們持續更新最大元音計數。

6. **單次遍歷解決方案**: 解決方案只需要遍歷字符串一次，對於大型輸入非常高效。

7. **記憶體效率**: O(1) 空間複雜度使這個解決方案非常記憶體高效，因為我們只需要幾個變數來追蹤當前計數和最大值。

8. **邊界情況處理**: 解決方案自然地處理邊界情況，如比 `k` 短的字符串，通過永遠找不到有效窗口。

## 遇到的問題
