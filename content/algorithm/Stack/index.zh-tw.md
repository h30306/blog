---
title: "Stack 與單調棧"
summary: "巢狀結構解析、跟前一個元素合併的模擬、單調棧、貪心刪字元取字典序最小，以及 lazy deletion 的 Max Stack"
description: "演算法學習"
date: 2026-10-20
tags: ["stack", "monotonic-stack", "greedy", "simulation"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 介紹

Stack 是後進先出（LIFO）：最後放進去的元素最先被拿出來。

辨識訊號：

- **巢狀結構**：括號、`k[...]`、化學式 `(...)n`。遇到開頭就把目前的狀態存起來，遇到結尾再取回來組合。
- **新元素會跟「前一個還留著的元素」互動**：合併、抵銷、碰撞。
- **找左邊或右邊第一個比自己大 / 小的元素**：單調棧。
- **刪掉一些字元讓字串字典序最小**：單調棧加貪心。

## 模板一：解析巢狀結構

遇到 `[` 或 `(` 時，把「目前累積的結果」推進 stack，開始累積新的一層；遇到 `]` 或 `)` 時，把這一層的結果處理完，再接回上一層。

```python
stack = []
cur, num = "", 0
for ch in s:
    if ch.isdigit():
        num = num * 10 + int(ch)          # 數字可能有好幾位
    elif ch == "[":
        stack.append((cur, num))           # 存下上一層的狀態
        cur, num = "", 0
    elif ch == "]":
        prev, k = stack.pop()
        cur = prev + cur * k               # 這一層處理完，接回上一層
    else:
        cur += ch
```

LC 394 Decode String 就是這個模板。LC 726 Number of Atoms 是同一個想法，只是每一層存的是元素的計數。

### 主要參數說明：

- **數字可能有好幾位**：不要假設只有一位數（LC 394、726）。
- **括號後面可能沒有數字**：這時倍數是 1（LC 726）。

## 模板二：跟前一個元素互動的模擬

新元素只會跟 stack 頂端互動，互動完可能還要繼續跟新的頂端互動：

```python
stack = []
for x in items:
    while stack and 會互動(stack[-1], x):
        x = 互動結果(stack.pop(), x)       # 合併、抵銷，或決定誰留下
        if x is None:
            break
    if x is not None:
        stack.append(x)
```

- LC 3834：相鄰相同就合併成兩倍，合併後可能又跟前一個相同。
- LC 2751：往右的機器人在 stack 裡，遇到往左的就碰撞，直到其中一方消失。
- LC 3703：stack 存「(字元, 連續個數)」，湊出 `k` 個 `(` 加 `k` 個 `)` 時就整段消掉。

## 模板三：單調棧

維持 stack 裡的元素單調，新元素進來前，先把破壞單調性的元素彈出：

```python
stack = []
for i in range(n - 1, -1, -1):             # 從右往左
    while stack and stack[-1] < nums[i]:
        stack.pop()                        # 被 nums[i] 擋住，之後的人看不到
    # 此時 stack[-1] 是 nums[i] 右邊第一個比它大的
    stack.append(nums[i])
```

- LC 1944：被彈出的人都看得到；彈完之後如果還有人，那個比較高的也看得到。
- LC 4045：從右往左，stack 存「車隊」的速度，比前面車隊快的遲早會追上併入，比較慢或一樣快的會自成一隊。

## 模板四：刪字元讓字典序最小

從左往右，新字元比 stack 頂端小、而且頂端那個字元**之後還能補回來或允許刪除**，就把頂端彈掉：

```python
for ch in s:
    while stack and stack[-1] > ch and 可以刪掉(stack[-1]):
        刪掉(stack.pop())
    stack.append(ch)
```

「可以刪掉」的條件依題目而不同：

| 題目 | 要求 | 可以刪掉的條件 |
|---|---|---|
| LC 316 | 每個字母**剛好留一個** | 這個字母後面還會再出現；而且已經在 stack 裡的字母直接跳過 |
| LC 3816 | 每個字母**至少留一個** | 目前字串裡這個字母還有不只一個；最後尾巴重複的也要刪掉 |

我曾經把 3816 的寫法直接套到 316，結果 WA：316 不允許同一個字母留兩個，所以一定要有 `seen` 把重複的跳過。

## 模板五：Max Stack，用 lazy deletion

`popMax` 要從中間刪除元素，stack 和 heap 都做不到。做法跟 heap 的 lazy deletion 一樣：

- 每個元素給一個**唯一的 id**，同時放進 stack 和 heap。
- 刪除時只把 id 記到 `deleted` 集合。
- `top`、`peekMax` 時，先把頂端已經被刪掉的元素彈掉。

**一定要用 id 而不是值**：同一個值可能出現很多次，只記值的話分不清楚刪掉的是哪一個（LC 716）。

## 複雜度

- 每個元素最多進出 stack 一次，所以模板一到四都是 `O(n)`。
- Max Stack 每個操作均攤 `O(log n)`。

## 常見錯誤

這些都是我練習時實際寫錯過的：

- **假設數字只有一位**（LC 394）。
- **括號後面沒有數字時沒有預設倍數 1**（LC 726）。
- **把「至少留一個」的寫法用在「剛好留一個」的題目**（LC 316）。
- **lazy deletion 只記值不記 id**：重複的值會刪錯（LC 716）。
- **只比較相鄰兩個的速度**：車隊題要跟前面「整個車隊」的速度比（LC 4045）。
- **用字串 `replace` 反覆刪除**：每次都重掃整個字串，`O(n^2)`（LC 3703 跑了 5 秒）。

## 相關 LeetCode

- `LC 394` Decode String
- `LC 726` Number of Atoms
- `LC 3834` Merge Adjacent Equal Elements
- `LC 3703` Remove K-Balanced Substrings
- `LC 2751` Robot Collisions
- `LC 1944` Number of Visible People in a Queue
- `LC 4045` Count Robot Groups
- `LC 316` Remove Duplicate Letters
- `LC 3816` Lexicographically Smallest String After Deleting Duplicate Characters
- `LC 716` Max Stack
