---
title: "LeetCode 3795: Minimum Subarray Length With Distinct Sum At Least K"
summary: "LeetCode 3795 解題筆記：求最短的可變視窗；同一個值只算一次，記錄每個值最後出現的位置，左邊界移出的是最後一次出現才扣掉"
description: "2026-01-03 的 LeetCode 3795 解題紀錄"
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
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

所有值都是正的，視窗變大時「不同值的和」只會變大或不變，所以可以用「求最短」的可變視窗：合法時更新答案，再試著縮左邊。

難點是**同一個值在視窗裡出現多次只算一次**：

- 用 `last[x]` 記錄值 `x` 在視窗裡**最後一次出現的位置**。加入 `x` 時，`x` 不在 `last` 裡才把它加進總和。
- 左邊界移出 `nums[left]` 時，只有 `last[nums[left]] == left`（它是視窗裡最後一個 `nums[left]`）才扣掉並刪除；否則右邊還有同樣的值，總和不變。

## 我的嘗試

第一版直接用一般的總和，沒處理重複。例如 `nums = [4, 4]`、`k = 7`：不同值的和最多只有 4，答案是 -1；這版把兩個 4 加起來是 8，回傳 2。

## 正確解法

```python
class Solution:
    def minLength(self, nums: List[int], k: int) -> int:
        last = {}                                  # 值 -> 視窗內最後出現的位置
        total = left = 0
        best = float("inf")
        for right, x in enumerate(nums):
            if x not in last:
                total += x
            last[x] = right
            while total >= k:
                best = min(best, right - left + 1)
                if last[nums[left]] == left:       # 視窗裡沒有其他的 nums[left]
                    total -= nums[left]
                    del last[nums[left]]
                left += 1
        return best if best < float("inf") else -1
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 用一般的總和：重複的值會被算很多次。
- 移出左邊的值時，右邊可能還有同一個值，不能直接扣掉。

## 面試口說整理

值都是正的，視窗越大不同值的和越大，所以用「求最短」的滑動視窗。重複的值只算一次：我記錄每個值在視窗裡最後出現的位置，加入時第一次出現才加進總和；左邊移出時，只有它是視窗裡最後一個同樣的值才扣掉。時間 `O(n)`。
