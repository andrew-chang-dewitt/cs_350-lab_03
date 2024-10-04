## # Task 2: Sum of two arrays (8 points)
## Code with risc-v to implement adding elements in array A and B as a new array C. Save your
## work as task2.s. A and B have x and y elements respectively (x and y may not be equal). In C,
## ci=ai+bi, where ai and bi are elements from A and B. z is the size of C. If A and B do not have the
## same length, bring the rest of elements in the longer array to the C directly. Print all elements in
## C to the screen.
##
## ## Example:
##
## Input:
##   A=(2, 4, 6)
##   B=(1,3)
##   x=3
##   y=4
##   z=3
##   C=(0,0,0)
##
## Output:
##   C=(3,7,6)
##
## Test your program with different values of A and B. Please save the screenshot of the two test
## cases below.
##   1) A=(10,20,30,40), B=(90,80,70,60,50)
##   2) A=(3,2,1,0,1,2,3), B=(7,8,9,10,9,8,7)

	.data
	# Example: A=(2, 4, 6), B=(1,3)
	#    sum_arr(A, B, x, y) => C=(3,7,6)
A:	.word 2, 4, 6
B:	.word 1, 3
x:	.word 3
y:	.word 2
z:	.word 3
C:	.word 0, 0, 0 # init C as empty
	# test cases from prompt:
	# 1) A=(10,20,30,40), B=(90,80,70,60,50)
	#    sum_arr(A, B, x, y) => C=(100, 100, 100, 100, 50)
# A:	.word 10, 20, 30, 40
# B:	.word 90, 80, 70, 60, 50
# x:	.word 4
# y:	.word 5
# z:	.word 5
# C:	.word 0, 0, 0, 0, 0 # init C as empty
	# 2) A=(3,2,1,0,1,2,3), B=(7,8,9,10,9,8,7)
	#    sum_arr(A, B, x, y) => C=(10,10,10,10,10,10,10)
# A:	.word 3, 2, 1, 0, 1, 2, 3
# B:	.word 7, 8, 9, 10, 9, 8, 7
# x:	.word 7
# y:	.word 7
# z:	.word 7
# C:	.word 0, 0, 0, 0, 0, 0, 0 # init C as empty
comma:  .string ", "
colon:  .string ": "
nline:  .string "\n"

	.text

main:
	la a0 A         # &A <- pointer to A[0]
	la t0 x         # &x
	lw a1 0(t0)     # x <- *t0
	la a2 B         # &B <- pointer to B[0]
	la t0 y         # &y
	lw a3 0(t0)     # y <- *t0
	jal ra sum_arr
	la a0 C         # &C <- pointer to C[0]
	la t0 z         # &z
	lw a1 0(t0)     # z <- *t0
	jal ra print_arr
	j exit
# END main

sum_arr:
	# sum_arr(A, x, B, y) is
	# input:  a0: A <- ptr to unordered array of unsigned ints
	#         a1: x <- length of A
	#         a2: B <- ptr to unordered array of unsigned ints
	#         a3: y <- length of B
	# output: a0: C <- ptr to array of sums
	#         a1: z <- int repr length of array
	# SETUP:
	addi sp sp -4     # push return addr to stack
	sw ra 0(sp)

	# BODY:
	jal ra print_arr  # print A (ptr in a0 & len in a1 already)
	add a0 a2 x0      # print B start by setting up args
	add a1 a3 x0
	jal ra print_arr

	# TEARDOWN:
	lw ra 0(sp)
	addi sp sp 4      # pop return addr from stack
	jr ra
# END sum_arr


print_arr:
	# print_arr(A, n) is
	# input:  a0: A <- ptr to unordered array of unsigned ints
	#         a1: n <- length of A
	# output: none
	# side effect: print every array entry to stdout
	# SETUP:
	addi sp sp -4     # push return addr to stack
	sw ra 0(sp)

	# BODY:
	# prepare to print results
	la t2 comma       # ptr to array element delimiter
	la t3 nline       # ptr to newline char
	slli a1 a1 2      # multiply length by 4 to get as words
	addi a1 a1 -4
	add t1 a0 a1      # n-1 <- ptr to end of A
	add t0 a0 x0      # i <- a_0 addr
	# print results in loop
pa_loop:
			  # loop from i to n-1:
	lw a0 0(t0)       # printing int value in each a_i
	addi a7 x0 1
	ecall
	addi t0 t0 4      # i += 4 to increment by word
	blt t1 t0 pa_exit # if i < n, loop again, else goto exit
	add a0 t2 x0      # print comma & space
	li a7 4
	ecall
	j pa_loop
	# exit loop
pa_exit: 
	add a0 t3 x0      # print newline for readability
	addi a7 x0 4
	ecall

	# TEARDOWN:
	lw ra 0(sp)
	addi sp sp 4      # pop return addr from stack
	jr ra
	jr ra
# END print_arr

exit:
	addi a7, x0, 10		# set up exit call
	ecall			# exit
