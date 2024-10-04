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
##    max_last(A) => A=(7,12,3,6,23,-2,-122,10,1,90)
## 2. A=(1205,5523,703,66,-324,0,-9,80,5048,990)
##    max_last(A) => A=(1205,703,66,-324,0,-9,80,5048,990,5523)
	.data
A:	.word 2, -1, 3, 8, 10, 5, 4, 23, -20, 6
	# max_last(A) => mutate A to be (2, -1, 3, 8, 10, 5, 4, -20, 6, 23)
	# test cases from prompt:
# A:	.word 7, 12, 3, 6, 23, 90, -2, -122, 10, 1
	# max_last(A) => A=(7, 12, 3, 6, 23, -2, -122, 10, 1, 90)
# A:	.word 1205, 5523, 703, 66, -324, 0, -9, 80, 5048, 990
	# max_last(A) => A=(1205, 703, 66, -324, 0, -9, 80, 5048, 990, 5523)
comma:  .string ", "

	.text

main:	la s0 A         # &A <- pointer to A[0]

	# # max_last(A) is
	# #   input:       A <- ptr to unordered array of unsigned ints
	# #                     in terms of a_i s.t. i is in [0..9]
	# #   output:      None
	# #   side-effect: swap last term in A w/ max term in A
	addi s1 s0 36   # ptr to A[n-1] to know when to stop processing A
	lw s2 0(s0)     # max value so far <- a_1
	add s3 s0 x0    # addr of max so far <- addr a_1

	# set up to loop over A
	addi s4 s0 4    # i  <- temp value track current loop iteration (1..n-1),

loop:	# from i to n-1:
	lw t1 0(s4)     # get a_i
	blt t1 s2 endif # if a_i < max, do nothing
	add s2 t1 x0    # else update max to a_i
	add s3 s4 x0    # and max index to addr of a_i
	# then prepare to loop again
endif:	addi s4 s4 4    # i++
	blt s4 s1 loop  # loop again if i still < n-1
	# else end loop

	# move max to end, shifting everything else down 1 word
move:   # j <- max value addr; used as loop counter since it already
	# points to addr to start processing at
	lw t1 4(s3)     # get value 1 past current addr
	sw t1 0(s3)     # and store it in current addr
	addi s3 s3 4    # j++
	blt s3 s1 move  # loop again if j < n-1
	# else end loop
	sw s2 0(s1)     # move max to a_n-1

	# prepare to print results
	la s2 comma    # &A <- pointer to A[0]
	add s4 s0 x0    # i <- 0 reset loop counter
print:	# print every array entry
			# loop from i to n-1:
	lw a0 0(s4)     #   arg0 <- val in a_i
	li a7 1         #   arg7 <- print code
	ecall           #   exec print
	addi s4 s4 4    # i += 4 to increment by word
	blt s1 s4 exit  # if i < n, loop again, else goto exit
	add a0 s2 x0    # print array item delimiter
	li a7 4
	ecall
	j print         # and go again

exit:
	addi a7, x0, 10		# set up exit call
	ecall			# exit
