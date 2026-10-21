---
title: "LeetCode 225: Implement Stack using Queues"
summary: "LeetCode 225 解題筆記：一個 queue 就夠：push 之後把前面的元素全部轉到後面，新元素就到了隊首"
description: "2022-08-21 的 LeetCode 225 解題紀錄"
date: 2022-08-21
tags: ["easy", "stack", "design", "queue"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-21
- 提交紀錄：Runtime Error → Wrong Answer ×2 → Accepted

## 解題思路

只能用 queue 的操作（從尾巴放、從頭拿）。`push(x)` 之後，把 `x` 前面的 `n - 1` 個元素依序拿出來放回尾巴，`x` 就跑到隊首（[Queue and Design]({{< relref "/algorithm/Queue-and-Design" >}})）。這樣 `pop` 和 `top` 都是看隊首，`O(1)`；`push` 是 `O(n)`。

## 我的嘗試

當時直接用 Python 的 list 當成 stack，**沒有照題目用 queue 實作**。中間兩次 WA 是 `top` 回傳了 `self.l[0]`（第一個放進去的），應該是 `self.l[-1]`。

## 正確解法

```python
class MyStack:
    def __init__(self):
        self.q = deque()

    def push(self, x: int) -> None:
        self.q.append(x)
        for _ in range(len(self.q) - 1):
            self.q.append(self.q.popleft())

    def pop(self) -> int:
        return self.q.popleft()

    def top(self) -> int:
        return self.q[0]

    def empty(self) -> bool:
        return not self.q
```

## 複雜度

`push` `O(n)`，其他 `O(1)`；空間 `O(n)`。

## 要特別避免的錯誤

- 題目要求只用 queue 的操作，直接用 list 當 stack 雖然能過但不符合題意。
- stack 的頂端是最後放進去的，不是第一個。

## 面試口說整理

只能用 queue 的操作，所以我在每次 push 之後，把新元素前面的所有元素依序轉到尾巴，新元素就到了隊首，pop 和 top 都直接看隊首。push 是 `O(n)`，其他 `O(1)`。
