---
title: "LeetCode 303: Range Sum Query - Immutable"
summary: "LeetCode 解題紀錄"
description: "LeetCode Daily"
date: 2025-04-19
tags: ["LeetCode", "easy", "prefix sum"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試： 2025-04-19
- 總花費時間：2:00.00

## 解題思路

解單的[Prefix Sum]({{< relref "algorithm/Prefix-Sum/index.zh-tw.md" >}})問題

## 解法

```python
class NumArray:

    def __init__(self, nums: List[int]):
        self.ps = [0]
        for num in nums:
            self.ps.append(num+self.ps[-1])

    def sumRange(self, left: int, right: int) -> int:
        return self.ps[right+1] - self.ps[left]
```

## 收穫
NA

## 遇到的問題
NA