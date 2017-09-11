# Group - 28
# Heeramani Prasad (15CS30015) and Himanshu Pareek (15CS30016)
# Date - Sep. 10, 2017
# Assembly programe to fine determinant of square matrix
# using recursive subroutine findDat

.text

# main function to start program
# takes order of matrix and seed (s) from the user
# into s0 and s1 registers respectively.
main:
		# Prompts the user for a positive integer n
		la		$a0, prompt_for_n				# load address of prompt_for_n into a0
		li		$v0, 4							# 4 is the print_string syscall
		syscall									# do the syscall
		
		# Read the integer entered by the user
		li		$v0, 5							# 5 is the read_int syscall
		syscall									# do the syscall
		
		move	$s0, $v0						# move n into s0
		
		blez	$s0, neg_n_error				# if n <= 0, goto the label neg_n_error
		
		# Allocate space for square matrix A on stack
		mul		$t0, $s0, $s0					# t0 = n * n
		mul		$t0, $t0, 4						# t0 = 4 * n * n
		subu	$sp, $sp, $t0					# sp = sp - 4 * n * n
		
		# Prompt the user for a positive integer s
		la		$a0, prompt_for_s				# load address of prompt_for_s into a0
		li		$v0, 4							# 4 is the print_string syscall
		syscall									# do the syscall
		
		# Read the integer entered by the user
		li		$v0, 5							# 5 is the read_int syscall
		syscall									# do the syscall
		
		move	$s1, $v0						# move s into s1
		
		blez	$s1, neg_s_error				# if s <= 0, goto the label neg_s_error
		
		# Populating the array A with random numbers generated using the linear congruential scheme: x(n+1) = (a * x(n) + c) % m, taking a = 7 * 47 + 1, c = 100 and m = 482 - 1. Let x(0) = s(the seed)
		
		# Calculating a
		li		$s2, 47							# a = 47
		mul		$s2, $s2, 7						# a = 47 * 7
		add		$s2, $s2, 1						# a = 47 * 7 + 1
		
		# Calculating c
		li		$s3, 100						# c = 100
		
		# Calculating m
		li		$s4, 482						# m = 482
		sub		$s4, $s4, 1						# m = 482 - 1
		
		li		$s5, 0							# i = 0
		li		$s6, 0							# j = 0
		
# Label to populate the array A with random numbers
populate_A:
		
		bge		$s5, $s0, end_populate_A		# if (i >= n) goto label end_populate_A else goto next inst.
		
		li		$s6, 0							# j = 0
		
populate_Ai:

		bge		$s6, $s0, end_populate_Ai		# if (j >= n) goto label end_populate_Ai else goto next inst.
		
		# M[sp] = s  ==> *(&A) = s
		sw		$s1, ($sp)						# store s into current address of A
		
		# Update s for next entry
		mul		$s1, $s1, $s2					# s = s * a
		add		$s1, $s1, $s3					# s = s * a + c
		rem		$s1, $s1, $s4					# s = ( s * a + c ) % m
		
		add		$s6, $s6, 1						# j = j + 1
		
		add		$sp, $sp, 4						# sp = sp + 4
		
		b		populate_Ai						# goto label populate_Ai
		
end_populate_Ai:

		add		$s5, $s5, 1						# i = i + 1
		
		b		populate_A						# goto label populate_A
		
end_populate_A:

		# Send sp back to top of stack
		mul		$t0, $s0, $s0					# t0 = n * n
		mul		$t0, $t0, 4						# t0 = 4 * n * n
		subu	$sp, $sp, $t0					# sp = sp - 4 * n * n
		
		# Call matPrint function to print the matrix A
		move	$a0, $s0						# first argument (order of matrix)
		move	$a1, $sp						# second argument (address of matrix)
		jal		matPrint						# call subroutine
		
		# Call findDet to calculate the determinant of the matrix A
		move	$a0, $s0						# first argument (order of matrix)
		move	$a1, $sp						# second argument (address of matrix)
		jal		findDet							# call subroutine to fine determinant
		
		move	$t0, $v0						# move the returned value (determinant) into register t0
		
		la		$a0, string_dotted_line			# load address of string_dotted_line into a0
		li		$v0, 4							# 4 is the print_string syscall
		syscall									# do the syscall
		
		la		$a0, string_final_det			# load the sddress of string_final_det into a0
		li		$v0, 4							# 4 is the print_string syscall
		syscall									# do the syscall
		
		move	$a0, $t0						# move value of determinant into a0 to print it
		li		$v0, 1							# 1 is the print_int syscall
		syscall									# do the syscall
		
		la		$a0, string_new_line			# move the address of string_new_line into a0
		li		$v0, 4							# 4 is the print_string syscall
		syscall									# do the syscall

		li		$v0, 10							# 10 is the exit syscall
		syscall									# do the syscall
		
		
		
