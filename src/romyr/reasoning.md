# Reasoning Before Execution

## P01
`c()` coerces every element to the most flexible type present (logical < integer < double < character), so `TRUE` becomes 1 and `2L` becomes 2 in a double vector. Three inputs give length 3, and a plain vector has no `dim`.

## P02
The string `"2"` makes `c()` coerce the result to character, giving length 3 with no `dim`. I expect only the element that started as a string to be written in quotes, while `1L` and `TRUE` keep their original form.

Correction: I predicted `[1,"2",TRUE]`, thinking only the `"2"` would be quoted. R printed `["1","2","TRUE"]` because once one element is character, `c()` turns every element into a string, including `1L` and `TRUE`.

## P03
Arithmetic is element-wise and recycles the shorter vector, so `c(1L, 2L)` repeats to `1,2,1,2` and the sums are 11, 22, 31, 42. Integer plus integer stays integer, the length matches the longer vector (4), and there is no `dim`.

## P04
A positive integer index selects elements in the order given and keeps their names, so `[c(3L, 1L)]` returns `third=9` then `first=8`. The type stays integer, length 2, no `dim`.

## P05
A negative index drops that position, so `[-2L]` removes the 7 and keeps 4 and 9 as an integer vector of length 2 with no `dim`.

Correction: I predicted `[4,7]`. R printed `[4,9]` because `[-2L]` drops the second element, the 7, so 4 and 9 are left. My reasoning said this, but I wrote the wrong number in the table.

## P06
A logical index keeps the positions where it is `TRUE`. `is.na(x) | x > 10L` is `F,T,T,F`, because `TRUE | NA` is `TRUE`, so NA and 12 are kept. The type stays integer, length 2, no `dim`.

## P07
A factor stores integer codes pointing into its levels, so `typeof` is integer and the length is the 3 data values, with no `dim`. I expect the labels and levels to be written as the quoted strings they came from, with the labels in data order and the levels in the given `levels` order.

Correction: I predicted `factor["low","high","low"];levels=["low","high"]` with each label in quotes. R printed `factor[low,high,low];levels=[low,high]` because a factor's labels and levels are written as bare level names, not as quoted strings.

## P08
A list keeps each element with its own type and name, so `scores` stays an integer vector and `label` a character vector. Length counts the 2 top-level elements, and a list has no `dim`.

## P09
A data frame is a list of equal-length columns, so `typeof` is list, length is the number of columns (2), and `dim` is rows x columns (2x2). I expect the value to list each column by name without the size, with the logical column written as the strings `"TRUE"` and `"FALSE"`.

## P10
`matrix(1:6, nrow = 2L)` fills column by column, so 6 values in 2 rows gives 2x3, and `c(10L, 20L)` is recycled down each column. Integer plus integer stays integer, and the length counts all 6 cells. I expect the value to be written as `matrix(...)` with the cells in column order.

## P11
`mean()` returns `NA` when any input is `NA` unless `na.rm = TRUE`, and the result is a double of length 1 with no `dim`.

## P12
`na.rm = TRUE` drops the `NA` before averaging, so the mean of 8 and 10 is 9, a double of length 1 with no `dim`.

## P13
Assigning a double into an integer vector promotes the whole vector to double, so `x` becomes 1, 2.5, 3 with length 3 and no `dim`.

## P14
`ifelse()` puts 0 where the score is `NA` and doubles the rest (14, 24, 8), and the result is double because both branches are double. Assigning 15 to the positions where `adjusted > 15` then caps 24 at 15. Length stays 4, no `dim`.

## P15
`array()` with `dim = c(2L, 2L, 2L)` places the 8 integers in column order across a 2x2x2 shape, so the type is integer and the length is 8. I expect the value to be written as `array(...)` with the cells in column order.

## P16
Index `0` matches no position, so the result is an empty integer vector with length 0 and no `dim`. I expect the value to still show 4, the first element.
