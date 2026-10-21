---
title: "LeetCode 1108: Defanging an IP Address"
summary: "LeetCode 1108 解題筆記：把每個 . 換成 [.]"
description: "2022-10-18 的 LeetCode 1108 解題紀錄"
date: 2022-10-18
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
第一次嘗試：2022-10-18
- 提交紀錄：Accepted（一次通過）

## 解題思路

把每個 `.` 換成 `[.]`。用 `replace` 一行，或用 list 逐字元組出結果（[String]({{< relref "/algorithm/String" >}}) 模板一）。

## 我的解法

```python
class Solution:
    def defangIPaddr(self, address: str) -> str:
        return address.replace(".", "[.]")
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- `replace` 回傳新字串，原本的字串不會變。

## 面試口說整理

我把每個點換成中括號包起來的點，用 replace 一行完成，時間 `O(n)`。
