---
title: "LeetCode 2999: Count the Number of Powerful Integers"
summary: "LeetCode 解題紀錄"
description: "LeetCode Daily"
date: 2025-04-11
tags: ["LeetCode", "daily", "hard", "digit DP"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試： 2025-04-10
- 總花費時間：120:00.00 (兩小時後放棄)

## 解題思路

在我第一次嘗試時完全沒有頭緒，後來我閱讀了這篇 [Digit Dynamic Programming]({{< relref "Digit-Dynamic-Programming.md" >}}) 文章，並透過修改狀態，套用模板成功解出了這題。

和大多數 Digit DP 題目不同，這一題在抵達最後一位後，還需要**額外進行一次比較**。舉例來說，即使我們已經遍歷了像 `123xx` 這樣的 tight 數字，我們仍然需要將尾段 `xx` 與題目中給定的 `s` 進行比較，以判斷目前這個數字是否有效。因此，我們必須額外加入一個條件判斷語句。


## 解法

```python
class Solution:
    def numberOfPowerfulInt(self, start: int, finish: int, limit: int, s: str) -> int:

        def count_powerful(number: int):
            
            digits = list(map(int, str(number)))

            if len(digits)<len(s):
                return 0
    
            from functools import lru_cache

            @lru_cache(None)
            def dfs(position: int, is_tight: bool):
                if position==(len(digits)-len(s)):
                    return not is_tight or str(number)[position:]>=s

                max_digit = min(digits[position], limit) if is_tight else limit
                res = 0

                for d in range(max_digit+1):
                    res += dfs(
                        position + 1,
                        is_tight and d==max_digit and limit>=digits[position]
                    )
                return res

            return dfs(0, True)

        return count_powerful(finish) - count_powerful(start-1)
```

## 收穫
在實作 `max_digit` 的邏輯時，`limit` 是用來限制所有的數字位。  
因此，在計算下一個 `is_tight` 值時，應該加入一個條件來檢查 `limit` 是否大於或等於 `digits[position]`。

這個條件用來判斷目前的數字 `d` 是否超過 `digits[position]`，並據此決定是否仍需維持 tight 的限制狀態。

## 遇到的問題

第一次嘗試時沒能解出來。