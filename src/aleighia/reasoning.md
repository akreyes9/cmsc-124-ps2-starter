## P01
The coercion ladder runs logical, integer, double, character, and c() stops at the highest type present. 3.5 is a double, TRUE becomes 1 and 2L becomes 2, giving [1,2,3.5] as double. It has length 3 and no dimensions.

## P02
A string is present, so every element becomes character, including 1L, which becomes "1", and TRUE, which becomes "TRUE". The value is ["1","2","TRUE"] with length 3 and no dimensions.

## P03
Arithmetic gets applied element by element, and the shorter 2-element vector recycles: 1,2,1,2 against 10,20,30,40. That gives [11,22,31,42]. Both operands are integer, so the type is integer, with length 4 and no dimensions.

## P04
Positive indices select positions in the order given, so position 3 comes first, then position 1. The names stay attached to their values, giving [third=9,first=8]. The type is integer, the length is 2, and there are no dimensions.

## P05
A negative index excludes only that position, so -2L excludes the second element and keeps the first and third. The value is [4,9], still integer, with length 2 and no dimensions.

## P06
Comparing NA with 10L gives NA, but is.na(x) is TRUE at position 2, and TRUE | NA is TRUE because the known side decides. The combined index is FALSE,TRUE,TRUE,FALSE, which selects the NA and the 12. The value is [NA,12], integer, length 2, no dimensions.

## P07
A factor stores integer codes and carries level labels, so typeof is integer. The levels argument fixes the order as low, high. Length counts the 3 elements and there are no dimensions.

## P08
A list keeps unlike types in separate elements with no coercion, so typeof is list. Length counts the 2 top-level items (scores and label), and a list has no dim.

## P09
A data frame is a list of equal-length columns, so typeof is list. Length counts columns, so it is 2. Its dim is rows by columns, 2x2.

## P10
A matrix is filled and stored by column as 1,2,3,4,5,6 with a dim attribute. The c(10L, 20L) recycles down that stored order: 10,20,10,20,10,20. That gives 11,22,13,24,15,26, which stays integer. The length is 6 (total values) and the dim is 2x3.

## P11
Arithmetic and summaries with a missing value give a missing result, and mean() has no na.rm here. The NA_real_ keeps the vector double, so the value is [NA] as double. The result is a single value, so length 1 and no dimensions.

## P12
na.rm = TRUE drops the missing value before the mean is computed, leaving 8 and 10. Their mean is 9, so the value is [9], double, length 1, no dimensions.

## P13
This is a mixed-mode assignment: writing the double 2.5 into an integer vector widens the whole vector to double. The value is [1,2.5,3] and the type is double. Assignment doesn't add elements, so length stays 3, with no dimensions.

## P14
ifelse makes one choice per position: the NA becomes 0 and the others double, giving 14,0,24,8. The mask adjusted > 15 selects only the 24, and subassignment caps it at 15. The value is [14,0,15,8], double, length 4, no dimensions.

## P15
An array is an atomic vector with a dim attribute. Length is the total number of values, 2x2x2 = 8. The type is integer and the dim is 2x2x2.

## P16
Index 0 selects nothing and returns a zero-length result of the same atomic type. The value is [], the type stays integer, the length is 0, and there are no dimensions.