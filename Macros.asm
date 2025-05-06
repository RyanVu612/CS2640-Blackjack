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

#same logic applied to displaying player hand
.macro displayDealerHand(%array)	#for when dealer only shows one card
	move $a1, %array
	lw $t3, 0($a1)         # get first card index
	move $t4, $t3
	divu $t4, $t4, 13
	mfhi $t4               # $t4 = index % 13

	# Face cards check
	li $t5, 9
	beq $t4, $t5, dealerPrintJ
	li $t5, 10
	beq $t4, $t5, dealerPrintQ
	li $t5, 11
	beq $t4, $t5, dealerPrintK
	li $t5, 12
	beq $t4, $t5, dealerPrintA

	# Not a face card: print numeric value
	getEntry($s0, $t3)
	printInt($v0)
	j afterDealerFirst

dealerPrintJ: printString(faceJ)
 j afterDealerFirst
dealerPrintQ: printString(faceQ)
 j afterDealerFirst
dealerPrintK: printString(faceK)
j afterDealerFirst
dealerPrintA: printString(faceA)

afterDealerFirst:
	printString(comma)
	printString(blankCard)
	printString(newLine)

	# Get total (just 1 card value for display)
	getEntry($s0, $t3)
	printString(total)
	printInt($v0)
.end_macro

#updated display hand
#macros will print JQKA based on the card index 
.macro displayHand(%array, %size, %total)
	move $a1, %array
	li $t2, 0

loop_displayHand:
	bge $t2, %size, total_displayHand
	beqz $t2, firstCard
	printString(comma)

firstCard:
	lw $t3, 0($a1)         # card index
	move $t4, $t3
	divu $t4, $t4, 13
	mfhi $t4               # t4 = index % 13

	# Face cards (J=10, Q=11, K=12, A=0)
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
	j continueHand

printJ: printString(faceJ) 
j continueHand
printQ: printString(faceQ)
j continueHand
printK: printString(faceK)
 j continueHand
printA: printString(faceA)

continueHand:
	add $a1, $a1, 4
	add $t2, $t2, 1
	j loop_displayHand

total_displayHand:
	printString(newLine)
	printString(total)
	printInt(%total)
	printString(newLine)
.end_macro

.macro getInt 	# save int in $v0
	li $v0, 5
	syscall
.end_macro


.macro randomCard(%deck, %deckSize)	#save random card in $v0
	li $v0, 0		#set $v0 to zero to ensure code runs at least once
loop_randomCard:			#keep getting random card until card is pulled
	bnez $v0, done_randomCard
	#get current time
	li $v0, 30
	syscall
	move $t1, $a0		#save time in $t1
	
	bltz $t1, negate
	j done_negate

negate:
	sub $t1, $zero, $t1
	j done_negate
	
done_negate:
	li $v0, 42
	move $a1, %deckSize
	syscall					#random number 0-51 in $v0
	move $t2, $v0			#move random number to $t2
		
	add $t2, $t1, $t2			#combine time with random
	
	#get $t2 % $t3
	div $t2, %deckSize		#divide $t2 by 52
	mfhi $t2				#move remainder into $t2
	getEntry(%deck, $t2)		#get card value of that index
	
	j loop_randomCard
	
done_randomCard:
.end_macro

#updated sum array to get values from deck[index]
#reworked logic to ensure totals are correct based on the actual value of the card 
.macro sumArray(%array, %size)	#sum saved to $v0
	move $a1, %array
	li $t1, 0
	li $t2, 0
sum_loop:
	bge $t2, %size, ace_check
	lw $t3, 0($a1)       # load card index
	getEntry($s0, $t3)   # look up value in deck
	add $t1, $t1, $v0
	add $a1, $a1, 4
	add $t2, $t2, 1
	j sum_loop

ace_check:
	# reduce Ace values if total > 21
	ble $t1, 21, sum_done
	move $a1, %array
	li $t2, 0

check_ace_loop:
	bge $t2, %size, sum_done
	ble $t1, 21, sum_done
	lw $t3, 0($a1)        # get card index
	getEntry($s0, $t3)    # get value
	bne $v0, 11, not_ace
	sub $t1, $t1, 10      # count Ace as 1 instead of 11
not_ace:
	add $a1, $a1, 4
	add $t2, $t2, 1
	j check_ace_loop

sum_done:
	move $v0, $t1
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

#now storeing cards index not value 
.macro drawCard(%array, %index, %total)
	randomCard($s0, $s5)        # $t2 = index, $v0 = card value
	setEntry(%array, %index, $t2)  # store index into hand
	add %index, %index, 1
	sumArray(%array, %index)
	move %total, $v0
.end_macro
