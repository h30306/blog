---
title: "LeetCode 904: Fruit Into Baskets"
summary: "LeetCode Problem Solving - Variable Size Sliding Window with Hash Map"
description: "LeetCode Daily - Find maximum fruits with at most two types using sliding window"
date: 2025-08-05
tags: ["LeetCode", "daily", "medium", "sliding window", "hash map", "two pointers", "variable window"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-08-05
- Total time: 00:00.00

## Intuition

This is a sliding window problem with a hash map constraint. The problem states that we can have only two types of fruits in our basket, and our goal is to find the maximum number of fruits we can collect under this condition. This is a variable-size sliding window problem where we must shrink the window when the number of fruit types exceeds 2. We maintain a hash map to track the count of each fruit type and shrink the window from the left when we have more than two types.

## Approach

### Variable Size Sliding Window with Hash Map
```python
class Solution:
    def totalFruit(self, fruits: List[int]) -> int:
        pick = defaultdict(int)
        max_tree = 0

        left = 0
        for right in range(len(fruits)):
            # Add current fruit to basket
            pick[fruits[right]] += 1
    
            # Shrink window if we have more than 2 types
            while len(pick) > 2:
                pick[fruits[left]] -= 1
                if not pick[fruits[left]]:
                    del pick[fruits[left]]
                left += 1
            
            # Update maximum fruits collected
            max_tree = max(max_tree, right - left + 1)

        return max_tree
```

## Algorithm Analysis

### Time Complexity
- **Time**: O(n) where n is the length of the input array
- **Space**: O(1) since we only use a hash map with at most 3 entries

### Key Insights
1. **Variable Window Size**: Window size changes based on the number of fruit types
2. **Hash Map Tracking**: Use hash map to track count of each fruit type
3. **Window Shrinking**: Shrink window when fruit types exceed 2

## Findings

1. **Variable Size Sliding Window**: This problem demonstrates the variable-size sliding window technique, where the window size changes based on the constraint (number of fruit types).

2. **Hash Map Constraint Management**: We use a hash map to track the count of each fruit type, allowing us to efficiently determine when we have more than two types.

3. **Window Shrinking Strategy**: When the number of fruit types exceeds 2, we shrink the window from the left by removing fruits one by one until we're back to having at most 2 types.

4. **Efficient Fruit Removal**: We decrement the count of the fruit being removed and delete the entry entirely when the count reaches zero, keeping the hash map clean.

5. **Maximum Tracking**: We continuously update the maximum number of fruits collected whenever we have a valid window (at most 2 fruit types).

6. **Single Pass Solution**: The solution requires only one pass through the array, making it very efficient for large inputs.

7. **Memory Efficiency**: O(1) space complexity since the hash map will never have more than 3 entries (we delete entries when count reaches zero).

8. **Constraint-Based Optimization**: The key insight is that we can collect fruits continuously until we encounter a third type, then we must start removing fruits from the beginning.

## Encountered Problems 
