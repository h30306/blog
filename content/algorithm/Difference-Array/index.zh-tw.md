---
title: "Difference Array"
summary: "Difference Array 介紹"
description: "演算法學習"
date: 2025-04-27
tags: ["algorithm", "difference array"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 介紹

差分陣列（Difference Array）是一種常用於「區間更新」問題的演算法技巧。  
當題目要求對一個範圍內的數值進行修改時，  
與其每次修改整個區間，不如**只記錄起點與終點的變化**，  
之後再透過**前綴和（Prefix Sum）**從左到右累加，還原出更新後的完整陣列。

## 核心概念

```python
origin = [1, 3, 2]
k = 5
operations = [[0, 1, 1], [1, 2, -1], [0, 2, 1]]

for start, end, amount in operations:
    for idx in range(start, end + 1):
        origin[idx] += amount

return max(origin) <= k
```

這是 `O(n * m)` 的操作（其中 `n` 是陣列長度，`m` 是操作數量）。

但如果使用**差分陣列**技巧，就可以避免內層迴圈，  
只需在特定位置記錄變化，再透過前綴和還原結果：

```python
difference_array = [0] * (len(origin) + 1)

for start, end, amount in operations:
    difference_array[start] += amount
    difference_array[end + 1] -= amount

diff = 0
for i in range(len(origin)):
    diff += difference_array[i]
    status = origin[i] + diff
    if status >= k:
        return False

return True
```

這樣可以將時間複雜度降到 `O(n + m)`。

## 模板

**1. Initialization**
```python
difference_array = [0] * (len(nums) + 1)
```
開一個比原本陣列長度多 1 的差分陣列，用來標記每個位置的增減變化。

**2. Apply operations**
```python
for start, end, amount in operations:
    difference_array[start] += amount
    difference_array[end + 1] -= amount
```
只在 `start` 增加，在 `end + 1` 減少，代表一段區間內的累積變化。

**3. Prefix sum to recover the final state**
```python
result = []
diff = 0
for i in range(len(nums)):
    diff += difference_array[i]
    result.append(nums[i] + diff)
```
## 不知道nums的長度

如果我們不知道 `nums` 的長度，  
例如題目只提供了操作（operations），  
我們可以使用**哈希表（hash map）**來記錄每個索引位置的差分變化量。  
之後，根據 hash map 的**鍵（索引）排序**，  
依照排序後的索引進行前綴和累加，來還原出最終的結果。

```python
diff_map = default_dict(int)
for start, end, amount in differences:
    diff_map[start] += 1
    diff_map[end+1] -=1

diff = 0
for key in sorted(diff_map.keys()):
    diff += diff_map[key]
```

### 主要參數說明：

## 範例

## LeetCode