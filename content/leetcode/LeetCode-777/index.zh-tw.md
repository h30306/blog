---
title: "LeetCode 777: Swap Adjacent in LR String"
summary: "LeetCode 777 解題筆記：XL→LX 是 L 往左、RX→XR 是 R 往右；跳過 X 後順序要一樣，L 只能往左、R 只能往右"
description: "2026-02-01 的 LeetCode 777 解題紀錄"
date: 2026-02-01
tags: ["medium", "two-pointers", "string"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-02-01
- 提交紀錄：Wrong Answer ×2 → Accepted

## 解題思路

把操作翻譯一下：

- `"XL" → "LX"`：`L` 往左移一格。
- `"RX" → "XR"`：`R` 往右移一格。

`X` 就是空格，`L` 和 `R` 不能互相穿越，所以這題跟 [LeetCode 2337]({{< relref "/leetcode/LeetCode-2337" >}}) 完全一樣：

1. 拿掉 `X` 後，`start` 和 `result` 的序列要一樣。
2. 每顆 `L` 在 `start` 的位置 `>=` 在 `result` 的位置；每顆 `R` 要 `<=`。

## 我的嘗試

1. **第一版**只比較 `Counter(start) == Counter(result)`。例如 `start = "LR"`、`result = "RL"`：字元數量一樣，但 `L`、`R` 不能互相穿越，答案是 `False`，這版回傳 `True`。
2. **第二版**改成雙指針跳過 `X`、比對順序，但沒檢查方向。例如 `start = "LX"`、`result = "XL"`：順序一樣，但 `L` 要往右移才能到位，答案是 `False`，這版回傳 `True`。

補上方向檢查就 AC 了。

## 正確解法

```python
class Solution:
    def canTransform(self, start: str, result: str) -> bool:
        n = len(start)
        i = j = 0
        while True:
            while i < n and start[i] == "X":
                i += 1
            while j < n and result[j] == "X":
                j += 1
            if i == n or j == n:
                return i == n and j == n
            if start[i] != result[j]:
                return False
            if start[i] == "L" and i < j:
                return False                      # L 只能往左
            if start[i] == "R" and i > j:
                return False                      # R 只能往右
            i += 1
            j += 1
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 只比較字元數量。
- 只比對順序，忘了 `L` 只能往左、`R` 只能往右。

## 面試口說整理

`XL` 換成 `LX` 是 `L` 往左走，`RX` 換成 `XR` 是 `R` 往右走，`X` 就是空格，棋子不能互相穿越。所以我用兩個指針跳過 `X`，配對第 k 顆棋子：種類一樣，`L` 在 `start` 不能比 `result` 左邊，`R` 不能比 `result` 右邊，最後兩邊同時走完。時間 `O(n)`。
