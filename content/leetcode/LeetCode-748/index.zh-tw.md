---
title: "LeetCode 748: Shortest Completing Word"
summary: "LeetCode 748 解題筆記：車牌只看字母並轉小寫計數，找出每個字母次數都夠的最短單字，同長度取最前面的"
description: "2022-09-03 的 LeetCode 748 解題紀錄"
date: 2022-09-03
tags: ["easy", "array", "hash-table", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-03
- 提交紀錄：Wrong Answer → Runtime Error ×2 → Wrong Answer ×6 → Accepted

## 解題思路

車牌只保留字母、轉小寫後計數（[Hash Table]({{< relref "/algorithm/Hash-Table" >}}) 模板一）。每個單字檢查是否每個需要的字母次數都夠（跟 LC 383 一樣），符合的單字中取最短的；同長度要回傳**最前面的**，所以只有在「嚴格更短」時才更新答案。

## 我的嘗試

這題提交了 10 次，錯誤一個接一個：

- 第一版內層迴圈用了外層迴圈留下來的變數 `i`，判斷的根本不是單字的字元（車牌最後一個字元不是字母時還會 KeyError）；接下來兩版是 KeyError 的 RE。
- 然後寫成 `d[i] = d.get(i.lower(), 0) + 1`，**存的 key 是原本的大小寫、讀的是小寫**：`"B"` 存成 `B`，單字 `"b"` 永遠不符合，回傳 `None`。
- key 統一成小寫後，`for word in set(words)` 打亂了順序，而且找到第一個符合的就回傳：`"a"`、`["a", "bda"]` 回傳 `"bda"`。拿掉 `set` 也還是第一個就回傳，不是最短的：`"B"`、`["ccb", "b"]` 回傳 `"ccb"`。
- 改成找最短時答案初始值是 `""`，**`len(word) < 0` 永遠不成立**，回傳空字串。加上 `res == ""` 的判斷才 AC。

## 正確解法

```python
class Solution:
    def shortestCompletingWord(self, licensePlate: str, words: List[str]) -> str:
        need = Counter(c.lower() for c in licensePlate if c.isalpha())
        best = None
        for w in words:
            if not (need - Counter(w)) and (best is None or len(w) < len(best)):
                best = w
        return best
```

## 複雜度

時間 `O(總字元數)`，空間 `O(k)`。

## 要特別避免的錯誤

- 計數的 key 要統一轉小寫。
- 不能把 `words` 轉成 `set`：會打亂順序，同長度時就不知道哪個在前面。
- 第一個符合的不一定最短，要全部看完。
- 答案初始值設成 `""` 時，`len(w) < len("")` 永遠不成立。

## 面試口說整理

我只取車牌的字母轉小寫計數，然後逐一檢查單字的字母次數是否都足夠，符合的單字中保留嚴格更短的，這樣同長度時會留下最前面那個。時間是所有單字的總長度。
