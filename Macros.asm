#Macros

.macro printString(%string)
	li $v0, 4
	la $a0, %string
	syscall
.end_macro

.macro getInt 	# save int in $v0
	li $v0, 5
	syscall
.end_macro



