---
title: "LeetCode 71: Simplify Path"
summary: "LeetCode 71 解題筆記：用 / 切開，空字串和 . 跳過，.. 就 pop（根目錄不能再往上），其他名稱 push，最後用 / 接起來"
description: "2022-10-24 的 LeetCode 71 解題紀錄"
date: 2022-10-24
tags: ["medium", "string", "stack"]
categories: ["leetcode"]
cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## 基本資料

難易度: medium
第一次嘗試：2022-10-24
- 提交紀錄：Runtime Error → Wrong Answer ×4 → Runtime Error ×2 → Wrong Answer ×2 → Accepted → Wrong Answer → Accepted → Wrong Answer → Accepted

## 解題思路

用 `/` 切開後每一段（[Stack]({{< relref "/algorithm/Stack" >}}) 模板一）：

- 空字串（連續的 `/`）和 `.`：跳過。
- `..`：stack 不是空的就 `pop`，在根目錄就不動。
- 其他（包括 `...`）：當成目錄名稱 `push`。

答案是 `"/" + "/".join(stack)`，stack 是空的時剛好是 `"/"`。

## 我的嘗試

這題提交了 14 次：

- 第一版想逐字元從後往前處理，判斷 `.` 和 `/` 的條件很亂，`/` 本身就回傳空字串。
- 改成 `split('/')` 加 stack 之後，一個一個補邊界：**根目錄的 `..` 對空的 stack `pop`**（IndexError）、**空字串沒跳過**（`/` 回傳 `//`）、**`.` 沒跳過**（`/.` 回傳 `/.`）。
- 2022-11 重寫兩次，又各漏了一次 `.` 和根目錄的 `..`（`/..` 回傳 `/..`）。

## 正確解法

```python
class Solution:
    def simplifyPath(self, path: str) -> str:
        st = []
        for part in path.split("/"):
            if part == "..":
                if st:
                    st.pop()
            elif part and part != ".":
                st.append(part)
        return "/" + "/".join(st)
```

## 複雜度

時間 `O(n)`，空間 `O(n)`。

## 要特別避免的錯誤

- `split("/")` 會產生空字串，要跳過。
- `.` 要跳過，`...` 是合法的名稱。
- 根目錄的 `..` 不能 `pop` 空的 stack，也不能把 `..` 放進去。

## 面試口說整理

我用斜線把路徑切開，空字串和點跳過，兩個點就把上一層 pop 掉，在根目錄就不動，其他名稱 push 進 stack，最後用斜線接起來。時間 `O(n)`。
