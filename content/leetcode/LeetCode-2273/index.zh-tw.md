---
title: "LeetCode 2273: Find Resultant Array After Removing Anagrams"
summary: "LeetCode 2273 解題筆記：一直刪掉跟前一個是異位詞的字，等於只保留跟前一個留下來的字不是異位詞的字；用排序後的字串比較"
description: "2026-01-29 的 LeetCode 2273 解題紀錄"
date: 2026-01-29
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
第一次嘗試：2026-01-29
- 提交紀錄：Accepted（一次通過）

## 解題思路

刪掉 `words[i]` 之後，它後面的字的「前一個」變成 `words[i - 1]`。被刪掉的字跟 `words[i - 1]` 是異位詞，而異位詞有傳遞性，所以跟被刪的字比、跟 `words[i - 1]` 比結果一樣。

因此由左到右掃，**只跟最後一個留下來的字比**：不是異位詞就留下。判斷異位詞用排序後的字串（[Hash Table]({{< relref "/algorithm/Hash-Table" >}}) 模板五）。

## 我的解法

我當時從右往左，用 `Counter` 比較相鄰的字，一樣就 `pop`。這裡改成由左到右建新的陣列：

```python
class Solution:
    def removeAnagrams(self, words: List[str]) -> List[str]:
        res = []
        for w in words:
            if not res or sorted(res[-1]) != sorted(w):
                res.append(w)
        return res
```

## 複雜度

時間 `O(n · L log L)`，`L` 是字的長度，空間 `O(n · L)`。

## 要特別避免的錯誤

- 在迴圈中 `pop` 會改變 index，從右往左做才安全；建新陣列更簡單。

## 面試口說整理

刪掉一個字後，下一個字會跟它前一個比；因為異位詞有傳遞性，結果等於只跟最後留下的字比。我由左到右掃，跟最後留下的字排序後不一樣就留下。時間 `O(n L log L)`。
