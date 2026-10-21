---
title: "LeetCode 3606: Coupon Code Validator"
summary: "LeetCode 3606 解題筆記：先過濾合法的優惠券，再用（類別順序, code）排序；字元範圍要包含 z、Z、9"
description: "2025-07-06 的 LeetCode 3606 解題紀錄"
date: 2025-07-06
tags: ["easy", "hash-table", "string", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2025-07-06
- 提交紀錄：Wrong Answer ×4 → Accepted

## 解題思路

兩步：

1. **過濾**：`code` 非空且只有英數字和底線、類別是四個之一、`isActive` 是 `True`。
2. **排序**：先照類別的指定順序，再照 `code` 的字典序。用 `(類別順序, code)` 當排序的 key（[Hash Table]({{< relref "/algorithm/Hash-Table" >}}) 模板五），類別順序用一個字典查。

## 我的嘗試

| 版本 | 問題 |
|---|---|
| 第一、二版 | 用 `range(ord("a"), ord("z"))` 判斷字元，**不包含 `z`、`Z`、`9`**。例如 `code = ["9"]`：合法，這版回傳空的。第一版也沒排序 |
| 第三版 | 範圍修好了，但只照 `code` 排序，忘了先照類別 |
| 第四版 | 排序 key 寫成 `(code, 類別)`，順序反了。例如 `code = ["_a", "a"]`、類別 `["pharmacy", "grocery"]`：答案是 `["a", "_a"]`，這兩版回傳 `["_a", "a"]` |
| AC | 改成 `(類別, code)` |

剛好四個類別本身就是字母順序，所以直接用類別字串排序也對；用字典寫明順序比較不依賴巧合。

## 正確解法

```python
class Solution:
    def validateCoupons(self, code: List[str], businessLine: List[str], isActive: List[bool]) -> List[str]:
        order = {"electronics": 0, "grocery": 1, "pharmacy": 2, "restaurant": 3}
        valid = [
            (order[b], c)
            for c, b, active in zip(code, businessLine, isActive)
            if active and b in order and c and all(ch.isalnum() or ch == "_" for ch in c)
        ]
        return [c for _, c in sorted(valid)]
```

`str.isalnum()` 對非 ASCII 的字母也會回傳 `True`，這題的輸入只有 ASCII 所以沒問題。

## 複雜度

時間 `O(L + n log n)`，`L` 是所有 code 的總長度，空間 `O(n)`。

## 要特別避免的錯誤

- `range(a, b)` 不包含 `b`。
- 多條件排序時，key 的順序就是優先順序。

## 面試口說整理

我先過濾出合法的優惠券：code 非空而且只有英數字和底線、類別在清單裡、狀態是啟用。再用（類別順序, code）排序，類別順序用字典查。時間 `O(n log n)`。
