---
title: "LeetCode 3298: Count Substrings That Can Be Rearranged to Contain a String II"
summary: "LeetCode 3298 解題筆記：能重排成以 word2 開頭 ⇔ 每個字元的數量都不少於 word2；「至少」型的計數視窗，用 meet 記錄有幾種字元已經達標"
description: "2026-01-20 的 LeetCode 3298 解題紀錄"
date: 2026-01-20
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
第一次嘗試：2026-01-20
- 提交紀錄：Accepted（一次通過）

## 解題思路

子字串能重排成以 `word2` 開頭 ⇔ 它的**每個字元數量都 `>=` `word2` 的數量**。條件單調，用「至少」型的計數：

- `need = Counter(word2)`，`meet` = 數量已經達標的字元種類數。
- 加入字元時，數量剛好變成 `need[c]` 就 `meet += 1`。
- `meet == len(need)` 時一直縮左邊；移出時數量從 `need[c]` 掉到 `need[c] - 1` 就 `meet -= 1`。
- `count += left`。

題目要求線性時間，每次只更新一個字元，`meet` 讓檢查是 `O(1)`，不用每次比較整個計數表。

## 我的解法

```python
class Solution:
    def validSubstringCount(self, word1: str, word2: str) -> int:
        need = Counter(word2)
        have = Counter()
        meet = left = count = 0
        for c in word1:
            have[c] += 1
            if have[c] == need[c]:
                meet += 1
            while meet == len(need):
                d = word1[left]
                if have[d] == need[d]:
                    meet -= 1                      # 移出後就不夠了
                have[d] -= 1
                left += 1
            count += left
        return count
```

不在 `word2` 裡的字元 `need[c] = 0`：`have[c]` 從 0 加到 1 不會等於 0，所以不會影響 `meet`；移出時 `have[d]` 是 `>= 1` 也不等於 0。

## 複雜度

時間 `O(n + m)`，空間 `O(26)`。

## 要特別避免的錯誤

- 每次都比較整個計數表：常數大，這題記憶體和時間都卡比較緊。
- 用 `Counter` 查不在 `word2` 的字元時，`need[c]` 是 0，要確認 `meet` 不會被誤加。

## 面試口說整理

能重排成以 `word2` 開頭，代表每個字元的數量都不少於 `word2`，這是單調的。我用「至少」型的滑動視窗，`meet` 記錄有幾種字元已經達標，全部達標時一直縮左邊，縮到少一種，左端在 0 到 `left - 1` 都合法，加上 `left`。時間 `O(n + m)`。
