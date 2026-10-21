---
title: "LeetCode 925: Long Pressed Name"
summary: "LeetCode 925 解題筆記：兩個指標分別走 name 和 typed，typed 的字元要嘛對到 name 的下一個字，要嘛是前一個字的長按"
description: "2022-09-25 的 LeetCode 925 解題紀錄"
date: 2022-09-25
tags: ["easy", "two-pointers", "string"]
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
- 提交紀錄：Runtime Error ×2 → Internal Error → Wrong Answer ×5 → Accepted

## 解題思路

兩個字串各一個指標（[Two Pointers]({{< relref "/algorithm/Two-Pointers" >}}) 模板二），以 `typed` 為主迴圈：

- `typed[j]` 等於 `name[i]`：配對成功，`i` 往前。
- 否則它必須是長按，也就是 `typed[j] == typed[j - 1]`；不是的話就失敗。

最後還要檢查 `i` 有沒有走完 `name`，避免 `typed` 只打了 `name` 的前半段。

## 我的嘗試

這題提交了 9 次。中間幾版的迴圈條件是兩個指標**都**沒走完才繼續，不相同時先 `i += 1` 再比 `name[i]`：

- `i` 加一之後沒檢查是否超出範圍，例如 `name = "b"`、`typed = "a"` 直接 IndexError。
- 迴圈在 `name` 走完時就停了，**`typed` 剩下的字元完全沒檢查**。

最後改成以 `typed` 為主迴圈、每個字元都要嘛配對、要嘛是長按，才 AC。

## 正確解法

```python
class Solution:
    def isLongPressedName(self, name: str, typed: str) -> bool:
        i = 0
        for j in range(len(typed)):
            if i < len(name) and name[i] == typed[j]:
                i += 1
            elif j == 0 or typed[j] != typed[j - 1]:
                return False
        return i == len(name)
```

## 複雜度

時間 `O(n + m)`，空間 `O(1)`。

## 要特別避免的錯誤

- 以 `typed` 為主迴圈，`typed` 裡多出來的字元都要檢查。
- 最後要確認 `name` 全部對到了。

## 面試口說整理

我用兩個指標，以 typed 為主：字元等於 name 目前的字就一起往前，不然它必須跟 typed 前一個字一樣（長按），否則失敗；最後確認 name 全部配對完。時間 `O(n + m)`、空間 `O(1)`。
