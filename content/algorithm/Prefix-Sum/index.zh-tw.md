---
title: "Prefix Sum"
summary: "Prefix Sum 介紹"
description: "演算法學習"
date: 2025-04-19
tags: ["algorithm", "prefix sum"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 介紹

**Prefix Sum（前綴和）** 是一種常見的演算法技巧，用來快速計算子陣列的總和或區間值。

舉例來說，假設有一個陣列 `nums = [2, 4, 5, 7]`，如果我們想要查詢從 `nums[i]` 到 `nums[j]` 的總和，使用暴力解法每次查詢都需要花費 `O(n)` 的時間。

然而，只要先遍歷一次陣列並建立一個 prefix sum 陣列，就能將每次查詢的時間縮短為 `O(1)`。

## 核心概念

這個技巧的核心概念是：建立一個陣列，讓其中的每個元素都代表原陣列中所有前面元素的累加和。

因此，對於索引 `i`，在 `prefix[i + 1]` 中儲存的值就是原始陣列從索引 `0` 到 `i` 的總和。

```python
prefix = [0] * (len(nums) + 1)
for i in range(len(nums)):
    prefix[i + 1] = prefix[i] + nums[i]
```

如果我們要查詢從索引 `i` 到 `j` 的區間總和，只需要這樣寫：

```python
sum_ = prefix[j+1] - prefix[i]
```

`prefix` 陣列的第一個元素代表的是「空區間」（也就是總和為 `0` 的情況），所以我們用 `prefix[j + 1]` 來包含索引 `j` 的值，並用 `prefix[i]` 來排除索引 `i` 之前的總和。


## 模板

```python
prefix = [0] * (len(nums) + 1)
for i in range(len(nums)):
    prefix[i + 1] = prefix[i] + nums[i]

sum_ = prefix[j+1] - prefix[i]
```

### 主要參數說明：

## 範例

經典題
```
class NumArray:

    def __init__(self, nums: List[int]):
        self.ps = [0]
        for num in nums:
            self.ps.append(num+self.ps[-1])

    def sumRange(self, left: int, right: int) -> int:
        return self.ps[right+1] - self.ps[left]
```

## LeetCode