---
title: "LeetCode 331: Verify Preorder Serialization of a Binary Tree"
summary: "LeetCode 331 解題筆記：數空位：一開始 1 個，每個節點用掉 1 個，非空節點再多出 2 個；中途不能變負，最後要剛好 0"
description: "2026-10-25 的 LeetCode 331 解題紀錄"
date: 2026-10-25
tags: ["medium", "string", "stack", "tree", "binary-tree"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-10-25
- 提交紀錄：Accepted（一次通過）

## 解題思路

不用真的建樹，只要數「還有幾個位置可以放節點」：

- 一開始有 1 個位置（給根）。
- 每讀到一個節點（包含 `#`），用掉 1 個位置。
- 非空節點會再開出 2 個位置（左右小孩）。

位置數在**中途**變成負的，表示節點比位置多，不合法；全部讀完要**剛好是 0**，不然有位置沒填滿。

例如 `9,#,#,1`：讀完 `9,#,#` 位置剛好用完，再讀 `1` 就變成 -1，回傳 `False`。

## 我的嘗試

一次通過。

## 正確解法

```python
class Solution:
    def isValidSerialization(self, preorder: str) -> bool:
        slots = 1
        for node in preorder.split(","):
            slots -= 1
            if slots < 0:
                return False
            if node != "#":
                slots += 2
        return slots == 0
```

## 複雜度

時間 `O(n)`，空間 `O(n)`（`split` 的結果；逐字元掃描可以做到 `O(1)`）。

## 要特別避免的錯誤

- 要先扣掉位置、檢查是否小於 0，最後才加 2。先加 2 的話，`#,1,#` 會被判成合法，但樹在第一個 `#` 就結束了。
- 最後要檢查剛好等於 0，不能只檢查中途沒變負。
- 值可能是多位數，要用逗號切開，不能一個字元一個字元當節點。

## 面試口說整理

我不建樹，只數空位。一開始有一個位置給根，每個節點用掉一個位置，非空節點再開出兩個。中途空位變負就不合法，最後要剛好用完。時間 `O(n)`。也可以用 stack 把「數字、#、#」不斷收成一個 `#`，最後剩一個 `#` 就合法。
