---
title: "LeetCode 1103: Distribute Candies to People"
summary: "LeetCode 1103 解題筆記：模擬一輪一輪發糖果，第 i 次發 i + 1 顆，不夠時把剩下的全給目前這個人"
description: "2022-10-18 的 LeetCode 1103 解題紀錄"
date: 2022-10-18
tags: ["easy", "math", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-10-18
- 提交紀錄：Wrong Answer ×3 → Accepted ×3

## 解題思路

直接模擬：第 `i` 次（從 0 開始）給第 `i % n` 個人 `min(i + 1, 剩下的)` 顆。總共只會發 `O(√candies)` 次，因為 `1 + 2 + ... + k ≈ k² / 2`。

## 我的嘗試

前三版先把 `gave += 1`、**再扣 `candies -= gave`**，扣的是下一次的數量，每次都多扣一顆：`candies = 3`、一個人時答案 `[3]`，回傳 `[2]`。把兩行對調就 AC 了。

## 正確解法

```python
class Solution:
    def distributeCandies(self, candies: int, num_people: int) -> List[int]:
        res = [0] * num_people
        i = 0
        while candies > 0:
            give = min(i + 1, candies)
            res[i % num_people] += give
            candies -= give
            i += 1
        return res
```

## 複雜度

時間 `O(√candies + n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 先扣掉這次發的數量，再把下次要發的數量加一；順序反了會多扣。

## 面試口說整理

我直接模擬，第 i 次發 i + 1 顆給第 i mod n 個人，剩下的不夠就全部給他。總共只會發根號 candies 次左右。