# Function to print the matrix
# Registers used : 
#					s0 - to store order of matrix
#					s1 - to store address of matrix
#					s2 - to store value of local variable i
#					s3 - to store value of local variable j
matPrint:

		# Store the variables of registers on top of stack 
		subu	$sp, $sp, 24					# make space for 6 registers
		sw		$ra, 20($sp)
		sw		$fp, 16($sp)
		sw		$s0, 12($sp)
		sw		$s1, 8($sp)
		sw		$s2, 4($sp)
		sw		$s3, ($sp)
		add		$fp, $sp, 16
		
		move	$s0, $a0						# move n into s0
		move	$s1, $a1						# move address of A into s1
		
		li		$s2, 0							# i = 0
		li		$s3, 0							# j = 0
		
print_A:

		bge		$s2, $s0, end_print_A			# if ( i >= n) goto label end_print_A, else goto next inst.
		
		li		$s3, 0							# j = 0
		
print_Ai:

		bge		$s3, $s0, end_print_Ai			# if (j >= n) goto label end_print_Ai, else goto next inst.
		
		lw	$a0, 0($s1)							# load element at address of A into a0
		li	$v0, 1								# 1 is the print_int syscall
		syscall									# do the syscall

		la	$a0, string_space					# load address of string_space into a0
		li	$v0, 4								# 4 is the print_string syscall
		syscall									# do the syscall

		addu	$s1, $s1, 4						# add 4 to address of A to get next value
		add		$s3, $s3, 1						# j = j + 1
		b		print_Ai						# goto label print_Ai
		
end_print_Ai:

		la	$a0, string_new_line				# load the address of string_new_line into a0
		li	$v0, 4								# 4 is the print_string syscall
		syscall									# do the syscall

		add		$s2, $s2, 1						# i = i + 1
		b		print_A							# goto label print_A
		
end_print_A:

		# Load the values into registers back from the stack
		lw		$ra, 20($sp)
		lw		$fp, 16($fp)
		lw		$s0, 12($sp)
		lw		$s1, 8($sp)
		lw		$s2, 4($sp)
		lw		$s3, ($sp)
		addu	$sp, $sp, 24
		
		jr		$ra								# return from the function
		
# recursive function to find the determinant of a square matrix
# s0 - n (order of matrix)
# s1 - address of the matrix array on stack (this will change)
# s2 - address of the mateix array on stack (this will not change)
# s3 - local variable i
# s4 - local variable j
# s5 - local variable k
# s6 - address of the adjecancy matrix (computed using s2)
# s7 - value of determinant
findDet:

		# store the contents of registers on the top of stack
		subu	$sp, $sp, 40				# make space for contents of 10 registers
		sw		$ra, 36($sp)
		sw		$fp, 32($sp)
		sw		$s0, 28($sp)
		sw		$s1, 24($sp)
		sw		$s2, 20($sp)
		sw		$s3, 16($sp)
		sw		$s4, 12($sp)
		sw		$s5, 8($sp)
		sw		$s6, 4($sp)
		sw		$s7, ($sp)
		addu	$fp, $sp, 32
		
		move	$s0, $a0					# move n into s0
		move	$s1, $a1					# move address of matrix into s1
		
		move	$s2, $s1					# s2 = address of matrix
		
		beq		$s0, 1, base_case_det		# if matrix is of order 1 send directly to base_case
		
		li		$s3, 0						# i = 0
		li		$s7, 0						# det = 0
		
