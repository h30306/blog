---
title: "LeetCode 1013: Partition Array Into Three Parts With Equal Sum"
summary: "LeetCode 1013 解題筆記：總和要能被 3 整除，從左邊累加，每湊到 total / 3 就切一刀，切出至少 3 段就成立"
description: "2022-09-27 的 LeetCode 1013 解題紀錄"
date: 2022-09-27
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
第一次嘗試：2022-09-27
- 提交紀錄：Wrong Answer → Runtime Error → Wrong Answer ×5 → Runtime Error → Wrong Answer → Runtime Error → Wrong Answer ×3 → Accepted → Wrong Answer → Accepted ×3

## 解題思路

每段的和必須是 `target = total / 3`，所以總和不能被 3 整除就不可能。從左往右累加，**一湊到 `target` 就切**（[Greedy]({{< relref "/algorithm/Greedy" >}})：越早切越好，剩下的部分只會有更多選擇）。只要能切出**至少** 3 段就成立：前兩段各是 `target`，剩下的全部合起來也一定是 `target`。`target = 0` 時可能切出超過 3 段，例如 `[0, 0, 0, 0]`，所以判斷是 `>= 3`，不是 `== 3`。

## 我的嘗試

這題提交了 18 次，卡在「到底要切出幾段」：

- 第一版就是正確的貪心，但判斷寫成 `c == 3`，**沒想到和為 0 的段可以切出更多段**：`[0, 0, 2, -2, 0]` 切成 `0 | 0 | 2, -2 | 0` 共 4 段，回傳 `False`，答案 `True`。
- 接下來十幾版一直改結尾的條件：限制 `c < 3` 才切、要求最後 `temp == target` 等等，每次都換一組輸入失敗，例如 `[1, 1, 1]`、`[2, 2, 2, 0]`。有一版把 `return` 放進迴圈裡，第一個元素就回傳了。
- 先 AC 的是「切到第 3 段時檢查剩下的和是 0」的版本，最後改回第一版、把 `== 3` 換成 `>= 3`，也 AC 了。

## 正確解法

```python
class Solution:
    def canThreePartsEqualSum(self, arr: List[int]) -> bool:
        total = sum(arr)
        if total % 3:
            return False
        target, cur, parts = total // 3, 0, 0
        for x in arr:
            cur += x
            if cur == target:
                parts += 1
                cur = 0
        return parts >= 3
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 判斷是 `>= 3`：和為 0 的段可以切得更多。
- 不要在迴圈裡直接 `return`，第一次迭代就結束了。

## 面試口說整理

總和要能被 3 整除，每段是三分之一。我從左往右累加，一湊到三分之一就切一刀，最後切出至少三段就成立；三分之一是 0 時可能切出更多段，所以用大於等於。時間 `O(n)`。
