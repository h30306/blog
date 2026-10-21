---
title: "LeetCode 7: Reverse Integer"
summary: "LeetCode 7 解題筆記：記下正負號，對絕對值反轉位數，結果超出 32 位元有號整數的範圍就回傳 0"
description: "2019-09-16 的 LeetCode 7 解題紀錄"
date: 2019-09-16
tags: ["medium", "math"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2019-09-16
- 提交紀錄：Wrong Answer → Accepted ×8

## 解題思路

記下正負號，對 `abs(x)` 用 `% 10`、`// 10` 逐位反轉（[Math]({{< relref "/algorithm/Math" >}}) 模板五），再把正負號乘回去。最後檢查是否在 `[-2^31, 2^31 - 1]` 之間，超出就回傳 0。Python 的整數不會溢位，所以可以先算完再檢查；在 C++ / Java 要在每次乘 10 之前就檢查。

## 我的嘗試

2019 年第一版處理負數時用 `str(x)[:0:-1]` 去掉了負號，**但反轉完沒有把負號加回去**：`-29` 回傳 `92`。加上負號就 AC 了。

## 正確解法

```python
class Solution:
    def reverse(self, x: int) -> int:
        sign = -1 if x < 0 else 1
        x, rev = abs(x), 0
        while x:
            rev = rev * 10 + x % 10
            x //= 10
        rev *= sign
        return rev if -2**31 <= rev <= 2**31 - 1 else 0
```

## 複雜度

時間 `O(log x)`，空間 `O(1)`。

## 要特別避免的錯誤

- 負數反轉後要把負號加回去。
- 範圍檢查是對反轉後的結果做。

## 面試口說整理

我記下正負號，把絕對值逐位反轉後乘回正負號，超出 32 位元有號整數範圍就回傳 0。Python 不會溢位所以最後檢查就好；其他語言要在每次乘 10 之前檢查。
