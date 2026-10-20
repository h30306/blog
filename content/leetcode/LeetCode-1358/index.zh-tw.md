---
title: "LeetCode 1358: Number of Substrings Containing All Three Characters"
summary: "LeetCode 1358 解題筆記：「至少各一個 a、b、c」的計數視窗：三種都有時一直縮左邊，count += left"
description: "2026-01-19 的 LeetCode 1358 解題紀錄"
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
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

跟 [LeetCode 2962]({{< relref "/leetcode/LeetCode-2962" >}}) 同一個「至少」的計數寫法：三種字元都有時一直縮左邊，縮到少了一種為止，左端在 `[0, left)` 的子字串都合法，`count += left`。

## 我的嘗試

第一版用 `len(set(s))` 當目標種類數，而不是固定的 3。如果字串本身只有兩種字元，例如 `s = "abb"`，目標變成 2，有 `a`、`b` 的子字串都被算進去，回傳 2；但沒有 `c` 就不可能合法，答案是 0。

## 正確解法

```python
class Solution:
    def numberOfSubstrings(self, s: str) -> int:
        cnt = Counter()
        left = count = 0
        for c in s:
            cnt[c] += 1
            while len(cnt) == 3:                   # 三種都有：一直縮
                cnt[s[left]] -= 1
                if cnt[s[left]] == 0:
                    del cnt[s[left]]
                left += 1
            count += left
        return count
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 目標是固定的 3 種，不是字串裡實際出現的種類數。

## 面試口說整理

這是「至少」型的計數：三種字元都在視窗裡時一直縮左邊，縮到少一種為止，這時左端在 0 到 `left - 1` 的子字串都包含三種字元，所以加上 `left`。時間 `O(n)`。
