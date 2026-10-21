---
title: "LeetCode 922: Sort Array By Parity II"
summary: "LeetCode 922 解題筆記：偶數位置的指標 i、奇數位置的指標 j，各自跳兩格；i 放錯（奇數）時讓 j 找到放錯的偶數再交換"
description: "2022-09-25 的 LeetCode 922 解題紀錄"
date: 2022-09-25
tags: ["easy", "array", "two-pointers", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-09-25
- 提交紀錄：Runtime Error ×10 → Output Limit Exceeded → Accepted ×3 → Runtime Error → Accepted ×2

## 解題思路

`i` 只看偶數位置、`j` 只看奇數位置，都一次跳兩格（[Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) 模板二）。`nums[i]` 是奇數時放錯了，往後找一個 `nums[j]` 是偶數（也放錯了）的奇數位置，兩個交換。奇偶數各一半，所以一定找得到。

## 我的嘗試

這題提交了 17 次，前十次都是 RE：兩個指標的邊界條件沒寫好，超出範圍，例如 `[9, 8]` 時 `j` 走過頭（IndexError）；有一版留著 debug 的 `print`，Output Limit Exceeded。

## 正確解法

```python
class Solution:
    def sortArrayByParityII(self, nums: List[int]) -> List[int]:
        j = 1
        for i in range(0, len(nums), 2):
            if nums[i] % 2:                              # 偶數位置放了奇數
                while nums[j] % 2:
                    j += 2
                nums[i], nums[j] = nums[j], nums[i]
        return nums
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 兩個指標都一次走兩格。
- `j` 不用重設，前面的奇數位置已經都是對的。

## 面試口說整理

我用 `i` 走偶數位置、`j` 走奇數位置，`i` 遇到奇數時讓 `j` 往後找放錯的偶數，兩個交換。每個指標只往前走，時間 `O(n)`。
