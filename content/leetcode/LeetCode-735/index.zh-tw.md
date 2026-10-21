---
title: "LeetCode 735: Asteroid Collision"
summary: "LeetCode 735 解題筆記：從左到右用 stack，只有「stack 頂端往右、目前的往左」才會相撞，小的爆掉，一樣大一起爆"
description: "2024-04-18 的 LeetCode 735 解題紀錄"
date: 2024-04-18
tags: ["medium", "array", "stack", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2024-04-18
- 提交紀錄：Wrong Answer → Runtime Error → Wrong Answer → Output Limit Exceeded → Accepted

## 解題思路

從左到右（[Stack]({{< relref "/algorithm/Stack" >}}) 模板二），只有 stack 頂端往右（`> 0`）、目前的往左（`< 0`）時會相撞：

- 頂端比較小：頂端爆掉，繼續跟新的頂端比。
- 一樣大：兩個都爆。
- 頂端比較大：目前的爆掉。

目前的沒爆就 `push`。往左的遇到空 stack 或往左的頂端，都不會相撞。

## 我的嘗試

2024 年寫的時候是從**右往左**掃，用另一個 stack 存往左的：

- 第一版最後**沒有把剩下的往左的小行星加回答案**：`[-4, 2]` 回傳 `[2]`。
- 補上之後，比較的對象用了 `rev_stack[0]`（最遠的那顆），**應該跟最近的 `rev_stack[-1]` 比**：`[2, -4, -1]` 回傳 `[-4]`，答案 `[-4, -1]`。改成 `[-1]` 才 AC，中間還有一次 `print` 造成 Output Limit Exceeded。

## 正確解法

```python
class Solution:
    def asteroidCollision(self, asteroids: List[int]) -> List[int]:
        st = []
        for a in asteroids:
            alive = True
            while alive and a < 0 and st and st[-1] > 0:
                if st[-1] < -a:
                    st.pop()
                elif st[-1] == -a:
                    st.pop()
                    alive = False
                else:
                    alive = False
            if alive:
                st.append(a)
        return st
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 只有右邊往左、左邊往右才會相撞；`[-4, 2]` 不會相撞。
- 要跟**最近的**那一顆比，是 stack 的頂端 `st[-1]`，不是 `st[0]`。

## 面試口說整理

我從左到右用 stack，只有頂端往右、目前的往左時才會相撞，頂端比較小就爆掉繼續比，一樣大一起爆，比較大就把目前的擋掉；沒爆的放進 stack。每顆最多進出一次，時間 `O(n)`。
