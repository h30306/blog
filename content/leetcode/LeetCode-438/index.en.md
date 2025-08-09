---
title: "LeetCode 438: Find All Anagrams in a String"
summary: "LeetCode Problem Solving - Sliding Window with Character Frequency"
description: "LeetCode Daily - Finding all anagrams of a pattern in a string using sliding window technique"
date: 2025-08-02
tags: ["LeetCode", "daily", "medium", "sliding window", "hash table", "string", "anagram", "frequency counting"]

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

Given two strings `s` and `p`, return an array of all the start indices of `p`'s anagrams in `s`. An Anagram is a word or phrase formed by rearranging the letters of a different word or phrase, typically using all the original letters exactly once.

## Intuition

My intuition is to use a hash table to store the occurrence of characters. When sliding the window, we count the element on the right and discount the element on the left. If the occurrence table matches the target count, that is the index we want and represents an anagram of the target. From the forum, there's a genius way using a frequency array to store the count of characters. By using an array with length 26, we can turn all characters to their ASCII ordinals. When sliding the window, we just match whether two arrays are equal, with no need to delete elements whose count equals zero. This saves time and eliminates redundant operations.

## Approach

### Method 1: Using Counter (Hash Table)
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

### Method 2: Using Frequency Array (More Efficient)
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

## Algorithm Analysis

### Time Complexity
- **Method 1**: O(n) where n is the length of string s
- **Method 2**: O(n) where n is the length of string s

### Space Complexity
- **Method 1**: O(k) where k is the size of the character set (worst case)
- **Method 2**: O(1) since we use a fixed-size array of 26 elements

## Findings

1. **Sliding Window with Character Counting**: This problem is a classic application of the sliding window technique combined with character frequency counting. We maintain a window of fixed size (equal to the length of pattern p) and track character frequencies.

2. **Two Implementation Approaches**: I explored two different approaches - one using Python's Counter class for hash table operations, and another using a fixed-size array for better performance. The array approach is more efficient as it avoids dictionary operations.

3. **ASCII-based Array Indexing**: Using `ord(c) - 97` (where 97 is the ASCII value of 'a') allows us to map lowercase letters to array indices 0-25, making the frequency counting very efficient.

4. **Window Management**: The key insight is maintaining the correct window size by adding new characters and removing old ones. The condition `i - len(p) >= 0` ensures we only start removing characters after the window is fully formed.

5. **Anagram Detection**: An anagram is detected when the frequency arrays match exactly. This is more efficient than comparing sorted strings or using other methods.

6. **Edge Case Handling**: We need to handle cases where the string s is shorter than the pattern p, in which case no anagrams can exist.

7. **Time Complexity**: O(n) where n is the length of string s, as we only need to traverse the string once.

8. **Space Complexity**: O(1) since we use a fixed-size array of 26 elements regardless of input size.

## Encountered Problems 

1. **Initial Hash Table Approach**: My first approach used Counter objects, which worked but was less efficient due to dictionary operations. The array-based approach proved to be much faster.

2. **Window Boundary Logic**: I initially struggled with the correct logic for sliding the window. The key was understanding that we need to add the current character first, then remove the character that falls outside the window.

3. **Index Calculation**: The calculation `i - len(p) + 1` for the starting index of an anagram was tricky. I had to carefully think about the relationship between the current position and the window boundaries.

4. **Character Frequency Management**: Ensuring that the frequency arrays are updated correctly when characters are added and removed from the window required careful attention to the order of operations.

5. **ASCII Mapping**: Initially, I was confused about the ASCII mapping (`ord(c) - 97`). Understanding that lowercase letters have ASCII values 97-122 helped clarify why we subtract 97 to get indices 0-25.

6. **Array Comparison**: The direct array comparison `window_now == target` is much more efficient than comparing Counter objects, as it avoids dictionary overhead.

## Key Takeaways

- **Sliding Window Technique**: Essential for problems involving substring analysis
- **Character Frequency Counting**: Efficient way to compare character distributions
- **Array vs Hash Table**: Fixed-size arrays can be more efficient than hash tables for known character sets
- **ASCII Manipulation**: Understanding ASCII values helps optimize character-based algorithms 