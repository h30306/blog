---
title: "Sliding Window"
summary: "Sliding Window 介紹"
description: "演算法學習"
date: 2025-07-04
tags: ["blog", "algorithm"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 介紹

滑動視窗是一種演算法技巧，用來在一個範圍內計算次數或總和。  
滑動視窗的題型有多種，例如固定大小的視窗、雙指標擴展／收縮等。

## 核心概念

大多數滑動視窗的題目會提供一個固定的視窗大小，並要求在這個範圍內達成某個條件，例如計算固定大小視窗內的最大總和。  
我們需要將視窗從左向右滑動，並在過程中持續追蹤最大累積值。

## 模板
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

### 主要參數說明：

## 範例

## LeetCode