---
title: "LeetCode 3834: Merge Adjacent Equal Elements"
summary: "LeetCode 3834 解題筆記：stack 模擬，新元素跟頂端相同就合併，合併後可能還要繼續跟新的頂端合併"
description: "2026-02-08 的 LeetCode 3834 解題紀錄"
date: 2026-02-08
tags: ["medium", "stack", "simulation", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-02-08
- 提交紀錄：Accepted（一次通過）

## 解題思路

規則：每次找**最左邊**的一對相鄰相同元素，換成它們的和，重複到沒有相鄰相同的為止。

直接照規則模擬，每次都要從頭找，是 `O(n^2)`。

用 stack 從左到右處理：stack 裡保存的是「已經處理完、沒有相鄰相同」的部分。新元素進來後，如果跟頂端相同，就合併成兩倍；合併後的值可能又跟新的頂端相同，所以要用 `while` 一直合併下去。

為什麼這樣跟「每次合併最左邊那一對」的結果一樣：stack 裡永遠沒有相鄰相同的元素，所以當前唯一可能相同的一對，就是剛放進來的元素和它左邊那個，而它就是最左邊的一對。

## 我的解法

```python
class Solution:
    def mergeAdjacent(self, nums: List[int]) -> List[int]:
        stack = []
        for x in nums:
            while stack and stack[-1] == x:
                x += stack.pop()
            stack.append(x)
        return stack
```

原本的版本先把元素推進去，再用 `while len(stack) > 1 and stack[-1] == stack[-2]` 檢查，效果一樣。這裡改成在推進去之前先合併，少一次 pop 和 push。

## 複雜度

時間 `O(n)`：每次合併都會讓元素少一個，總合併次數不超過 `n`。空間 `O(n)`。

## 要特別避免的錯誤

- 合併一次就停：合併後的值可能又跟前一個相同，要用 `while`。
- 直接照題目規則每次從頭找最左邊的一對：`O(n^2)`。

## 面試口說整理

我用 stack 從左到右處理，stack 裡保存的是沒有相鄰相同元素的部分。新元素跟頂端相同就合併成兩倍，合併後可能又跟新的頂端相同，所以一直合併到不同為止再推進去。因為 stack 裡永遠沒有相鄰相同，每次合併的都是最左邊那一對，結果和題目規則一致。每次合併都讓元素少一個，總共 `O(n)`。
