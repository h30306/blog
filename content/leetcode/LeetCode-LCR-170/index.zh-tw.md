---
title: "LeetCode LCR 170: 交易逆序對的總數"
summary: "LCR 170（劍指 Offer 51）解題筆記：merge 時順便數逆序對"
description: "2026-10-18 merge sort 練習梯子的 LCR 170 紀錄"
date: 2026-10-18
tags: ["hard", "merge-sort", "divide-and-conquer", "counting"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: hard
第一次嘗試：2026-10-18
來源：Merge sort 練習梯子，第 1 階（祖師題）

## 解題思路

逆序對是 `i < j` 且 `record[i] > record[j]` 的 pair。在 LC 912 的 merge sort 上**只要多一行**：

merge 時走進 `else`，代表右邊的 `record[j]` 比左邊的 `record[i]` 嚴格小（相等時 `<=` 會先取左邊）。左半已排序，所以 `record[i..mid-1]` 全部都比 `record[j]` 大，各自和它組成一個逆序對，共 `mid - i` 對。

## 我的第一版

參考了 Krahets 的閉區間解法，改成自己習慣的左閉右開寫法：

```python
def mergeSort(low: int, high: int):
    if high - low <= 1:
        return                                   # ① 回傳 None

    mid = (low + high) // 2
    res = mergeSort(low, mid) + mergeSort(mid, right)   # ② right 沒定義

    i, j, k = l, mid, l                          # ③ l 沒定義
    while i < mid or j < high:
        if j >= high or (i < mid and record[i] <= reocrd[j]):   # ④ 拼錯
            tmp[k] = record[i]
            i += 1
        elif i >= mid:
            tmp[k] = reocrd[j]
            j += 1
        else:
            tmp[k] = record[j]
            j += 1
            res += mid - i + 1                   # ⑤ 多加 1
        k += 1

    res[low: high] = tmp[low: high]              # ⑥ 應該寫回 record
    return res
```

## 檢討

| # | 問題 | 會怎樣 |
|---|---|---|
| ① | 終止條件 `return` 要改成 `return 0` | `None + None`，TypeError |
| ② ③ | 混用參考解的 `l`、`r` 和自己的 `low`、`high` | NameError |
| ④ | `reocrd` 拼錯 | NameError |
| ⑤ | `mid - i + 1` | **邏輯錯誤，不會報錯** |
| ⑥ | `res` 是 int，不能切片 | TypeError |

最重要的是 ⑤。參考解用閉區間 `[l, m]`，左半剩下 `m - i + 1` 個；我用左閉右開 `[low, mid)`，左半剩下 `mid - i` 個。`[2, 1]` 用我的寫法會算出 2，正確答案是 1。

**參考別人的解答時，公式要用自己的區間定義重新推一次。**

`elif i >= mid` 這個分支也可以拿掉：改成 `mid - i` 之後，左半用完時 `i == mid`，`else` 加的是 0，不會多算。

## 正確解法

```python
class Solution:
    def reversePairs(self, record: list[int]) -> int:
        n = len(record)
        tmp = [0] * n

        def mergeSort(low: int, high: int) -> int:
            if high - low <= 1:
                return 0

            mid = (low + high) // 2
            res = mergeSort(low, mid) + mergeSort(mid, high)

            i, j, k = low, mid, low
            while i < mid or j < high:
                if j >= high or (i < mid and record[i] <= record[j]):
                    tmp[k] = record[i]
                    i += 1
                else:
                    tmp[k] = record[j]
                    j += 1
                    res += mid - i        # 左半剩下的都比 record[j] 大
                k += 1

            record[low:high] = tmp[low:high]
            return res

        return mergeSort(0, n)
```

## 複雜度

時間 `O(n log n)`，空間 `O(n)`。計數只是每次取右邊時多一個 `O(1)` 的加法。

## 要特別避免的錯誤

- 用 `<` 而不是 `<=`：相等時會先取右邊，把相等的 pair 也算成逆序對。
- 照抄閉區間的 `+ 1`。
- 寫完沒有掃一遍變數名稱：每個用到的名字都要能在上面找到定義。

## 面試口說整理

我在 merge sort 的 merge 階段計數。合併時左半都是原本的 `i`、右半都是原本的 `j`，所以跨兩半的 pair 自動滿足 `i < j`。當右邊的元素比左邊的隊頭小，代表左半剩下的 `mid - i` 個元素都比它大，一次全部加進答案。相等時先取左邊，避免把相等的 pair 算進去。時間 `O(n log n)`，空間 `O(n)`。
