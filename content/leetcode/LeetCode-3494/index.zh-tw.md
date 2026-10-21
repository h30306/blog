---
title: "LeetCode 3494: Find the Minimum Amount of Time to Brew Potions"
summary: "LeetCode 3494 解題筆記：每瓶藥先往前推出最後一位巫師的完成時間（每個人都要等自己有空），再往回扣出每位巫師的完成時間"
description: "2025-03-23 的 LeetCode 3494 解題紀錄"
date: 2025-03-23
tags: ["medium", "simulation", "prefix-sum", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-03-23
- 提交紀錄：Accepted（一次通過，但跑了 11.7 秒）

## 解題思路

`done[i]` 是巫師 `i` 做完上一瓶的時間。一瓶藥傳到巫師 `i` 時，他必須已經有空，而且中間**不能等**。

1. **往前推**：假設藥瓶一路往下傳，到巫師 `i` 時取 `max(到達時間, done[i])` 再加上這瓶的工時。最後得到的是最後一位巫師的完成時間 `t`。
   - 不能等待的限制，等於把整瓶藥的開始時間往後延，讓最卡的那位巫師剛好有空；往後延不會改變最後完成的時間，所以 `t` 是對的。
2. **往回扣**：知道最後完成時間後，每位巫師的完成時間就是 `t` 往回減掉後面巫師的工時，更新 `done`。

所有藥都做完後，`done[n - 1]` 就是答案。

## 我的解法

```python
class Solution:
    def minTime(self, skill: List[int], mana: List[int]) -> int:
        n = len(skill)
        done = [0] * n                         # done[i]：巫師 i 做完上一瓶的時間
        for m in mana:
            t = 0
            for i in range(n):                 # 往前推：每個人都要等自己有空
                t = max(t, done[i]) + skill[i] * m
            for i in range(n - 1, -1, -1):     # 往回扣：中間不能等待
                done[i] = t
                t -= skill[i] * m
        return done[-1]
```

## 複雜度

時間 `O(n · m)`，空間 `O(n)`。Python 跑 `5000 × 5000` 很慢（我當時 11.7 秒才過）；更快的寫法是用 `skill` 的前綴和，把每瓶藥的開始時間寫成一個 `max`，但複雜度一樣。

## 要特別避免的錯誤

- 不能只往前推：往前推時有人在等，實際上要把開始時間往後延，所以要往回扣出每個人的真正完成時間。

## 面試口說整理

我記錄每位巫師做完上一瓶的時間。新的一瓶先往前推，每個人都等到自己有空再開始，得到最後一位的完成時間；因為中間不能等待，再從最後一位往回扣出每個人的完成時間。所有藥做完後最後一位的時間就是答案。時間 `O(nm)`。
