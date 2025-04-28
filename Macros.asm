#Macros

.macro printString(%string)
	li $v0, 4
	la $a0, %string
	syscall
.end_macro

.macro getInt 	# Save int in $v0
	li $v0, 5
	syscall
.end_macro

.macro randomCard(%deck, %deckSize)	# Save random card in $v0
	li $t1, 1		# Set $t1 to a nonzero number in case it is already set to 0
	#la $a0, %deck
	#li $t2, %deckSize
	loop_randomCard:					# Keep getting random card until card is pulled
		bnez $v0, done_randomCard
		li $v0, 42
		li $a1, %deckSize
		syscall				# Random number in $v0
		move $t1, $v0		# Save random number in $t1
		
		getEntry(%deck, $t1)		# Get card value of that index
		j loop_randomCard
	done_randomCard:
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
	end_sumArray:	# Do nothing, exit out of macro
.end_macro

.macro getEntry(%array, %index)		# Save in $v0
	mul $t2, %index, 4
	add $t3, %array, $t2
	lw $v0, 0($t3)
.end_macro

.macro addEntry(%array, %index, %value)
	mul $t2, %index, 4
	add $t3, %array, $t2
	sw %value, 0($t3)
.end_macro

.macro removeEntry(%array, %index)		# Set selected index to 0
	mul $t2, %index, 4
	add $t3, %array, $t2
	sw $zero, 0($t3)
.end_macro

