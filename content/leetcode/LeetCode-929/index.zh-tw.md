---
title: "LeetCode 929: Unique Email Addresses"
summary: "LeetCode 929 解題筆記：用 @ 切開，只處理 local 的部分（+ 之後丟掉、去掉 .），接回 domain 後放進集合"
description: "2022-09-26 的 LeetCode 929 解題紀錄"
date: 2022-09-26
tags: ["easy", "array", "hash-table", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-26
- 提交紀錄：Runtime Error → Wrong Answer ×3 → Accepted ×2

## 解題思路

把每個信箱正規化後放進集合（[Hash Table]({{< relref "/algorithm/Hash-Table" >}}) 模板五）：用 `@` 切成 local 和 domain，local 先砍掉第一個 `+` 之後的內容、再刪掉所有 `.`；domain 不動。接回去時**要把 `@` 加回來**，不然不同的信箱可能接成同一個字串。

## 我的嘗試

- 第一版 `replace` 拼錯（AttributeError）。
- 接下來兩版用 `"".join(email)` 接回去，**`@` 不見了**：`["a@bx.com", "ab@x.com"]` 都變成 `"abx.com"`，答案 2，回傳 1。
- 再下一版寫成 `emails[0] + '@' + emails[1]`，`email` 和 `emails` 搞混了，只有一個信箱時 IndexError。

## 正確解法

```python
class Solution:
    def numUniqueEmails(self, emails: List[str]) -> int:
        seen = set()
        for e in emails:
            local, domain = e.split("@")
            local = local.split("+")[0].replace(".", "")
            seen.add(local + "@" + domain)
        return len(seen)
```

## 複雜度

時間 `O(總字元數)`，空間 `O(總字元數)`。

## 要特別避免的錯誤

- 規則只套用在 local 的部分，domain 的 `.` 要保留。
- 接回去時要保留 `@`：`"a@bx.com"` 和 `"ab@x.com"` 是不同的信箱。

## 面試口說整理

我用 @ 把信箱切成兩半，local 的部分砍掉 + 之後的字、刪掉點，domain 不動，接回去之後放進集合，最後回傳集合的大小。時間是總字元數。
