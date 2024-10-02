## Task 1: Swap elements in an array (8 points)
##
## Please declare an array A in your data segment
## with 10 random integers. Program to find the
## maximum number of A and put it as the last
## element in the array while other elements
## relative order does not change. Then print A[0] 
## to A[9] on the screen.
##
## For example:
## - Input: A=(2,-1,3,8,10,5,4,23,-20,6)
## - Output: A=(2,-1,3,8,10,5,4,-20,6,23)
##
## Test your program by giving different values
## to A. Please save the screenshot of the two
## following test cases:
## 1. A=(7,12,3,6,23,90,-2,-122,10,1)
## 2. A = (1205,5523,703,66,-324,0,-9,80,5048,990)
	.data
A:	.word 2, -1, 3, 8, 10, 5, 4, 23, -20, 6
	# max_last(A) => mutate A to be 2, -1, 3, 8, 10, 5, 4, -20, 6, 23
	# TODO: add test cases from assignment here
	.text
main:	# max_last(A) is
	#   input:       A <- unordered array of unsigned ints
	#                     in terms of a_i s.t. i is in [0..9]
	#   output:      None
	#   side-effect: swap last term in A w/ max term in A
	addi t0 x0 40 # n  <- length of A in bytes, 10 * 4
	la t1 A       # &A <- pointer to A[0]
	lw t2 0(t1)   # mv <- max value, init as a_0
	add t3 x0 x0  # mi <- max index, init as 0
	addi t4 x0 4  # i  <- temp value track current loop iteration (1..n-1), 
	               # init i @ 1 byte to skip first value as it's already in max
loop:	# loop from i to n-1: 
	blt a0 mv endif #   if mv < a_i:
	#     mv <- a_i
	#     mi <- i
endif:	# end loop iteration
	addi t4 t4 1    # i++
	blt t4 t0 loop  # check if i < n
	# end loop
	# swap a_n-1 & a_mi
	# tmp <- a_n-1

	# i <- 0 reset loop counter
print:	# print every array
	# loop from i to n-1:
	#   arg? <- val in a_i
	#   arg? <- print code
	#   exec print
	# end loop

exit:
	addi a0, x0, 10		# set up exit call
	ecall			# exit
