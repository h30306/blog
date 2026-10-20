---
title: "LeetCode 1989: Maximum Number of People That Can Be Caught in Tag"
summary: "LeetCode 1989 解題筆記：鬼從左到右，每個鬼抓範圍內最左邊、還沒被抓的人；用一個只往右走的指針指向下一個候選人"
description: "2026-01-27 的 LeetCode 1989 解題紀錄"
date: 2026-01-27
tags: ["medium", "two-pointers", "greedy", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-27
- 提交紀錄：Wrong Answer → Accepted（2026-01-28）

## 解題思路

貪心：鬼從左到右處理，**每個鬼抓自己範圍 `[i - dist, i + dist]` 裡最左邊、還沒被抓的人**。左邊的人只有現在的鬼和更左邊的鬼抓得到，留給右邊的鬼沒有用；右邊的人留給後面的鬼，選擇更多。

用指針 `j` 指向「下一個可能被抓的人」：

- 跳過所有鬼，以及 `j < i - dist` 的人（太左邊，之後的鬼更抓不到）。
- 如果 `j <= i + dist`，抓到，`j` 前進。

## 我的嘗試

第一版用「人」當主角：`left` 找下一個人、`right` 找第一個能抓到他的鬼。問題是：如果這個人左右兩邊都沒有鬼抓得到，`right` 會一路往右跳過所有鬼，直到 `n` 才停，**應該被跳過的是這個人，不是鬼**。

例如 `team = [0, 0, 1]`、`dist = 1`：位置 0 的人抓不到，但位置 2 的鬼可以抓位置 1 的人，答案是 1。這版找位置 0 的人時，`right` 越過位置 2 的鬼，回傳 0。

改成以鬼為主角、讓「人」的指針跳過太左邊的人，就 AC 了。

## 正確解法

```python
class Solution:
    def catchMaximumAmountofPeople(self, team: List[int], dist: int) -> int:
        n = len(team)
        caught = 0
        j = 0                                      # 下一個候選的人
        for i in range(n):
            if team[i] != 1:
                continue
            while j < n and (team[j] == 1 or j < i - dist):
                j += 1                             # 跳過鬼和太左邊的人
            if j < n and j <= i + dist:
                caught += 1
                j += 1
        return caught
```

## 複雜度

時間 `O(n)`：`i` 和 `j` 都只往右。空間 `O(1)`。

## 要特別避免的錯誤

- 抓不到的人要跳過，不能為了他把鬼都跳過。
- 每個鬼要抓最左邊的人，不是最近的人。

## 面試口說整理

我從左到右處理每個鬼，讓它抓範圍內最左邊、還沒被抓的人，因為左邊的人之後的鬼只會更抓不到。用一個只往右走的指針指向下一個候選人，跳過鬼和太左邊的人，如果它在鬼的範圍內就抓。兩個指針都只往右，時間 `O(n)`。
