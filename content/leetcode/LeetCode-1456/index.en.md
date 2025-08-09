---
title: "LeetCode 1456: Maximum Number of Vowels in a Substring of Given Length"
summary: "LeetCode Problem Solving - Fixed Size Sliding Window with Vowel Counting"
description: "LeetCode Daily - Find maximum vowels in substring of given length using sliding window"
date: 2025-08-03
tags: ["LeetCode", "daily", "medium", "sliding window", "string", "vowel counting", "fixed window"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-08-03
- Total time: 00:00.00

## Intuition

This is a classic fixed-size sliding window problem. We need to maintain a window of size `k` and count the number of vowels within that window. As we slide the window, we add new vowels and remove old ones to maintain the correct count. The key insight is that we only need to track the vowel count within the current window and update the maximum count whenever we have a complete window.

## Approach

### Fixed Size Sliding Window with Vowel Counting
```python
class Solution:
    def maxVowels(self, s: str, k: int) -> int:
        count = 0
        max_count = 0
        vowel = "aeiou"

        for i in range(len(s)):
            # Add current character if it's a vowel
            if s[i] in vowel:
                count += 1
            
            # Remove character that falls outside the window
            if i - k >= 0 and s[i - k] in vowel:
                count -= 1
            
            # Update maximum count
            max_count = max(max_count, count)

        return max_count
```

## Algorithm Analysis

### Time Complexity
- **Time**: O(n) where n is the length of the input string
- **Space**: O(1) since we only use a constant amount of extra space

### Key Insights
1. **Fixed Window Size**: We maintain a window of exactly size `k`
2. **Vowel Counting**: We only need to track vowels, not all characters
3. **Window Management**: Add new vowels and remove old ones as window slides

## Findings

1. **Fixed Size Sliding Window**: This problem demonstrates the classic fixed-size sliding window technique, where we maintain a window of exactly size `k` and slide it through the string.

2. **Vowel Counting Strategy**: We only need to track the count of vowels in the window, not all characters. This simplifies the logic and makes the solution more efficient.

3. **Window Management**: The key insight is maintaining the correct window size by adding new vowels and removing old ones when the window exceeds size `k`.

4. **Character Set Optimization**: Using a string `"aeiou"` to check for vowels is more efficient than using a set or multiple if statements.

5. **Maximum Tracking**: We continuously update the maximum vowel count whenever we have a complete window (after the first `k` characters).

6. **Single Pass Solution**: The solution requires only one pass through the string, making it very efficient for large inputs.

7. **Memory Efficiency**: O(1) space complexity makes this solution very memory-efficient, as we only need a few variables to track the current count and maximum.

8. **Edge Case Handling**: The solution naturally handles edge cases like strings shorter than `k` by never finding valid windows.

## Encountered Problems 
