---
title: "LeetCode 181: Employees Earning More Than Their Managers"
summary: "LeetCode 181 解題筆記：Employee 跟自己 self join，用 managerId = id 把員工和主管接起來，再比較薪水"
description: "2021-10-09 的 LeetCode 181 解題紀錄"
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
- 提交紀錄：Runtime Error → Wrong Answer ×2 → Accepted → Wrong Answer → Accepted

## 解題思路

同一張表要扮演「員工」和「主管」兩個角色，所以 self join（[SQL]({{< relref "/algorithm/SQL" >}}) 模板三）：`e.managerId = m.id` 把每個員工接到他的主管，再用 `e.salary > m.salary` 過濾。輸出欄位要命名成 `Employee`。沒有主管的人 `managerId` 是 `NULL`，join 不到，自然不會出現。

## 我的嘗試

這題提交了 6 次：

- 第一版 `SELECT Name` 沒寫是哪一個別名的欄位，**兩個別名都有 `Name`**，有歧義（RE）。
- 改成 `A.Name` 之後，輸出的欄位名稱不是 `Employee`；中間有一版改成 `SELECT *` 想看資料。最後寫成 `a.Name AS 'Employee'` 才 AC。

## 正確解法

```sql
SELECT e.name AS Employee
FROM Employee e
JOIN Employee m ON e.managerId = m.id
WHERE e.salary > m.salary;
```

## 複雜度

self join，有索引時接近 `O(n)`。

## 要特別避免的錯誤

- 兩個別名都要寫清楚欄位屬於哪一個，`Name` 單獨寫會有歧義。
- 輸出的欄位名稱要是 `Employee`。
- SQL 的別名在 MySQL 預設不分大小寫，但最好保持一致。

## 面試口說整理

同一張表要當員工和主管兩個角色，所以我用 self join，用員工的 managerId 接到主管的 id，再留下薪水比主管高的員工，欄位命名成 Employee。
