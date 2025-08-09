---
title: "LeetCode 567: Permutation in String"
summary: "LeetCode Problem Solving - Sliding Window with Character Frequency"
description: "LeetCode Daily - Check if one string's permutation is a substring of another string"
date: 2025-08-02
tags: ["LeetCode", "daily", "medium", "sliding window", "string", "permutation", "frequency counting", "hash table"]

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

## Problem Description

Given two strings `s1` and `s2`, return `true` if `s2` contains a permutation of `s1`, or `false` otherwise. In other words, return `true` if one of `s1`'s permutations is the substring of `s2`.

## Intuition

This problem is very similar to [LeetCode 438: Find All Anagrams in a String](/leetcode/LeetCode-438/). We can use an array with length 26 to store the occurrence of characters and match the target when sliding the window. The key difference is that we only need to find one match instead of all matches, so we can return `true` as soon as we find a valid permutation.

## Approach

### Sliding Window with Frequency Array
```python
class Solution:
    def checkInclusion(self, s1: str, s2: str) -> bool:
        freq_s1 = [0] * 26
        freq_s2 = [0] * 26

        def get_ord_index(num):
            return ord(num) - 97

        # Initialize frequency array for s1
        for c in s1:
            idx = get_ord_index(c)
            freq_s1[idx] += 1

        # Slide window through s2
        for i in range(len(s2)):
            idx = get_ord_index(s2[i])
            freq_s2[idx] += 1

            # Remove character that falls outside the window
            if i - len(s1) >= 0:
                 idx = get_ord_index(s2[i - len(s1)])
                 freq_s2[idx] -= 1

            # Check if current window matches s1's frequency
            if freq_s2 == freq_s1:
                return True

        return False
```

## Algorithm Analysis

### Time Complexity
- **Time**: O(n) where n is the length of string s2
- **Space**: O(1) since we use fixed-size arrays of 26 elements

### Key Optimizations
1. **Early Return**: We return `true` as soon as we find a match, unlike LeetCode 438 where we need to find all matches
2. **Fixed Array Size**: Using arrays instead of hash tables for better performance
3. **ASCII Mapping**: Efficient character-to-index mapping using `ord(c) - 97`

## Findings

1. **Sliding Window Application**: This problem demonstrates how the sliding window technique can be adapted for different requirements - finding one match vs. finding all matches.

2. **Character Frequency Comparison**: Using fixed-size arrays for character frequency counting is more efficient than hash tables when dealing with a known character set (lowercase letters).

3. **Optimization Opportunity**: Unlike LeetCode 438, we can optimize by returning early as soon as we find the first valid permutation, making this problem potentially faster in practice.

4. **ASCII Index Mapping**: The `ord(c) - 97` mapping efficiently converts lowercase letters to array indices 0-25, avoiding dictionary overhead.

5. **Window Management**: The sliding window maintains a fixed size equal to the length of s1, ensuring we only check windows that could potentially contain a permutation.

6. **Frequency Array Comparison**: Direct array comparison `freq_s2 == freq_s1` is more efficient than comparing Counter objects or sorted strings.

7. **Edge Case Handling**: The solution naturally handles cases where s2 is shorter than s1 by never finding a match.

8. **Memory Efficiency**: O(1) space complexity makes this solution very memory-efficient for large inputs.

## Encountered Problems 

1. **Initial Approach Confusion**: I initially tried to use the same approach as LeetCode 438, but had to adapt it to return early when finding the first match instead of collecting all matches.

2. **Window Size Management**: Ensuring the window size remains exactly equal to the length of s1 was crucial. I had to carefully manage when to start removing characters from the frequency count.

3. **Index Calculation**: The calculation for removing characters that fall outside the window (`i - len(s1)`) required careful attention to ensure correct window boundaries.

4. **Frequency Array Initialization**: I had to ensure that the frequency array for s1 is properly initialized before starting the sliding window process.

5. **Early Return Logic**: Understanding when to return `true` was important - we need to check for matches after each character addition, not just at the end.

6. **Character Mapping**: Initially, I was confused about the ASCII mapping. Understanding that lowercase letters have ASCII values 97-122 helped clarify the `ord(c) - 97` calculation.

## Key Takeaways

- **Sliding Window Adaptation**: The same technique can be adapted for different problem requirements
- **Early Optimization**: When only one match is needed, early return can significantly improve performance
- **Character Frequency Arrays**: Fixed-size arrays are more efficient than hash tables for known character sets
- **ASCII Manipulation**: Understanding ASCII values helps optimize character-based algorithms
- **Window Boundary Management**: Careful attention to window boundaries is crucial for correct implementation 