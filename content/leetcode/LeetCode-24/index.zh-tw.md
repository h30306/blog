---
title: "LeetCode 24: Swap Nodes in Pairs"
summary: "LeetCode 24 解題筆記：dummy 加上兩兩一組，prev.next、a.next、b.next 三個指標一起重接；交換的是節點不是值"
description: "2022-10-21 的 LeetCode 24 解題紀錄"
date: 2022-10-21
tags: ["medium", "linked-list", "recursion"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-10-21
- 提交紀錄：Time Limit Exceeded → Wrong Answer ×3 → Accepted → Runtime Error → Wrong Answer ×2 → Accepted ×2 → Runtime Error ×3 → Accepted ×2

## 解題思路

每次處理 `prev` 後面的兩個節點 `a`、`b`（[Linked List]({{< relref "/algorithm/Linked-List" >}}) 模板五）：

- `prev.next` 改成 `b`
- `a.next` 改成 `b` 原本的下一個
- `b.next` 改成 `a`

然後 `prev` 移到 `a`（現在是這組的第二個）。用 dummy 處理第一組會換掉頭的情況。

## 我的嘗試

2022 年這題提交了 15 次：

- **TLE / WA**：一開始想用 `node.val, node.next, node.next.next = ...` 一行交換，但左邊是由左到右指定，`node.next` 改完之後 `node.next.next` 指到錯的節點，造成迴圈或掉節點；第一版還忘了讓 `node` 前進（TLE），第二版最後回傳的是走到底的 `node`（`None`）而不是頭，所以 `[4]` 回傳空的，`[2, 2]` 也只剩一個。
- **RE**：空串列時取了 `head.next`。
- 改成 dummy + `a`、`b` 兩個變數之後就 AC 了。

## 正確解法

```python
class Solution:
    def swapPairs(self, head: Optional[ListNode]) -> Optional[ListNode]:
        dummy = ListNode(0, head)
        prev = dummy
        while prev.next and prev.next.next:
            a, b = prev.next, prev.next.next
            prev.next, a.next, b.next = b, b.next, a
            prev = a
        return dummy.next
```

## 複雜度

時間 `O(n)`，空間 `O(1)`。

## 要特別避免的錯誤

- Python 的多重指定會先算出右邊所有的值，所以 `b.next` 用的是舊的值；但左邊是**由左到右**指定，寫成 `node.next, node.next.next = ...` 時，第二個目標用的是已經改過的 `node.next`。

## 面試口說整理

我用 dummy，每次處理後面兩個節點：讓前一組的尾巴指向 `b`，`a` 指向 `b` 原本的下一個，`b` 指向 `a`，再往後移兩格。時間 `O(n)`。
