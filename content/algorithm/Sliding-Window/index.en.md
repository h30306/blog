---
title: "Sliding Window"
summary: "Introduction to Sliding Window"
description: "Algorithm Learning"
date: 2025-07-04
tags: ["blog", "algorithm", "Sliding Window"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Introduction

Sliding window is an algorithmic technique used to calculate occurrences or accumulations within a range.  
There are several types of sliding window problems, such as fixed-size windows and two-pointer expand/shrink patterns.

## Core Idea

Most sliding window problems provide a fixed window size and define a target condition that must be satisfied within that frame, for example, calculating the maximum sum in a fixed-size window.  
We need to move the window from left to right and track the maximum accumulation along the way.

## Template

### Fixed Window Size
#### Use Cases:
- max/min array sum
- avg value
- max value in frame

```python
def fixed window(nums, k):
  window_sum = sum(nums[:k])
  res = window_sum

  for i in range(k, len(nums)):
    window_sum += nums[i] - nums[i - k]
    res = max(res, window_size)
```

### Mutable Window Size (Two Pointers)
#### Use Cases:
- character occurrence frequency
- distinct count / at most k
```python
def variable_window(s):
  left = res = 0
  counter = defaultdict(int)

  for right in range(len(s)):
    counter[s[right]] += 1

    while condition_not_satisfied(counter):
      counter[s[left]] -= 1
      left += 1

    res = max(res, right - left + 1)

  return res
```

### Sliding Window + Character Frequency
#### Use Cases:
- character sorting
- character frequency
```python
def check_inclusion(s1, s2):
  if len(s1) > len(s2):
    return False

  target = Counter(s1)
  window = Counter(s2[:len(s1)])

  if target == window:
    return True

  for i in range(len(s1), len(s2)):
    window[s2[i]] += 1
    window[s2[i - len(s1)]] -= 1
    if windows[s2[i - len(s1)]] == 0:
      del windows[s2[i - len(s1)]]
    if window == target:
      return True

  return False
```

### Sliding Window + Deque
#### Use Cases:
- max/min value in sliding frame
```python
def maxSlidingWindow(nums, k):
  dq = deque()
  res = []

  for i in range(len(nums)):
    if dq and dq[0] <= i - k:
      dq.popleft()

    while dq and nums[dq[-1]] < nums[i]:
      dq.pop()

    dq.append(i)

    if i - k + 1 >= 0:
      res.append(nums[dq[0]])

  return res
```


## Examples

## LeetCode