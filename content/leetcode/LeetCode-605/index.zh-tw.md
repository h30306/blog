---
title: "LeetCode 605: Can Place Flowers"
summary: "LeetCode 605 解題筆記：從左到右，左右都空的空格就種下去；種下去的花會擋住下一格，要真的更新陣列"
description: "2022-08-28 的 LeetCode 605 解題紀錄"
date: 2022-08-28
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
第一次嘗試：2022-08-28
- 提交紀錄：Runtime Error ×2 → Wrong Answer → Internal Error → Wrong Answer → Accepted → Wrong Answer ×5 → Accepted

## 解題思路

貪心（[Greedy]({{< relref "/algorithm/Greedy" >}})）：從左往右，只要這格是 0、左邊和右邊都不是 1（兩端外面當成空的），就種下去，**並把這格改成 1**，這樣下一格就會被擋住。能種越早越好，因為種在比較左邊只會讓右邊的選擇更多。最後比較種下的數量 `>= n`。

## 我的嘗試

這題 2022 年和 2025 年各寫了一次，總共錯了 10 次：

- 2022：一開始算「不靠近任何花的空格有幾個」，**但新種的花也會擋住旁邊的格子**，這樣算會把相鄰的空格都算進去：`[0, 0]`、`n = 2` 回傳 `True`，答案 `False`。改成在頭尾補 0、種下去就標記才 AC。
- 2025：用 `prev_plant`、`next_plant` 兩個變數追蹤，先是把 `prev_plant` 打成 `pre_plant`，左邊永遠被當成空的；修好之後最後一行寫成 `plots <= n`，**比較方向寫反了**。

## 正確解法

```python
class Solution:
    def canPlaceFlowers(self, flowerbed: List[int], n: int) -> bool:
        bed = [0] + flowerbed + [0]
        count = 0
        for i in range(1, len(bed) - 1):
            if bed[i - 1] == bed[i] == bed[i + 1] == 0:
                bed[i] = 1
                count += 1
        return count >= n
```

## 複雜度

時間 `O(n)`，空間 `O(n)`（加上頭尾的哨兵；直接在原陣列判斷邊界可以 `O(1)`）。

## 要特別避免的錯誤

- 種下去之後要更新陣列，不然相鄰的兩個空格都會被算成可以種。
- 比較方向是 `count >= n`。

## 面試口說整理

我在頭尾各補一個空格當哨兵，從左往右掃，左右都是空的就種下去並標記，種越早越好，最後看種下的數量是否不少於 n。時間 `O(n)`。
