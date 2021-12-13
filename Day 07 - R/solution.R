library(stringr)

input_file <- "./input.txt"

file_content <- paste(readLines(input_file, encoding = "UTF-8"), collapse = " ")
numbers <- as.integer(str_split(file_content, ",")[[1]])

abs_of_minus <- function(minuend, subtrahend) {
  return( abs(minuend - subtrahend) )
}

sum_from_one_to_abs_of_minus <- function(x, c) {
  return( sum(c(1:abs_of_minus(x, c))) )
}

# Part 1
median <- round(median(numbers))

subs <- unlist(lapply(numbers, abs_of_minus, subtrahend = median)) 

print("Part 1:")
print(sum(subs))

# Part 2
cost_for_value <- function(list, c) {
  return( sum(unlist(lapply(list, sum_from_one_to_abs_of_minus, c = c))) )
}

mean <- round(mean(numbers))
possible_middles <- c(mean-1, mean, mean+1)
values_for_middle <- unlist(lapply(possible_middles, cost_for_value, list = numbers))

print("Part 2:")
print(min(values_for_middle))