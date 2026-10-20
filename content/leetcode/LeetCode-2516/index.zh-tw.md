---
title: "LeetCode 2516: Take K of Each Character From Left and Right"
summary: "LeetCode 2516 解題筆記：從兩端拿等於中間留一段；留下的每種字元最多是總數 − k，找最長的這種中間視窗"
description: "2026-01-11 的 LeetCode 2516 解題紀錄"
date: 2026-01-11
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
第一次嘗試：2026-01-11
- 提交紀錄：Wrong Answer → Runtime Error ×2 → Accepted

## 解題思路

跟 [LeetCode 1423]({{< relref "/leetcode/LeetCode-1423" >}}) 一樣，從兩端拿 = 中間留下連續的一段。

拿到的每種字元至少 `k` 個 ⇔ 留下的每種字元**最多 `總數 − k` 個**。所以：

1. 先算每種字元的上限 `limit[c] = count[c] - k`。有任何一個 `< 0`，代表總數就不夠，回傳 -1。
2. 用「求最長」的滑動視窗找中間留下的最長一段：剛加入的字元超過上限就縮左邊。
3. 答案是 `n - 最長長度`。

## 我的嘗試

這題的錯都在第一步的判斷：

| 版本 | 問題 |
|---|---|
| 第一版 WA | 寫成 `char not in freq or freq[char] < k`。`k = 0` 時不需要任何字元，但字串裡沒有的字元還是被判成不夠。例如 `s = "b"`、`k = 0`：答案是 0，這版回傳 -1 |
| 第二、三版 RE | 改成 `and`（第三版再加 `k > 0`），變成字元存在但數量不夠時**不會回傳 -1**，上限變成負的，視窗怎麼縮都不合法，`left` 一路跑出字串。例如 `s = "abc"`、`k = 2`：直接 IndexError，答案是 -1 |
| AC | `(k > 0 and char not in freq) or freq[char] < k` |

其實只要看 `count[c] - k < 0` 就夠了：`Counter` 對不存在的字元回傳 0，`k = 0` 時 `0 - 0` 不是負的。

## 正確解法

```python
class Solution:
    def takeCharacters(self, s: str, k: int) -> int:
        limit = Counter(s)
        for c in "abc":
            limit[c] -= k                          # 中間最多能留幾個 c
            if limit[c] < 0:
                return -1

        cnt = Counter()
        left = best = 0
        for right, c in enumerate(s):
            cnt[c] += 1
            while cnt[c] > limit[c]:
                cnt[s[left]] -= 1
                left += 1
            best = max(best, right - left + 1)
        return len(s) - best
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- `k = 0` 時不需要任何字元。
- 數量不夠時一定要提早回傳，否則上限是負的，視窗的迴圈會越界。

## 面試口說整理

從兩端拿，等於中間留下連續的一段，所以我把問題反過來：留下的每種字元最多是總數減 `k`，找最長的這種中間視窗，答案是總長減掉它。總數不夠就直接回傳 -1。用求最長的滑動視窗，剛加入的字元超過上限就縮左邊，時間 `O(n)`。
