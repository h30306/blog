---
title: "LeetCode 696: Count Binary Substrings"
summary: "LeetCode 696 解題筆記：把字串切成連續相同字元的段，相鄰兩段可以組出 min(前一段, 這一段) 個子字串"
description: "2022-08-30 的 LeetCode 696 解題紀錄"
date: 2022-08-30
tags: ["easy", "two-pointers", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-30
- 提交紀錄：Wrong Answer ×2 → Accepted ×3

## 解題思路

符合條件的子字串一定跨在**兩段相鄰的連續字元**上，例如 `000111` 的 `0` 段長 3、`1` 段長 3，可以組出 `01`、`0011`、`000111` 共 `min(3, 3)` 個。所以只要記住前一段長度 `prev` 和這一段長度 `cur`，每次段落結束就加上 `min(prev, cur)`。**最後一段結束時迴圈已經跑完，要在迴圈外再加一次。**

## 我的嘗試

第一版忘了 `return`。第二版補上之後，**迴圈結束時沒有把最後一對段落加進去**，例如 `"01"`：答案 1，回傳 0。

## 正確解法

```python
class Solution:
    def countBinarySubstrings(self, s: str) -> int:
        res, prev, cur = 0, 0, 1
        for i in range(1, len(s)):
            if s[i] == s[i - 1]:
                cur += 1
            else:
                res += min(prev, cur)
                prev, cur = cur, 1
        return res + min(prev, cur)
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 迴圈結束後最後一對段落還沒加，要補上 `min(prev, cur)`。

## 面試口說整理

我把字串看成一段段連續相同的字元，相鄰兩段可以組出兩段長度較小值那麼多個答案，所以一路記錄前一段和這一段的長度，段落結束時累加，迴圈後再補最後一次。時間 `O(n)`、空間 `O(1)`。
