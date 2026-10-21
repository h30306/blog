---
title: "LeetCode 953: Verifying an Alien Dictionary"
summary: "LeetCode 953 解題筆記：把字母對應到外星順序的 index，相鄰兩個單字找第一個不同的字元比較，沒有不同時短的要在前面"
description: "2022-09-26 的 LeetCode 953 解題紀錄"
date: 2022-09-26
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
第一次嘗試：2022-09-26
- 提交紀錄：Wrong Answer → Runtime Error ×4 → Wrong Answer → Runtime Error ×3 → Accepted ×3

## 解題思路

先建 `rank[c]` = 字母在 `order` 裡的位置（[Hash Table]({{< relref "/algorithm/Hash-Table" >}})）。字典序只要檢查**相鄰兩個**單字：從頭找第一個不同的字元，比 `rank` 決定大小；如果短的那個整個是長的前綴，短的必須在前面。Python 可以直接把單字轉成 `rank` 的 list 比較，list 比較本身就是字典序。

## 我的嘗試

這題提交了 12 次：

- 第一版用 `zip(*words)` 一欄一欄比，**每一欄都要求非遞減**，但字典序只看第一個不同的字元；而且 `zip` 會截斷，前綴的情況沒有檢查：`["ll", "l"]` 回傳 `True`。
- 改成相鄰兩個單字逐字比較後，先是外層迴圈跑到最後一個單字，`words[i + 1]` 超出範圍（IndexError）。
- 有一版內層寫成 `range(len(words[i]) - 1)`，**少比了最後一個字元**：`["r", "p"]` 一個字都沒比，回傳 `True`。
- 修好之後，下一個單字比較短時 `words[i + 1][j]` 還是 IndexError。最後加上「下一個單字已經用完就回傳 `False`」才 AC。

## 正確解法

```python
class Solution:
    def isAlienSorted(self, words: List[str], order: str) -> bool:
        rank = {c: i for i, c in enumerate(order)}
        keys = [[rank[c] for c in w] for w in words]
        return all(keys[i] <= keys[i + 1] for i in range(len(keys) - 1))
```

## 複雜度

時間 `O(總字元數)`，空間 `O(總字元數)`。

## 要特別避免的錯誤

- 只看第一個不同的字元，後面的不用比。
- 前綴的情況：`["ll", "l"]` 不是排好的。
- 存取下一個單字的字元前要確認它夠長。

## 面試口說整理

我把每個字母對應到外星順序的位置，把單字轉成位置的 list，檢查每兩個相鄰的 list 是否非遞減；list 比較本身就是字典序，前綴的情況也處理好了。時間是總字元數。
