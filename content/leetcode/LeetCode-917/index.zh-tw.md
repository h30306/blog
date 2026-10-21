---
title: "LeetCode 917: Reverse Only Letters"
summary: "LeetCode 917 解題筆記：左右指針各自跳過非字母，兩邊都是字母時交換；字串要先轉成 list 才能改"
description: "2022-09-25 的 LeetCode 917 解題紀錄"
date: 2022-09-25
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
第一次嘗試：2022-09-25
- 提交紀錄：Wrong Answer → Runtime Error ×3 → Time Limit Exceeded ×2 → Wrong Answer ×2 → Runtime Error → Wrong Answer → Runtime Error → Wrong Answer ×9 → Runtime Error → Wrong Answer → Accepted → Wrong Answer ×2 → Accepted ×2

## 解題思路

跟 LC 125 一樣的左右指針（[Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) 模板一）：左邊不是字母就右移、右邊不是字母就左移，兩邊都是字母才交換。Python 字串不可變，先轉成 list，最後 `join`。

## 我的嘗試

這題提交了 27 次，是這批最多的：

- 第一版兩個指標都從 0 開始（`i = j = 0`），迴圈根本沒有執行，也直接對字串交換字元。
- 之後試了很多種「先把字母存起來再填回去」的寫法，邊界一直出錯：單一字元 `"z"` 回傳空字串或 `"zz"`，`"a7"` 少了字母只剩 `"7"`。
- 2026 年重寫成左右指針才一次寫對。

## 正確解法

```python
class Solution:
    def reverseOnlyLetters(self, s: str) -> str:
        a = list(s)
        l, r = 0, len(a) - 1
        while l < r:
            if not a[l].isalpha():
                l += 1
            elif not a[r].isalpha():
                r -= 1
            else:
                a[l], a[r] = a[r], a[l]
                l, r = l + 1, r - 1
        return "".join(a)
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 字串不能原地改，要轉成 list。
- 兩個指標一開始一個在頭、一個在尾。

## 面試口說整理

我把字串轉成 list，用左右指針各自跳過非字母，兩邊都是字母時交換再往中間走，最後接回字串。時間 `O(n)`。
