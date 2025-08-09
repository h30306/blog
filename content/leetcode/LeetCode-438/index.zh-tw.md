---
title: "LeetCode 438: Find All Anagrams in a String"
summary: "LeetCode 解題紀錄 - 使用字符頻率的滑動窗口"
description: "LeetCode Daily - 使用滑動窗口技巧在字符串中尋找模式的所有變位詞"
date: 2025-08-02
tags: ["LeetCode", "daily", "medium", "sliding window", "hash table", "string", "anagram", "frequency counting"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試： 2025-08-02
- 總花費時間：00:00.00

## 問題描述

給定兩個字符串 `s` 和 `p`，返回 `s` 中所有 `p` 的變位詞的起始索引陣列。變位詞是通過重新排列不同單詞或短語的字母而形成的單詞或短語，通常使用所有原始字母恰好一次。

## 解題思路

我的直覺是使用雜湊表來存儲字符的出現次數。在滑動窗口時，我們計算右側的元素並扣除左側的元素。如果出現次數表與目標計數匹配，那就是我們想要的索引，代表目標的變位詞。從論壇中，有一個巧妙的方法使用頻率陣列來存儲字符的計數。通過使用長度為26的陣列，我們可以將所有字符轉換為ASCII序數。在滑動窗口時，我們只需要匹配兩個陣列是否相等，無需刪除計數為零的元素，這節省了時間並消除了冗餘操作。

## 解法

### 方法一：使用 Counter（雜湊表）
```python
class Solution:
    def findAnagrams(self, s: str, p: str) -> List[int]:
        len_s = len(s)
        len_p = len(p)

        res = []
        if len(s) < len(p):
            return res
        
        occur = Counter(s[:len_p])
        target = Counter(p)

        if occur == target:
            res.append(0)

        for i in range(len_p, len_s):
            occur[s[i]] += 1
            occur[s[i - len_p]] -= 1
            if occur[s[i - len_p]] == 0:
                del occur[s[i - len_p]]

            if occur == target:
                res.append(i - len_p + 1)

        return res
```

### 方法二：使用頻率陣列（更高效）
```python
class Solution:
    def findAnagrams(self, s: str, p: str) -> List[int]:
        window_now = [0] * 26
        target = [0] * 26
        res = []

        for c in p:
            target[ord(c) - 97] += 1

        for i in range(len(s)):
            window_now[ord(s[i]) - 97] += 1

            if i - len(p) >= 0:
                window_now[ord(s[i - len(p)]) - 97] -= 1

            if window_now == target:
                res.append(i - len(p) + 1)

        return res
```

## 演算法分析

### 時間複雜度
- **方法一**: O(n)，其中 n 是字符串 s 的長度
- **方法二**: O(n)，其中 n 是字符串 s 的長度

### 空間複雜度
- **方法一**: O(k)，其中 k 是字符集的大小（最壞情況）
- **方法二**: O(1)，因為我們使用固定大小的26元素陣列

## 收穫

1. **滑動窗口與字符計數**: 這道題是滑動窗口技巧結合字符頻率計數的經典應用。我們維護一個固定大小的窗口（等於模式p的長度）並追蹤字符頻率。

2. **兩種實現方法**: 我探索了兩種不同的方法 - 一種使用Python的Counter類進行雜湊表操作，另一種使用固定大小陣列以獲得更好的性能。陣列方法更高效，因為它避免了字典操作。

3. **基於ASCII的陣列索引**: 使用 `ord(c) - 97`（其中97是'a'的ASCII值）允許我們將小寫字母映射到陣列索引0-25，使頻率計數非常高效。

4. **窗口管理**: 關鍵洞察是通過添加新字符和移除舊字符來維持正確的窗口大小。條件 `i - len(p) >= 0` 確保我們只在窗口完全形成後才開始移除字符。

5. **變位詞檢測**: 當頻率陣列完全匹配時檢測到變位詞。這比比較排序字符串或使用其他方法更高效。

6. **邊界情況處理**: 我們需要處理字符串s比模式p短的情況，在這種情況下不可能存在變位詞。

7. **時間複雜度**: O(n)，其中n是字符串s的長度，因為我們只需要遍歷字符串一次。

8. **空間複雜度**: O(1)，因為我們使用固定大小的26元素陣列，無論輸入大小如何。

## 遇到的問題

1. **初始雜湊表方法**: 我的第一個方法使用Counter對象，雖然有效但由於字典操作效率較低。基於陣列的方法證明要快得多。

2. **窗口邊界邏輯**: 我最初對滑動窗口的正確邏輯感到困惑。關鍵是理解我們需要先添加當前字符，然後移除落在窗口外的字符。

3. **索引計算**: 變位詞起始索引的計算 `i - len(p) + 1` 很棘手。我必須仔細思考當前位置與窗口邊界之間的關係。

4. **字符頻率管理**: 確保當字符被添加到窗口和從窗口中移除時，頻率陣列正確更新需要仔細注意操作的順序。

5. **ASCII映射**: 最初，我對ASCII映射（`ord(c) - 97`）感到困惑。理解小寫字母的ASCII值為97-122有助於澄清為什麼我們減去97來獲得索引0-25。

6. **陣列比較**: 直接陣列比較 `window_now == target` 比比較Counter對象更高效，因為它避免了字典開銷。

## 關鍵要點

- **滑動窗口技巧**: 對於涉及子字符串分析的問題至關重要
- **字符頻率計數**: 比較字符分佈的高效方法
- **陣列 vs 雜湊表**: 對於已知字符集，固定大小陣列可能比雜湊表更高效
- **ASCII操作**: 理解ASCII值有助於優化基於字符的演算法
