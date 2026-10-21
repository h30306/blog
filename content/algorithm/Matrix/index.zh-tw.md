---
title: "Matrix 矩陣"
summary: "轉置與旋轉、二維 index 和一維序列互換、鄰居與對角線、四個邊界的螺旋走訪"
description: "演算法學習"
date: 2026-10-21
tags: ["matrix", "simulation", "array"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 介紹

矩陣題大多是二維陣列上的模擬，難的是 **index**：哪一維是列、哪一維是欄、邊界在哪裡。幾個固定的寫法：

| 形式 | 做法 | 例子 |
|---|---|---|
| 轉置、旋轉 | 交換 `(i, j)` 和 `(j, i)`，再反轉 | 旋轉 90 度、轉置 |
| index 換算 | 第 `k` 個元素在 `(k // n, k % n)` | 重塑、原地標記 |
| 鄰居與對角線 | 枚舉 `dx, dy`，或比較 `(i - 1, j - 1)` | 平滑、Toeplitz、表面積 |
| 螺旋走訪 | 上下左右四個邊界往內縮 | 螺旋讀取、螺旋填入 |

網格上的 BFS / DFS 見 [BFS]({{< relref "/algorithm/BFS" >}})，網格 DP 見 [Grid DP]({{< relref "/algorithm/Grid-DP" >}})，二維前綴和見 [Prefix Sum]({{< relref "/algorithm/Prefix-Sum" >}})。

## 模板一：轉置與旋轉

```python
n = len(matrix)
for i in range(n):
    for j in range(i + 1, n):            # 只換對角線的一邊
        matrix[i][j], matrix[j][i] = matrix[j][i], matrix[i][j]
for row in matrix:
    row.reverse()                        # 轉置 + 每列反轉 = 順時針 90 度
```

- **轉置**（LC 867）：`m × n` 變成 `n × m`，`res[j][i] = matrix[i][j]`；Python 是 `zip(*matrix)`（每一列是 tuple）。
- **旋轉 90 度**（LC 48）：順時針 = 轉置後每列反轉；逆時針 = 轉置後上下反轉。`matrix[:] = zip(*matrix[::-1])` 能過，但不是真正的原地。

## 模板二：二維 index 和一維序列互換

```python
m, n = len(mat), len(mat[0])
for k in range(m * n):
    i, j = k // n, k % n                 # 第 k 個元素（按列展開）
```

- **重塑**（LC 566）：原本的 `(k // n, k % n)` 放到新的 `(k // c, k % c)`；元素總數不同就回傳原矩陣。
- **整列整欄清零**（LC 73）：先記錄哪些列、欄有 0，掃完再改；邊掃邊改會讓新的 0 被當成原本的 0。`O(1)` 空間版本把標記放在第一列、第一欄。

## 模板三：鄰居與對角線

```python
for dx in (-1, 0, 1):
    for dy in (-1, 0, 1):
        x, y = i + dx, j + dy
        if 0 <= x < m and 0 <= y < n:
            ...
```

- **3 × 3 平均**（LC 661）：結果寫到新的矩陣；用 `[[0] * n for _ in range(m)]`，不要用 `[[0] * n] * m`。
- **對角線相同**（LC 766）：同一條對角線 `i - j` 相同，只要比較 `matrix[i][j]` 和 `matrix[i - 1][j - 1]`。
- **立體方塊**（LC 883、892）：投影面積是非 0 格數加上每列、每欄的最大值；表面積是每疊 `4v + 2` 減掉相鄰兩疊的 `2 × min`。
- **畫出一個形狀**（LC 3071）：先判斷每一格屬不屬於形狀，分兩組計數，再枚舉兩組的目標值。
- **數獨**（LC 36）：宮格的編號是 `(i // 3, j // 3)`。

## 模板四：螺旋走訪

```python
top, bottom, left, right = 0, m - 1, 0, n - 1
while top <= bottom and left <= right:
    for j in range(left, right + 1): visit(top, j)
    top += 1
    for i in range(top, bottom + 1): visit(i, right)
    right -= 1
    if top <= bottom:                    # 只剩一列時不要再走回來
        for j in range(right, left - 1, -1): visit(bottom, j)
        bottom -= 1
    if left <= right:                    # 只剩一欄時不要再走回來
        for i in range(bottom, top - 1, -1): visit(i, left)
        left += 1
```

- **螺旋讀取**（LC 54）、**螺旋填入 1 到 n²**（LC 59）：同一個骨架，把 `visit` 換成讀或寫。

## 主要參數說明

- `m`、`n`：列數、欄數。`len(matrix)` 是列數，`len(matrix[0])` 是欄數。
- `top`、`bottom`、`left`、`right`：螺旋走訪時還沒走過的範圍，全部是閉區間。

## 複雜度

每格處理常數次，時間 `O(mn)`。原地的寫法空間 `O(1)`，建新矩陣時 `O(mn)`。

## 常見錯誤

這些都是我練習時實際寫錯過的：

- **非正方形時兩層迴圈的範圍寫反**（LC 867）。
- **`[[0] * n] * m`**：每一列是同一個 list，改一列等於全部都改（LC 661）。
- **邊掃邊清零**：新的 0 被當成原本的 0，擴散到整個矩陣（LC 73）。
- **重塑時每段切 `r` 個**：每一列有 `c` 個；不能重塑時要回傳原矩陣，不是 `False`（LC 566）。
- **螺旋走訪只剩一欄時重複走**、**下面一列拿成上面一列**（LC 54）。
- **對角線用補 `None` 再 `zip`**：每列長度不同，`zip` 會截斷（LC 766）。
- **表面積當成投影面積的兩倍**：凹進去的面沒算到（LC 892）。
- **用字串數 `'0'` 來找空格**：`10` 裡也有 `'0'`（LC 883）。
- **數獨忘了檢查 3 × 3 宮格**（LC 36）。
- **回傳距離而不是座標**（LC 1030）。

## 相關 LeetCode

- `LC 867` Transpose Matrix
- `LC 48` Rotate Image
- `LC 566` Reshape the Matrix
- `LC 73` Set Matrix Zeroes
- `LC 661` Image Smoother
- `LC 766` Toeplitz Matrix
- `LC 883` Projection Area of 3D Shapes
- `LC 892` Surface Area of 3D Shapes
- `LC 3071` Minimum Operations to Write the Letter Y on a Grid
- `LC 36` Valid Sudoku
- `LC 54` Spiral Matrix
- `LC 59` Spiral Matrix II
- `LC 1030` Matrix Cells in Distance Order
- `LC 3070` Count Submatrices with Top-Left Element and Sum Less Than k
