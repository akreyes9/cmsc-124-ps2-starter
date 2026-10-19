# Vector and Scalar Evaluation



<!-- Replace this paragraph after your checks pass. Trace one input, including the
missing value, through `clean_scores_vector()` and `clean_scores_scalar()`.
Compare the two evaluation models, identify where recycling would change the
answer, and explain which implementation you would keep in an R program. -->

- For this we can use this input as a tracing example 

### Input

- scores <- c(test1 = 8, test2 = NA, test3 = 12, test4 = 4)


### Tracing for clean_scores_vector
- Table version just like previous 124 lec 

| Step | Expression | Result |
|---|---|---|
| start | `scores` | test1 = 8, test2 = NA, test3 = 12, test4 = 4 |
| double | `2 * scores` | 16, NA, 24, 8 |
| cap | `pmin(..., 20)` | 16, NA, 20, 8 *(NA remains NA)* |
| check if is NAs | `is.na(out)` | FALSE, TRUE, FALSE, FALSE |
| replace na | `out[is.na(out)] <- 0` | 16, 0, 20, 8 |

- vectorized method for cleaning scores wherein there is no if and  decisions are depending on the (is.na(out)) -> picks element to overwrite


### Tracing for clean_scores_scalar
- TBD


### Comparison
- For the vectorized
  - one operation per step and is applied to every element
  - no conditional used 
  - logical mask (is.na(out)) is used to pick what element to overwrite


- For the scalar
  - TBD



### Where recycling would change the answer
- Recycling -> conbines two vectors of different lengths in which it repeats the shorter one to match the longer one

- So it happens harmlessly in these situation
    - 2 * scores: the 2 is recycled into 2 2 2 2.
    - pmin(x, 20): the 20 is recycled into 20 20 20 20.

- Where it can change the answer
    - pmin(c(test1 = 16, test2 = 30, test3 = 24, test4 = 18), c(20, 10))
        - caps:   20  10  20  10
        - result: 16  10  20  10


### Which one to keep
- keep the vectoriezed version because it is shorter and more is a much more idiomatic. It is also much more versatile and faster since it hands the whole vector to R's compiled C code, which loops over the elements with almost no per-element cost while the scalar runs the loop in the R interpreter so each set of passes repeats the full call. As time goes on those call adds up and affects the speed of the program. That is a good trade-off for using more memory for it, we replaced speed with memory 