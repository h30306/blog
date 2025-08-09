---
title: "LeetCode 3: Longest Substring Without Repeating Characters"
summary: "LeetCode 解題紀錄"
description: "LeetCode Daily"
date: 2025-08-02
tags: ["LeetCode", "daily", "medium", "sliding window", "hashmap"]

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

## 解題思路

這題要求找出最長的不包含重複字符的子字串。關鍵思路是使用滑動窗口配合雜湊表來追蹤字符的出現次數。

**關鍵觀察：**
1. 我們需要維護一個沒有重複字符的窗口
2. 當遇到重複字符時，需要從左邊縮小窗口直到重複字符被移除
3. 可以使用雜湊表來追蹤當前窗口中每個字符的頻率
4. 任何有效窗口的最大長度就是我們的答案

**演算法：**
- 使用兩個指針（left 和 right）來維護滑動窗口
- 用雜湊表追蹤當前窗口中字符的頻率
- 當右指針遇到已存在於窗口中的字符時，移動左指針直到重複字符被移除
- 每當有有效窗口時更新最大長度

## 解法

### 方法一：使用雜湊表的滑動窗口
```python
from collections import defaultdict

class Solution:
    def lengthOfLongestSubstring(self, s: str) -> int:
        left = right = max_len = 0
        occur = defaultdict(int)
        n = len(s)

        while right < n:
            occur[s[right]] += 1
            # 從左邊縮小窗口直到沒有重複
            while occur[s[right]] > 1:
                occur[s[left]] -= 1
                left += 1
            max_len = max(max_len, right - left + 1)
            right += 1

        return max_len
```

### 方法二：使用集合的滑動窗口（替代方案）
```python
class Solution:
    def lengthOfLongestSubstring(self, s: str) -> int:
        left = max_len = 0
        char_set = set()
        n = len(s)
        
        for right in range(n):
            # 如果字符已在集合中，從左邊移除直到它消失
            while s[right] in char_set:
                char_set.remove(s[left])
                left += 1
            char_set.add(s[right])
            max_len = max(max_len, right - left + 1)
            
        return max_len
```

## 收穫

1. **時間複雜度**: O(n)，其中 n 是字串長度
   - 每個字符最多被訪問兩次（一次由右指針，一次由左指針）

2. **空間複雜度**: O(min(m, n))，其中 m 是字符集大小
   - 最壞情況下，我們存儲所有唯一字符

3. **關鍵洞察**: 滑動窗口技術非常適合這題，因為：
   - 我們需要維護連續的子字串
   - 我們需要高效地添加/移除字符
   - 我們需要追蹤重複項

4. **邊界情況**:
   - 空字串：返回 0
   - 單個字符：返回 1
   - 所有相同字符：返回 1
   - 無重複：返回字串長度

## 遇到的問題
