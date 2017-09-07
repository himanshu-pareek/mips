# Group - 28
# Heeramani Prasad (15CS30015) and
# Himanshu Pareek (15CS30016)		 -- Sep. 09, 2017
# transpose.asm -- A program that computes transpose of a matrix
#				and prints the result
# Registers used:
# 		$s0		- used to hold the value of m
#		$s1		- used to hold the value of n
#		$s2		- used to hold the value of s

.text						# Subsequent items (instructions) stored in Text segmen t at next available address

main:
	# Prompt user to enter m
	la	$a0, prompt_for_m		# load addr. of prompt_for_m into $a0
	li	$v0, 4					# 4 is the print_string syscall
	syscall						# do the syscall

	# Read the value of m
	li	$v0, 5					# 5 is the read_int syscall
	syscall						# do the syscall
	move	$s0, $v0			# $s0 = m
	
	# Prompt user to enter n
	la	$a0, prompt_for_n		# load addr. of prompt_for_n into $a0
	li	$v0, 4					# 4 is the print_string syscall
	syscall						# do the syscall

	# Read the value of n
	li	$v0, 5					# 5 is the read_int syscall
	syscall						# do the syscall
	move	$s1, $v0			# $s1 = n
	
	# Prompt user to enter s
	la	$a0, prompt_for_s		# load addr. of prompt_for_s into $a0
	li	$v0, 4					# 4 is the print_string syscall
	syscall						# do the syscall

	# Read the value of s
	li	$v0, 5					# 5 is the read_int syscall
	syscall						# do the syscall
	move	$s2, $v0			# $s2 = s
	
	# Check for wrong input (m, n and s all must be positive)
	blez	$s0, wrong_input	# If m is less than or equal to 0, go to label wrong_input
	blez	$s1, wrong_input	# If n is less than or equal to 0, go to label wrong_input
	blez	$s2, wrong_input	# If s is less than or equal to 0, go to label wrong_input

	# storing variables on stack
	subu	$sp, $sp, 20		# allocate space for 5 integers (sp = sp - (5 * 4))
	sw	$s0, 0($sp)				# M[sp + 0] = m
	sw	$s1, 4($sp)				# M[sp + 4] = n
	sw	$s2, 8($sp)				# M[sp + 8] = s
	sw	$fp, 12($sp)			# M[sp + 12] = fp
	sw	$ra, 16($sp)			# M[sp + 16] = ra
	move	$fp, $sp			# fp = sp

	# Create space for two matrices (each will be represented as 2d array)
	mul	$s6, $s0, $s1			# s6 = m * n
	mul	$s6, $s6, 4				# s6 = 4 * m * n
	subu	$sp, $sp, $s6		# sp = sp - 4mn	(space for A)
	subu	$sp, $sp, $s6		# sp = sp - 4mn	(space for B)
	addu	$s6, $s6, $sp		# s6 = sp + s6 (address of A)

	# Xn+1 = (aXn + c) mod m, taking a = 7 * 47+1, c = 100 and m = 482-1. Let X0 = s (the seed)
	# Calculating a
	li	$s0, 47					# a is saved in s0, a = 47
	mul	$s0, $s0, 7				# a = a * 7 = 47 * 7
	add	$s0, $s0, 1				# a = a + 1 = 7 * 47 + 1
	
	li	$s1, 100				# c is stored in s1, c = 100

	li	$s2, 482				# m is stored in s2, m = 482
	sub	$s2, $s2, 1				# m = m - 1 = 482 - 1

	lw	$s3, 8($fp)				# load value of s from stack into s3

	li	$s4, 0					# i = 0
	li	$s5, 0					# j = 0

# fill_A is to fill the values into Matrix A
fill_A:							
	lw	$t0, 0($fp)				# load value of m into t0
	bge	$s4, $t0, end_fill_A	# if (i >= m) goto label end_fill_A
	li	$s5, 0					# j = 0

