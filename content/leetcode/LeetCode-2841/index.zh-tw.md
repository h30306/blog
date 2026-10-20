---
title: "LeetCode 2841: Maximum Sum of Almost Unique Subarray"
summary: "LeetCode 2841 解題筆記：固定長度 k 的視窗，維護總和與計數雜湊表；不同值的個數就是雜湊表的大小，數量歸零要刪 key"
description: "2025-12-23 的 LeetCode 2841 解題紀錄"
date: 2025-12-23
tags: ["medium", "sliding-window", "hash-table", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-12-23
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

固定長度 `k` 的視窗，同時維護兩樣東西：

- 視窗總和。
- 計數雜湊表 `cnt`：值 → 在視窗裡出現幾次。數量減到 0 時刪掉 key，`len(cnt)` 就是視窗裡有幾種不同的值。

視窗滿了而且 `len(cnt) >= m` 時，更新最大總和。

## 我的嘗試

第一版想用「每個值出現的次數 `<= k - m`」來判斷，這跟「至少 `m` 種不同的值」不是同一件事，而且只在加入新元素時檢查那一個值。例如 `nums = [2]`、`m = 1`、`k = 1`：`k - m = 0`，`2` 出現 1 次就被判為不合格，回傳 0，答案是 2。

改成直接看 `len(freq) >= m`、並在數量歸零時刪 key，就 AC 了。

## 正確解法

```python
class Solution:
    def maxSum(self, nums: List[int], m: int, k: int) -> int:
        cnt = Counter()
        window = best = 0
        for right, x in enumerate(nums):
            cnt[x] += 1
            window += x
            if right >= k:
                out = nums[right - k]
                cnt[out] -= 1
                window -= out
                if cnt[out] == 0:
                    del cnt[out]                   # len(cnt) 才會是不同值的個數
            if right >= k - 1 and len(cnt) >= m:
                best = max(best, window)
        return best
```

## 複雜度

時間 `O(n)`，空間 `O(k)`。

## 要特別避免的錯誤

- 用出現次數去推「幾種不同的值」：直接看雜湊表大小。
- 數量歸零沒刪 key：`len()` 會多算。

## 面試口說整理

固定長度 `k` 的滑動視窗，同時維護總和和一個計數雜湊表。元素離開視窗時數量減一，歸零就刪掉，這樣雜湊表的大小就是不同值的個數。視窗滿了而且不同值至少 `m` 種時更新答案。時間 `O(n)`。
