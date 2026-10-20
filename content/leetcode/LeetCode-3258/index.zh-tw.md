---
title: "LeetCode 3258: Count Substrings That Satisfy K-Constraint I"
summary: "LeetCode 3258 解題筆記：0 的個數 <= k 或 1 的個數 <= k；兩個都超過才不合法，縮左邊後以 right 結尾的合法子字串有 right - left + 1 個"
description: "2026-01-18 的 LeetCode 3258 解題紀錄"
date: 2026-01-18
tags: ["easy", "sliding-window", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2026-01-18
- 提交紀錄：Accepted（一次通過）

## 解題思路

合法 ⇔ `0` 的個數 `<= k` **或** `1` 的個數 `<= k`。反過來，不合法 ⇔ 兩個都 `> k`。

視窗變大時兩個計數都不會變少，所以「不合法」是單調的：

- 右端加入字元，兩個都 `> k` 就縮左邊。
- 以 `right` 結尾的合法子字串有 `right - left + 1` 個（左端在 `[left, right]` 的都合法）。

## 我的解法

```python
class Solution:
    def countKConstraintSubstrings(self, s: str, k: int) -> int:
        cnt = Counter()
        left = count = 0
        for right, c in enumerate(s):
            cnt[c] += 1
            while cnt["0"] > k and cnt["1"] > k:
                cnt[s[left]] -= 1
                left += 1
            count += right - left + 1
        return count
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 縮視窗的條件寫成 `or`：只要有一個 `<= k` 就合法，兩個都超過才要縮。

## 面試口說整理

子字串合法的條件是 0 或 1 其中一個不超過 `k`，所以兩個都超過才不合法，這個條件是單調的。我用滑動視窗，兩個都超過就縮左邊，以右端結尾的合法子字串有 `right - left + 1` 個，全部加起來。時間 `O(n)`。
