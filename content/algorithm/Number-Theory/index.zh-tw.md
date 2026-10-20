---
title: "Number Theory 數論"
summary: "GCD、判斷質數、埃氏篩 / 線性篩 / 最小質因數（SPF）、質因數分解後用 Union-Find 連起來，以及用質因數的最後出現位置切陣列"
description: "演算法學習"
date: 2026-10-20
tags: ["math", "number-theory", "prime", "sieve", "union-find", "gcd"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 介紹

數論題在面試裡大多是幾個固定的工具組合起來：

| 工具 | 用途 | 複雜度 |
|---|---|---|
| GCD（輾轉相除法） | 最大公因數、最小公倍數 | `O(log min(a, b))` |
| 試除法 | 判斷一個數是不是質數、分解質因數 | `O(√n)` |
| 篩法 | 一次找出 `<= N` 的所有質數 / 每個數的最小質因數 | `O(N log log N)` 或 `O(N)` |
| 質因數 + Union-Find | 「有共同因數就相連」的連通性 | 每個數 `O(log x)`（用 SPF） |

「`gcd(a, b) > 1`」等價於「**有共同的質因數**」，這是很多題目的關鍵轉換：不用兩兩算 GCD（`O(n^2)`），改成把每個數跟它的質因數連起來。

## 模板一：GCD 與 LCM

```python
def gcd(a: int, b: int) -> int:
    while b:
        a, b = b, a % b
    return a

lcm = a // gcd(a, b) * b                 # 先除再乘，避免中間值太大
```

Python 也可以直接用 `math.gcd`、`math.lcm`。

- **最大和最小數的 GCD**（LC 1979）。
- **2 和 n 的最小公倍數**（LC 2413）：`n` 是偶數就是 `n`，奇數就是 `2n`。

## 模板二：判斷質數

```python
from math import isqrt

def is_prime(x: int) -> bool:
    if x < 2:
        return False
    if x % 2 == 0:
        return x == 2
    for d in range(3, isqrt(x) + 1, 2):
        if x % d == 0:
            return False
    return True
```

用 `isqrt` 而不是 `x ** 0.5`，避免浮點誤差；用 `%` 判斷整除，不要比較 `x // d == x / d`。

- **範圍內的質數和**（LC 3918）、**質數 index 的元素**（LC 3618）。
- **範圍內最接近的兩個質數**（LC 2523）：從 `left` 往右掃，找到差是 2 的一對就可以停，因為除了 `[2, 3]` 不可能更小。

## 模板三：篩法

**埃氏篩**：每個質數把自己的倍數劃掉。

```python
is_prime = [True] * (N + 1)
is_prime[0] = is_prime[1] = False
for i in range(2, isqrt(N) + 1):
    if is_prime[i]:
        for j in range(i * i, N + 1, i):
            is_prime[j] = False
```

**最小質因數（SPF）**：篩的時候記下每個數的最小質因數，之後分解任何 `<= N` 的數只要 `O(log x)`：

```python
spf = list(range(N + 1))
for i in range(2, isqrt(N) + 1):
    if spf[i] == i:                      # i 是質數
        for j in range(i * i, N + 1, i):
            if spf[j] == j:
                spf[j] = i               # 是 spf[j]，不是 spf[i]

def factorize(x):                        # 回傳不重複的質因數
    primes = []
    while x > 1:
        p = spf[x]
        primes.append(p)
        while x % p == 0:
            x //= p
    return primes
```

**線性篩**：每個合數只被它的最小質因數劃掉一次，`O(N)`。外層要跑**所有的 `i`**（不只是質數），內層在 `i % p == 0` 時停：

```python
primes, spf = [], [0] * (N + 1)
for i in range(2, N + 1):
    if spf[i] == 0:
        spf[i] = i
        primes.append(i)
    for p in primes:                     # 每個 i 都要跑，不能放在 if 裡面
        if i * p > N:
            break
        spf[i * p] = p
        if i % p == 0:
            break
```

- **和為 n 的質數對**（LC 2761）：篩完之後，`x` 從小到大，`x` 和 `n - x` 都是質數就是一對。

## 模板四：質因數 + Union-Find

「有共同因數就相連」：把每個數跟它的每個質因數放進同一組。實作上可以讓 Union-Find 的節點是**值**（質因數和數字共用編號），或記錄「每個質因數第一次出現在哪個 index」，之後遇到同一個質因數就跟那個 index 合併：

```python
owner = {}                               # 質因數 -> 第一個擁有它的 index
for i, x in enumerate(nums):
    for p in factorize(x):
        if p in owner:
            union(i, owner[p])
        else:
            owner[p] = i
```

- **最大連通塊**（LC 952）、**任兩個 index 都能互通嗎**（LC 2709）、**只能跟有共同因數的交換，能不能排序**（LC 1998：排序前後每個位置的數要在同一組）。
- **門檻以上的公因數**（LC 1627）：不分解質因數，直接對每個 `z > threshold` 把 `z, 2z, 3z, ...` 連起來，總共 `O(n log n)`。

`1` 沒有任何質因數，不會跟任何數相連，要特別處理。

## 模板五：質因數的最後出現位置

**切成兩段，乘積互質**（LC 2584）：兩段乘積互質 ⇔ 沒有任何質因數同時出現在兩段。先記下每個質因數**最後出現的 index**，從左往右掃，目前看過的質因數最遠會延伸到 `reach`；`reach == i` 時在 `i` 後面切就合法。這跟「劃分字母區間」是同一個想法。

## 主要參數說明

- 篩法的上限 `N` 是陣列裡的最大值（或題目給的範圍）。
- 試除法只要試到 `√x`；試完剩下的 `x > 1` 本身是質數。
- 用值當 Union-Find 節點時，陣列大小是 `max(nums) + 1`。

## 複雜度

試除 `O(√x)`；埃氏篩 `O(N log log N)`；線性篩 `O(N)`；用 SPF 分解 `O(log x)`。

## 常見錯誤

這些都是我練習時實際寫錯過的：

- **兩兩算 GCD**：`O(n^2)`，TLE（LC 952、2709、1627）。
- **用 `x // d == x / d` 判斷整除**：`2` 會被自己整除，被判成合數（LC 3918）。
- **SPF 篩法寫成 `spf[i] = i`**：應該是 `spf[j] = i`；分解時又直接改了原本的 `num`，之後拿去 union 的值已經不對了（LC 1998）。
- **線性篩的內層迴圈放進了 `if 是質數` 裡面**：合數不會去劃掉它的倍數，像 8 就被當成質數（LC 1998）。
- **忘了 `1` 沒有質因數**：`[1, 1]` 兩個 1 互相連不到；但 `[1]` 只有一個數時答案是 `True`（LC 2709）。從 `-1` 開始記 `reach`，第一個數是 1 時就切不出來（LC 2584）。
- **找最近的質數對時 index 寫錯**：`prime[i + 1] - prime[i - 1]`（LC 2523）。
- **沒有路徑壓縮**：`find` 寫成 `return find(parent[a])` 而沒有存回去，同一題慢了三倍（LC 952）。

## 相關 LeetCode

- `LC 1979` Find Greatest Common Divisor of Array
- `LC 2413` Smallest Even Multiple
- `LC 3918` Sum of Primes Between Number and Its Reverse
- `LC 3618` Split Array by Prime Indices
- `LC 2523` Closest Prime Numbers in Range
- `LC 2761` Prime Pairs With Target Sum
- `LC 952` Largest Component Size by Common Factor
- `LC 2709` Greatest Common Divisor Traversal
- `LC 1998` GCD Sort of an Array
- `LC 1627` Graph Connectivity With Threshold
- `LC 2584` Split the Array to Make Coprime Products
