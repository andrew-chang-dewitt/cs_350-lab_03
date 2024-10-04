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
# 	.include "debug.s"

## --- BEGIN PROGRAM ---
	.globl main

	.data
	# Example: A=(2, 4, 6), B=(1,3)
	#    sum_arr(A, B, x, y) => C=(3,7,6)
# A:	.word 2, 4, 6
# B:	.word 1, 3
# x:	.word 3
# y:	.word 2
# C:	.word 0, 0, 0 # init C as empty
	# test cases from prompt:
	# 1) A=(10,20,30,40), B=(90,80,70,60,50)
	#    sum_arr(A, B, x, y) => C=(100, 100, 100, 100, 50)
A:	.word 10, 20, 30, 40
B:	.word 90, 80, 70, 60, 50
x:	.word 4
y:	.word 5
C:	.word 0, 0, 0, 0, 0 # init C as empty
	# 2) A=(3,2,1,0,1,2,3), B=(7,8,9,10,9,8,7)
	#    sum_arr(A, B, x, y) => C=(10,10,10,10,10,10,10)
# A:	.word 3, 2, 1, 0, 1, 2, 3
# B:	.word 7, 8, 9, 10, 9, 8, 7
# x:	.word 7
# y:	.word 7
# C:	.word 0, 0, 0, 0, 0, 0, 0 # init C as empty

comma:  .string ", "
colon:  .string ": "
nline:  .string "\n"

	.text
main:
	# load A & B into position for sum_arr(...)
	la a0 A          # &A <- pointer to A[0]
	la t0 x          # &x
	lw a1 0(t0)      # x <- *t0
	la a2 B          # &B <- pointer to B[0]
	la t0 y          # &y
	lw a3 0(t0)      # y <- *t0
	jal ra sum_arr
# 	debug("got arr ptr", a0, 34)
# 	debug("got arr len", a1, 1)
# 	debug("passing arr ptr to print", a0, 34)
# 	debug("passing arr len to print", a1, 1)

	# C already in position from sum_arr return for printing results
	jal ra print_arr

	j exit
# END main

# BEGIN sum_arr(A, x, B, y) is
# input:  a0: A <- ptr to unordered array of unsigned ints
#         a1: x <- length of A
#         a2: B <- ptr to unordered array of unsigned ints
#         a3: y <- length of B
# output: a0: C <- ptr to array of sums
#         a1: z <- int repr length of array
sum_arr:
	# SETUP:
	addi sp sp -4     # push return addr to stack
	sw ra 0(sp)

	# BODY:
	bge a3 a1 sa_b_ge # if a is longer:
# 	debug_msg("A is longer than B")
	add s0 a0 x0 # s0 <- ptr for indexing longer array
	add s1 a2 x0 # s1 <- ptr for indexing shorter (or equal) array
	la s2 C # s2 <- ptr for indexing result array
	add s5 s2 x0 # save original C ptr for return value
	add s6 a1 x0 # save longer distance as distance of result array
	slli a1 a1 2
	add s3 a1 s0 # s3 <- end of longer array
	slli a3 a3 2
	add s4 a3 s0 # s4 <- end of shorter array
	j sa_sum_loop

sa_b_ge:	     # else b is longer
# 	debug_msg("B is longer than A")
	add s0 a2 x0 # s0 <- ptr for indexing longer array
	add s1 a0 x0 # s1 <- ptr for indexing shorter (or equal) array
	la s2 C # s2 <- ptr for indexing result array
	add s5 s2 x0 # save original C ptr for return value
	add s6 a3 x0 # save longer distance as distance of result array
	slli a3 a3 2
	add s3 a3 s0 # s3 <- end of longer array
	slli a1 a1 2
	add s4 a1 s0 # s4 <- end of shorter array

sa_sum_loop:
# 	debug("for i", s0, 34)
	lw t0 0(s0)  # t0 <- load s0
# 	debug("a_i", t0, 1)
	lw t1 0(s1)  # t1 <- load s1
# 	debug("b_i", t1, 1)
	add t2 t1 t0 # t2 <- t0 + t1
	sw t2 0(s2)  # mem@s2 <- t2
# 	debug("put into c_i", t2, 1)
	addi s0 s0 4 # s0 + 4
# 	debug("incremented i to", s0, 34)
	addi s1 s1 4 # s1 + 4
	addi s2 s2 4 # s2 + 4
# 	debug("is i still less than s4", s4, 34)
	bge s0 s4 sa_rst_loop # if s4 < s0, goto rest loop
# 	debug_msg("yes, going again")
	j sa_sum_loop # else, go again

sa_rst_loop:
# 	debug_msg("no, going to rest loop")
	lw t0 0(s0)  # t0 <- load s0
# 	debug("a_i", t0, 1)
	sw t0 0(s2)  # mem@s2 <- t0
# 	debug("put into c_i", t0, 1)
	addi s0 s0 4 # s0 + 4
# 	debug("incremented i to", s0, 34)
	addi s2 s2 4 # s2 + 4
# 	debug("is i still less than s3", s3, 34)
	bge s0 s3 sa_exit # if s3 < s0, goto fn exit
# 	debug_msg("yes, going again")
	j sa_rst_loop # else, go again


sa_exit:
# 	debug_msg("no, going to fn exit")
	add a0 s5 x0 # a0 <- s5, ptr to result array
	add a1 s6 x0 # a1 <- s6, value of result array length
# 	debug("returning arr ptr", a0, 34)
# 	debug("returning arr len", a1, 1)
	# TEARDOWN:
	lw ra 0(sp)
	addi sp sp 4      # pop return addr from stack
	jr ra
# END sum_arr


# BEGIN print_arr(A, n) is
# input:  a0: A <- ptr to unordered array of unsigned ints
#         a1: n <- length of A
# output: none
# side effect: print every array entry to stdout
print_arr:
	# BODY:
	# prepare to print results
# 	debug("given arr ptr", a0, 34)
# 	debug("given arr len", a1, 1)
	la t2 comma       # ptr to array element delimiter
	la t3 nline       # ptr to newline char
	slli a1 a1 2      # multiply length by 4 to get as words
	addi a1 a1 -4
	add t1 a0 a1      # n-1 <- ptr to end of A
	add t0 a0 x0      # i <- a_0 addr
	# print results in loop
pa_loop:
                          # loop from i to n-1:
# 	debug("for i", t0, 34)
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
	jr ra
# END print_arr

exit:
	addi a7, x0, 10	  # set up exit call
	ecall             # exit
