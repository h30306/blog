---
title: "LeetCode 726: Number of Atoms"
summary: "LeetCode 726 解題筆記：先把字串切成元素、數字、括號三種 token，括號用 stack 處理，沒有數字時倍數是 1"
description: "2026-07-11 的 LeetCode 726 解題紀錄"
date: 2026-07-11
tags: ["hard", "stack", "string", "hash-map", "sorting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-07-11
- 提交紀錄：Wrong Answer ×3 → Accepted

## 解題思路

化學式有三種東西：

- **元素**：一個大寫字母，後面接 0 個以上的小寫字母，例如 `H`、`Mg`。
- **數字**：可能有好幾位，沒寫就是 1。
- **括號**：`( ... )` 後面可以接一個倍數，沒寫就是 1。

用 index 從左到右解析，每次讀一個完整的 token：

1. 讀到 `(`：在 stack 放一個標記。
2. 讀到 `)`：讀出後面的倍數，把 stack 裡到 `(` 為止的元素計數都乘上倍數，再放回去。
3. 讀到大寫字母：讀完整個元素名稱和後面的數字，推進 stack。

最後把 stack 裡的計數加總，依元素名稱排序輸出。

## 我的嘗試

前三版都是「一個字元一個字元處理」，邊讀邊猜目前的字元屬於哪個 token，錯在好幾個邊界：

1. **`digits = "23456789"`**：漏了 `0` 和 `1`。題目說數量 1 不會寫出來，但 `10`、`21` 這種多位數還是會出現 `0` 和 `1`。
2. **數字只讀一位**：`H12` 會被讀成 `H1` 和 `2`。
3. **`)` 後面沒有數字**：例如 `(OH)`，括號裡的元素沒有被合併，`)` 標記一直留在 stack 裡。

第四版改成**用 index 一次讀完一個完整的 token**，每種 token 各自處理，就 AC 了。

## 正確解法

```python
from collections import defaultdict

class Solution:
    def countOfAtoms(self, formula: str) -> str:
        n = len(formula)
        i = 0

        def read_number() -> int:
            nonlocal i
            start = i
            while i < n and formula[i].isdigit():
                i += 1
            return int(formula[start:i]) if i > start else 1

        stack = [defaultdict(int)]
        while i < n:
            ch = formula[i]
            if ch == "(":
                stack.append(defaultdict(int))
                i += 1
            elif ch == ")":
                i += 1
                mult = read_number()
                inner = stack.pop()
                for atom, cnt in inner.items():
                    stack[-1][atom] += cnt * mult
            else:
                start = i
                i += 1
                while i < n and formula[i].islower():
                    i += 1
                atom = formula[start:i]
                stack[-1][atom] += read_number()

        counts = stack[0]
        return "".join(a + (str(counts[a]) if counts[a] > 1 else "") for a in sorted(counts))
```

這裡讓 stack 的每一層是一個 dict，`)` 時把這一層乘上倍數合併到上一層。AC 版是把 `(元素, 數量)` 一筆一筆放在同一個 stack 上，遇到 `)` 時往回彈到 `(` 標記，概念一樣。

## 複雜度

時間 `O(n^2)` 最壞（巢狀很深時，每層合併都要掃過裡面所有元素），加上排序。空間 `O(n)`。

## 要特別避免的錯誤

- 數字字元集合漏掉 `0` 和 `1`。
- 數字只讀一位。
- `)` 後面沒有數字時沒有預設倍數 1。
- 一個字元一個字元猜 token 的類型：先切成完整的 token 再處理，邏輯清楚很多。

## 面試口說整理

我用 index 從左到右解析，每次讀一個完整的 token：元素名稱是一個大寫加上後面的小寫，數字可能有好幾位、沒寫就是 1。stack 的每一層是一個計數的 dict，遇到 `(` 開新的一層，遇到 `)` 讀出倍數，把這一層乘上倍數後併回上一層。最後把元素排序輸出，數量大於 1 才寫數字。
