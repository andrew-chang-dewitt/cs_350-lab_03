## debug.s
##
## a set of tools for debugging using the old print("here") method
##
## supplies some macros to make it easier:
##
## 1) debug_msg(<msg>) -> prints msg to stdout, followed by newline
## 2) debug_reg(<reg>, <code>) -> prints register using given ecall code
## 3) debug(<msg>, <reg>, <code>) -> prints "<msg>: <val>" where val is contents of register parsed using given ecall <code>


## --- MACRO DEFINITIONS ---

	.macro debug_msg (%msg)
	.data
msg:	.asciz %msg
nline:  .string "\n"
	.text
	# SETUP:
	addi sp sp -8 # push return addr and args to stack
	sw a0 0(sp)
	sw a7 4(sp)

	# BODY
	la a0 msg      # print msg
	li a7 4
	ecall
	la a0 nline    # followed by newline for readability
	addi a7 x0 4
	ecall

	# TEARDOWN
	lw a0 0(sp)
	lw a7 4(sp)
	addi sp sp 8 # pop args & return addr from stack
	.end_macro

	.macro debug_reg (%reg %code)
	.data
nline:  .string "\n"
	.text
	# SETUP:
	addi sp sp -8 # push return addr and args to stack
	sw a0 0(sp)
	sw a7 4(sp)

	# BODY
	li a0 %reg   # print reg
	li a7 %code  # using code
	ecall
	la a0 nline  # followed by newline for readability
	addi a7 x0 4
	ecall

	# TEARDOWN
	lw a7 4(sp)
	lw a0 0(sp)
	addi sp sp 8 # pop args & return addr from stack
	.end_macro

	.macro debug(%msg, %reg %code)
	.data
msg:	.asciz %msg
colon:  .string ": "
nline:  .string "\n"
	.text
	# SETUP:
	addi sp sp -8 # push return addr and args to stack
	sw a0 0(sp)
	sw a7 4(sp)

	# BODY
	la a0 msg        # print msg
	li a7 4
	ecall
	la a0 colon      # separated by colon for readability
	addi a7 x0 4
	ecall
	add a0 %reg x0   # print reg
	li a7 %code      # using code
	ecall
	la a0 nline      # followed by newline for readability
	addi a7 x0 4
	ecall

	# TEARDOWN
	lw a7 4(sp)
	lw a0 0(sp)
	addi sp sp 8 # pop args & return addr from stack
	.end_macro
