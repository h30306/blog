---
title: "LeetCode 2653: Sliding Subarray Beauty"
summary: "LeetCode 2653 解題筆記：值域只有 -50 到 50，固定視窗用計數陣列維護，每個視窗從 -50 往上累加找第 x 小的負數"
description: "2026-01-03 的 LeetCode 2653 解題紀錄"
date: 2026-01-03
tags: ["medium", "sliding-window", "hash-table", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-03
- 提交紀錄：Accepted（一次通過）

## 解題思路

每個長度 `k` 的視窗要找第 `x` 小的數，如果它是負數就回傳它，否則回傳 0。

一般的「視窗第 `x` 小」需要有序結構，但這題**值域只有 `-50..50`**，用長度 101 的計數陣列就夠了：

- 視窗移動時，進來的 +1、出去的 -1。
- 每個視窗從 `-50` 往上累加負數的個數，累計到 `x` 時的值就是答案；負數不到 `x` 個就是 0。

每個視窗最多看 50 個格子，總共 `O(50n)`。

## 我的解法

```python
class Solution:
    def getSubarrayBeauty(self, nums: List[int], k: int, x: int) -> List[int]:
        cnt = [0] * 101                            # 值 v 存在 cnt[v + 50]
        res = []
        for right, v in enumerate(nums):
            cnt[v + 50] += 1
            if right >= k:
                cnt[nums[right - k] + 50] -= 1
            if right >= k - 1:
                seen = 0
                for idx in range(50):              # 只看負數 -50..-1
                    seen += cnt[idx]
                    if seen >= x:
                        res.append(idx - 50)
                        break
                else:
                    res.append(0)
        return res
```

我原本的寫法用長度 50 的陣列，直接拿負數 `v` 當 index（`neg_array[v]`），利用 Python 的負 index 從尾巴數回來，`-50` 會對到 index 0，所以掃到 index `i` 時的值是 `i - 50`。能跑但不好讀，這裡改成明確的位移 `+ 50`。

## 複雜度

時間 `O(n · 50)`，空間 `O(1)`（101 格）。

## 要特別避免的錯誤

- 每個視窗都排序：`O(n · k log k)`。
- 負數不到 `x` 個時要回傳 0。

## 面試口說整理

值域只有 -50 到 50，所以我用計數陣列維護固定長度的視窗，進來加一、出去減一。每個視窗從 -50 往上累加負數的數量，加到 `x` 時就是第 `x` 小的負數，不夠就回傳 0。每個視窗最多看 50 格，總共 `O(50n)`。
