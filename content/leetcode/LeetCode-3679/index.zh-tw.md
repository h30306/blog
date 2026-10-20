---
title: "LeetCode 3679: Minimum Discards to Balance Inventory"
summary: "LeetCode 3679 解題筆記：規則已經決定哪些要丟，直接模擬；長度 w 的視窗只計算「留下來」的到貨，被丟掉的離開視窗時不能再扣"
description: "2025-12-24 的 LeetCode 3679 解題紀錄"
date: 2025-12-24
tags: ["medium", "sliding-window", "hash-table", "simulation", "counting", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2025-12-24
- 提交紀錄：Wrong Answer ×3 → Accepted ×2

## 解題思路

題目規定「如果留下會超過 `m` 個，就**必須**丟掉」，所以不需要做選擇，照規則模擬就是最少的丟棄數。

長度 `w` 的固定視窗，計數雜湊表只記錄**留下來的**到貨：

1. 第 `i` 天先把第 `i - w` 天移出視窗：**只有當天的到貨有被留下，才扣掉**。
2. 這個類型在視窗裡已經有 `m` 個：丟掉，答案 +1。
3. 否則留下，計數 +1。

## 我的嘗試

| 版本 | 問題 |
|---|---|
| 第一、二版 | 先把到貨加進計數，超過 `m` 時答案 +1，但**沒有把被丟掉的那個從計數裡拿掉**。例如 `[2, 2, 2]`、`w = 2`、`m = 1`：第 2 天丟掉，第 3 天的視窗是第 2、3 天，第 2 天已經丟了，所以第 3 天可以留，答案是 1；這兩版還把第 2 天算在視窗裡，回傳 2 |
| 第三版 | 丟掉時有扣回計數，但第 `i - w` 天離開視窗時，**不管它有沒有被丟，都再扣一次**，計數變少。例如 `[3, 3, 1, 3, 3]`、`w = 2`、`m = 1`：答案是 2，回傳 1 |
| 第四版 AC | 丟掉時把 `arrivals[i]` 改成 `0`（不存在的類型），它離開視窗時扣的是類型 0，不影響真正的計數 |

## 正確解法

```python
class Solution:
    def minArrivalsToDiscard(self, arrivals: List[int], w: int, m: int) -> int:
        n = len(arrivals)
        kept = [False] * n
        cnt = Counter()
        discards = 0
        for i, t in enumerate(arrivals):
            if i >= w and kept[i - w]:
                cnt[arrivals[i - w]] -= 1         # 只有留下來的才需要移出
            if cnt[t] >= m:
                discards += 1                     # 規則規定要丟
            else:
                cnt[t] += 1
                kept[i] = True
        return discards
```

用 `kept` 陣列記錄，比把 `arrivals[i]` 改成 0 更直接，也不會修改輸入。

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- 被丟掉的到貨還留在計數裡。
- 被丟掉的到貨離開視窗時又扣一次。

## 面試口說整理

規則已經決定哪些到貨一定要丟，所以直接模擬就是最少的丟棄數。我用長度 `w` 的滑動視窗，計數只記錄留下來的到貨：每天先把 `w` 天前的到貨移出（只有它當初被留下才扣），再看這個類型是不是已經有 `m` 個，有就丟、沒有就留。時間 `O(n)`。
