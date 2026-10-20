---
title: "LeetCode 3959: Check Good Integer"
summary: "LeetCode 3959 解題筆記：累積位數平方和減位數和；每個位數貢獻 d² − d ≥ 0，差距只增不減，所以達到 50 就能提早回傳"
description: "2026-06-14 的 LeetCode 3959 解題紀錄"
date: 2026-06-14
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
第一次嘗試：2026-06-14
- 提交紀錄：Accepted（一次通過）

## 解題思路

`squareSum - digitSum` 可以拆成每個位數各自貢獻 `d² - d`。因為 `d` 是 0~9 的整數，`d² - d = d(d - 1) >= 0`，**差距只會越來越大**，所以累積到 `>= 50` 就可以直接回傳 `True`。

## 我的解法

```python
class Solution:
    def checkGoodInteger(self, n: int) -> bool:
        gap = 0
        while n:
            d = n % 10
            gap += d * d - d                 # 每個位數的貢獻 >= 0
            if gap >= 50:
                return True
            n //= 10
        return False
```

我當時分開記 `sum_` 和 `sSum`，再比較差；合成一個 `gap` 是一樣的。

## 複雜度

時間 `O(d)`，空間 `O(1)`。

## 要特別避免的錯誤

- 提早回傳要先確認累積值是單調的；如果某個位數的貢獻可能是負的，就不能中途下結論。

## 面試口說整理

差距等於每個位數 `d² - d` 的總和，而這個值永遠不是負的，所以我邊走邊累積，到 50 就回傳 `True`，走完還沒到就是 `False`。時間 `O(d)`。
