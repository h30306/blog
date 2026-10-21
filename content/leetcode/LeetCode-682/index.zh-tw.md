---
title: "LeetCode 682: Baseball Game"
summary: "LeetCode 682 解題筆記：用 stack 存有效的分數，C 刪掉最後一個，D 加入兩倍，+ 加入最後兩個的和"
description: "2022-08-30 的 LeetCode 682 解題紀錄"
date: 2022-08-30
tags: ["easy", "array", "stack", "simulation"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: easy
第一次嘗試：2022-08-30
- 提交紀錄：Accepted（一次通過）

## 解題思路

每個操作只跟最近的分數有關（[Stack]({{< relref "/algorithm/Stack" >}}) 模板二）：數字就 `push`；`C` 就 `pop`；`D` 就 `push(2 * st[-1])`；`+` 就 `push(st[-1] + st[-2])`。最後加總 stack。

## 我的解法

```python
class Solution:
    def calPoints(self, operations: List[str]) -> int:
        st = []
        for op in operations:
            if op == "C":
                st.pop()
            elif op == "D":
                st.append(2 * st[-1])
            elif op == "+":
                st.append(st[-1] + st[-2])
            else:
                st.append(int(op))
        return sum(st)
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 分數可能是負數，用 `int(op)` 轉換，不要用 `isdigit` 判斷。

## 面試口說整理

每個操作只跟最近的分數有關，我用 stack 存有效的分數，C 刪掉最後一個、D 放入最後一個的兩倍、加號放入最後兩個的和，最後加總。時間 `O(n)`。
