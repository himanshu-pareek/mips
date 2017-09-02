# Group - 28
# Heeramani Prasad (15CS30015) and
# Himanshu Pareek (15CS30016)		 -- Sep. 02, 2017
# kthLargest.asm -- A program that computes the kth largest
#				3 <= k <= 20, of n integers and prints the 
#				result
# Registers used:
# 		$s0		- used to hold the value of k
#		$s1		- used to hold the value of n
#		$s2		- used to hold the value of i
#		$s3		- used to hold the value of j

.text

main:
		la		$a0, prompt_k			# load the addr of prompt_k into $a0.
		li		$v0, 4					# 4 is the print_string syscall.
		syscall							# do the syscall
		
		li		$v0, 5					# 5 is the read_int syscall.
		syscall							# do the syscall
		move	$s0, $v0				# move the scanned int into $s0 (k).
		
		la		$a0, prompt_n			# load the addr of prompt_n into $a0
		li		$v0, 4					# 4 is the print_string syscall
		syscall							# do the syscall
		
		li		$v0, 5					# 5 is the read_int syscall.
		syscall							# do the syscall
		move	$s1, $v0				# move the scanned int into $s1 (n).
		
		bgt		$s0, $s1, wrong_inp		# if (k > n) goto wrong_inp

		li		$s2, 0					# i <= 0
		mul		$s2, $s1, 4				# i <= n * 4
		add		$s2, $s2, 4				# i <= i + 4
		sub		$sp, $sp, $s2			# $sp <= $sp - i [Creating space for n + 1 integers]
		sub		$s2, $s2, $s2			# i <= i - i ===> i = 0
		
scan_next:
		beq		$s1, $s2, end_scan		# if (n == i) goto end_scan else continue
		
		la		$a0, string_prompt1		# load the addr of string_prompt1 into $a0
		li		$v0, 4					# 4 is for print_string syscall
		syscall							# do the syscall
		
		move	$a0, $s2				# $a0 <= $s2 [a0 <= i]
		li		$v0, 1					# 1 is print_int syscall
		syscall							# do the syscall
		
		la		$a0, string_prompt2		# load the addr of string_prompt2 into $a0.
		li		$v0, 4					# 4 is print_string syscall
		syscall							# do the syscall
		
		li		$v0, 5					# 5 is read_int syscall
		syscall							# do the syscall
		
		mul		$t0, $s2, 4				# $t0 <= 4 * i
		add		$t0, $t0, $sp			# $t0 <= $t0 + $sp
		sw		$v0, 0($t0)				# M[$t0 + 0] <= $v0 ===> M[sp + 4 * i] <= scanned_int
		add		$s2, $s2, 1				# i <= i + 1
		b 		scan_next				# goto scan_next
		
end_scan:
		li		$s2, 0					# i <= 0
		
		la		$a0, string_the			# load addr of string_the into $a0
		li		$v0, 4					# 4 is the print_string syscall
		syscall							# do the syscall
		
		move	$a0, $s0				# $a0 <= k
		li		$v0, 1					# 1 is the print_int syscall
		syscall							# do the syscall
		
		la		$a0, string_fp			# load addr of string_fp into $a0.
		li		$v0, 4					# 4 is the print_string syscall
		syscall							# do the syscall
		
		mul		$t0, $s2, 4				# $t0 <= 4 * i
		add		$t0, $t0, $sp			# $t0 <= $t0 + $sp
		lw		$a0, 0($t0)				# load M[sp + 4 * i] into $a0
		li		$v0, 1					# 1 is the syscall for print_int
		syscall							# do the syscall
		
		add		$s2, $s2, 1				# i <= i + 1
		
