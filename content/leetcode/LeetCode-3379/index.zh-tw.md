---
title: "LeetCode 3379: Transformed Array"
summary: "LeetCode 3379 解題筆記：往右或往左走 nums[i] 步都可以寫成 nums[(i + nums[i]) % n]；Python 的 % 對負數也回傳非負值"
description: "2026-02-05 的 LeetCode 3379 解題紀錄"
date: 2026-02-05
tags: ["easy", "array", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2026-02-05
- 提交紀錄：Accepted（一次通過）

## 解題思路

正數往右、負數往左走 `|nums[i]|` 步，兩種情況合起來就是走到 `i + nums[i]`。環狀陣列用 `% n` 繞回來（[Array]({{< relref "/algorithm/Array" >}}) 模板五）；Python 的 `%` 對負數會回傳 `0..n-1`，所以不用分開處理。`nums[i] == 0` 時落在自己，結果就是 0，也一起處理了。

## 我的解法

```python
class Solution:
    def constructTransformedArray(self, nums: List[int]) -> List[int]:
        n = len(nums)
        return [nums[(i + x) % n] for i, x in enumerate(nums)]
```

我當時把正、負、零分成三種情況，結果一樣。

## 複雜度

時間 `O(n)`，空間 `O(n)`（輸出）。

## 要特別避免的錯誤

- 其他語言的 `%` 對負數可能回傳負值，要寫成 `((i + x) % n + n) % n`。

## 面試口說整理

往右或往左走都等於走到 `i + nums[i]`，環狀陣列取 mod `n` 就好；Python 的 mod 對負數也是非負的。時間 `O(n)`。
