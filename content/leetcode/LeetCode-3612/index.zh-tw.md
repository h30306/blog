---
title: "LeetCode 3612: Process String with Special Operations I"
summary: "LeetCode 3612 解題筆記：用 list 模擬四種操作；判斷 * 時要把「結果非空」寫在分支裡面，不然 * 會被當成字母加進去"
description: "2025-07-13 的 LeetCode 3612 解題紀錄"
date: 2025-07-13
tags: ["medium", "string", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-07-13
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

照規則模擬（[String]({{< relref "/algorithm/String" >}}) 模板一）。用 list 當結果，`*` 是 `pop`、`#` 是 `res += res`、`%` 是反轉、字母就 `append`，最後 `join`。

## 我的嘗試

第一版寫成 `if char == "*" and res:`。結果是空的時候這個條件不成立，`*` 就往下掉到最後的 `elif char.lower() == char`，而 `"*".lower()` 還是 `"*"`，**被當成字母加進結果**。例如 `"*"`：答案是空字串，這版回傳 `"*"`。把 `if res` 移到分支裡面就 AC 了。

## 正確解法

```python
class Solution:
    def processStr(self, s: str) -> str:
        res = []
        for ch in s:
            if ch == "*":
                if res:
                    res.pop()
            elif ch == "#":
                res += res
            elif ch == "%":
                res.reverse()
            else:
                res.append(ch)
        return "".join(res)
```

## 複雜度

結果長度可能每次 `#` 都翻倍，時間和空間都跟最後的長度成正比。

## 要特別避免的錯誤

- 用 `and` 把額外條件塞進分支判斷時，條件不成立會掉到後面的分支。
- `ch.lower() == ch` 不能用來判斷字母，符號也會成立；用 `ch.isalpha()` 或直接放在 `else`。

## 面試口說整理

我用 list 模擬四種操作，最後 `join`。要注意 `*` 在結果是空的時候什麼都不做，判斷要寫在分支裡，不然它會掉到後面被當成字母。時間跟輸出長度成正比。
