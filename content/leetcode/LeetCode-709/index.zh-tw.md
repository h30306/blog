---
title: "LeetCode 709: To Lower Case"
summary: "LeetCode 709 解題筆記：大寫字母的 ASCII 加 32 就是小寫，其他字元不變"
description: "2022-08-31 的 LeetCode 709 解題紀錄"
date: 2022-08-31
tags: ["easy", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-31
- 提交紀錄：Internal Error → Runtime Error ×3 → Accepted ×2

## 解題思路

`'A'` 到 `'Z'` 是 65 到 90，小寫剛好多 32。逐字元檢查是不是大寫，是的話 `chr(ord(c) + 32)`（[String]({{< relref "/algorithm/String" >}}) 模板四）。實務上就是 `s.lower()`。

## 我的嘗試

前三版在條件裡寫成 `ord(s)`（整個字串），**長度超過 1 就 TypeError**，其中兩版還少了右括號。第四版改成 `ord(int(i))`，字母轉 `int` 直接 ValueError。改回 `ord(i)` 就 AC 了。

## 正確解法

```python
class Solution:
    def toLowerCase(self, s: str) -> str:
        return "".join(chr(ord(c) + 32) if "A" <= c <= "Z" else c for c in s)
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- `ord` 要對單一字元用，不是整個字串。

## 面試口說整理

大寫字母的 ASCII 加 32 就是對應的小寫，我逐字元檢查是不是 A 到 Z，是的話轉換，其他字元不變。時間 `O(n)`。