while_loop:

		bge		$s3, $s0, end_while_loop	# if (i >= n) goto label end_while_loop
		
		# calculate s6 = s2 + 4 * n
		mul		$t0, $s0, 4					# t0 = n * 4
		addu	$s6, $s2, $t0				# s6 = s2 + 4 * n
		
		# make space for adjoint matrix of Matrix[0][i]
		sub		$t0, $s0, 1					# t0 = n - 1
		mul		$t0, $t0, $t0				# t0 = (n - 1) * (n - 1)
		mul		$t0, $t0, 4					# t0 = 4 * (n - 1) * (n - 1)
		
		subu	$sp, $sp, $t0				# sp = sp - 4 * (n - 1) * (n - 1)
		
		li		$s4, 1						# j = 0
		li		$s5, 0						# k = 0
		
while_for_loop:

		bge		$s4, $s0, end_while_for_loop	# if (j >= n) goto label end_while_for_loop
		
		li		$s5, 0							# k = 0
		
while_inner_for_loop:

		bge		$s5, $s0, end_while_inner_for_loop	# if (k >= n) goto label end_while_inner_for_loop
		
		beq		$s5, $s3, continue_while_for_loop	# if (k == i) goto label continue_while_for_loop to skip this value of k
		
		lw		$t0, ($s6)							# load value at location s6 into t0	(original matrix)
		sw		$t0, ($sp)							# store content of t0 at sp (adjoint matrix)
		
		addu	$s6, $s6, 4							# move pointer of s6 ahead by one word
		addu	$sp, $sp, 4							# move pointer of sp ahead by one word
		
		add		$s5, $s5, 1							# k = k + 1
				
		b		while_inner_for_loop				# goto while_inner_for_loop
		
continue_while_for_loop:	

		add		$s5, $s5, 1							# k = k + 1
		addu	$s6, $s6, 4							# move pointer of s6 ahead by one word to skip content at location i
		
		b		while_inner_for_loop				# go back to inner for loop
		
end_while_inner_for_loop:

		add		$s4, $s4, 1							# j = j + 1
		
		b		while_for_loop						# go back to for loop
		
end_while_for_loop:

		# Move sp back to top of adjoint matrix (sp = sp - 4 (n-1)^2)
		sub		$t0, $s0, 1							# t0 = n - 1
		mul		$t0, $t0, $t0						# t0 = (n - 1) * (n - 1)
		mul		$t0, $t0, 4							# t0 = 4 * (n - 1) * (n - 1)
		
		subu	$sp, $sp, $t0						# sp = sp - 4 * (n - 1) * (n - 1)
		
		# Checking for sign (+1 if i is odd else -1)
		rem		$t0, $s3, 2							# t0 = i % 2
		beq		$t0, 1, negative_det				# if t0 == 1 ==> i is odd goto negative_det label, else continue
		
		# Call findDet function for adjoint matrix (order = n - 1, address = sp)
		sub		$a0, $s0, 1							# order of matrix = n - 1
		move	$a1, $sp							# address of matrix = sp
		jal		findDet								# recursive call to function to calculate determinant of adjoint matrix
		
		move	$t2, $v0							# move the determinant of adjoint matrix into register t2
		
		# Free space of ajoint matrix (sp = sp + 4 * (n -1)**2)
		sub		$t0, $s0, 1							# t0 = n - 1					
		mul		$t0, $t0, $t0						# t0 = (n - 1) * (n - 1)
		mul		$t0, $t0, 4							# t0 = 4 * (n - 1) * (n - 1)
		
		addu	$sp, $sp, $t0						# sp = sp + 4 * (n - 1) * (n - 1)
		
		lw		$t1, ($s1)							# load content of s1 (element Matrix[0][i]) into t1
			
		mul		$t0, $t2, $t1						# t0 = Matrix[0][i] * det(Adj(Matrix[0][i])
		add		$s7, $s7, $t0						# det = det + t0
		
		b		after_add							# goto label after_add
		
		
