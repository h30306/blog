---
title: "LeetCode 825: Friends Of Appropriate Ages"
summary: "LeetCode 825 解題筆記：排序後，每個人能送出邀請的對象是年齡落在 (0.5 × age + 7, age] 的一段區間，用兩個同向指針維護區間再扣掉自己"
description: "2026-01-21 的 LeetCode 825 解題紀錄"
date: 2026-01-21
tags: ["medium", "two-pointers", "sorting", "binary-search", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-21
- 提交紀錄：Wrong Answer ×2 → Runtime Error → Wrong Answer ×2 → Accepted

## 解題思路

`x` 會送邀請給 `y` 的條件，整理後是：

- `age[y] > 0.5 * age[x] + 7`
- `age[y] <= age[x]`
- 第三個條件（`age[y] > 100 and age[x] < 100`）在 `age[y] <= age[x]` 時不可能成立，可以忽略。

所以對年齡 `a` 的人，能邀請的對象是年齡落在 **`(0.5a + 7, a]`** 的人，再扣掉自己。

排序後，這是一段連續區間 `[left, right)`。依年齡由小到大處理每個人時，區間的兩端都只會往右，用兩個同向指針維護：

- `left`：跳過所有 `<= 0.5a + 7` 的人。
- `right`：吃進所有 `<= a` 的人（同齡的人也要算進來）。

區間不是空的時候，自己一定在裡面（`a > 0.5a + 7` 才可能有人），所以加上 `right - left - 1`。

## 我的嘗試

| 版本 | 問題 |
|---|---|
| 第一、二版 WA | 用「`right` 往右走、只數 `right` 左邊的人」的方式，同齡的人只有一個方向被算到，再用「每種重複年齡加 1」補，數量不對。例如 `[16, 16, 16]`：三個人互相邀請，答案是 6，這兩版都回傳 4 |
| 第三版 RE | 改成兩個指針，但門檻寫成 `0.5 * ages[right] + 7`，`right` 走到 `n` 時越界。例如 `[20, 20]` 直接 IndexError |
| 第四、五版 WA | 門檻改用 `ages[i]`，但 `left` 的迴圈條件是 `left < right`，太年輕的人沒被跳完。例如 `[5, 5]`：5 歲的門檻是 9.5，沒有人能被邀請，答案是 0，這版回傳 1 |

把 `left` 的條件改成 `left < n` 就 AC 了。

## 正確解法

```python
class Solution:
    def numFriendRequests(self, ages: List[int]) -> int:
        ages.sort()
        n = len(ages)
        ans = left = right = 0
        for age in ages:
            while left < n and ages[left] <= 0.5 * age + 7:
                left += 1                          # 太年輕的人
            while right < n and ages[right] <= age:
                right += 1                         # 不比自己大的人
            if right > left:
                ans += right - left - 1            # 扣掉自己
        return ans
```

另一種做法是年齡只有 1 到 120，可以用計數陣列 `O(120^2)` 枚舉年齡對。

## 複雜度

時間 `O(n log n)`，空間 `O(1)`（不算排序）。

## 要特別避免的錯誤

- 同齡的人互相邀請，要兩個方向都算。
- 指針的邊界條件用 `left < right`：太年輕的人可能沒被跳完。
- 區間不是空的才扣掉自己。

## 面試口說整理

整理條件後，年齡 `a` 的人能邀請年齡在 `(0.5a + 7, a]` 的人，第三個條件被第二個條件涵蓋。我把年齡排序，依序處理每個人，這段區間的兩端都只會往右，所以用兩個同向指針維護，區間大小扣掉自己就是這個人送出的邀請數。時間 `O(n log n)`。
