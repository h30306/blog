---
title: "LeetCode 227: Basic Calculator II"
summary: "LeetCode 227 解題筆記：先把數字讀完整，遇到運算子時處理上一個運算子：+ - 把數放進 stack（減號放負數），* / 直接跟頂端算"
description: "2022-11-13 的 LeetCode 227 解題紀錄"
date: 2022-11-13
tags: ["medium", "math", "string", "stack"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-11-13
- 提交紀錄：Wrong Answer → Accepted

## 解題思路

沒有括號，只有優先順序（[Stack]({{< relref "/algorithm/Stack" >}}) 模板一）。用 `op` 記住**上一個運算子**，掃到數字就累積成完整的數；遇到下一個運算子或字串結尾時處理 `op`：

- `+`：`push(num)`；`-`：`push(-num)`。
- `*`、`/`：跟 stack 頂端算完放回去，除法要**往 0 截斷**（`int(a / b)`）。

最後加總 stack。乘除當場算掉，加減留到最後，就符合優先順序。

## 我的嘗試

- 第一版把字串轉成字元的 list，**每個字元當成一個 token**，多位數的數字被拆開了：`"18"` 回傳 1 之類的結果。
- 第二版先把數字和運算子切成 token 才 AC，但做法是在 list 上用切片 `s[i - 1:i + 2] = [結果]` 原地取代，每次都要搬移後面的元素，`O(n²)`；而且除法用的是 `//`，只有在數都是非負時才跟往 0 截斷一樣。

## 正確解法

```python
class Solution:
    def calculate(self, s: str) -> int:
        st, num, op = [], 0, "+"
        for i, c in enumerate(s):
            if c.isdigit():
                num = num * 10 + int(c)
            if c in "+-*/" or i == len(s) - 1:
                if op == "+":
                    st.append(num)
                elif op == "-":
                    st.append(-num)
                elif op == "*":
                    st.append(st.pop() * num)
                else:
                    st.append(int(st.pop() / num))
                op, num = c, 0
        return sum(st)
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 數字可能有好幾位，要先讀完整。
- 除法往 0 截斷：`-3 / 2` 是 -1，`//` 會得到 -2。
- 最後一個數要在字串結尾處理。

## 面試口說整理

我記住上一個運算子，把數字讀完整，遇到下一個運算子或結尾時處理：加減把數放進 stack，減號放負數，乘除直接跟頂端算完放回去，最後加總。乘除當場算掉、加減留到最後，就符合優先順序。時間 `O(n)`。
