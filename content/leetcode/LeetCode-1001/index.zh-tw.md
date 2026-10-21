---
title: "LeetCode 1001: Grid Illumination"
summary: "LeetCode 1001 解題筆記：列、欄、兩條對角線各開一個計數器（r - c、r + c），加上亮著的燈的集合；關燈時四個計數器都要減"
description: "2026-10-03 的 LeetCode 1001 解題紀錄"
date: 2026-10-03
tags: ["hard", "hash-table", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-10-03
- 提交紀錄：Runtime Error → Wrong Answer → Accepted → Wrong Answer ×2 → Accepted

## 解題思路

`n` 可以到 `10^9`，不能建格子。一盞燈照亮它的列、欄和兩條對角線，所以四個方向各記「有幾盞亮著的燈」（[Hash Table]({{< relref "/algorithm/Hash-Table" >}}) 模板三）：

- 列 `r`、欄 `c`、對角線 `r - c`、反對角線 `r + c`。
- 一個格子被照亮，等於這四個計數有任一個 `> 0`。
- 另外用集合記哪些燈亮著：同一盞燈可能重複出現，只能算一次；關燈時也只能關真的亮著的燈。

每次查詢後，檢查自己和周圍 8 格，亮著的就關掉，四個計數器都減 1。

## 我的嘗試

| 版本 | 問題 |
|---|---|
| RE | `if row, col not in active_lamps` 少了括號，語法錯誤 |
| WA | 查詢時寫成 `row_count[col]`，應該是 `col_count[col]`；關燈時也減了 `row_count[nc]`。例如 `n = 3`、燈在 `(0, 2)`、查詢 `(1, 2)`：同一欄，答案 1，回傳 0 |
| AC | 整份重寫，四個計數器都對 |
| 兩次 WA | 回到原本的程式，先修好查詢，但關燈時還是減 `row_count[nc]`，欄的計數一直沒減。例如 `n = 4`、燈在 `(1, 3)`、查詢 `(0, 3)` 之後再查 `(2, 3)`：第一次查詢就把燈關掉了，第二次答案 0，回傳 1 |
| AC | 改成 `col_count[nc] -= 1` |

## 正確解法

```python
class Solution:
    def gridIllumination(self, n: int, lamps: List[List[int]], queries: List[List[int]]) -> List[int]:
        row, col, diag, anti = Counter(), Counter(), Counter(), Counter()
        on = set()
        for r, c in lamps:
            if (r, c) not in on:
                on.add((r, c))
                row[r] += 1; col[c] += 1; diag[r - c] += 1; anti[r + c] += 1
        res = []
        for r, c in queries:
            res.append(1 if row[r] or col[c] or diag[r - c] or anti[r + c] else 0)
            for nr in (r - 1, r, r + 1):
                for nc in (c - 1, c, c + 1):
                    if (nr, nc) in on:
                        on.remove((nr, nc))
                        row[nr] -= 1; col[nc] -= 1; diag[nr - nc] -= 1; anti[nr + nc] -= 1
        return res
```

## 複雜度

時間 `O(L + Q)`，`L` 是燈數、`Q` 是查詢數（每次查詢檢查 9 格），空間 `O(L)`。

## 要特別避免的錯誤

- 四個計數器名字很像，複製貼上後要逐一檢查，查詢和關燈都要用對。
- 重複的燈只能算一次。

## 面試口說整理

格子太大不能模擬，所以我用四個計數器記每一列、每一欄、每條 `r - c` 對角線和 `r + c` 反對角線上有幾盞燈，再用集合記亮著的燈。查詢時四個有任一個大於 0 就亮；之後檢查周圍 9 格，亮著的就關掉並更新四個計數器。時間 `O(L + Q)`。
