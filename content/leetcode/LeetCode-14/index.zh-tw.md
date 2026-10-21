---
title: "LeetCode 14: Longest Common Prefix"
summary: "LeetCode 14 解題筆記：用最短的字串當上限，逐個位置檢查所有字串是否相同，第一個不同的位置就是答案的長度"
description: "2019-09-19 的 LeetCode 14 解題紀錄"
date: 2019-09-19
tags: ["easy", "array", "string", "trie"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2019-09-19
- 提交紀錄：Wrong Answer → Accepted → Wrong Answer → Runtime Error → Wrong Answer ×4 → Runtime Error → Wrong Answer ×3 → Accepted ×2

## 解題思路

共同前綴不會比最短的字串長。用 `zip(*strs)` 一次取出所有字串在同一個位置的字元，全部相同就繼續，第一個不同的位置就停。**迴圈正常跑完代表最短的字串整個都是前綴**，這個情況也要回傳。

## 我的嘗試

2019 年第一次只寫了兩行特殊情況就送出。2022-05 用「最短字串逐位比對」就 AC 了。2022-08 改用 `zip(*strs)` 重寫，錯了十次，幾乎都是同一個問題：

- **迴圈正常跑完時沒有回傳**，只在遇到不同時才 `return`：`[""]` 這種 `zip` 一次都沒跑的情況回傳 `None`。
- 補上之後回傳的是 `""`，**但跑完代表最短字串整個都是前綴**：`["a"]` 答案 `"a"`，回傳 `""`。最後改回最短字串的寫法才 AC。

## 正確解法

```python
class Solution:
    def longestCommonPrefix(self, strs: List[str]) -> str:
        n = 0
        for chars in zip(*strs):
            if len(set(chars)) != 1:
                break
            n += 1
        return strs[0][:n]
```

## 複雜度

時間 `O(總字元數)`，空間 `O(m)`（`m` 是字串數量）。

## 要特別避免的錯誤

- 迴圈結束後也要回傳，不然最短字串整個都是前綴時會回傳 `None`。
- 有空字串時 `zip` 一次都不會執行，答案是空字串。

## 面試口說整理

我用 zip 把所有字串同一個位置的字元一起取出來，全部相同就把長度加一，遇到第一個不同就停，最後回傳第一個字串的前面那段。時間是總字元數。