print_ints:
		beq		$s1, $s2, end_print		# if (n == i) goto end_print else continue
		
		la		$a0, string_sep			# load addr of string_sep into $a0
		li		$v0, 4					# 4 is the syscall for print_string
		syscall							# do the syscall
		
		mul		$t0, $s2, 4				# $t0 <= 4 * i
		add		$t0, $t0, $sp			# $t0 <= $t0 + $sp
		lw		$a0, 0($t0)				# load M[sp + 4 * i] into $a0
		li		$v0, 1					# 1 is the syscall for print_int
		syscall							# do the syscall
		
		add		$s2, $s2, 1				# i <= i + 1
		b		print_ints				# goto print_ints
		
end_print:
		la		$a0, string_sp			# load the addr of string_sp into $a0
		li		$v0, 4					# 4 is the syscall for print_string
		syscall							# do the syscall
		
		sub		$s3, $s1, 1				# j <= n - 1
		
outer_for:
		beqz	$s3, exit_outer_for		# if (j == 0) goto exit_outer_for else continue
		li		$s2, 0					# i <= 0
		
inner_for:	
		bge		$s2, $s3, end_inner_for	# if (i >= j) goto exit_inner_for else continue
		
		add		$t0, $s2, 1				# $t0 <= i + 1 ==> next <= i + 1
		
		mul		$t1, $s2, 4				# $t1 <= 4 * i
		add		$t2, $sp, $t1			# $t2 <= $sp + $t1
		lw		$t3, ($t2)				# $t3 <= M[$sp + 4 * i] ==> $t3 <= array[i]
		
		mul		$t1, $t0, 4				# $t1 <= 4 * next
		add		$t5, $sp, $t1			# $t5 <= $sp + $t1
		lw		$t4, ($t5)				# $t4 <= M[$sp + 4 * next] ==> $t4 <= array[next]
		
		bge		$t3, $t4, no_swap		# if (array[i] >= array[next]) goto no_swap else continue
		lw		$t1, ($t2)				# $t1 <= array[i]
		lw		$t0, ($t5)				# $t0 <= array[next]
		sw		$t0, ($t2)				# array[i] <= $t0
		sw		$t1, ($t5)				# array[next] <= $t1
		
no_swap:
		add		$s2, $s2, 1				# i <= i + 1
		b		inner_for				# goto inner_for
		
end_inner_for:
		sub		$s3, $s3, 1				# j <= j - 1
		b		outer_for				# goto outer_for
			
exit_outer_for:
		li		$s2, 0					# i <= 0
		
		sub		$t0, $s0, 1				# $t0 <= k - 1
		mul		$t0, $t0, 4				# $t0 <= 4 * (k - 1)
		add		$t0, $sp, $t0			# $t0 <= $sp + 4 * (k - 1)
		lw		$a0, 0($t0)				# load array[k - 1] into $a0
		li		$v0, 1					# 1 is the syscall for print_int
		syscall							# do the syscall
		
		la		$a0, string_new_line	# load the addr of string_new_line_into $a0
		li		$v0, 4					# 4 is the syscall for print_string
		syscall							# do the syscall
		
		b		end_prog
		
wrong_inp:
		la		$a0, string_nk			# load the addr of string_nk into $a0
		li		$v0, 4					# 4 is the syscall for print_string
		syscall							# do the syscall
		
		b		main
		
end_prog:		
		li		$v0, 10					# 10 is the syscall for exit the program
		syscall							# do the syscall
		
		
.data
		prompt_k:	.asciiz	"Enter the value of k: "
		prompt_n:	.asciiz	"Enter the count of elements to be read : "
		string_sep:	.asciiz	", "
		string_the:	.asciiz	"The "
		string_fp:	.asciiz	"-th largest number among [ "
		string_sp:	.asciiz	" ] is : "
		string_new_line:	.asciiz	"\n"
		string_prompt1:		.asciiz	"Enter Element[ "
		string_prompt2:		.asciiz	" ] : "
		string_nk:	.asciiz	"\nError: Value of count must be greater than or equal to k.\nTry again\n\n"

# end kthLargest.asm

		
		
