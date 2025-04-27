---
title: "LeetCode 3527: Find the Most Common Response"
summary: "LeetCode 解題紀錄"
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

## 基本資料

難易度: medium
第一次嘗試： 2025-04-27
- 總花費時間：00:00.00

## 解題思路

使用 `Counter` 來統計每個 response status 出現的次數。  
如果有多個 status 出現次數一樣多，就取字典序最小的那一個作為答案。

## 解法

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

### 根據 Runtime 排名的優化

其實不需要先建一個 list `l` 再統一用 `Counter` 統計，  
可以直接初始化一個空的 `Counter`，  
然後在遍歷 responses 時，直接用 `set(response)` 去更新 Counter。  
另外，為了取字典序最小的 status，可以直接使用 `min()` 函式。

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

## 收穫

NA

## 遇到的問題

NA