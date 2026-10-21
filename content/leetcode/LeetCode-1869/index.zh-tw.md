---
title: "LeetCode 1869: Longer Contiguous Segments of Ones than Zeros"
summary: "LeetCode 1869 解題筆記：分別找出最長的連續 1 和最長的連續 0，比較大小；用 split 一行就能做"
description: "2022-08-24 的 LeetCode 1869 解題紀錄"
date: 2022-08-24
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
第一次嘗試：2022-08-24
- 提交紀錄：Wrong Answer ×2 → Accepted ×2

## 解題思路

用 `'0'` 切開，剩下的每一段都是連續的 1，最長的一段就是最長連續 1；用 `'1'` 切開同理。比較兩者，1 的要**嚴格**比較長。

## 我的嘗試

前兩版手動數連續段落，但判斷寫成 `i == 1`，**字串的字元永遠不等於整數 1**，所有字元都被當成 0：`"1"` 回傳 `False`。第一版另外也沒有在迴圈結束後更新最後一段。最後改用 `split` 一行就 AC 了。

## 正確解法

```python
class Solution:
    def checkZeroOnes(self, s: str) -> bool:
        return max(map(len, s.split("0"))) > max(map(len, s.split("1")))
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 字串的字元是 `'1'`，不是整數 `1`。
- 自己數連續段落時，最後一段要在迴圈結束後再更新一次。

## 面試口說整理

我用 0 切開字串，最長的一段就是最長的連續 1；用 1 切開就是最長的連續 0，比較兩者即可。時間 `O(n)`。
