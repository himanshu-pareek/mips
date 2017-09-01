		.text
main:
		la		$a0, hello_msg	# load the addr of hello_msg into $a0.
		li		$v0, 4			# 4 is the print_string syscall.
		syscall					# do the syscall
		
		li		$v0, 10			# 10 is to exit syscall.
		syscall					# do the syscall.
		
# Data for the program:
.data
		hello_msg:		.asciiz	"Hello World\n"
		
# end hello.asm 

