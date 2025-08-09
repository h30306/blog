---
title: "LeetCode 3: Longest Substring Without Repeating Characters"
summary: "LeetCode Problem Solving"
description: "LeetCode Daily"
date: 2025-08-02
tags: ["LeetCode", "daily", "medium", "sliding window", "hashmap"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-08-02
- Total time: 00:00.00

## Intuition

The problem requires finding the longest substring without duplicate characters. The key insight is to use a sliding window approach with a hashmap to track character occurrences.

**Key Observations:**
1. We need to maintain a window of characters with no duplicates
2. When we encounter a duplicate character, we need to shrink the window from the left until the duplicate is removed
3. We can use a hashmap to track the frequency of each character in the current window
4. The maximum length of any valid window gives us our answer

**Algorithm:**
- Use two pointers (left and right) to maintain the sliding window
- Keep a hashmap to track character frequencies in the current window
- When the right pointer encounters a character that already exists in the window, move the left pointer until the duplicate is removed
- Update the maximum length whenever we have a valid window

## Approach

### Method 1: Sliding Window with Hashmap
```python
from collections import defaultdict

class Solution:
    def lengthOfLongestSubstring(self, s: str) -> int:
        left = right = max_len = 0
        occur = defaultdict(int)
        n = len(s)

        while right < n:
            occur[s[right]] += 1
            # Shrink window from left until no duplicates
            while occur[s[right]] > 1:
                occur[s[left]] -= 1
                left += 1
            max_len = max(max_len, right - left + 1)
            right += 1

        return max_len
```

### Method 2: Sliding Window with Set (Alternative)
```python
class Solution:
    def lengthOfLongestSubstring(self, s: str) -> int:
        left = max_len = 0
        char_set = set()
        n = len(s)
        
        for right in range(n):
            # If character already in set, remove from left until it's gone
            while s[right] in char_set:
                char_set.remove(s[left])
                left += 1
            char_set.add(s[right])
            max_len = max(max_len, right - left + 1)
            
        return max_len
```

## Findings

1. **Time Complexity**: O(n) where n is the length of the string
   - Each character is visited at most twice (once by right pointer, once by left pointer)

2. **Space Complexity**: O(min(m, n)) where m is the size of the character set
   - In the worst case, we store all unique characters

3. **Key Insight**: The sliding window technique is perfect for this problem because:
   - We need to maintain a contiguous substring
   - We need to efficiently add/remove characters
   - We need to track duplicates

4. **Edge Cases**:
   - Empty string: returns 0
   - Single character: returns 1
   - All same characters: returns 1
   - No duplicates: returns length of string

## Encountered Problems