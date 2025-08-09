---
title: "LeetCode 239: Sliding Window Maximum"
summary: "LeetCode Problem Solving"
description: "LeetCode Daily"
date: 2025-08-02
tags: ["LeetCode", "daily", "hard", "Monotonic Queue"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: hard
First Attempt: 2025-08-02
- Total time: 00:00.00

## Intuition

This problem is the first time I used a deque. The concept is to maintain a deque that keeps the numbers sorted within the fixed window. The key insight is that we can pop elements from the queue if they are smaller than the element we're currently iterating, because if a bigger element appears in the window, the smaller elements become useless when we're finding the maximum number in a span. How do we ensure that all elements in the queue are within the span? We store the indices in the queue and check the first element in every step to see if the index is already out of the span - if so, we pop it out. Since we do this check in every iteration, we can always maintain that the queue contains only elements within the current window.

## Approach

```python
class Solution:
    def maxSlidingWindow(self, nums: List[int], k: int) -> List[int]:
        q = deque()
        res = []

        for i in range(len(nums)):
            while q and nums[q[-1]] < nums[i]:
                q.pop()

            if q and q[0] <= (i - k):
                q.popleft()

            q.append(i)

            if i - k + 1 >= 0:
                res.append(nums[q[0]])

        return res
```

## Findings

1. **Monotonic Deque Technique**: This problem introduces the powerful monotonic deque technique, where we maintain a deque that stores indices in decreasing order of their corresponding values. This ensures the front of the deque always contains the maximum value in the current window.

2. **Efficient Maximum Tracking**: By maintaining a monotonic decreasing deque, we can access the maximum value in O(1) time at any point, making this approach much more efficient than naive methods that would require O(k) time to find the maximum in each window.

3. **Index-Based Approach**: Storing indices instead of values in the deque is crucial because it allows us to determine when elements fall outside the current window and need to be removed.

4. **Window Boundary Management**: The condition `q[0] <= (i - k)` ensures that we remove elements that are no longer within the current window, maintaining the sliding window property.

5. **Monotonic Property Maintenance**: The while loop `while q and nums[q[-1]] < nums[i]` maintains the monotonic decreasing property by removing smaller elements that can never be the maximum in future windows.

6. **Time Complexity**: O(n) where n is the length of the input array. Although we have nested loops, each element is pushed and popped at most once, leading to amortized O(1) operations per element.

7. **Space Complexity**: O(k) in the worst case, where k is the window size, as the deque can contain at most k elements.

## Encountered Problems 

1. **Understanding Monotonic Deque**: Initially, I struggled to understand why we can safely remove smaller elements from the deque. The key insight is that if a larger element appears, smaller elements that came before it can never be the maximum in any future window.

2. **Index vs Value Storage**: I was confused about whether to store indices or values in the deque. Storing indices is essential because we need to know when elements fall outside the current window.

3. **Deque Operations Order**: The order of operations (pop smaller elements, remove out-of-window elements, append current element) is crucial for maintaining the correct state of the deque. 