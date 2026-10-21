---
title: "LeetCode 305: Number of Islands II"
summary: "LeetCode 305 解題筆記：每加一格陸地島數加 1，跟四周已經是陸地的格子合併，每成功合併一次減 1；重複的位置要跳過"
description: "2026-10-15 的 LeetCode 305 解題紀錄"
date: 2026-10-15
tags: ["hard", "union-find", "hash-table", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-10-15
- 提交紀錄：Wrong Answer ×6 → Accepted → Wrong Answer → Accepted → Wrong Answer → Accepted ×2 → Wrong Answer → Accepted

## 解題思路

每加一格陸地（[Union-Find]({{< relref "/algorithm/Union-Find" >}}) 的「數連通塊個數」）：

1. 島數先加 1（自己是一座新島）。
2. 看上下左右四格，已經是陸地的話就合併；**真的合併兩座不同的島**才減 1。
3. 同一格重複加入時什麼都不變，但答案還是要記一次。

只數「旁邊有幾格陸地」不夠，因為旁邊的幾格可能本來就是同一座島，所以要用 Union-Find 判斷。

## 我的嘗試

| 版本 | 問題 |
|---|---|
| 前三版 | 沒用 Union-Find，只數旁邊有幾格陸地。第一版「有接到就不變」：`1 × 3` 依序加 `(0, 2)`、`(0, 0)`、`(0, 1)`，最後一格連起兩座島，答案 1，回傳 2；第二版改成減掉鄰居數，回傳 0；第三版減掉鄰居數 - 1，但 `2 × 2` 最後一格的兩個鄰居早就是同一座島，答案 1，回傳 0 |
| 第四、五版 | 改用 Union-Find，但沒處理重複位置：同一格加兩次會多算一座島；第五版跳過了，卻忘了把答案記進去，結果陣列變短 |
| 第六版 | 記了答案但沒有 `continue`，同一格還是多算一次 |
| AC | 重複時記答案並 `continue` |
| 之後幾版 | 練習不同的 `find` 寫法：一版在 `find` 裡誤用外層迴圈的變數 `x`；一版只做一次 `parent[a] = parent[parent[a]]` 沒有迴圈，深度超過 2 時回傳的不是根；一版路徑減半把 `while` 寫成 `if`，島數甚至變成負的 |

## 正確解法

```python
class Solution:
    def numIslands2(self, m: int, n: int, positions: List[List[int]]) -> List[int]:
        parent = list(range(m * n))
        land = set()

        def find(x):
            while parent[x] != x:
                parent[x] = parent[parent[x]]      # 路徑減半，一定要用 while
                x = parent[x]
            return x

        res, count = [], 0
        for r, c in positions:
            if (r, c) not in land:
                land.add((r, c))
                count += 1
                for nr, nc in ((r + 1, c), (r - 1, c), (r, c + 1), (r, c - 1)):
                    if (nr, nc) in land:
                        a, b = find(r * n + c), find(nr * n + nc)
                        if a != b:
                            parent[a] = b
                            count -= 1
            res.append(count)
        return res
```

`(nr, nc) in land` 已經保證在範圍內，因為只有合法的格子會被加進 `land`。

## 複雜度

時間 `O(m · n + k · α(m · n))`，`k` 是操作數，空間 `O(m · n)`。

## 要特別避免的錯誤

- 鄰居是陸地不代表是不同的島，要用 `find` 判斷。
- 重複的位置要跳過，但答案還是要記。
- 路徑減半要用 `while` 一直走到根。

## 面試口說整理

我用 Union-Find 維護島嶼。每加一格先當成一座新島，再跟四周已經是陸地的格子合併，只有兩個根不同時才真的合併並減 1。同一格重複加時直接記下目前的島數。每次操作接近 `O(1)`。
