
.text

main:
	# Prompt user to enter m
	la	$a0, prompt_for_m	# load addr. of prompt_for_m into $a0
	li	$v0, 4			# 4 is the print_string syscall
	syscall				# do the syscall

	# Read the value of m
	li	$v0, 5			# 5 is the read_int syscall
	syscall				# do the syscall
	move	$s0, $v0		# $s0 = m
	
	# Prompt user to enter n
	la	$a0, prompt_for_n	# load addr. of prompt_for_n into $a0
	li	$v0, 4			# 4 is the print_string syscall
	syscall				# do the syscall

	# Read the value of n
	li	$v0, 5			# 5 is the read_int syscall
	syscall				# do the syscall
	move	$s1, $v0		# $s1 = n
	
	# Prompt user to enter s
	la	$a0, prompt_for_s	# load addr. of prompt_for_s into $a0
	li	$v0, 4			# 4 is the print_string syscall
	syscall				# do the syscall

	# Read the value of s
	li	$v0, 5			# 5 is the read_int syscall
	syscall				# do the syscall
	move	$s2, $v0		# $s2 = s

	subu	$sp, $sp, 20
	sw	$s0, 0($sp)
	sw	$s1, 4($sp)
	sw	$s2, 8($sp)
	sw	$fp, 12($sp)
	sw	$ra, 16($sp)
	move	$fp, $sp

	mul	$s6, $s0, $s1
	mul	$s6, $s6, 4
	subu	$sp, $sp, $t0
	subu	$sp, $sp, $t0
	addu	$s6, $s6, $sp

	li	$s0, 47
	mul	$s0, $s0, 7
	add	$s0, $s0, 1

	li	$s1, 100

	li	$s2, 482
	sub	$s2, $s2, 1

	lw	$s3, 8($fp)

	li	$s4, 0
	li	$s5, 0
	
	# sw	$s3, $t0($sp)

fill_A:
	lw	$t0, 0($fp)
	bge	$s4, $t0, end_fill_A
	li	$s5, 0
	
fill_Ai:
	lw	$t0, 4($fp)
	bge	$s5, $t0, end_fill_Ai

	sw	$s3, 0($s6)

	mul	$s3, $s0, $s3
	add	$s3, $s3, $s1
	rem	$s3, $s3, $s2

	addu	$s6, $s6, 4
	add	$s5, $s5, 1
	b	fill_Ai

end_fill_Ai:
	add	$s4, $s4, 1
	b	fill_A

end_fill_A:

	# print matrix A
	lw	$a0, 0($fp)
	lw	$a1, 4($fp)

	mul	$a2, $a0, $a1
	mul	$a2, $a2, 4
	add	$a2, $a2, $sp

	jal	matPrint

	lw	$a0, 0($fp)
	lw	$a1, 4($fp)
	move	$a3, $sp
	mul	$a2, $a0, $a1
	mul $a2, $a2, 4
	add	$a2, $a2, $sp
	jal	matTrans
	
	b	end_prog
	
	move	$a2, $sp
	jal matPrint

	# end the program
	b	end_prog

end_prog:

	lw	$t0, 0($fp)
	lw	$t1, 4($fp)
	mul	$t0, $t0, $t1
	mul		$t0, $t0, 8

	move	$a0, $t0
	li	$v0, 1
	syscall

	addu	$sp, $sp, $t0
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$fp, 12($sp)
	lw	$ra, 16($sp)
	addu	$sp, $sp, 20
	
	li	$v0, 10			# 10 is the exit syscall
	syscall				# do the syscall
	
matPrint:
	move	$s0, $a0
	move	$s1, $a1
	li	$s2, 0
	li	$s3, 0
	move	$s4, $a2

outer_print:
	bge	$s2, $s0, end_outer_print

	li	$s3, 0

inner_print:
	bge	$s3, $s1, end_inner_print

	lw	$a0, 0($s4)
	li	$v0, 1
	syscall

	la	$a0, string_space
	li	$v0, 4
	syscall

	addu	$s4, $s4, 4
	add	$s3, $s3, 1
	b	inner_print

end_inner_print:
	la	$a0, string_new_line
	li	$v0, 4
	syscall

	add	$s2, $s2, 1
	b	outer_print

end_outer_print:

	jr	$ra

matTrans:
	move	$s0, $a0				# m
	move	$s1, $a1				# n
	move	$s2, $a2				# Address of A(m, n)	
	move	$s3, $a3				# Address of B(n, m)

	li	$s4, 0					# i = 0
	li	$s5, 0					# j = 0
	
outer_trans:

	bge		$s4, $s0, end_outer_trans
	
	li		$s5, 0
	
inner_trans:

	bge		$s5, $s1, end_inner_trans
	
	lw		$t0, 0($s2)
	sw		$t0, 0($s3)
	
	addu	$s2, $s2, 4
	
	mul		$t0, $s0, 4
	addu	$s3, $s3, $t0
	
	add		$s5, $s5, 1
	
	b		inner_trans
	
end_inner_trans:
	
	mul		$t0, $s0, $s1
	mul		$t0, $t0, 4
	subu	$s3, $s3, $t0
	addu	$s3, $s3, 4
	
	add		$s4, $s4, 1
	
	b		outer_trans
	
end_outer_trans:

	jr		$ra
	

.data
	.align 2
	prompt_for_m:	.asciiz	"Enter positive integer m : "
	prompt_for_n:	.asciiz	"Enter positive integer n : "
	prompt_for_s:	.asciiz	"Enter positive integer s : "
	string_space:	.asciiz " "
	string_new_line:	.asciiz	"\n"
		

