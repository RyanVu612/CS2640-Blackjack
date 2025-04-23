#Macros

.macro printString(%string)
	li $v0, 4
	la $a0, %string
	syscall
.end_macro