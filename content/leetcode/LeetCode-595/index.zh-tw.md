---
title: "LeetCode 595: Big Countries"
summary: "LeetCode 595 解題筆記：面積至少 300 萬或人口至少 2500 萬，用 WHERE 加 OR 過濾"
description: "2021-10-10 的 LeetCode 595 解題紀錄"
date: 2021-10-10
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
第一次嘗試：2021-10-10
- 提交紀錄：Accepted ×3

## 解題思路

兩個條件任一成立就是大國，用 `OR` 連接（[SQL]({{< relref "/algorithm/SQL" >}}) 模板一）。題目說的是**至少**，用 `>=`。

## 我的嘗試

三次都 AC：`OR` 寫法、換個順序的 `OR`，以及兩個查詢 `UNION`。當時用的是 `>`，題目是「至少」，邊界應該用 `>=`，剛好測資沒有卡到。

## 正確解法

```sql
SELECT name, population, area
FROM World
WHERE area >= 3000000 OR population >= 25000000;
```

## 複雜度

掃一次資料表，`O(n)`。

## 要特別避免的錯誤

- 「至少」是 `>=`。
- 也可以用兩個查詢 `UNION`，在有索引時有機會比較快，但一般用 `OR` 就好。

## 面試口說整理

我用 WHERE 過濾面積至少三百萬或人口至少兩千五百萬的國家，回傳名稱、人口和面積。
