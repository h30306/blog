---
title: "LeetCode 3527: Find the Most Common Response"
summary: "LeetCode Problem Solving"
description: "LeetCode Bi-Weekly Contest 155"
date: 2025-04-26
series: ["LeetCode Bi-Weekly Contest 155"]
series_order: 1
tags: ["LeetCode", "blog", "bi-weekly", "medium"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium  
First Attempt: 2025-04-26  
- Total time: 10:00.00  

## Intuition

Use a `Counter` to count the occurrences of each response status.  
Then, if there are multiple statuses with the same maximum occurrence,  
select the lexicographically smallest one by taking the minimum among them.

## Approach

```python
class Solution:
    def findCommonResponse(self, responses: List[List[str]]) -> str:
        from collections import Counter
        l = []
        
        for response in responses:
            l.extend(list(set(response)))
            
        count_map = Counter(l)
        max_occur = max(count_map.values())
        
        status_list = [k for k,v in count_map.items() if v == max_occur]
        return sorted(status_list)[0]
```

### Optimization Based on Runtime Ranking

We don't need to create a list `l` and then update it with all sets of responses before using `Counter`.  
Instead, we can initialize an empty `Counter` and directly update it with the `set(response)` during iteration.  
Also, to get the lexicographically smallest status, we can simply use `min()`.

```python
class Solution:
    def findCommonResponse(self, responses: List[List[str]]) -> str:
        from collections import Counter
        
        counter = Counter()
        
        for response in responses:
            res = set(response)
            counter.update(res)
    
        max_occur = max(counter.values())
        
        status_list = [k for k,v in counter.items() if v == max_occur]
        return min(status_list)
```

## Findings

N/A

## Encountered Problems

N/A