# inner loop for fill A	
fill_Ai:
	lw	$t0, 4($fp)				# load value of n into t0
	bge	$s5, $t0, end_fill_Ai	# if (j >= n) goto label end_fill_Ai

	# Store value of s into A[i][j]
	sw	$s3, 0($s6)				# M[s6 + 0] = s

	# calculate next value of s
	mul	$s3, $s0, $s3			# s = s * a
	add	$s3, $s3, $s1			# s = s + c
	rem	$s3, $s3, $s2			# s = s mod m

	# Go to next pointer in A
	addu	$s6, $s6, 4			# s6 = s6 + 4
	add	$s5, $s5, 1				# j = j + 1
	b	fill_Ai					# goto label fill_Ai (inner loop)

end_fill_Ai:					# end of inner for loop
	add	$s4, $s4, 1				# i = i + 1
	b	fill_A					# run outer for loop again

end_fill_A:						# end of outer for loop

	la	$a0, matrix_a_string	# load address of matrix_a_string into a0
	li	$v0, 4					# 4 is the print_string syscall
	syscall						# do the syscall

	# print matrix A
	
	lw	$a0, 0($fp)				# load the m into parameter register a0
	lw	$a1, 4($fp)				# load the n into parameter register a1

	mul	$a2, $a0, $a1			# a2 = m * n
	mul	$a2, $a2, 4				# a2 = 4 * m * n
	add	$a2, $a2, $sp			# a2 = sp + a2 (address of A)

	# Pass a0(m), a1(n) and a2(address of A) and call module matPrint
	jal	matPrint				# call matPrint
	
	la	$a0, string_transposing	# load the address of string_transposing into a0
	li	$v0, 4					# 4 is the print_string syscall
	syscall						# do the syscall

	lw	$a0, 0($fp)				# load m into parameter register a0
	lw	$a1, 4($fp)				# load n into parameter register a1
	move	$a3, $sp			# a3 = sp (address of Matrix B)
	mul	$a2, $a0, $a1			# a2 = m * n
	mul $a2, $a2, 4				# a2 = 4 * m * n
	add	$a2, $a2, $sp			# a2 = sp + 4 * m * n (address of Matrix A)
	jal	matTrans				# call matTrans module
	
	la	$a0, matrix_b_string	# load the address of matrix_b_string into a0
	li	$v0, 4					# 4 is the print_string syscall
	syscall						# do the syscall
	
	# Calling matPrint function to print matrix B
	lw		$a0, 4($fp)			# load n into a0
	lw		$a1, 0($fp)			# load m into a1
	move	$a2, $sp			# load address of B(sp) into a2
	jal matPrint				# call matPrint

	# end the program
	b	end_prog				# goto label end_prog

# end of program
end_prog:

	lw	$t0, 0($fp)				# load m into t0
	lw	$t1, 4($fp)				# load n into t1
	mul	$t0, $t0, $t1			# to = m * n
	mul		$t0, $t0, 8			# to = 8 * m * n

	addu	$sp, $sp, $t0		# deallocate space fo A and B by sp = sp + t0
	lw	$s0, 0($sp)				# load m into s0
	lw	$s1, 4($sp)				# load n into s1
	lw	$s2, 8($sp)				# load s into s2
	lw	$fp, 12($sp)			# load fp into fp
	lw	$ra, 16($sp)			# load ra into ra
	addu	$sp, $sp, 20		# deallocate all the space by sp = sp + 20
	
	li	$v0, 10					# 10 is the exit syscall
	syscall						# do the syscall
	
# module to print the matrix
# s0 - a0 - m (number of rows)
# s1 - a1 - n (number of columns)
# s2 - i (local variable)
# s3 - j (local variable)
# s4 - a2 - address of matrix
matPrint:
	move	$s0, $a0			# s0 = m
	move	$s1, $a1			# s1 = n
	li	$s2, 0					# i = 0
	li	$s3, 0					# j = 0
	move	$s4, $a2			# s4 = address of A

# outer for loop to print matrix A
outer_print:
	bge	$s2, $s0, end_outer_print	# if (i >= m) goto label end_outer_print

	li	$s3, 0						# j = 0

