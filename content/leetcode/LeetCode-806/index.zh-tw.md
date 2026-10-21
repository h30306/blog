---
title: "LeetCode 806: Number of Lines To Write String"
summary: "LeetCode 806 解題筆記：模擬寫字，加上去會超過 100 就換行；剛好 100 時還留在這一行"
description: "2022-09-07 的 LeetCode 806 解題紀錄"
date: 2022-09-07
tags: ["easy", "array", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-07
- 提交紀錄：Wrong Answer → Runtime Error → Wrong Answer ×6 → Runtime Error → Wrong Answer ×2 → Accepted

## 解題思路

從第 1 行、寬度 0 開始逐字模擬：目前寬度加上這個字母的寬度**超過 100** 才換行（新的一行寬度就是這個字母的寬度），否則加上去。剛好等於 100 時**還在這一行**，不用換行。

## 我的嘗試

這題提交了 12 次，起點是「剛好 100 時換到下一行、寬度歸零」這個錯誤的想法，之後一直在補洞：

- 第一版用字母的 index 當寬度，忘了查 `widths`；只有一個 `"a"` 時還被最後的「寬度是 0 就少算一行」減成 `[-1, 0]`。
- 換行之後先把寬度設成這個字母的寬度，**後面的 `if` 又加了一次**：`[2, 23]`，答案 `[2, 15]`。
- 把 `if` 改成 `elif` 之後，剛好寫滿 100 時被當成換行再減回來，得到 `[1, 0]`，答案 `[1, 100]`。
- 最後的 AC 版是在結尾補上「寬度是 0 就少一行、寬度改成 100」。

## 正確解法

```python
class Solution:
    def numberOfLines(self, widths: List[int], s: str) -> List[int]:
        lines, cur = 1, 0
        for c in s:
            w = widths[ord(c) - ord("a")]
            if cur + w > 100:
                lines += 1
                cur = w
            else:
                cur += w
        return [lines, cur]
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 剛好 100 不換行，最後一行的寬度可以是 100。
- 換行後新的一行寬度是這個字母的寬度，不要再加一次。
- 寬度要查 `widths`，不是字母的 index。

## 面試口說整理

我從第一行開始逐字模擬，加上這個字母會超過 100 才換行，新的一行寬度就是這個字母的寬度，否則累加，最後回傳行數和最後一行的寬度。時間 `O(n)`。
