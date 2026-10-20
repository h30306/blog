---
title: "LeetCode 2271: Maximum White Tiles Covered by a Carpet"
summary: "LeetCode 2271 解題筆記：地毯的左端放在某段白磚的起點一定不會更差；排序後用雙指針，完整蓋住的段累加，最後一段只算部分"
description: "2026-01-11 的 LeetCode 2271 解題紀錄"
date: 2026-01-11
tags: ["medium", "sliding-window", "greedy", "sorting", "prefix-sum", "binary-search", "array"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2026-01-11
- 提交紀錄：Accepted ×2（2026-01-11、01-14 各寫一次）

## 解題思路

**地毯的左端一定可以放在某段白磚的起點**：如果左端落在空白處或某段的中間，把地毯往右推到下一段的起點（或推到這段的起點後面），左邊少蓋的都是空白或已經算過的，右邊只會多蓋。

所以把段落依起點排序，枚舉地毯從 `tiles[left][0]` 開始，終點是 `start + carpetLen - 1`：

- `right` 往右吃掉所有**完整**被蓋住的段（`tiles[right][1] <= end`），累加長度。
- 下一段 `tiles[right]` 可能被**部分**蓋住：`max(0, end - tiles[right][0] + 1)`。
- 換下一個 `left` 前，扣掉 `tiles[left]` 的長度。

`left` 往右時地毯終點也往右，`right` 不用回頭。

## 我的解法

```python
class Solution:
    def maximumWhiteTiles(self, tiles: List[List[int]], carpetLen: int) -> int:
        tiles.sort()
        n = len(tiles)
        right = covered = best = 0                 # covered：完整蓋住的段的總長
        for left in range(n):
            end = tiles[left][0] + carpetLen - 1
            while right < n and tiles[right][1] <= end:
                covered += tiles[right][1] - tiles[right][0] + 1
                right += 1
            partial = max(0, end - tiles[right][0] + 1) if right < n else 0
            best = max(best, covered + partial)
            if right > left:
                covered -= tiles[left][1] - tiles[left][0] + 1
            else:
                right = left + 1                   # 這段本身就沒被完整蓋住
        return best
```

我原本的寫法沒有 `else` 分支：當地毯連 `tiles[left]` 自己都蓋不完時，`right == left`，扣掉長度會讓 `covered` 變負。原本的程式碼還是 AC 了，因為那種情況下 `covered` 的值在下一輪會被修正回來；這裡寫成明確的分支比較好讀。

## 複雜度

時間 `O(n log n)`，空間 `O(1)`（不算排序）。

## 要特別避免的錯誤

- 枚舉地毯每一個可能的起始位置：座標到 `10^9`。
- 忘了最後一段只被部分蓋住。

## 面試口說整理

地毯的左端放在某段白磚的起點不會更差，所以我把段落排序，枚舉地毯從每段的起點開始。用另一個指針累加被完整蓋住的段，下一段可能只蓋到一部分，另外算。左指針往右時扣掉離開的那段，右指針不用回頭。時間由排序決定，`O(n log n)`。
