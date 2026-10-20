---
title: "LeetCode 3952: Maximum Total Value of Covered Indices"
summary: "LeetCode 3952 解題筆記：每個代幣只能往左移一格，狀態是「這格的代幣有沒有往左移」；往左移只有在左邊那格原本沒被蓋住時才有用"
description: "2026-06-11 的 LeetCode 3952 解題紀錄"
date: 2026-06-11
tags: ["medium", "dynamic-programming", "state-machine", "greedy", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-06-11
- 提交紀錄：Accepted（一次通過）

## 解題思路

每個代幣最多往左移一格，所以第 `i` 格的代幣只會影響第 `i - 1` 和第 `i` 格。從左到右做狀態機 DP，狀態是**第 `i` 格的代幣有沒有往左移**：

- `stay`：處理完前 `i` 格，第 `i` 格的代幣留在原地（或第 `i` 格沒有代幣）的最大值。
- `move`：處理完前 `i` 格，第 `i` 格的代幣移到了 `i - 1` 的最大值。

轉移到第 `i` 格：

- **沒有代幣**：兩個狀態一樣，都是 `max(move, stay)`。
- **有代幣、留在原地**：`max(move, stay) + nums[i]`。
- **有代幣、往左移**：第 `i - 1` 格會被蓋住，但它可能本來就被蓋住了：
  - 如果 `i - 1` 也有代幣，只有當那個代幣往左移走了（`move` 狀態），蓋住它才有用：`move + nums[i - 1]`。
  - 如果 `i - 1` 沒有代幣，它原本一定沒被蓋：`max(move, stay) + nums[i - 1]`。

所有數都是正的，所以不用考慮「拿了反而更差」的情況。

## 我的解法

```python
class Solution:
    def maxTotal(self, nums: List[int], s: str) -> int:
        move = float("-inf")                       # 第 0 格的代幣不能往左
        stay = nums[0] if s[0] == "1" else 0
        for i in range(1, len(nums)):
            best = max(move, stay)
            if s[i] == "1":
                new_stay = best + nums[i]
                if s[i - 1] == "1":
                    new_move = move + nums[i - 1]  # 左邊的代幣移走了，這格才空出來
                else:
                    new_move = best + nums[i - 1]
            else:
                new_stay = new_move = best
            move, stay = new_move, new_stay
        return max(move, stay)
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 往左移時，左邊那格如果已經被蓋住，不能重複加分。
- 第 0 格的代幣不能往左移，`move` 初始化成負無限大。

## 面試口說整理

每個代幣只能往左移一格，所以從左到右做狀態機 DP，狀態是這格的代幣有沒有往左移。留在原地就加這格的值；往左移就加左邊那格的值，但如果左邊那格也有代幣，只有它自己往左移走了，這格才是空的，所以只能從 `move` 狀態轉移。時間 `O(n)`。
