---
title: "LeetCode 197: Rising Temperature"
summary: "LeetCode 197 解題筆記：Weather self join，條件是兩天的日期差 1 天而且今天比較熱；日期要用 DATEDIFF 比，不能比 id"
description: "2021-10-10 的 LeetCode 197 解題紀錄"
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
- 提交紀錄：Runtime Error → Accepted

## 解題思路

把每一天接到「前一天」（[SQL]({{< relref "/algorithm/SQL" >}}) 模板三）：`DATEDIFF(w.recordDate, y.recordDate) = 1`，再過濾 `w.temperature > y.temperature`。**不能用 id 相鄰代表日期相鄰**，id 的順序不一定跟日期一樣，日期也可能有缺。

## 我的嘗試

第一版 join 的寫法打錯，`JOIN weather,w` 多了一個逗號（RE）；拿掉就 AC 了。

## 正確解法

```sql
SELECT w.id
FROM Weather w
JOIN Weather y ON DATEDIFF(w.recordDate, y.recordDate) = 1
WHERE w.temperature > y.temperature;
```

## 複雜度

self join，有日期索引時接近 `O(n)`。

## 要特別避免的錯誤

- 用日期判斷前一天，不要用 id。
- `DATEDIFF` 是 MySQL 的函數，其他資料庫的寫法不同（例如 `date - interval`）。

## 面試口說整理

我把 Weather 跟自己 join，條件是兩筆的日期差剛好一天，再留下今天比前一天熱的 id。前一天要用日期判斷，id 的順序不一定跟日期一樣。
