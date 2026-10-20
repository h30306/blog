---
title: "LeetCode 2953: Count Complete Substrings"
summary: "LeetCode 2953 解題筆記：先在相鄰字元差 > 2 的地方切段；每段枚舉有幾種字元 d，視窗長度固定是 d × k，維護「剛好出現 k 次的字元數」"
description: "2026-01-04 的 LeetCode 2953 解題紀錄"
date: 2026-01-04
tags: ["hard", "sliding-window", "hash-table", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-01-04
- 提交紀錄：Wrong Answer ×3 → Accepted

## 解題思路

兩個條件分開處理：

1. **相鄰字元差 `<= 2`**：只要某個位置跟前一個字元差 `> 2`，任何完整子字串都不能跨過它。所以先在這些地方**切成好幾段**，每段分開算。
2. **每個字元剛好 `k` 次**：如果子字串裡有 `d` 種字元，長度一定是 `d × k`。`d` 只有 1 到 26，所以對每個 `d` 做一次**固定長度 `d × k`** 的滑動視窗。

視窗裡維護 `good` = 剛好出現 `k` 次的字元數。長度是 `d × k` 而且 `good == d`，就代表這 `d` 種字元各 `k` 次、沒有別的字元。

`good` 只在計數跨過 `k` 的時候變動：加入後變成 `k` 就 +1，變成 `k + 1` 就 -1；移出時反過來。

## 我的嘗試

我的寫法是對每個視窗長度 `k, 2k, ..., 26k` 掃整個字串，遇到差 `> 2` 的位置就重設視窗。

| 版本 | 問題 |
|---|---|
| 第一版 | 縮視窗的條件寫成 `right - left > win_size`，也沒檢查長度剛好等於 `win_size`，長度不對的視窗也被算進去。例如 `word = "bd"`、`k = 1`：答案是 3（`b`、`d`、`bd`），回傳 4 |
| 第二版 | 補上長度檢查，但遇到斷點時重設視窗後直接 `continue`，**斷點那個字元沒加進新視窗**。例如 `word = "ah"`、`k = 1`：答案是 2，回傳 1 |
| 第三版 | 斷點的字元有加進去，但還是 `continue`，跳過了長度 1 的視窗的檢查，同一個例子還是回傳 1 |
| 第四版 AC | 調整順序並加上 `win_size > 1` 的條件，跑了 5.5 秒才過 |

每個視窗都用 `for c in count.values()` 檢查一遍，所以很慢。改成先切段、維護 `good` 計數，每次移動是 `O(1)`。

## 正確解法

```python
class Solution:
    def countCompleteSubstrings(self, word: str, k: int) -> int:
        def count_segment(seg: str) -> int:
            res = 0
            for d in range(1, 27):                 # 子字串裡有 d 種字元
                size = d * k
                if size > len(seg):
                    break
                cnt = [0] * 26
                good = 0                           # 剛好出現 k 次的字元數
                for right, ch in enumerate(seg):
                    c = ord(ch) - 97
                    cnt[c] += 1
                    if cnt[c] == k:
                        good += 1
                    elif cnt[c] == k + 1:
                        good -= 1
                    if right >= size:
                        c = ord(seg[right - size]) - 97
                        if cnt[c] == k:
                            good -= 1
                        elif cnt[c] == k + 1:
                            good += 1
                        cnt[c] -= 1
                    if right >= size - 1 and good == d:
                        res += 1
            return res

        total = start = 0
        for i in range(1, len(word) + 1):
            if i == len(word) or abs(ord(word[i]) - ord(word[i - 1])) > 2:
                total += count_segment(word[start:i])
                start = i
        return total
```

## 複雜度

時間 `O(26 · n)`，空間 `O(26)`（不算切出來的子字串）。

## 要特別避免的錯誤

- 沒有固定視窗長度：「每個字元剛好 `k` 次」不單調，要先固定有幾種字元。
- 斷點的處理：最乾淨的方式是先切段，不要在視窗裡特判。
- 每個視窗都重新檢查所有字元的次數：常數很大。

## 面試口說整理

相鄰字元差大於 2 的地方不能跨，所以我先把字串切段。每個字元剛好 `k` 次代表長度是種類數乘 `k`，所以對每段枚舉種類數 `d` 從 1 到 26，用長度 `d × k` 的固定視窗，維護剛好出現 `k` 次的字元數，等於 `d` 就是完整子字串。總共 `O(26n)`。
