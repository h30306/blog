---
title: "LeetCode 1750: Minimum Length of String After Deleting Similar Ends"
summary: "LeetCode 1750 解題筆記：兩端字元相同時，各自把同一段相同字元全部吃掉；整段都是同一個字元時可以刪光"
description: "2026-01-24 的 LeetCode 1750 解題紀錄"
date: 2026-01-24
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
第一次嘗試：2026-01-24
- 提交紀錄：Wrong Answer ×2 → Accepted

## 解題思路

每次可以刪掉「全部是同一個字元的前綴」和「全部是同一個字元的後綴」，條件是兩者是同一個字元、而且不重疊。

貪心：兩端字元相同時，**把兩端連續的這個字元全部刪掉**一定不吃虧。刪得少只會讓同樣的字元留在兩端，下一輪還是要刪。

用對撞指針：

1. 兩端字元相同時，記下這個字元 `c`。
2. 左指針往右吃掉所有 `c`，右指針往左吃掉所有 `c`。
3. 兩端不同、或指針交錯時停下，剩下的長度是 `right - left + 1`。

## 我的嘗試

### 第一版：回傳了刪掉的數量

```python
while left < right:
    if s[left] == s[right]:
        removed += 2
        left += 1
        right += 1          # 應該是 right -= 1
    else:
        return removed      # 題目要的是剩下的長度
return removed
```

三個問題：回傳的是**刪掉的字元數**而不是剩下的長度，所以 `"a"` 回傳 0（正確是 1）；右指針寫成 `+= 1`，往外走；而且一次只刪一個字元，沒有把連續相同的字元一起刪。

### 第二版：兩端不同時沒有停下

改成吃掉連續相同的字元、最後回傳 `len(s) - removed`，但 `left += 1`、`right -= 1` 寫在 `if` 外面：**兩端字元不同時，指針還是往內移，繼續刪裡面相同的字元**。例如 `"aaab"`，兩端是 `a` 和 `b`，一個都不能刪，答案是 4；這一版卻會跳過兩端、繼續刪中間的 `"aa"`，回傳 2。

題目只能從兩端刪，**兩端一旦不同就要停下**。最後一版把「兩端相同」放進 `while` 的條件，不同就直接結束。

## 正確解法

```python
class Solution:
    def minimumLength(self, s: str) -> int:
        left, right = 0, len(s) - 1
        while left < right and s[left] == s[right]:
            c = s[left]
            while left <= right and s[left] == c:
                left += 1
            while right >= left and s[right] == c:
                right -= 1
        return right - left + 1
```

左指針的條件是 `left <= right`，所以整段都是 `c` 時，左指針會走到 `right + 1`，答案剛好是 0。

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- 右指針寫成 `+= 1`。
- 一次只刪一個字元。
- 兩端不同時還繼續往內刪：只能從兩端刪，兩端不同就要停。
- 回傳刪掉的數量而不是剩下的長度。

## 面試口說整理

我用對撞指針：兩端字元相同時，左指針往右吃掉所有這個字元，右指針往左吃掉所有這個字元，因為刪得越多越好。兩端不同或指針交錯時停下，剩下的長度就是答案；整段都是同一個字元時，左指針會超過右指針，長度就是 0。時間 `O(n)`。
