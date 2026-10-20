---
title: "LeetCode 2838: Maximum Coins Heroes Can Collect"
summary: "LeetCode 2838 解題筆記：怪物依強度排序建金幣前綴和，每個英雄用 bisect_right 找能打贏的範圍"
description: "2026-02-10 的 LeetCode 2838 解題紀錄"
date: 2026-02-10
tags: ["medium", "binary-search", "prefix-sum", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-02-10
- 提交紀錄：Accepted（一次通過）

## 解題思路

英雄能打贏所有強度 `<=` 自己的怪物，而且每隻怪物的金幣都拿得到。所以每個英雄的答案是「強度 `<=` 英雄的怪物的金幣總和」。

1. 把 `(怪物強度, 金幣)` 依強度排序。
2. 建金幣的前綴和。
3. 每個英雄用 `bisect_right` 找到第一隻打不贏的怪物位置 `idx`，答案是 `prefix[idx]`。

## 我的解法

```python
import bisect

class Solution:
    def maximumCoins(self, heroes: List[int], monsters: List[int], coins: List[int]) -> List[int]:
        pairs = sorted(zip(monsters, coins))
        powers = [p for p, _ in pairs]
        prefix = [0]
        for _, c in pairs:
            prefix.append(prefix[-1] + c)
        return [prefix[bisect.bisect_right(powers, h)] for h in heroes]
```

用 `bisect_right` 是因為強度**等於**英雄的怪物也打得贏。

## 複雜度

時間 `O((n + m) log m)`，空間 `O(m)`。

## 要特別避免的錯誤

- 用 `bisect_left`：強度剛好相等的怪物會被漏掉。
- 對每個英雄重新加總：`O(n * m)`。
- 怪物和金幣分開排序：兩個陣列的對應關係會亂掉，要 `zip` 在一起排。

## 面試口說整理

每個英雄的答案是強度不超過他的怪物的金幣總和。我把怪物和金幣綁在一起依強度排序，建金幣前綴和，然後每個英雄用 `bisect_right` 找到第一隻打不贏的怪物，前綴和就是答案。時間 `O((n + m) log m)`。
