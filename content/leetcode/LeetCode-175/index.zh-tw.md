---
title: "LeetCode 175: Combine Two Tables"
summary: "LeetCode 175 解題筆記：沒有地址的人也要出現，所以用 LEFT JOIN，對不到的 city、state 會是 NULL"
description: "2021-10-09 的 LeetCode 175 解題紀錄"
date: 2021-10-09
tags: ["easy", "database"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2021-10-09
- 提交紀錄：Runtime Error → Accepted ×3

## 解題思路

每個人都要出現，即使 `Address` 裡沒有他的資料，所以是 `Person LEFT JOIN Address`（[SQL]({{< relref "/algorithm/SQL" >}}) 模板三）：左表的每一列都保留，右表對不到的欄位補 `NULL`。`INNER JOIN` 會把沒有地址的人丟掉。

## 我的嘗試

第一版把 join 用括號包起來再給一個別名 `as ouptut`，MySQL 不接受這種寫法（RE）；拿掉別名就 AC 了。

## 正確解法

```sql
SELECT p.firstName, p.lastName, a.city, a.state
FROM Person p
LEFT JOIN Address a ON p.personId = a.personId;
```

## 複雜度

用 `personId` join，有索引時接近 `O(n + m)`。

## 要特別避免的錯誤

- 要保留左表全部的列，用 `LEFT JOIN`，不是 `JOIN`。
- FROM 後面的 join 加括號再給別名會變成子查詢，語法要對。

## 面試口說整理

沒有地址的人也要出現，所以我用 Person LEFT JOIN Address，對不到地址的人 city 和 state 會是 NULL。
