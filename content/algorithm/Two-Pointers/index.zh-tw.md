---
title: "Two Pointers 雙指針"
summary: "對撞指針、兩個序列各一個指針、跳過空白比對位置，以及排序後數 pair"
description: "演算法學習"
date: 2026-10-20
tags: ["two-pointers", "string", "sorting"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 介紹

雙指針用兩個 index 一起掃描，每一步根據條件決定移動哪一個，讓原本 `O(n^2)` 的兩兩比較降到 `O(n)`。

關鍵是**每個指針都只往一個方向走**：只要能證明「這個位置之後不會再用到」，就可以放心地移動它。

常見的三種形式：

| 形式 | 指針怎麼走 | 例子 |
|---|---|---|
| 對撞指針 | 一個從頭、一個從尾，往中間靠 | 回文、反轉、排序後找 pair |
| 兩個序列各一個 | 各自在自己的序列上往前 | 合併、比對、子序列判斷 |
| 同向快慢 | 兩個都從頭開始，速度不同 | 滑動窗口、去重 |

滑動窗口另外有一篇，這篇講前兩種。

## 模板一：對撞指針

```python
left, right = 0, len(s) - 1
while left < right:
    if 符合條件(s[left], s[right]):
        處理()
    left += 1
    right -= 1
```

- **檢查回文 / 改成回文**（LC 2697）：兩端不同時，改成比較小的那個字元，字典序最小。
- **反轉，但跳過某些字元**（LC 3823）：兩邊各自先跳到要處理的字元，再交換。
- **兩個字串拼成回文**（LC 1616）：外側貪心配對，配不下去時，剩下的中間段必須整段來自同一個字串，而且本身是回文。

Python 的字串不能修改，要交換字元得先 `list(s)`，最後再 `"".join(...)`（LC 3794）。

## 模板二：兩個序列各一個指針

```python
i = j = 0
while i < len(a) and j < len(b):
    if a[i] == b[j]:
        ...
        i += 1
        j += 1
    elif a[i] < b[j]:
        i += 1
    else:
        j += 1
# 處理剩下的部分
```

- **合併兩個有序序列**（LC 2570）：跟 merge sort 的 merge 一樣。
- **找共同元素**（LC 2540）：比較小的那邊往前。
- **子序列判斷**（LC 522）：相同時兩邊都前進，不同時只有長字串前進。
- **連續段比對**（LC 809）：兩邊各自數出目前這段相同字元有多長，再比較長度。

### 主要參數說明：

- **迴圈結束後要確認兩邊都用完了**：只檢查其中一邊，另一邊剩下的字元會被忽略（LC 809）。
- **其中一邊先用完時，不能再讀它**：讀之前要先檢查 index（LC 2337 的 Runtime Error）。

## 模板三：跳過空白，比對棋子的位置

`L` 只能往左、`R` 只能往右、`_` 或 `X` 是空位（LC 2337、777）：

1. 去掉空位之後，兩個字串的棋子順序必須完全一樣（棋子不能互相跨越）。
2. 每一對對應的棋子：`L` 在起點的位置必須 `>=` 終點的位置；`R` 必須 `<=`。

```python
i = j = 0
while True:
    while i < n and start[i] == "_":
        i += 1
    while j < n and target[j] == "_":
        j += 1
    if i == n or j == n:
        return i == n and j == n
    if start[i] != target[j]:
        return False
    if start[i] == "L" and i < j or start[i] == "R" and i > j:
        return False
    i += 1
    j += 1
```

只比較字元的數量（`Counter`）不夠：順序和移動方向都要檢查（LC 777 的第一次 WA）。

## 模板四：排序後數 pair

陣列排序後，固定一端，另一端用指針或 bisect 找出符合條件的範圍：

```python
nums.sort()
left, right = 0, len(nums) - 1
while left < right:
    if nums[left] + nums[right] > target:
        right -= 1                    # 太大，只能縮小最大的那個
    else:
        count += right - left         # left 跟 (left, right] 都可以配
        left += 1
```

這是 Two Sum 的排序版本，也是很多「數有幾對 pair」題目的骨架。

## 複雜度

雙指針本身是 `O(n)`。需要排序時是 `O(n log n)`。

## 常見錯誤

這些都是我練習時實際寫錯過的：

- **`while` 迴圈裡忘記移動指針**：無限迴圈，TLE（LC 1768）。
- **`right += 1` 寫成往外走**：對撞指針的右指針要減（LC 1750）。
- **重疊的區間重複輸出**：用一個指針記住「已經輸出到哪裡」（LC 2200）。
- **只看下一個元素就下結論**：LC 1826 要比對整段剩下的資料，還要處理兩種情況都成立的歧義。
- **同一個檢查呼叫了兩次**：`check(a, b) or check(a, b)`，第二個應該是 `check(b, a)`（LC 1616）。
- **只比較數量，不看順序**（LC 777）。

## 相關 LeetCode

- `LC 1768` Merge Strings Alternately
- `LC 2570` Merge Two 2D Arrays by Summing Values
- `LC 2540` Minimum Common Value
- `LC 2441` Largest Positive Integer That Exists With Its Negative
- `LC 3794` Reverse String Prefix
- `LC 3823` Reverse Letters Then Special Characters in a String
- `LC 3643` Flip Square Submatrix Vertically
- `LC 3750` Minimum Number of Flips to Reverse Binary String
- `LC 3884` First Matching Character From Both Ends
- `LC 2697` Lexicographically Smallest Palindrome
- `LC 1750` Minimum Length of String After Deleting Similar Ends
- `LC 1616` Split Two Strings to Make Palindrome
- `LC 2200` Find All K-Distant Indices in an Array
- `LC 3775` Reverse Words With Same Vowel Count
- `LC 1826` Faulty Sensor
- `LC 522` Longest Uncommon Subsequence II
- `LC 809` Expressive Words
- `LC 2337` Move Pieces to Obtain a String
- `LC 777` Swap Adjacent in LR String
