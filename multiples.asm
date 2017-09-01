.text

main:
	li	$v0, 5
	syscall
	move	$t0, $v0

	li	$v0, 5
	syscall
	move	$t1, $v0

	blez	$t1, terminate
	mul	$t2, $t0, $t1
	move	$t3, $t0

loop:
	move	$a0, $t3
	li	$v0, 1
	syscall

	beq	$t3, $t2, terminate
	add	$t3, $t3, $t0

	la	$a0, spaceC
	li	$v0, 4
	syscall

	b	loop

terminate:
	li	$v0, 10
	syscall

.data
	spaceC:	.asciiz	" "


# end multiples.asm
