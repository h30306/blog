---
title: "LeetCode 2231: Largest Number After Digit Swaps by Parity"
summary: "LeetCode 2231 解題筆記：奇數位數只能跟奇數交換、偶數只能跟偶數交換；分別排序後，依原本每個位置的奇偶放回最大的"
description: "2022-11-22 的 LeetCode 2231 解題紀錄"
date: 2022-11-22
tags: ["easy", "sorting", "heap-priority-queue"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-11-22
- 提交紀錄：Wrong Answer ×2 → Accepted

## 解題思路

「奇偶」指的是**數字本身**的奇偶，不是位置。把奇數位數和偶數位數分成兩組，各自由大到小排（或用 max-heap，[Heap]({{< relref "/algorithm/Heap" >}})），再從左到右：原本是奇數的位置放奇數組最大的，偶數的位置放偶數組最大的。

## 我的嘗試

前兩版把分組的依據寫成 **index 的奇偶**（`i % 2`），不是數字本身的奇偶：`5575` 的四個位數都是奇數，可以排成 `7555`，這兩版一個沒回傳、一個回傳錯的結果。改成看 `int(s) % 2` 才 AC。

## 正確解法

```python
class Solution:
    def largestInteger(self, num: int) -> int:
        digits = [int(c) for c in str(num)]
        odd = sorted((d for d in digits if d % 2), reverse=True)
        even = sorted((d for d in digits if d % 2 == 0), reverse=True)
        oi = ei = 0
        res = 0
        for d in digits:
            if d % 2:
                res = res * 10 + odd[oi]; oi += 1
            else:
                res = res * 10 + even[ei]; ei += 1
        return res
```

## 複雜度

時間 `O(d log d)`（`d` 是位數），空間 `O(d)`。

## 要特別避免的錯誤

- 分組依據是數字的奇偶，不是 index 的奇偶。
- 回傳整數。

## 面試口說整理

奇數只能跟奇數換、偶數只能跟偶數換，所以我把位數依奇偶分兩組各自由大到小排序，再從左到右，原本是奇數的位置放奇數組最大的，偶數的位置放偶數組最大的。