# inner for loop to print row of matrix A
inner_print:
	bge	$s3, $s1, end_inner_print	# if (j >= n) goto label end_inner_print

	lw	$a0, 0($s4)					# load element at address of A into a0
	li	$v0, 1						# 1 is the print_int syscall
	syscall							# do the syscall

	la	$a0, string_space			# load address of string_space into a0
	li	$v0, 4						# 4 is the print_string syscall
	syscall							# do the syscall

	addu	$s4, $s4, 4				# add 4 to address of A to get next value
	add	$s3, $s3, 1					# i = i + 1
	b	inner_print					# goto label inner_print

end_inner_print:					# end of inner for loop
	la	$a0, string_new_line		# load the address of string_new_line into a0
	li	$v0, 4						# 4 is the print_string syscall
	syscall							# do the syscall

	add	$s2, $s2, 1					# i = i + 1
	b	outer_print					# goto the label outer_print

end_outer_print:					# end of outer for loop
	
	jr	$ra							# return from function

# function to calculate B = A'
# a0 - m
# a1 - n
# a2 - address of A(m, n)
# a3 - address of B(n, m)
matTrans:
	move	$s0, $a0				# m
	move	$s1, $a1				# n
	move	$s2, $a2				# Address of A(m, n)	
	move	$s3, $a3				# Address of B(n, m)

	li	$s4, 0						# i = 0
	li	$s5, 0						# j = 0
	
outer_trans:							# outer for loop to calculate Transpose

	bge		$s4, $s0, end_outer_trans	# if (i >= m) goto label end_outer_trans
	
	li		$s5, 0						# j = 0
	
inner_trans:							# inner for loop to calculate Transpose

	bge		$s5, $s1, end_inner_trans	# if (j >= n) goto label end_inner_trans
	
	# Do the transpose
	lw		$t0, 0($s2)					# load value at current address of A into t0 to = M[s2]
	sw		$t0, 0($s3)					# store value of t0 at current address of B		M[s3] = t0
	
	addu	$s2, $s2, 4					# Add 4 to address of A
	
	# Add 4 * m to address of B
	mul		$t0, $s0, 4					# to = 4 * m
	addu	$s3, $s3, $t0				# s3 = s3 + 4 * m 
	
	add		$s5, $s5, 1					# j = j + 1
	
	b		inner_trans					# goto label inner_trans
	
end_inner_trans:						# end of inner for loop 
	
	# Access address of next column of B by subtracting 4mn and adding 4
	mul		$t0, $s0, $s1				# to = m * n
	mul		$t0, $t0, 4					# t0 = 4 * m * n
	subu	$s3, $s3, $t0				# s3 = s3 - 4 * m * n
	addu	$s3, $s3, 4					# s3 = s3 + 4
	
	add		$s4, $s4, 1					# i = i + 1
	
	b		outer_trans					# goto label outer_trans
	
end_outer_trans:						# end of outer for loop

	jr		$ra							# return from function to main

# This label will be executed when user enters wrong input	
wrong_input:
	
	la		$a0, wrong_inp_string		# load the address of wrong_inp_string into a0
	li		$v0, 4						# 4 is the print_string syscall
	syscall								# do the syscall
	
	b		main						# goto the labe main

# data to be used in the program
.data
	.align 2
	prompt_for_m:	.asciiz	"Enter positive integer m : "
	prompt_for_n:	.asciiz	"Enter positive integer n : "
	prompt_for_s:	.asciiz	"Enter positive integer s : "
	string_space:	.asciiz "\t"
	string_new_line:	.asciiz	"\n\n"
	matrix_a_string:	.asciiz	"\n\n---------------------------------------------------------\n                                 MATRIX A                                     \n---------------------------------------------------------\n\n"
	matrix_b_string:	.asciiz "\n\n---------------------------------------------------------\n                                 MATRIX B                                     \n---------------------------------------------------------\n\n"
	string_transposing:	.asciiz	"\n\n\t\t\tCalculating Matrix B = Transponse (Matrix A)...\n\n\n"
	wrong_inp_string:	.asciiz	"\n ERROR! m, n and s, all must be positive integers. Try again...\n\n"
	
# end transpose.asm
