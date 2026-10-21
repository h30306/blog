---
title: "LeetCode 860: Lemonade Change"
summary: "LeetCode 860 解題筆記：只記 5 元和 10 元的張數；找 15 元時優先用 10 + 5，因為 5 元比較萬用"
description: "2022-09-17 的 LeetCode 860 解題紀錄"
date: 2022-09-17
tags: ["easy", "array", "greedy"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-17
- 提交紀錄：Runtime Error → Wrong Answer ×2 → Runtime Error → Wrong Answer → Runtime Error → Wrong Answer ×3 → Runtime Error → Wrong Answer → Runtime Error → Accepted ×5

## 解題思路

要記的是**每種面額的張數**，不是總金額：有 10 元也找不開 5 元。收到 5 元直接收下；收到 10 元要找一張 5 元；收到 20 元要找 15 元，貪心優先用 `10 + 5`，沒有才用 `5 + 5 + 5`（[Greedy]({{< relref "/algorithm/Greedy" >}})）：5 元能找 10 元和 20 元，10 元只能找 20 元，所以要盡量留 5 元。20 元找不出去，不用記。

## 我的嘗試

這題提交了 17 次：

- 一開始只記**總金額**：第一版連收進來的錢都沒加上，`[5, 10]` 回傳 `False`；第二版加上了，但 `[5, 10, 10]` 手上只有一張 10 元，找不開第三個人的 5 元，回傳 `True`。總金額夠不代表找得開。
- 改成用 dict 記面額後，一版把「找零失敗」的 `return False` 放在 `else`，**不需要找零的 5 元也走到了 `else`**：`[5]` 回傳 `False`。
- 有幾版的 key 用的是要找的錢 `b - 5` 而不是收到的面額，收到 10 元時記成 `balance[5]`，等於自己找自己：`[10]` 回傳 `True`。改用面額當 key 後又遇到 key 不存在的 KeyError。
- 最後改成兩個整數 `c5`、`c10` 才 AC。

## 正確解法

```python
class Solution:
    def lemonadeChange(self, bills: List[int]) -> bool:
        five = ten = 0
        for b in bills:
            if b == 5:
                five += 1
            elif b == 10:
                if five == 0:
                    return False
                five, ten = five - 1, ten + 1
            elif ten and five:
                ten, five = ten - 1, five - 1
            elif five >= 3:
                five -= 3
            else:
                return False
        return True
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 記張數，不是總金額。
- 用收到的面額當 key，不是要找的錢。
- 找 15 元先用 10 + 5。

## 面試口說整理

我只記 5 元和 10 元的張數，收到 10 元找一張 5 元，收到 20 元優先找 10 加 5，因為 5 元能用在更多情況，沒有才找三張 5 元，找不開就回傳 False。時間 `O(n)`。
