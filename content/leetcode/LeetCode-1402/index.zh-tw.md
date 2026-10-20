---
title: "LeetCode 1402: Reducing Dishes"
summary: "LeetCode 1402 解題筆記：排序後從滿意度大的開始選；每多選一道放在最前面，前面選的都往後一格，總和增加「目前選的滿意度總和」，總和是正的就繼續選"
description: "2026-07-08 的 LeetCode 1402 解題紀錄"
date: 2026-07-08
tags: ["hard", "dynamic-programming", "greedy", "sorting", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-07-08
- 提交紀錄：Accepted（一次通過）

## 解題思路

選定要做的菜之後，**滿意度大的放後面**，總和最大（排序不等式）。所以排序後，選的一定是**最大的那幾道**。

從滿意度最大的開始，一道一道往前加。每加一道新的菜放在最前面，原本選的菜全部往後一格，各多乘一次：

```text
新的總和 = 舊的總和 + (目前選的所有菜的滿意度總和，包含新的這道)
```

只要「目前選的滿意度總和」還是正的，加上去就會變大；變成 `<= 0` 就停。

## 我的解法

```python
class Solution:
    def maxSatisfaction(self, satisfaction: List[int]) -> int:
        satisfaction.sort(reverse=True)
        total = suffix = 0                         # suffix：目前選的滿意度總和
        for s in satisfaction:
            suffix += s
            if suffix <= 0:
                break
            total += suffix                        # 前面選的都往後一格
        return total
```

我 AC 的版本是反過來做：先把全部都選、算出總和，再從最小的開始一道一道拿掉，每拿掉一道總和減少「剩下的總和」，取過程中的最大值。兩種是同一件事。

## 複雜度

時間 `O(n log n)`，空間 `O(1)`（不算排序）。

## 要特別避免的錯誤

- 只挑正的菜：負的菜放最前面，可以讓後面的菜都多乘一次，有時候反而更好。例如 `[-1, -8, 0, 5, -9]` 的答案 14 就用了 `-1`。

## 面試口說整理

選定的菜一定是滿意度大的放後面，所以選的是最大的幾道。我從最大的開始往前加，每加一道放在最前面，前面選的都往後一格，總和增加目前選的滿意度總和，只要這個總和是正的就繼續加。時間 `O(n log n)`。
