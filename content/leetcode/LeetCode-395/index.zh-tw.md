---
title: "LeetCode 395: Longest Substring with At Least K Repeating Characters"
summary: "LeetCode 395 解題筆記：「每個字元至少 k 次」不單調，不能直接滑動；分治法用出現不到 k 次的字元切開，或枚舉視窗裡有幾種字元，固定種類數後就能滑動"
description: "2026-01-17 的 LeetCode 395 解題紀錄"
date: 2026-01-17
tags: ["medium", "sliding-window", "divide-and-conquer", "hash-table", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-17
- 提交紀錄：WA → RE ×2 → WA ×2 → AC（分治）→ AC ×2（滑動視窗）

## 解題思路

「視窗裡每個字元至少 `k` 次」**不單調**：視窗變大可能讓某個字元剛出現 1 次而變得不合法，也可能讓它湊滿 `k` 次而變得合法。所以沒辦法直接用「不合法就縮左邊」。

### 分治

如果某個字元在整個字串裡出現不到 `k` 次，答案一定不包含它。用它把字串切開，對每一段遞迴。所有字元都夠 `k` 次時，整段就是答案。

### 固定種類數的滑動視窗

**多加一個限制讓它變單調**：視窗裡剛好有 `t` 種字元。種類數超過 `t` 就縮左邊，這是單調的。對 `t = 1..26` 各跑一次，視窗裡種類數是 `t`、而且這 `t` 種都達到 `k` 次時更新答案。

## 我的嘗試

前幾版想直接滑動，用 `not_enough` 計數「還沒達到 `k` 次的字元出現次數」，遇到總數不到 `k` 的字元就把左端跳過它。

| 版本 | 問題 |
|---|---|
| 第一版 WA | 左端跳過之後，計數沒有重設，視窗外的字元還留在計數裡。例如 `s = "cbb"`、`k = 2`：答案是 2（`"bb"`），回傳 0 |
| 兩次 RE | 改成正反各跑一次，第一次少了冒號，第二次輔助函式忘了 `return` |
| 第四版 WA | 補上 `return`，但計數還是沒重設。例如 `s = "caab"`、`k = 2`：答案是 2，回傳 0 |
| 第五版 WA | 重設了計數，但這個方法本身就不對：條件不單調，左端不知道該不該縮。例如 `s = "bcccbab"`、`k = 3`：答案是 3（`"ccc"`），回傳 0 |

之後改用分治 AC，再用固定種類數的滑動視窗寫了一次。

## 正確解法

分治：

```python
class Solution:
    def longestSubstring(self, s: str, k: int) -> int:
        for c, cnt in Counter(s).items():
            if cnt < k:                            # 答案不可能包含 c
                return max(self.longestSubstring(part, k) for part in s.split(c))
        return len(s)
```

固定種類數的滑動視窗：

```python
class Solution:
    def longestSubstring(self, s: str, k: int) -> int:
        best = 0
        for target in range(1, len(set(s)) + 1):   # 視窗裡剛好有 target 種字元
            cnt = Counter()
            left = unique = enough = 0             # enough：達到 k 次的種類數
            for right, c in enumerate(s):
                if cnt[c] == 0:
                    unique += 1
                cnt[c] += 1
                if cnt[c] == k:
                    enough += 1
                while unique > target:
                    d = s[left]
                    if cnt[d] == k:
                        enough -= 1
                    cnt[d] -= 1
                    if cnt[d] == 0:
                        unique -= 1
                    left += 1
                if unique == target and enough == target:
                    best = max(best, right - left + 1)
        return best
```

## 複雜度

- 分治：每一層至少拿掉一種字元，最多 26 層，每層 `O(n)`，總共 `O(26n)`。
- 滑動視窗：`O(26n)`，空間 `O(26)`。

## 要特別避免的錯誤

- 條件不單調時直接滑動視窗。
- 跳過左端時沒有重設計數。

## 面試口說整理

每個字元至少 `k` 次這個條件不單調，不能直接滑動。一種做法是分治：出現不到 `k` 次的字元一定不在答案裡，用它切開字串遞迴。另一種是多加一個限制，枚舉視窗裡剛好有幾種字元，固定種類數之後縮視窗的條件就單調了，再看這幾種是不是都達到 `k` 次。兩種都是 `O(26n)`。
