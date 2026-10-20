---
title: "LeetCode 2441: Largest Positive Integer That Exists With Its Negative"
summary: "LeetCode 2441 解題筆記：把正數和負數的絕對值分開放兩個 set，取交集的最大值；只用絕對值會把同號的重複數字誤判成一對"
description: "2025-08-06 的 LeetCode 2441 解題紀錄"
date: 2025-08-06
tags: ["easy", "hash-map", "two-pointers", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2025-08-06
- 提交紀錄：Wrong Answer ×4 → Accepted

## 解題思路

找最大的正數 `k`，而且 `-k` 也在陣列裡。

把**正數**和**負數的絕對值**分開放進兩個 set，兩邊都有的就是符合條件的 `k`，取最大值。

## 我的嘗試

### 第一、二版：只用絕對值判斷

```python
for num in nums:
    if num < 0:
        num *= -1
    if num not in exist:
        exist.add(num)
    else:
        max_num = max(max_num, num)
```

把所有數字都轉成絕對值，看到第二次就當作找到一對。問題是**同號的重複數字**也會被當成一對，例如 `[3, 3]` 會回傳 3，但 `-3` 根本不在陣列裡。第二版只是補上「找不到時回傳 -1」，沒有修到這個問題。

### 第三、四版：分成兩個 set，但正負號寫反

改成正數和負數各一個 set，但正負號一直沒處理對：第三版把負數原樣放進 `exist_pos`、正數放進 `exist_neg`，一邊全是負數、一邊全是正數，交集永遠是空的；第四版把正數取負號，兩邊都變成負數，交集找得到，但回傳的是負的 `-k`。最後一版改成「負數取絕對值放進 `exist_neg`、正數直接放進 `exist_pos`」才 AC。

## 正確解法

```python
class Solution:
    def findMaxK(self, nums: List[int]) -> int:
        pos = {x for x in nums if x > 0}
        neg = {-x for x in nums if x < 0}
        both = pos & neg
        return max(both) if both else -1
```

### 另一種解法：排序後雙指針

排序後左指針從最小的負數、右指針從最大的正數開始：絕對值相等就找到答案；左邊的絕對值比較大就左指針往右，否則右指針往左。時間 `O(n log n)`、空間 `O(1)`。

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 只看絕對值：同號的重複數字會被誤判。
- 兩個 set 的正負號不一致：交集會是空的，或回傳負數。

## 面試口說整理

我把正數放進一個 set、負數取絕對值放進另一個 set，兩個 set 的交集就是同時有正負兩個版本的數字，取最大值；交集是空的就回傳 `-1`。不能只看絕對值，因為同號的重複數字會被誤判成一對。時間 `O(n)`。
