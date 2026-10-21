---
title: "LeetCode 551: Student Attendance Record I"
summary: "LeetCode 551 解題筆記：A 少於 2 次，而且字串裡沒有 LLL"
description: "2022-08-27 的 LeetCode 551 解題紀錄"
date: 2022-08-27
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
第一次嘗試：2022-08-27
- 提交紀錄：Wrong Answer → Accepted ×4

## 解題思路

兩個條件：`'A'` 的總數少於 2，而且沒有連續三個 `'L'`，也就是 `"LLL" not in s`（[String]({{< relref "/algorithm/String" >}}) 模板二）。

## 我的嘗試

第一版寫成 `for i in s: if i[:3] == "LLL"`，`i` 只是一個字元，**`i[:3]` 永遠不會是 `"LLL"`**：`"LLL"` 回傳 `True`。改成 `s[i:i + 3]` 就 AC 了。

## 正確解法

```python
class Solution:
    def checkRecord(self, s: str) -> bool:
        return s.count("A") < 2 and "LLL" not in s
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 檢查連續的 `L` 要看子字串，逐字元迴圈的變數只是單一字元。

## 面試口說整理

我檢查 A 的數量少於 2，而且字串裡沒有 LLL 這個子字串，時間 `O(n)`。
