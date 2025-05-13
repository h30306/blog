---
title: "LeetCode 1109: Corporate Flight Bookings"
summary: "LeetCode Problem Solving"
description: "LeetCode Daily"
date: 2025-04-27
tags: ["LeetCode", "difference array", "medium"]

cascade:
  showEdit: true
  showSummary: true
  hideFeatureImage: false
draft: false
---

## Meta Data

Difficulty: medium
First Attempt: 2025-04-27
- Total time: 5:00.00

## Intuition

This is a classic **difference array** problem with a known array size `n`.  
Thus, we can directly initialize a difference array of size `n + 1`.  
Then, iterate through the `bookings` array to apply the difference updates to the appropriate indices.  
Finally, perform a prefix sum over the difference array to reconstruct the final number of booked seats for each flight.


## Approach

```python
class Solution:
    def corpFlightBookings(self, bookings: List[List[int]], n: int) -> List[int]:
        diff_array = [0]*(n+1)

        for start, end, seat in bookings:
            diff_array[start-1] += seat
            diff_array[end] -= seat

        res = []
        diff = 0
        for seat in diff_array[:-1]:
            diff += seat
            res.append(diff)

        return res
```
- `start - 1` because flight numbering is 1-indexed but the array is 0-indexed.
- `end` cancels the added seat count after the last flight of the booking.
- Finally, a prefix sum restores the actual number of seats booked for each flight.

## Findings

N/A

## Encountered Problems 

I encountered an index not found error the first time,  
because I didn't realize that the flight numbers were 1-indexed.  
This caused an off-by-one mistake when updating the difference array.  
After adjusting `start` to `start - 1`, the problem was solved.
