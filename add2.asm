
main:
		# Get first number from user, put into $t0
		li 		$v0, 5			# load syscall read_int into $v0
		syscall					# make the syscall.
		move	$t0, $v0		# move the number read into $t0.
		
		# Get second number from user, puto into $t1
		li		$v0, 5
		syscall
		move 	$t1, $v0
		
		add $t2, $t0, $t1
		
		move	$a0, $t2
		li		$v0, 1
		syscall
		
		li		$v0, 10
		syscall

