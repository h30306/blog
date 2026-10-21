---
title: "LeetCode 3843: First Element with Unique Frequency"
summary: "LeetCode 3843 解題筆記：數每個值的次數，再數「每種次數有幾個值」；由左到右第一個次數只屬於它自己的就是答案"
description: "2026-02-16 的 LeetCode 3843 解題紀錄"
date: 2026-02-16
tags: ["medium", "hash-table", "counting", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-02-16
- 提交紀錄：Accepted（一次通過）

## 解題思路

兩層計數（[Hash Table]({{< relref "/algorithm/Hash-Table" >}}) 模板一）：

- `cnt`：值 -> 次數。
- `freq_of_freq`：次數 -> 有幾個不同的值是這個次數。

「次數唯一」就是 `freq_of_freq[cnt[x]] == 1`。要第一個，就照原陣列由左到右找。

## 我的解法

```python
class Solution:
    def firstUniqueFreq(self, nums: List[int]) -> int:
        cnt = Counter(nums)
        freq_of_freq = Counter(cnt.values())
        for x in nums:
            if freq_of_freq[cnt[x]] == 1:
                return x
        return -1
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 「第一個」是照原陣列的順序，不是照 `cnt` 的順序。

## 面試口說整理

我先數每個值的次數，再數每種次數有幾個值。由左到右掃原陣列，第一個次數只對應到一個值的就是答案。時間 `O(n)`。
