---
title: "LeetCode 76: Minimum Window Substring"
summary: "LeetCode Problem Solving - Variable Size Sliding Window with Character Counting"
description: "LeetCode Daily - Find minimum window substring containing all characters from target"
date: 2025-08-05
tags: ["LeetCode", "daily", "hard", "sliding window", "string", "hash map", "two pointers", "variable window"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2025-08-05
- Total time: 00:00.00

## Intuition

This is a sliding window problem with a condition that requires shrinking the window size from left to right. The intuition is to first count the occurrence of characters in the target string, then expand or shrink the window from left to right. If the occurrence in the window equals the target, we record the window size. However, there's an important consideration: the window size might not be the minimum size that fulfills the condition because the occurrence might be more than what the target wants. Thus, we must shrink the window and update the occurrence map until it's no longer equal to the target.

## Approach

### Variable Size Sliding Window with Character Counting
```python
class Solution:
    def minWindow(self, s: str, t: str) -> str:
        m = len(s)
        n = len(t)

        # Handle edge case
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
            # Expand window and update character count
            if occur[char] < target[char]:
                target_char_remaining -= 1
            occur[char] += 1

            # Shrink window when all target characters are found
            while target_char_remaining == 0:
                if right - left < min_window[1] - min_window[0]:
                    min_window = (left, right)

                # Remove character from left side of window
                char = s[left]
                if occur[char] == target[char]:
                    target_char_remaining += 1
                occur[char] -= 1
                left += 1

        return "" if min_window[1] > len(s) else s[min_window[0]:min_window[1]+1]
```

## Algorithm Analysis

### Time Complexity
- **Time**: O(n) where n is the length of string s
- **Space**: O(k) where k is the number of unique characters in t

### Key Insights
1. **Variable Window Size**: Window size changes based on character requirements
2. **Character Counting**: Use hash maps to track character frequencies
3. **Global Counter**: Use `target_char_remaining` to track remaining characters needed

## Findings

1. **Variable Size Sliding Window**: This problem demonstrates the variable-size sliding window technique, where the window size changes based on the constraint (having all target characters).

2. **Character Frequency Tracking**: We use hash maps to track the frequency of characters in both the target string and the current window, allowing us to efficiently determine when we have all required characters.

3. **Global Counter Strategy**: Instead of comparing two hash maps directly, we use a global counter `target_char_remaining` to track how many target characters we still need to find.

4. **Window Shrinking Logic**: When we have all target characters, we shrink the window from the left until we no longer have all required characters, ensuring we find the minimum valid window.

5. **Minimum Window Tracking**: We continuously update the minimum window whenever we find a valid window (all target characters present) that is smaller than the current minimum.

6. **Character Removal Logic**: When removing characters from the left side, we only increment `target_char_remaining` when the character count equals the target count, ensuring we don't over-count.

7. **Single Pass Solution**: The solution requires only one pass through the string, making it very efficient for large inputs.

8. **Edge Case Handling**: We handle edge cases like when the source string is shorter than the target string.

## Encountered Problems 

1. **Hash Map Comparison Issue**: I initially tried to compare two hash maps (target and current count), but this was problematic because some character counts in the current window might be larger than the target, making direct comparison difficult.

2. **Global Counter Solution**: The key insight was to use a global counter `target_char_remaining` to track the remaining target characters needed, which simplifies the logic significantly.
