---
title: "LeetCode 584: Find Customer Referee"
summary: "LeetCode 584 解題筆記：referee_id != 2 會漏掉 NULL，因為跟 NULL 比較的結果是 unknown；要另外加上 IS NULL"
description: "2025-12-23 的 LeetCode 584 解題紀錄"
date: 2025-12-23
tags: ["easy", "database", "sql"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2025-12-23
- 提交紀錄：Accepted（一次通過）

## 解題思路

要找「不是被 2 號推薦」的客戶，包含**沒有推薦人**（`referee_id` 是 NULL）的人。

SQL 的比較有三種結果，`NULL != 2` 是 **unknown**，不是 true，而 `WHERE` 只留下 true 的列（[SQL]({{< relref "/algorithm/SQL" >}}) 模板二）。所以只寫 `referee_id != 2` 會漏掉 NULL 的人，要另外加上 `IS NULL`。

## 我的解法

```sql
SELECT name
FROM Customer
WHERE referee_id IS NULL OR referee_id != 2;
```

也可以寫成 `WHERE COALESCE(referee_id, 0) != 2`，先把 NULL 換成一個不會是 2 的值。

## 複雜度

掃一次資料表，`O(n)`。

## 要特別避免的錯誤

- 跟 NULL 比較要用 `IS NULL`，`= NULL` 和 `!= 2` 都不會選到 NULL 的列。

## 面試口說整理

推薦人不是 2 號的人包含沒有推薦人的人，但 `NULL != 2` 在 SQL 裡是 unknown，`WHERE` 不會留下，所以要用 `referee_id IS NULL OR referee_id != 2`。
