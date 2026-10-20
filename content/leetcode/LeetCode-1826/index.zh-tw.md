---
title: "LeetCode 1826: Faulty Sensor"
summary: "LeetCode 1826 解題筆記：找到第一個不同的位置後，比對兩種「誰掉了資料」的情況；兩種都成立時無法判斷，回傳 -1"
description: "2026-04-05 的 LeetCode 1826 解題紀錄"
date: 2026-04-05
tags: ["easy", "two-pointers", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2026-04-05
- 提交紀錄：Wrong Answer ×2 → Accepted

## 解題思路

壞掉的感測器會掉一筆資料，後面的資料往左移一格，最後一格補上一個隨機值（保證不等於被掉的值）。最多只有一個感測器壞掉。

找到第一個 `sensor1[i] != sensor2[i]` 的位置 `i`：

- 如果 **sensor2 壞掉**：sensor2 掉了 `sensor1[i]`，所以 `sensor2[i:-1]` 應該等於 `sensor1[i+1:]`。
- 如果 **sensor1 壞掉**：同理，`sensor1[i:-1]` 應該等於 `sensor2[i+1:]`。

只有一種成立才能確定是哪個；**兩種都成立、或都不成立**時無法判斷，回傳 `-1`。完全沒有不同的位置也回傳 `-1`。

## 我的嘗試

1. **第一版**只比對了下一個元素：`sensor1[i + 1] == sensor2[i]` 就判定 sensor2 壞掉。
2. **第二版**改成比對整段剩下的資料，但還是**沒有處理兩種情況都成立的歧義**。

兩版都會在這個例子出錯：`sensor1 = [3, 3, 2, 3]`、`sensor2 = [3, 2, 3, 2]`。sensor2 可能是掉了第二個 3（最後補 2），sensor1 也可能是掉了 sensor2 的第一個 2（最後補 3），兩種都說得通，答案是 `-1`；這兩版都回傳 2。

## 正確解法

```python
class Solution:
    def badSensor(self, sensor1: List[int], sensor2: List[int]) -> int:
        n = len(sensor1)
        for i in range(n - 1):
            if sensor1[i] != sensor2[i]:
                sensor2_bad = sensor1[i + 1:] == sensor2[i:-1]
                sensor1_bad = sensor2[i + 1:] == sensor1[i:-1]
                if sensor1_bad == sensor2_bad:
                    return -1
                return 1 if sensor1_bad else 2
        return -1
```

迴圈只跑到 `n - 2`：如果只有最後一個位置不同，那只是補上的隨機值，無法判斷是哪個感測器壞掉。

## 複雜度

時間 `O(n)`，空間 `O(n)`（切片會複製）。

## 要特別避免的錯誤

- 只比對下一個元素就下結論。
- 沒有處理兩種情況都成立的歧義。

## 面試口說整理

我找到第一個不同的位置 `i`，分別假設 sensor1 或 sensor2 壞掉：如果 sensor2 壞了，它從 `i` 開始的資料應該等於 sensor1 從 `i + 1` 開始的資料，最後一格不算；sensor1 壞了同理。只有一種成立才能判斷，兩種都成立或都不成立就回傳 `-1`。時間 `O(n)`。
