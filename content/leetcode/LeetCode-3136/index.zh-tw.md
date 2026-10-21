---
title: "LeetCode 3136: Valid Word"
summary: "LeetCode 3136 解題筆記：長度至少 3、只能有英數字元、至少一個母音、至少一個子音；數字不是子音"
description: "2024-05-05 的 LeetCode 3136 解題紀錄"
date: 2024-05-05
tags: ["easy", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2024-05-05
- 提交紀錄：Wrong Answer → Accepted → Wrong Answer → Accepted

## 解題思路

四個條件逐一檢查（[String]({{< relref "/algorithm/String" >}}) 模板四）：長度 `>= 3`、每個字元都是英數字元、至少一個母音（大小寫都算）、至少一個子音。**子音是「不是母音的字母」**，數字不算。

## 我的嘗試

- 2024 年第一版把「不是母音」的字元都當成子音，**數字也被算成子音**：`"a3E"` 只有母音和數字，答案 `False`，回傳 `True`。
- 2025 年重寫時判斷母音用 `w in "aeiou"`，**漏了大寫母音**：`"bEE"` 回傳 `False`，答案 `True`。改成 `w.lower()` 就 AC 了。

## 正確解法

```python
class Solution:
    def isValid(self, word: str) -> bool:
        if len(word) < 3 or not all(c.isalnum() for c in word):
            return False
        vowels = set("aeiouAEIOU")
        has_vowel = any(c in vowels for c in word)
        has_consonant = any(c.isalpha() and c not in vowels for c in word)
        return has_vowel and has_consonant
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 數字不是子音，要確認是字母。
- 大寫母音也是母音。

## 面試口說整理

我檢查長度至少 3、全部都是英數字元，再確認至少有一個母音和一個子音，子音必須是字母而且不是母音。時間 `O(n)`。
