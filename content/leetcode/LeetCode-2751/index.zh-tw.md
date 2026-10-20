---
title: "LeetCode 2751: Robot Collisions"
summary: "LeetCode 2751 解題筆記：依位置排序，往右的機器人放進 stack，往左的遇到就一路碰撞到其中一方消失"
description: "2026-10-13 的 LeetCode 2751 解題紀錄"
date: 2026-10-13
tags: ["hard", "stack", "simulation", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-10-13
- 提交紀錄：Accepted（一次通過）

## 解題思路

只有「左邊往右走、右邊往左走」的兩台機器人會相撞。所以**依位置排序**之後從左到右掃：

- 往右的機器人：先放進 stack，等著被右邊往左的撞。
- 往左的機器人：跟 stack 頂端往右的機器人碰撞：
    - 頂端血量比較少：頂端消失，自己血量減 1，繼續跟新的頂端碰撞。
    - 一樣多：兩台都消失。
    - 頂端比較多：自己消失，頂端血量減 1。
- 如果 stack 頂端是往左的（或 stack 是空的），這台往左的機器人就不會再撞到任何人。

最後留在 stack 裡的就是存活的機器人，再依原本的順序輸出血量。

這跟 LC 735 Asteroid Collision 是同一個模型，差別在這題碰撞後贏家會扣 1 點血。

## 我的解法

```python
class Solution:
    def survivedRobotsHealths(self, positions: List[int], healths: List[int], directions: str) -> List[int]:
        order = sorted(range(len(positions)), key=lambda i: positions[i])
        health = healths[:]
        stack = []                                     # 存 index
        for i in order:
            if directions[i] == "R":
                stack.append(i)
                continue
            while stack and directions[stack[-1]] == "R" and health[i] > 0:
                j = stack[-1]
                if health[j] < health[i]:
                    stack.pop()
                    health[j] = 0
                    health[i] -= 1
                elif health[j] == health[i]:
                    stack.pop()
                    health[j] = health[i] = 0
                else:
                    health[j] -= 1
                    health[i] = 0
            if health[i] > 0:
                stack.append(i)
        return [h for h in health if h > 0]
```

原本的版本把 `(位置, 血量, 方向, 原 index)` 整組放進 stack，最後再依原 index 排序輸出。這裡改成只存 index、血量另外存一個陣列，最後**依原本順序**直接篩出血量大於 0 的，不需要再排序。

## 複雜度

時間 `O(n log n)`，主要是排序；每台機器人最多進出 stack 一次。空間 `O(n)`。

## 要特別避免的錯誤

- 沒有先依位置排序：題目的位置不一定是排好的。
- 碰撞贏了之後只撞一次就停：往左的機器人要一路撞到它消失，或前面沒有往右的機器人。
- 輸出時依位置順序而不是原本的順序。

## 面試口說整理

只有左邊往右、右邊往左的機器人會相撞，所以我先依位置排序，從左到右掃，往右的放進 stack。遇到往左的，就一直跟 stack 頂端往右的碰撞：血量少的消失、贏的扣 1，平手兩台都消失，直到它消失或前面沒有往右的機器人。最後依原本的順序輸出還活著的血量。排序 `O(n log n)`，碰撞總共 `O(n)`。
