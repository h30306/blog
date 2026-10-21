---
title: "LeetCode 832: Flipping an Image"
summary: "LeetCode 832 解題筆記：每一列先左右反轉再把 0、1 互換；可以用左右指針同時做"
description: "2022-09-15 的 LeetCode 832 解題紀錄"
date: 2022-09-15
tags: ["easy", "array", "two-pointers", "bit-manipulation", "matrix"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-15
- 提交紀錄：Runtime Error ×7 → Accepted

## 解題思路

每一列左右反轉後再反相。左右指針同時處理（[Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) 模板一）：交換 `row[l]`、`row[r]` 的同時各自 `^ 1`；`l == r` 的中間那格只要反相一次。

## 我的嘗試

前七次都是 RE：第一版用 `/` 算迴圈次數，得到浮點數放進 `range`（TypeError）；改成 `//` 之後，這版和後面五版都回傳或使用了不存在的變數 `A`（參數名稱是 `image`，NameError）。第一版的交換也寫成 `row[-i]`：`i = 0` 時 `row[-0]` 就是 `row[0]` 而不是最後一格，整個差了一格，應該是 `row[-1 - i]`。最後一行 list comprehension 改用 `image` 才 AC。

## 正確解法

```python
class Solution:
    def flipAndInvertImage(self, image: List[List[int]]) -> List[List[int]]:
        for row in image:
            l, r = 0, len(row) - 1
            while l <= r:
                row[l], row[r] = row[r] ^ 1, row[l] ^ 1
                l, r = l + 1, r - 1
        return image
```

## 複雜度

時間 `O(n²)`，空間 `O(1)`。

## 要特別避免的錯誤

- `l == r` 時同時指定也只會反相一次，剛好正確。

## 面試口說整理

我對每一列用左右指針，交換兩端的同時各自做 XOR 1 反相，中間那格只反相一次。時間 `O(n²)`、空間 `O(1)`。
