---
title: "LeetCode 202: Happy Number"
summary: "LeetCode 202 解題筆記：一直取位數平方和，會走到 1 或進入環；用集合記看過的數，或用快慢指針判圈"
description: "2022-08-21 的 LeetCode 202 解題紀錄"
date: 2022-08-21
tags: ["easy", "hash-table", "math", "two-pointers", "floyds-cycle-finding-algorithm"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-21
- 提交紀錄：Runtime Error → Wrong Answer → Runtime Error → Wrong Answer → Accepted → Wrong Answer → Accepted

## 解題思路

不斷做「位數平方和」，數字很快就會變小，最後不是到 1，就是進入一個不含 1 的環。用集合記看過的數，看到重複就代表進環了（也可以用 [Linked List]({{< relref "/algorithm/Linked-List" >}}) 模板三的快慢指針判圈，`O(1)` 空間）。

## 我的嘗試

兩次 WA 都是同一個錯：迴圈裡一直用**原本的 `n`** 算平方和，沒有更新 `n`，第二輪就重複了，例如 `94` 會走到 1，這版回傳 `False`。

## 正確解法

```python
class Solution:
    def isHappy(self, n: int) -> bool:
        seen = set()
        while n != 1 and n not in seen:
            seen.add(n)
            n = sum(int(c) ** 2 for c in str(n))
        return n == 1
```

## 複雜度

每一步 `O(log n)`，步數很少；空間 `O(步數)`。

## 要特別避免的錯誤

- 每一輪要用**新的**數字算下一輪，`n` 要更新。

## 面試口說整理

我不斷把數字換成位數平方和，用集合記看過的數，走到 1 就是快樂數，看到重複代表進入不含 1 的環。時間很短，可以視為 `O(log n)`。
