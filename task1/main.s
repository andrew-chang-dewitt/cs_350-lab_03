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
comma:  .string ", "
	# max_last(A) => mutate A to be 2, -1, 3, 8, 10, 5, 4, -20, 6, 23
	# TODO: add test cases from assignment here
	.text
main:	# # max_last(A) is
	# #   input:       A <- unordered array of unsigned ints
	# #                     in terms of a_i s.t. i is in [0..9]
	# #   output:      None
	# #   side-effect: swap last term in A w/ max term in A
	li s0 40        # n  <- length of A in bytes, 10 * 4
	la s1 A         # &A <- pointer to A[0]
	la s2 comma    # &A <- pointer to A[0]
	# lw a0 0(s1)   # mv <- max value, init as a0
	# add t3 x0 x0  # mi <- max index, init as 0
	# addi t4 x0 4  # i  <- temp value track current loop iteration (1..n-1),
	#               # init i @ 1 byte to skip first value as it's already in max

loop:	# # loop from i to n-1:
	# blt a0 t2 endif #   if mv < a_i:
	# #     mv <- a_i
	# #     mi <- i

endif:	# # end loop iteration
	# addi t4 t4 1    # i++
	# blt t4 s0 loop  # check if i < n
	# # end loop
	# # swap a_n-1 & a_mi
	# # tmp <- a_n-1

	li t4 0         # i <- 0 reset loop counter
print:	# print every array entry
	                # loop from i to n-1:
	add t5 t4 s1    # get pointer to i by adding loop counter to a0 location
	lw a0 0(t5)     #   arg0 <- val in a_i
	li a7 1         #   arg7 <- print code
	ecall           #   exec print
	# FIXME: somehow we're printing 12 elements instead of 10?
	#        check math on incrementing i, maybe add a print statement for it
	blt s0 t4 exit  # check if loop keeps printing, if so:
	add a0 s2 x0    # print array item delimiter
	li a7 4
	ecall
	addi t4 t4 4    # i += 4 to increment by word
	j print         # and go again

exit:
	addi a7, x0, 10		# set up exit call
	ecall			# exit
