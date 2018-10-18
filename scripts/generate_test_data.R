expression <- matrix(rnorm(90), 10, 9, dimnames = list(paste0("C", seq_len(10)), paste0("G", seq_len(9))))
write.csv(expression, outputs[["expression"]])
