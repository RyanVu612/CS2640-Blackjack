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

.macro randomNumber(%max)	#save random int in $v0
	li $v0, 42
	li $a1, %max
	syscall
.end_macro

.macro sumArray(%array, %size)	#sum saved to $v0
	la $t2, %array	#address of array
	li $t3, 0		#counter
	li $v0, 0		#sum
	
loop_sumArray:
	bge $t3, %size, end_sumArray
	lw $t4, 0($t2)		#load array element
	add $v0, $v0, $t4	#sum += element
	add $t2, $t2, 4		#next element
	add $t3, $t3, 1		#counter++
	j loop_sumArray

end_sumArray:	#do nothing, exit out of macro
.end_macro

