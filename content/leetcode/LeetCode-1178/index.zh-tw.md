---
title: "LeetCode 1178: Number of Valid Words for Each Puzzle"
summary: "LeetCode 1178 解題筆記：單字只在乎用了哪些字母，轉成 26-bit 遮罩計數，再枚舉謎題遮罩的所有子集合"
description: "2026-08-28 的 LeetCode 1178 解題紀錄"
date: 2026-08-28
tags: ["hard", "bit-manipulation", "hash-map", "trie"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-08-28
- 提交紀錄：Accepted（一次通過）

## 解題思路

單字對某個謎題合法的條件：

1. 包含謎題的第一個字母。
2. 單字用到的每個字母都在謎題裡。

這兩個條件都只跟「**用到哪些字母**」有關，跟順序和次數無關。所以每個單字可以壓成一個 26-bit 的遮罩，用 `Counter` 記錄每種遮罩有幾個單字。

謎題剛好 7 個字母，所以：

- 合法單字的遮罩，一定是「謎題遮罩的子集合，而且包含第一個字母」。
- 除了第一個字母，其他 6 個字母的子集合只有 `2^6 = 64` 種。

對每個謎題，枚舉這 64 種子集合，加上第一個字母，查 `Counter` 加總就好。

### 枚舉子集合的技巧

```python
sub = mask
while True:
    處理(sub)
    if sub == 0:
        break
    sub = (sub - 1) & mask
```

`(sub - 1) & mask` 會依序產生 `mask` 的所有子集合，由大到小，最後是 0。

## 我的解法

```python
from collections import Counter

class Solution:
    def findNumOfValidWords(self, words: List[str], puzzles: List[str]) -> List[int]:
        def to_mask(s: str) -> int:
            m = 0
            for ch in s:
                m |= 1 << (ord(ch) - ord("a"))
            return m

        word_count = Counter(to_mask(w) for w in words)

        res = []
        for p in puzzles:
            first = 1 << (ord(p[0]) - ord("a"))
            rest = to_mask(p[1:])
            count = 0
            sub = rest
            while True:
                count += word_count[sub | first]
                if sub == 0:
                    break
                sub = (sub - 1) & rest
            res.append(count)
        return res
```

把第一個字母分開，只枚舉其他 6 個字母的子集合，再 `| first`，就保證每個遮罩都包含第一個字母。

## 複雜度

時間 `O(W + P · 2^6)`，`W` 是所有單字的總長度，`P` 是謎題數。空間 `O(單字數)`。

## 要特別避免的錯誤

- 對每個謎題掃過所有單字：`10^5 × 10^4` 太慢。
- 把第一個字母也放進要枚舉的子集合：會枚舉到不包含第一個字母的遮罩。
- 枚舉子集合時漏掉空集合：只有第一個字母的單字（例如 `"aaaa"`）就是靠空集合加上 `first`。

## 面試口說整理

合法與否只跟單字用了哪些字母有關，所以我把每個單字轉成 26-bit 遮罩，用 Counter 計數。謎題只有 7 個字母，合法單字的遮罩一定是謎題遮罩的子集合並包含第一個字母，所以我枚舉其他 6 個字母的 64 種子集合，每個加上第一個字母去查 Counter。時間 `O(W + 64P)`。LeetCode 把它標成 Trie，但位元遮罩更直接。
