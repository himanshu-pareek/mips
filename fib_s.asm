# fib-- (callee-save method)
# Registered used:
# 	$a0	- initially n.
#	$s0	- parameter n.
#	$s1	- fib (n - 1).
#	$s2	- fib (n - 2).

.text

fib:
	subu	$sp, $sp, 32		# frame size = 32, just because...
	sw	$ra, 28($sp)		# preserve the Return Address.
	sw	$fp, 24($sp)		# preserve the Frame Pointer.
	sw	$s0, 20($sp)		# preserve $s0.
	sw	$s1, 16($sp)		# preserve $s1.
	sw	$s2, 12($sp)		# preserve $s2.
	addu	$fp, $sp, 32		# move Frame Pointer to base of frame.
	
