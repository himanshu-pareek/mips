.text

main:
	la	$a0, string_space
	li	$a1, 1024
	li	$v0, 8
	syscall

	la	$t1, string_space
	la	$t2, string_space

length_loop:
	lb	$t3, ($t2)
	beqz	$t3, end_length_loop
	addu	$t2, $t2, 1
	b	length_loop

end_length_loop:
	subu	$t2, $t2, 2

test_loop:
	bge	$t1, $t2, is_palin


.data
	string_space:	.space	1024

