---
title: "LeetCode 620: Not Boring Movies"
summary: "LeetCode 620 解題筆記：id 是奇數而且 description 不是 boring，按 rating 由高到低排序"
description: "2021-10-10 的 LeetCode 620 解題紀錄"
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
- 提交紀錄：Runtime Error → Wrong Answer ×2 → Accepted

## 解題思路

兩個條件用 `AND` 過濾（[SQL]({{< relref "/algorithm/SQL" >}}) 模板一）：`id % 2 = 1` 而且 `description <> 'boring'`，再用 `ORDER BY rating DESC` 由高到低排序。字串要用引號。

## 我的嘗試

第一版 `boring` 沒有加引號，被當成欄位名稱（RE）；加了引號之後**忘了排序**，接著用了 `ORDER BY rating`（預設是由小到大），改成 `DESC` 才 AC。

## 正確解法

```sql
SELECT *
FROM Cinema
WHERE id % 2 = 1 AND description <> 'boring'
ORDER BY rating DESC;
```

## 複雜度

排序 `O(n log n)`。

## 要特別避免的錯誤

- 字串要加引號：`'boring'`。
- 由高到低是 `DESC`，預設是 `ASC`。

## 面試口說整理

我用 WHERE 留下 id 是奇數而且不是 boring 的電影，再按 rating 由高到低排序。
