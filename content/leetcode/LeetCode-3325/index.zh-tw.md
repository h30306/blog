---
title: "LeetCode 3325: Count Substrings With K-Frequency Characters I"
summary: "LeetCode 3325 解題筆記：「至少一個字元出現 k 次」的計數視窗；剛加入的字元湊滿 k 次就一直縮，縮到它變成 k - 1 次為止"
description: "2026-01-19 的 LeetCode 3325 解題紀錄"
date: 2026-01-19
tags: ["medium", "sliding-window", "hash-table", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-19
- 提交紀錄：Wrong Answer → Runtime Error → Wrong Answer ×2 → Accepted

## 解題思路

「至少一個字元出現至少 `k` 次」是單調的，用「至少」型的計數：

- 右端加入字元 `c`，如果 `c` 剛好湊滿 `k` 次，視窗合法。
- 合法時一直縮左邊，直到**某個字元的數量從 `k` 掉到 `k - 1`**（那就是唯一達標的字元剛被移出去）。
- `count += left`。

縮之前視窗是不合法的（沒有字元達到 `k`），加入 `c` 後只有 `c` 可能達標，所以合法 ⇔ `cnt[c] >= k`，縮到 `cnt[c] < k` 就好。

## 我的嘗試

| 版本 | 問題 |
|---|---|
| 第一版 WA | 把 `k` 寫死成 2。例如 `s = "b"`、`k = 1`：答案是 1，回傳 0 |
| 第二版 RE | 改用 `k`，但移出時判斷「不合法了」的條件寫成數量 `== 1`，應該是 `== k - 1`。`k = 1` 時數量會掉到 0，永遠不會等於 1，`left` 一路跑出字串 |
| 第三、四版 WA | 加上 `left < n`、`left <= right` 擋住越界，但門檻還是錯的。例如 `s = "cc"`、`k = 1`：答案是 3，第三版回傳 4；`s = "bbb"`、`k = 3`：答案是 1，第四版回傳 2 |
| AC | 門檻改成 `== k - 1` |

## 正確解法

```python
class Solution:
    def numberOfSubstrings(self, s: str, k: int) -> int:
        cnt = Counter()
        left = count = 0
        for c in s:
            cnt[c] += 1
            while cnt[c] >= k:                     # 只有剛加入的 c 可能達標
                cnt[s[left]] -= 1
                left += 1
            count += left
        return count
```

直接用 `cnt[c] >= k` 當條件，比維護「達標的字元數」再判斷 `== k - 1` 簡單，也不會寫錯門檻。

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 把 `k` 寫死。
- 「離開達標」的門檻是 `k - 1`，不是 1。

## 面試口說整理

這是「至少」型的計數。加入字元前視窗不合法，加入後只有這個字元可能達到 `k` 次，所以它達到 `k` 次時我就一直縮左邊，縮到它少於 `k` 次，這時左端在 0 到 `left - 1` 都合法，加上 `left`。時間 `O(n)`。
