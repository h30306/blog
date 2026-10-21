---
title: "LeetCode 217: Contains Duplicate"
summary: "LeetCode 217 解題筆記：轉成 set 後長度變短就代表有重複"
description: "2022-08-21 的 LeetCode 217 解題紀錄"
date: 2022-08-21
tags: ["easy", "array", "hash-table", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-21
- 提交紀錄：Wrong Answer → Accepted → Wrong Answer → Accepted ×4

## 解題思路

`set(nums)` 會去掉重複，長度變短就有重複（[Hash Table]({{< relref "/algorithm/Hash-Table" >}})）。想提早結束的話，邊掃邊放進集合，看到已經在裡面的就回傳 `True`。

## 我的嘗試

2022-08 和 2022-10 兩次都寫成 `len(set(nums)) == len(nums)`，**意思剛好相反**：沒有重複時回傳 `True`。改成 `!=` 就 AC 了。

## 正確解法

```python
class Solution:
    def containsDuplicate(self, nums: List[int]) -> bool:
        seen = set()
        for x in nums:
            if x in seen:
                return True
            seen.add(x)
        return False
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 長度**不相等**才有重複，不要寫反。

## 面試口說整理

我邊掃邊把數字放進集合，遇到已經在集合裡的就代表有重複。時間 `O(n)`、空間 `O(n)`；也可以直接比較 set 和原陣列的長度。
