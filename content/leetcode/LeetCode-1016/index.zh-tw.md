---
title: "LeetCode 1016: Binary String With Substrings Representing 1 To N"
summary: "LeetCode 1016 解題筆記：s 最多 1000 個字元，長度固定時的子字串數量有限，n 太大一定是 False；從 n 往下檢查會很快失敗，或從每個起點往右最多延伸 30 位收集所有 <= n 的值"
description: "2026-01-04 的 LeetCode 1016 解題紀錄"
date: 2026-01-04
tags: ["medium", "sliding-window", "string", "bit-manipulation", "hash-table"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-04
- 提交紀錄：Memory Limit Exceeded → Wrong Answer ×4 → Accepted

## 解題思路

`n` 可以到 `10^9`，但 `s` 最多只有 1000 個字元。

**關鍵觀察**：`(n/2, n]` 裡的數字二進位長度都一樣，設為 `L`，共約 `n/2` 個。`s` 裡長度 `L` 的子字串最多只有 `len(s)` 個，所以只要 `n/2 > len(s)`，一定有數字找不到。也就是說，答案是 `True` 的時候 `n` 一定很小（大約 `<= 2000`）。

兩種做法：

1. **從 `n` 往下檢查**：每個數字用 `bin(i)[2:] in s` 檢查。`n` 很大時，前面幾個就會失敗；`n` 小時總共也只檢查幾千次。
2. **滑動視窗收集**：從 `s` 的每個 `1` 開始往右延伸，邊走邊算二進位值，超過 `n` 或超過 30 位就停，把所有 `<= n` 的值放進 `set`，最後看 `set` 的大小是不是 `n`。

## 我的嘗試

| 版本 | 問題 |
|---|---|
| 第一版 MLE | 先把 `1..n` 的二進位字串全部放進 `set`，`n = 10^9` 時記憶體爆掉 |
| 第二版 WA | 改成「每個長度的子字串種類數要夠多」，長度 1 要求 `"0"`、`"1"` 兩種都有。但 `0` 不在 `1..n` 裡。例如 `s = "1"`、`n = 1`：答案是 `True`，這版回傳 `False` |
| 第三到五版 WA | 改成長度 `w` 要有 `2^w - 1` 種。但子字串可能有前導 0（`"0"`、`"01"`），而且 `n` 不一定用到長度 `w` 的所有數字，數量對不代表內容對。例如 `s = "0"`、`n = 1`：長度 1 的種類數是 1，但那是 `"0"` 不是 `"1"`，答案是 `False`，這版回傳 `True` |
| AC | 直接從 `n` 往下用 `in` 檢查每個數字 |

## 正確解法

```python
class Solution:
    def queryString(self, s: str, n: int) -> bool:
        for i in range(n, 0, -1):                  # 大的數字先檢查，n 太大會很快失敗
            if bin(i)[2:] not in s:
                return False
        return True
```

滑動視窗收集的版本：

```python
class Solution:
    def queryString(self, s: str, n: int) -> bool:
        seen = set()
        for i in range(len(s)):
            if s[i] == "0":
                continue                           # 二進位表示不會有前導 0
            val = 0
            for j in range(i, min(len(s), i + 30)):
                val = val * 2 + (s[j] == "1")
                if val > n:
                    break
                seen.add(val)
        return len(seen) == n
```

## 複雜度

- 往下檢查：答案是 `True` 時 `n = O(len(s))`，每次 `in` 是 `O(len(s) · log n)`，總共大約 `O(len(s)^2 · log n)`；`n` 很大時會在前幾個數字就失敗。
- 收集版本：時間 `O(30 · len(s))`，空間 `O(min(n, 30 · len(s)))`。

## 要特別避免的錯誤

- 把 `1..n` 全部存起來：`n` 可以到 `10^9`。
- 用「子字串種類數」判斷：前導 0 和不在 `1..n` 範圍的值都會混進來。

## 面試口說整理

`s` 最多 1000 個字元，而 `n/2` 到 `n` 之間的數字二進位長度都一樣，所以 `n` 大於大約兩倍的 `len(s)` 時一定是 `False`。我可以從 `n` 往下檢查每個數字是不是子字串，`n` 大時很快就會失敗；或者從每個 `1` 開始往右最多延伸 30 位，把所有 `<= n` 的值收進 `set`，看大小是不是 `n`，時間 `O(30 · len(s))`。
