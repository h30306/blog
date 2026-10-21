---
title: "LeetCode 596: Classes With at Least 5 Students"
summary: "LeetCode 596 解題筆記：按 class 分組，HAVING COUNT(DISTINCT student) >= 5；舊版測資有重複的列，要數不同的學生"
description: "2021-10-10 的 LeetCode 596 解題紀錄"
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
- 提交紀錄：Wrong Answer ×3 → Runtime Error → Wrong Answer → Accepted

## 解題思路

跟 LC 182 一樣是對分組下條件（[SQL]({{< relref "/algorithm/SQL" >}}) 模板四）：`GROUP BY class` 加 `HAVING ...  >= 5`。數的是**不同的學生**，`COUNT(DISTINCT student)`，同一個學生重複出現不能算兩次。現在的題目 `(student, class)` 是主鍵，`COUNT(*)` 也對，但 `DISTINCT` 比較保險。

## 我的嘗試

這題提交了 6 次，問題都在「重複的列」：

- 前幾版用 `COUNT(class)`，2021 年當時的測資裡**同一個學生在同一個班級出現了不只一次**，被重複計算了；第一版還用了 `SELECT *`。
- 想用 `FROM distinct(courses)` 去重是錯的語法（RE）。
- 最後改成在子查詢裡算 `COUNT(DISTINCT student)`、外層再過濾 `>= 5` 才 AC；直接寫在 `HAVING` 裡也可以，不需要子查詢。

## 正確解法

```sql
SELECT class
FROM Courses
GROUP BY class
HAVING COUNT(DISTINCT student) >= 5;
```

## 複雜度

分組 `O(n)` 或 `O(n log n)`。

## 要特別避免的錯誤

- `SELECT *` 搭配 `GROUP BY` 在嚴格模式會出錯，只選分組的欄位。
- 數不同的學生用 `COUNT(DISTINCT student)`。

## 面試口說整理

我按 class 分組，用 HAVING 留下不同學生數至少五個的班級。用 COUNT DISTINCT 可以避免同一個學生重複出現被算兩次。
