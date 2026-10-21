---
title: "LeetCode 205: Isomorphic Strings"
summary: "LeetCode 205 解題筆記：兩個字串的字元要一對一對應，字元種類數和配對種類數都相同就成立"
description: "2022-08-21 的 LeetCode 205 解題紀錄"
date: 2022-08-21
tags: ["easy", "hash-table", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-21
- 提交紀錄：Wrong Answer ×2 → Accepted ×2 → Wrong Answer → Accepted ×2

## 解題思路

同構就是雙射：`s` 的每個字元只對應 `t` 的一個字元，反過來也是。`len(set(s)) == len(set(t)) == len(set(zip(s, t)))`：配對數比字元種類多，代表有字元對到兩個不同的字元（[Hash Table]({{< relref "/algorithm/Hash-Table" >}}) 模板五）。另一種寫法是把每個字元換成「第一次出現的 index」，兩個字串轉換後相同就成立。

## 我的嘗試

前幾版把每個字元換成「第一次出現的 index」再比較：

- 第一版兩次都對 `s` 編碼，`t` 沒用到，永遠回傳 `True`：`"aa"`、`"ca"` 也是 `True`。
- 第二版改成編碼 `t`，但數字直接接在一起沒有分隔，**index 到兩位數就會撞**：`"abcdefghijkbl"` 和 `"abcdefghijklc"` 最後兩個字元分別編成 `1, 12` 和 `11, 2`，都是 `"112"`，回傳 `True`，答案 `False`。
- 加上空白分隔就 AC 了。後來改寫成一行的 set 比較，第一次忘了寫 `return`。

## 正確解法

```python
class Solution:
    def isIsomorphic(self, s: str, t: str) -> bool:
        return len(set(s)) == len(set(t)) == len(set(zip(s, t)))
```

## 複雜度

時間 `O(n)`，空間 `O(k)`。

## 要特別避免的錯誤

- 用 index 編碼時，數字之間要加分隔符號，不然 `1` + `12` 和 `11` + `2` 都是 `112`。
- 兩個字串都要編碼，不要對 `s` 做兩次。

## 面試口說整理

同構就是兩個方向都要一對一，我比較 s 的字元種類數、t 的字元種類數和 (s[i], t[i]) 配對的種類數，三者相等就成立。時間 `O(n)`。
