# analysis.R -- the four functions Part 2 asks for.
#
# Each stub below carries what it receives, what it must return, the constraint
# the grader enforces on it, and one worked call using the published sample. The
# grader calls each function with this sample and with other inputs. A function
# that reproduces the sample but breaks the rules fails on those other inputs.
#
# The published sample, used by every example here:
#
#   sample_scores <- c(Ada = 8, Grace = NA_real_, Linus = 12, Barbara = 4)

# clean_scores_vector(scores)
#
# scores:  a numeric vector, possibly carrying a `names` attribute, and possibly
#          holding NA values.
# returns: a double vector of the same length, carrying the same names, where
#          every NA has become 0 and every other element is min(2 * score, 20).
#
# Vector expressions and subassignment only. No for, while, repeat, Map, lapply,
# sapply, or vapply. The grader reads the calls in this function's body and fails
# the run when it finds a call to one of those. A word in a string does not
# count. The constraint is checked whether or not the numbers come out right.
#
#   clean_scores_vector(sample_scores)
#   #     Ada   Grace   Linus Barbara
#   #      16       0      20       8
#
# A logical vector the same length as `scores`, placed inside [ ] on the left of
# <-, replaces exactly the elements it marks and leaves the names attached. That
# is the subassignment the constraint is asking for.
clean_scores_vector <- function(scores) {
    # stop("TODO: implement clean_scores_vector()")

    out <- pmin(2 * scores, 20)  # pmin for not just one comparison but whole elements
    out[is.na(out)] <- 0
    out 
}

# clean_scores_scalar(scores)
#
# scores:  the same input as clean_scores_vector().
# returns: the same output as clean_scores_vector(), element for element,
#          including the names.
#
# This one must use a `for` loop and handle one element per pass, and it must not
# call clean_scores_vector(). The grader checks both. The loop gives you an
# element-at-a-time strategy to compare with R's vectorized strategy in
# ANALYSIS.md. R still represents each selected value as a length-one vector.
#
#   clean_scores_scalar(sample_scores)
#   #     Ada   Grace   Linus Barbara
#   #      16       0      20       8
#
# Copy `scores` into a local double vector that keeps the names:
# out <- setNames(as.double(scores), names(scores)). A bare as.double() drops
# the names. A plain copy of integer input stays integer when the loop never
# writes to it. Write each result back with out[[i]] <- value, which keeps the
# names attached. Accumulating into a fresh vector with out <- c(out, value)
# drops them, and the check compares with identical(), which notices.
clean_scores_scalar <- function(scores) {
    out <- setNames(as.double(scores), names(scores))
    for (i in seq_along(out)) {
        if (is.na(out[[i]])) {
            out[[i]] <- 0
        } else {
            out[[i]] <- min(2 * out[[i]], 20)
        }
    }
    out
}

# build_roster(student_names, groups, scores)
#
# student_names: a character vector of names.
# groups:        a character vector of group labels, the same length.
# scores:        a numeric vector of raw scores, the same length, possibly named.
# returns:       a data frame with five columns, in this order:
#                  name            the names as character values
#                  group           a factor whose levels follow first appearance
#                                  in `groups`
#                  raw_score       the scores with their names removed
#                  adjusted_score  clean_scores_vector(scores), names removed
#                  passed          TRUE when adjusted_score is at least 12
#
# Build it with stringsAsFactors = FALSE. The `group` column is an explicit
# factor, so that setting only affects `name`, which has to stay character.
#
#   build_roster(c("Ada", "Grace", "Linus", "Barbara"),
#                c("red", "blue", "red", "blue"),
#                sample_scores)
#   #      name group raw_score adjusted_score passed
#   # 1     Ada   red         8             16   TRUE
#   # 2   Grace  blue        NA              0  FALSE
#   # 3   Linus   red        12             20   TRUE
#   # 4 Barbara  blue         4              8  FALSE
#
# factor(groups) sorts its levels, which for "red" and "blue" gives the wrong
# order. factor(groups, levels = unique(groups)) keeps first-appearance order.
# unname() is what strips the names off the two score columns.
build_roster <- function(student_names, groups, scores) {
    adjusted <- clean_scores_vector(scores)
    data.frame(
        name = student_names,
        group = factor(groups, levels = unique(groups)),
        raw_score = unname(scores),
        adjusted_score = unname(adjusted),
        passed = unname(adjusted) >= 12,
        stringsAsFactors = FALSE
    )
}

# summarize_roster(roster)
#
# roster:  a data frame built by build_roster().
# returns: a list with these five items, in this order, with these types:
#            rows           integer, the row count
#            missing_raw    integer, how many raw_score values are NA
#            mean_adjusted  double, the mean of adjusted_score
#            passed         character, the names of students whose passed is TRUE
#            mean_by_group  a named double vector with no dim attribute, one
#                           mean of adjusted_score per level of the group
#                           factor, named by that level, in level order
#
# The check compares with identical(), so the types are graded as strictly as
# the numbers. nrow() and sum() over a logical already give integers, and mean()
# gives a double. tapply() looks like the tool for mean_by_group and returns a
# one-dimensional array, which carries a dim attribute and fails identical()
# even when it prints the same two numbers.
#
#   summarize_roster(build_roster(...))    # the call above
#   # List of 5
#   #  $ rows         : int 4
#   #  $ missing_raw  : int 1
#   #  $ mean_adjusted: num 11
#   #  $ passed       : chr [1:2] "Ada" "Linus"
#   #  $ mean_by_group: Named num [1:2] 18 4
#   #   ..- attr(*, "names")= chr [1:2] "red" "blue"
#
# split() can divide adjusted_score by every factor level. vapply() can then
# compute one mean for each part and return a named vector with no dimensions.
summarize_roster <- function(roster) {
    # stop("TODO: implement summarize_roster()")

    list(
        rows = nrow(roster),
        missing_raw = sum(is.na(roster$raw_score)),
        mean_adjusted = mean(roster$adjusted_score),
        passed = roster$name[roster$passed],
        mean_by_group = vapply(split(roster$adjusted_score, roster$group), mean, numeric(1))
        # split for combining all the adjusted score values by group
        # vapply for every group -> compute mean and then it needs to be a double
    )

    
}