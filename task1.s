	.data
A:	.word 2, -1, 3, 8, 10, 5, 4, 23, -20, 6
	# max_last(A) => mutate A to be 2, -1, 3, 8, 10, 5, 4, -20, 6, 23
	# TODO: add test cases from assignment here
	.text
main: 	# max_last(A) is
	#   input: 	 A <- 	unordered array of unsigned ints
	# 			in terms of a_i s.t. i is in [0..9]
	#   output: 	 None
	#   side-effect: swap last term in A w/ max term in A
	# n  <- length of A, 10
	# &A <- pointer to A[0]
	# ma <- max value, init as a_0
	# mi <- max index, init as 0
	# i  <- temp value track current loop iteration (1..n-1), init @ 1
	# skip first value as it's already stored in max
	# loop from i to n-1: 
	#   if mv < a_i:
	#     mv <- a_i
	#     mi <- i
	# end loop
	# swap a_n-1 & a_mi

	# i <- 0 reset loop counter
  # print every array
  # loop from i to n-1:
	#   arg? <- val in a_i
  #   arg? <- print code
  #   exec print
  # end loop

exit:
	addi a0, x0, 10		# set up exit call
	ecall			# exit
