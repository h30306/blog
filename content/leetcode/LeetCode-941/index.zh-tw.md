---
title: "LeetCode 941: Valid Mountain Array"
summary: "LeetCode 941 解題筆記：從左邊爬上坡走到頂，再從頂往下走，必須剛好走到最後，而且頂點不能在兩端"
description: "2022-09-26 的 LeetCode 941 解題紀錄"
date: 2022-09-26
tags: ["easy", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-26
- 提交紀錄：Runtime Error → Wrong Answer ×2 → Accepted ×4

## 解題思路

走過單調段（[Array]({{< relref "/algorithm/Array" >}}) 模板一）：`i` 從 0 開始，嚴格上升就往前走；停下來的地方是山頂，**山頂不能是第一個或最後一個**（不然沒有上坡或下坡）。接著嚴格下降就往前走，最後必須剛好走到最後一個元素。相等的相鄰元素會讓兩段都停下來，自然就失敗。

## 我的嘗試

- 第一版 `range(len(arr))` 比較 `arr[i + 1]`，最後一個超出範圍。
- 第二版只檢查「下降之後不能再上升」，**沒有要求上坡和下坡都存在**：`[3]` 回傳 `True`。
- 第三版改成回傳 `increase`，只上升沒有下降的 `[0, 2]` 還是回傳 `True`。再補上「下降前必須先上升」、最後回傳 `increase and decrease` 才 AC。

## 正確解法

```python
class Solution:
    def validMountainArray(self, arr: List[int]) -> bool:
        n, i = len(arr), 0
        while i + 1 < n and arr[i] < arr[i + 1]:
            i += 1
        if i == 0 or i == n - 1:
            return False
        while i + 1 < n and arr[i] > arr[i + 1]:
            i += 1
        return i == n - 1
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 上坡和下坡都要存在：只上升或只下降都不是山。
- 長度小於 3 一定不是。

## 面試口說整理

我從左邊一直走上坡，停下來的地方是山頂，山頂不能在兩端；接著一直走下坡，最後要剛好走到最後一個元素。時間 `O(n)`、空間 `O(1)`。
