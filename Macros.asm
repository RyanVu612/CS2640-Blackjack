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

.macro randomCard(%array, %size)	#save random card in $t3
	li $v0, 1		#set $t3 to a nonzero number in case it is already set to 0
	la $a0, %array
	li $t2, %size
loop_randomNumber:					#keep getting random card until card is pulled
	bnez $v0, done_randomNumber
	li $v0, 42
	li $a1, %size
	syscall				#random number in $v0
	
	getEntry($a0, $v0)		#get card value of that index
	j loop_randomNumber
	
done_randomNumber:
.end_macro

.macro sumArray(%array, %size)	#sum saved to $v0
	la $a0, %array	#address of array
	li $t2, 0		#counter
	li $v0, 0		#sum
	
loop_sumArray:
	bge $t2, %size, end_sumArray
	lw $t3, 0($a0)		#load array element
	add $v0, $v0, $t3	#sum += element
	add $a0, $a0, 4		#next element
	add $t2, $t2, 1		#counter++
	j loop_sumArray

end_sumArray:	#do nothing, exit out of macro
.end_macro

.macro getEntry(%array, %index)		#save in $v0
	la $a0, %array
	li $t2, %index
	mul $t2, $t2, 4
	lw $v0, $t2($a0)
.end_macro

.macro setEntry(%array, %index, %value)
	la $a0, %array
	li $t2, %index
	mul $t2, $t2, 4
	sw %value, $t2($a0)
.end_macro

.macro removeEntry(%array, %index)		#set selected index to 0
	la $a0, %array
	li $t2, %index
	mul $t2, $t2, 4
	sw $zero, $t2($a0)
.end_macro