negative_det:

		# Call findDet function for adjoint matrix (order = n - 1, address = sp)
		sub		$a0, $s0, 1							# order of matrix = n - 1
		move	$a1, $sp							# address of matrix = sp
		jal		findDet								# recursive call to function to calculate determinant of adjoint matrix
		
		move	$t2, $v0							# move the determinant of adjoint matrix into register t2
		
		# Free space of ajoint matrix (sp = sp + 4 * (n -1)**2)
		sub		$t0, $s0, 1							# t0 = n - 1					
		mul		$t0, $t0, $t0						# t0 = (n - 1) * (n - 1)
		mul		$t0, $t0, 4							# t0 = 4 * (n - 1) * (n - 1)
		
		addu	$sp, $sp, $t0						# sp = sp + 4 * (n - 1) * (n - 1)
		
		lw		$t1, ($s1)							# load content of s1 (element Matrix[0][i]) into t1
			
		mul		$t0, $t2, $t1						# t0 = Matrix[0][i] * det(Adj(Matrix[0][i])
		sub		$s7, $s7, $t0						# det = det - t0
		
		
after_add:
		
		addu	$s1, $s1, 4							# s1 = s1 + 4 ==> (s1) = Matrix[0][i + 1]
		add		$s3, $s3, 1							# i = i + 1
		
		b		while_loop							# restart while loop

end_while_loop:

		la		$a0, string_dotted_line				# load the address of string_dotted_line into a0
		li		$v0, 4								# 4 is the print_string syscall
		syscall										# do the syscall

		la		$a0, string_matrix_passed			# load the address of string_matrix_passed into a0
		li		$v0, 4								# 4 is the print_string syscall
		syscall										# do the syscall
		
		move	$a0, $s0							# first argument is order of matrix
		move	$a1, $s2							# second argyment is address of matrix
		jal		matPrint							# call matPrint to print the matrix
		
		la		$a0, string_matrix_det				# load the address of string_matrix_det into a0
		li		$v0, 4								# 4 is the print_string syscall
		syscall										# do the syscall
		
		move	$a0, $s7							# move the det into a0 (argument for print_int)
		li		$v0, 1								# 1 is the print_int syscall
		syscall										# do the syscall
		
		la		$a0, string_new_line				# load the address of string_new_line into a0
		li		$v0, 4								# 4 is the print_string_syscall
		syscall										# do the syscall
		
		rem		$v0, $s7, 1000000007				# take the mod of answer to avoid arithmatic overflow
		
		# load register back from top of stack
		lw		$ra, 36($sp)
		lw		$fp, 32($sp)
		lw		$s0, 28($sp)
		lw		$s1, 24($sp)
		lw		$s2, 20($sp)
		lw		$s3, 16($sp)
		lw		$s4, 12($sp)
		lw		$s5, 8($sp)
		lw		$s6, 4($sp)
		lw		$s7, ($sp)
		addu	$sp, $sp, 40						# free space on stack
		
		jr		$ra									# return from the subroutine
		
base_case_det:

		lw		$s7, ($s1)						# In base case the determinant is the very first element at the location s1
		b		end_while_loop					# goto label end_while_loop
				
neg_n_error:

		la		$a0, string_neg_n				# load the address of string_neg_n into a0
		li		$v0, 4							# 4 is the print_string syscall
		syscall									# do the syscall
		
		b		main							# goto label main
		
neg_s_error:

		la		$a0, string_neg_s				# load the address of string_neg_s into a0
		li		$v0, 4							# 4 is the print_string syscall
		syscall									# do the syscall
		
		b		main							# goto label main
	
	
# This is data used in the program	
.data

		prompt_for_n:	.asciiz	"Enter the order of the square matrix whose determinant is to be found : "
		prompt_for_s:	.asciiz	"Enter some positive integer for the value of the seed s : "
		string_neg_n:	.asciiz	"ERROR! n must be a positive integer.\n\t\tTry again...\n\n"
		string_neg_s:	.asciiz	"ERROR! s must be a positive integer.\n\t\tTry again...\n\n"
		string_space:	.asciiz "\t"
		string_new_line:	.asciiz	"\n\n"
		string_matrix_passed:	.asciiz	"The matrix passed on this invocation is : \n\n"
		string_matrix_det:	.asciiz	"The determinant value returned in this invocation is : "
		string_dotted_line:	.asciiz	"--------------------------\n\n"
		string_final_det:	.asciiz	"Finally the determinant is : "
		


# end recursiveDeterminant.asm

