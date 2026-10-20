---
title: "Merge Sort 與分治計數"
summary: "Merge sort 模板、逆序對類計數題的計數位置、linked list 版本與常見錯誤"
description: "演算法學習"
date: 2026-10-20
tags: ["merge-sort", "divide-and-conquer", "sorting", "counting"]
categories: ["algorithm"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 介紹

Merge sort 本身是穩定、最壞情況也是 `O(n log n)` 的排序。面試裡更常考的是它的延伸：**歸併排序計數**，也叫分治計數或逆序對類題目。

辨識訊號：

- 題目要數「`i < j` 而且 `a[i]`、`a[j]` 滿足某個大小關係」的 pair 個數。
- `n` 大約 `10^5`，`O(n^2)` 會超時。
- 出現前綴和、差值，或兩個陣列相減。這通常是要你先轉換式子，轉完又回到這個題型。

## 核心概念

Merge sort 分兩步：

1. **切**：把區間對半切，遞迴到只剩 1 個元素。1 個元素本身就有序。
2. **合**：把兩段**已經排好序**的區間合併成一段。

三個重要性質：

- **merge 只會合併，不會排序。** merge 每一步只比較兩邊的隊頭，而且不會改變同一半內部的順序。所以兩半必須先被遞迴排好，merge 的結果才會正確。
- **跨兩半的 pair 自動滿足 `i < j`。** 合併時左半全部是原本的 `i`，右半全部是原本的 `j`。排序只會打亂同一半內部的順序，不會讓左右對調。
- **兩半都有序，所以可以用單調的雙指針計數。** 左半的 `i` 往右走時值只會變大，右半符合條件的範圍也只會單向移動，每層計數是 `O(n)`。

## 模板一：陣列 Merge Sort（LC 912）

```python
class Solution:
    def sortArray(self, nums: list[int]) -> list[int]:
        n = len(nums)
        temp = [0] * n                       # 全程共用一個暫存陣列

        def sort(low: int, high: int):       # 排序 nums[low:high]（左閉右開）
            if high - low <= 1:
                return

            mid = (low + high) // 2
            sort(low, mid)
            sort(mid, high)

            i, j, k = low, mid, low
            while i < mid or j < high:
                if j >= high or (i < mid and nums[i] <= nums[j]):
                    temp[k] = nums[i]
                    i += 1
                else:
                    temp[k] = nums[j]
                    j += 1
                k += 1

            nums[low:high] = temp[low:high]  # 抄回原陣列

        sort(0, n)
        return nums
```

### 主要參數說明：

- `low`、`high`：左閉右開區間 `[low, high)`，終止條件是 `high - low <= 1`。
- `mid`：左半是 `[low, mid)`，右半是 `[mid, high)`。
- `temp`：merge 時**只寫**；`nums` 在 merge 時**只讀**。合併完才從 `temp` 抄回 `nums`。
- `<=`：值相等時先取左邊，讓排序**穩定**。計數題會依賴這一點。

## 模板二：Merge Sort 計數骨架

所有計數題都是這個形狀，只有中間的計數段在換：

```python
def solve(low: int, high: int) -> int:      # 回傳 nums[low:high] 內的 pair 數
    if high - low <= 1:
        return 0

    mid = (low + high) // 2
    count = solve(low, mid) + solve(mid, high)

    # ── 只有這段隨題目改變 ──
    j = mid
    for i in range(low, mid):               # 左右兩半都已排序
        while j < high and <條件(nums[i], nums[j])>:
            j += 1
        count += <跟 j 有關的數量>
    # ──────────────────────

    nums[low:high] = sorted(nums[low:high])  # 或手寫 merge
    return count
```

`sorted()` 在這裡會偵測到兩段已排序的 run，實際上接近線性，可以 AC。面試官要求手寫時，就換成模板一的 merge。

## 計數位置怎麼決定

寫計數段之前先問兩個問題：

1. **計數條件跟排序條件一樣嗎？** 一樣的話，可以在 merge 的同時計數；不一樣的話，要**先掃一遍計數，再合併**。
2. **把條件改寫成「`nums[j]` 跟某個值比較」之後，符合的 `j` 是右半的前綴、後綴，還是中間一段？**

| 題目 | 條件 | 計數方式 | 加多少 |
|---|---|---|---|
| LCR 170 逆序對 | `a[i] > a[j]` | merge 時取**右邊**才計數 | `mid - i`：左半還剩幾個 |
| LC 315 | 每個元素右邊有幾個比它小 | merge 時取**左邊**才計數，帶原 index | `j - mid`：右半已取走幾個 |
| LC 493 | `a[i] > 2 * a[j]` | 先掃再合併，符合的是**前綴** | `j - mid` |
| LC 2426 | `d[i] - d[j] <= diff` | 先掃再合併，符合的是**後綴** | `high - j` |
| LC 327 / 4051 | 子陣列和落在區間 | 先掃再合併，符合的是**中間一段** | `r - l`，兩個指針 |

記法：**算誰的答案，就在取出誰的時候計數。**

## 模板三：Linked List Merge Sort（LC 148 / LC 23）

Linked list 上的 merge 只要改指標，不需要 `temp`：

```python
def merge(a, b):                             # LC 21
    dummy = tail = ListNode()
    while a and b:
        if a.val <= b.val:
            tail.next = a
            a = a.next
        else:
            tail.next = b
            b = b.next
        tail = tail.next
    tail.next = a or b                       # 剩下的整段直接接上
    return dummy.next

def sortList(head):                          # LC 148
    if not head or not head.next:
        return head
    slow, fast = head, head.next             # fast 先走一步
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next
    mid = slow.next
    slow.next = None                         # 從切口斷開
    return merge(sortList(head), sortList(mid))
```

`fast` 從 `head.next` 開始，是因為**要切斷 list，就要站在切口前面**。不確定時代入 2 個節點，檢查能不能切成 `[1]` 和 `[2]`。

LC 23 是把「每條 list」當成一個元素做 merge sort，merge 一樣是 LC 21。

## 複雜度

- 時間 `O(n log n)`：切 `log n` 層，每層 merge 和計數的總工作量是 `O(n)`。最好、最壞都一樣。
- 空間 `O(n)`：陣列版的 `temp`，加上 `O(log n)` 的遞迴深度。Linked list 版只有遞迴深度。

## 什麼時候不用 Merge Sort

- **只問存不存在，不問有幾個**：LC 775 問的是 global 和 local inversion 是否相等。local 是 global 的子集，所以只要檢查「距離 ≥ 2 的逆序對」存不存在，`O(n)` 就能解決。
- **更新和查詢交錯進行**：merge sort 只能離線處理。像 LC 307 這種要一邊更新一邊查詢的題目，要用 BIT（Fenwick Tree）或線段樹。
- **同一批計數題的第二套解法是 BIT**：從右往左掃，用 BIT 查「已看過的值中有幾個落在某區間」。值域大時要先離散化。

## 常見錯誤

這些都是我練習時實際寫錯過的：

- **右半沒有遞迴**：寫成 `sort(mid, lo)`，右半直接 return，merge 拿到沒排序的資料。
- **merge 時讀錯陣列**：寫成 `temp[k] = temp[i]`。賦值號左邊一定是 `temp`，右邊一定是 `nums`。
- **區間公式直接抄別人的**：閉區間寫法是 `m - i + 1`，左閉右開要改成 `mid - i`。
- **該累加的地方寫成賦值**：`bad = r - l` 會蓋掉遞迴結果和前面的計數，要寫 `bad += r - l`。
- **用 `<` 而不是 `<=`**：逆序對會把相等的 pair 也算進去。
- **前綴、後綴搞反**：LC 2426 的符合範圍是後綴，照搬 LC 493 的 `j - mid` 會錯。
- **忘記極端參數**：LC 4051 的 `k = 0` 時，雙指針的 `r - l` 會變成負數。
- **巢狀函式改外層的 int**：`count += x` 是對名字賦值，需要 `nonlocal`，或改用回傳值。`tmp[k] = x` 是改物件內容，不需要。
- **變數名稱撞到內建名稱**：`lists` 寫成 `list`，`list[low]` 不會報錯，要到之後讀 `.val` 才出現 `AttributeError`。

## 相關 LeetCode

練習梯子，依難度排序：

- `LC 88` Merge Sorted Array
- `LC 912` Sort an Array
- `LC 21` Merge Two Sorted Lists
- `LC 148` Sort List
- `LCR 170` 交易逆序對的總數（劍指 Offer 51）
- `LC 315` Count of Smaller Numbers After Self
- `LC 493` Reverse Pairs
- `LC 327` Count of Range Sum
- `LC 2426` Number of Pairs Satisfying Inequality
- `LC 4051` Count Subarrays with Distant Sums
- `LC 23` Merge k Sorted Lists
- `LC 775` Global and Local Inversions
