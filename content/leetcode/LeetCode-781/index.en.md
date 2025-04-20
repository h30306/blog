---
title: "LeetCode 781: Rabbits in Forest"
summary: "LeetCode Problem Solving"
description: "LeetCode Daily"
date: 2025-04-20
tags: ["LeetCode", "blog", "daily", "medium"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-04-20
- Total time: 00:00.00


## Intuition

We can categorize the answers into three types of rabbit groups.  
The first group includes rabbits that gave the same non-zero answer, indicating they belong to the same color group.  
The second type refers to rabbits whose answer is unique (i.e., no other rabbit gave the same answer), which implies they belong to separate groups.  
The third type includes rabbits that answered `0`, which means they are the only rabbit of their color in the forest.

Once we build a frequency hash map from the answers, we can iterate through it, handle each type of group, and calculate the **minimum number** of rabbits in the forest.  
A special situation arises when the count of rabbits in a group exceeds the group size.  
For example, if the group size is 2 (i.e., each rabbit says there’s one more of its color), but there are 7 such rabbits, we must account for at least 4 groups of size 2 (as 7 requires ceiling(7/2) = 4 groups).

## Approach

### First Attempt

```python
class Solution:
    def numRabbits(self, answers: List[int]) -> int:
        count = {}

        for answer in answers:
            count[answer] = count.get(answer, 0) + 1

        res = 0
        for key, value in count.items():
            if key == 0:
                res += value
            
            elif value == 1:
                res += key + 1

            else:
                group = value // (key + 1)
                group += 1 if value % (key + 1) else 0

                res += group * (key + 1)

        return res
```

### Second Attempt

I initially tried to split the problem into three different scenarios, but I later realized that I could merge the two cases — when only one rabbit or multiple rabbits give the same answer — into one.  
Both scenarios essentially represent rabbits that report seeing `k` others of their color, which corresponds to groups of size `k + 1`.  
So, in the second approach, I adjusted the counting logic accordingly:

```python
class Solution:
    def numRabbits(self, answers: List[int]) -> int:
        count = defaultdict(int)

        for answer in answers:
            count[answer + 1] += 1  # Add 1 to include the answering rabbit in the group size

        res = 0
        for key, value in count.items():
            group = value // key
            group += 1 if value % key else 0

            res += group * key

        return res
```

## Findings

## Encountered Problems