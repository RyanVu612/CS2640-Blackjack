#Macros

.macro printString(%string)
	li $v0, 4
	la $a0, %string
	syscall
.end_macro

.macro printInt(%integer)
	li $v0, 1
	move $a0, %integer
	syscall
.end_macro


.macro displayDealerHand(%array)	#for when dealer only shows one card
	move $a1, %array
	lw $t1, 0($a1)
	printInt($t1)
	printString(comma)
	printString(blankCard)
	printString(newLine)
	printString(total)
	printInt($t1)
.end_macro

.macro displayHand(%array, %size, %total)
	move $a1, %array
	li $t2, 0

loop_displayHand:
	bge $t2, %size, done_displayHand
	beqz $t2, firstCard
	printString(comma)

firstCard:
	lw $t3, 0($a1)         # card index
	move $t4, $t3
	divu $t4, $t4, 13
	mfhi $t4               # t4 = index % 13

	# Face cards
	li $t5, 9
	beq $t4, $t5, printJ
	li $t5, 10
	beq $t4, $t5, printQ
	li $t5, 11
	beq $t4, $t5, printK
	li $t5, 12
	beq $t4, $t5, printA

	# Print numeric value
	getEntry($s0, $t3)
	printInt($v0)
	j cont_display

printJ:
	printString(faceJ)
	j cont_display
printQ:
	printString(faceQ)
	j cont_display
printK:
	printString(faceK)
	j cont_display
printA:
	printString(faceA)

cont_display:
	add $a1, $a1, 4
	add $t2, $t2, 1
	j loop_displayHand

done_displayHand:
	printString(newLine)
	printString(total)
	printInt(%total)
	

.end_macro

.macro getInt 	# save int in $v0
	li $v0, 5
	syscall
.end_macro


.macro randomCard(%deck, %deckSize)	#save random card in $v0
	# Get system time as seed
	li $v0, 30
	syscall
	move $t1, $a0

	# Generate a safe base random index (0 to 51)
	li $v0, 42
	li $a1, 52        # explicitly bound max deck size
	syscall
	move $t2, $v0

	# Mix with time for better spread
	add $t2, $t2, $t1

	# Ensure result stays in bounds (0–51)
	divu $t2, $t2, %deckSize
	mfhi $t2

	getEntry(%deck, $t2)  # $v0 = card value
	
done_randomCard:
.end_macro

.macro sumArray(%array, %size)	#sum saved to $v0
	move $a1, %array
	li $t1, 0
	li $t2, 0

sum_loop:
	bge $t2, %size, sum_done
	lw $t3, 0($a1)          # index
	getEntry($s0, $t3)      # $v0 = value
	add $t1, $t1, $v0
	add $a1, $a1, 4
	add $t2, $t2, 1
	j sum_loop

sum_done:
	move $v0, $t1
		
	end_sumArray:
		move $v0, $t1		#save the sum in $v0
.end_macro

.macro getEntry(%array, %index)		# Save in $v0
	mul $t2, %index, 4
	add $t3, %array, $t2
	lw $v0, 0($t3)
.end_macro

.macro setEntry(%array, %index, %value)
	mul $t2, %index, 4
	add $t3, %array, $t2
	sw %value, 0($t3)
.end_macro

.macro removeEntry(%array, %index)		# Set selected index to 0
	mul $t2, %index, 4
	add $t3, %array, $t2
	sw $zero, 0($t3)
.end_macro

.macro drawCard(%array, %index, %total)
	randomCard($s0, $s5)        # $v0 = card value
	move $t1, $v0
	setEntry(%array, %index, $t1)
	add %index, %index, 1
	sumArray(%array, %index)
	move %total, $v0
	
	
.end_macro
