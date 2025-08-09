---
title: "LeetCode 76: Minimum Window Substring"
summary: "LeetCode 解題紀錄 - 可變大小滑動窗口與字符計數"
description: "LeetCode Daily - 使用滑動窗口尋找包含目標所有字符的最小窗口子串"
date: 2025-08-05
tags: ["LeetCode", "daily", "hard", "sliding window", "string", "hash map", "two pointers", "variable window"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試： 2025-08-05
- 總花費時間：00:00.00

## 解題思路

這是一個需要從左到右縮小窗口大小的條件滑動窗口問題。直覺是首先計算目標字符串中字符的出現次數，然後從左到右擴展或縮小窗口。如果窗口中的出現次數等於目標，我們記錄窗口大小。然而，有一個重要的考慮：窗口大小可能不是滿足條件的最小大小，因為出現次數可能超過目標想要的數量。因此，我們必須縮小窗口並更新出現次數映射，直到它不再等於目標。

## 解法

### 可變大小滑動窗口與字符計數
```python
class Solution:
    def minWindow(self, s: str, t: str) -> str:
        m = len(s)
        n = len(t)

        # 處理邊界情況
        if m < n:
            return ""

        left = 0
        target = defaultdict(int)
        for ch in t:
            target[ch] += 1

        occur = defaultdict(int)
        target_char_remaining = n
        min_window = (0, float("inf"))

        for right, char in enumerate(s):
            # 擴展窗口並更新字符計數
            if occur[char] < target[char]:
                target_char_remaining -= 1
            occur[char] += 1

            # 當找到所有目標字符時縮小窗口
            while target_char_remaining == 0:
                # 如果當前窗口更小，則更新最小窗口
                if right - left < min_window[1] - min_window[0]:
                    min_window = (left, right)

                # 從窗口左側移除字符
                char = s[left]
                if occur[char] == target[char]:
                    target_char_remaining += 1
                occur[char] -= 1
                left += 1

        return "" if min_window[1] > len(s) else s[min_window[0]:min_window[1]+1]
```

## 演算法分析

### 時間複雜度
- **時間**: O(n)，其中 n 是字符串 s 的長度
- **空間**: O(k)，其中 k 是字符串 t 中唯一字符的數量

### 關鍵洞察
1. **可變窗口大小**: 窗口大小根據字符需求變化
2. **字符計數**: 使用雜湊表追蹤字符頻率
3. **全局計數器**: 使用 `target_char_remaining` 追蹤剩餘需要的目標字符

## 收穫

1. **可變大小滑動窗口**: 這道題展示了可變大小滑動窗口技巧，其中窗口大小根據約束條件（擁有所有目標字符）變化。

2. **字符頻率追蹤**: 我們使用雜湊表來追蹤目標字符串和當前窗口中字符的頻率，使我們能夠高效地確定何時擁有所有必需的字符。

3. **全局計數器策略**: 與其直接比較兩個雜湊表，我們使用全局計數器 `target_char_remaining` 來追蹤我們仍然需要找到的目標字符數量。

4. **窗口縮小邏輯**: 當我們擁有所有目標字符時，我們從左側縮小窗口，直到我們不再擁有所有必需的字符，確保我們找到最小的有效窗口。

5. **最小窗口追蹤**: 每當我們找到一個比當前最小值更小的有效窗口（所有目標字符存在）時，我們持續更新最小窗口。

6. **字符移除邏輯**: 從左側移除字符時，我們只在字符計數等於目標計數時遞增 `target_char_remaining`，確保我們不會過度計數。

7. **單次遍歷解決方案**: 解決方案只需要遍歷字符串一次，對於大型輸入非常高效。

8. **邊界情況處理**: 我們處理邊界情況，如當源字符串比目標字符串短時。

## 遇到的問題

1. **雜湊表比較問題**: 我最初嘗試比較兩個雜湊表（目標和當前計數），但這有問題，因為當前窗口中的一些字符計數可能大於目標，使直接比較變得困難。

2. **全局計數器解決方案**: 關鍵洞察是使用全局計數器 `target_char_remaining` 來追蹤剩餘需要的目標字符，這顯著簡化了邏輯。
