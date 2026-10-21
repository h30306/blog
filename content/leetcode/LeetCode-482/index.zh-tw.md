---
title: "LeetCode 482: License Key Formatting"
summary: "LeetCode 482 解題筆記：先去掉所有 - 並轉大寫，再從尾巴每 k 個切一段，最前面那段可以比較短"
description: "2022-08-24 的 LeetCode 482 解題紀錄"
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
- 提交紀錄：Wrong Answer ×8 → Output Limit Exceeded → Accepted

## 解題思路

只有第一組可以比較短，所以要**從尾巴開始**每 `k` 個切一段。先把 `-` 全部拿掉、轉大寫，再算第一組的長度 `len % k`（是 0 的話就是 `k`），之後每 `k` 個一組，用 `"-".join` 接起來（[String]({{< relref "/algorithm/String" >}}) 模板一）。

## 我的嘗試

這題提交了 10 次，都在處理「從後往前每 `k` 個加一個 `-`」的計數：

- 前四版**沒有轉大寫**：`"a"` 回傳 `"a"`，答案 `"A"`。
- 加上 `upper()` 之後，計數器從 1 開始又用 `c <= k`，**每組變成 `k + 1` 個**：`"B2a"`、`k = 1` 答案 `"B-2-A"`，回傳 `"B2-A"`。
- 改成 `c < k` 之後，`k = 1` 時第一個字元就進了 `else`，**多出一個 `-`**：`"2"` 回傳 `"2-"`。
- 計數器改從 0 開始就對了，但留下的 `print` 造成 Output Limit Exceeded，拿掉才 AC。

## 正確解法

```python
class Solution:
    def licenseKeyFormatting(self, s: str, k: int) -> str:
        t = s.replace("-", "").upper()
        first = len(t) % k or k
        groups = [t[:first]] + [t[i:i + k] for i in range(first, len(t), k)]
        return "-".join(g for g in groups if g)
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 要轉大寫。
- 每組 `k` 個；從後往前數時計數器的起始值和比較符號要一致，不然會差一個或在最前面多一個 `-`。
- `s` 全部都是 `-` 時答案是空字串。

## 面試口說整理

我先把破折號拿掉並轉大寫，第一組的長度是總長度除以 k 的餘數，餘數是 0 就是 k，之後每 k 個一組，用破折號接起來。時間 `O(n)`。
