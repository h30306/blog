---
title: "LeetCode 4045: Count Robot Groups"
summary: "LeetCode 4045 解題筆記：先合併 t = 0 就夠近的機器人，再從右往左像車隊一樣，比前面車隊快的遲早會併入"
description: "2026-09-17 的 LeetCode 4045 解題紀錄"
date: 2026-09-17
tags: ["medium", "stack", "monotonic-stack", "greedy"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-09-17
- 提交紀錄：Wrong Answer ×3 → Accepted

## 解題思路

機器人都往右走，距離 `<= distance` 時就合併，合併後的群組用**最右邊那台**的位置和速度。

分兩個階段：

**1. `t = 0` 時已經夠近的先合併。** 從左到右掃，跟前一個群組最右邊那台的距離 `<= distance` 就併進去，群組的位置和速度更新成這台。

**2. 之後的合併，跟 LC 853 Car Fleet 一樣。** 從右往左看，每個群組只會追上它前面那個「車隊」：

- 速度**比前面車隊快**：距離會一直縮小，遲早會 `<= distance` 而合併。合併後用前面車隊的速度，所以車隊的速度不變。
- 速度**比較慢或一樣**：永遠追不上，自成一個新車隊。

所以從右往左維護一個 stack，存每個車隊的速度；比 stack 頂端快的就跳過（併入），否則推進去。最後 stack 的大小就是答案。

## 我的嘗試

1. **第一版**：`t = 0` 的合併從右往左做，而且保留的是左邊那台，方向跟題目相反（題目要用最右邊那台的狀態）。之後只比較相鄰兩個群組的速度。
2. **第二、三版**：改了比較的方向，也把 `t = 0` 的合併改成從左往右，但還是**只比較相鄰的兩個群組**。

問題在於：一個群組追上的是前面「整個車隊」，車隊的速度是那個車隊最前面那台的速度，不是相鄰那台原本的速度。只比相鄰的，就會把「追上一個已經被併入的群組」算錯。改成 stack 存車隊速度就 AC 了。

## 正確解法

```python
class Solution:
    def countGroups(self, position: List[int], speed: List[int], distance: int) -> int:
        groups = []                                  # (最右邊的位置, 速度)
        for p, v in zip(position, speed):
            if groups and groups[-1][0] + distance >= p:
                groups[-1] = (p, v)                  # t = 0 就合併，改成最右邊這台
            else:
                groups.append((p, v))

        fleets = []                                  # 由右往左的車隊速度
        for _, v in reversed(groups):
            if fleets and v > fleets[-1]:
                continue                             # 會追上前面的車隊
            fleets.append(v)
        return len(fleets)
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- `t = 0` 的合併保留了左邊那台的狀態：要用最右邊那台。
- 只比較相鄰的群組：要跟前面整個車隊的速度比。
- 速度一樣也算追上：速度相同時距離不變，不會合併。

## 面試口說整理

我先從左到右合併 `t = 0` 就已經夠近的機器人，群組用最右邊那台的位置和速度。接著像 Car Fleet 一樣從右往左看：比前面車隊快的遲早會縮短到 `distance` 以內而併入，車隊速度不變；不比它快的就形成新車隊。用 stack 存車隊速度，最後的大小就是群組數，時間 `O(n)`。
