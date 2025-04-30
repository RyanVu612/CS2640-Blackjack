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
	printString(dealerTotal)
	printInt($t1)
.end_macro

.macro displayHand(%array, %size)
	move $a1, %array
	li $t2, 0		#counter
	
loop_displayHand:
	bge $t2, %size, total_displayHand
	beqz $t2, firstCard_displayHand		#formatting
	printString(comma)					#if not firs card, will fall through to next loop

firstCard_displayHand:
	lw $t3, 0($a1)
	printInt($t3)
	add $a1, $a1, 4			#next element
	add $t2, $t2, 1			#increment counter
	j loop_displayHand
	
total_displayHand:
	printString(newLine)
	printString(playerTotal)
	sumArray(%array, %size)
	move $t3, $v0
	printInt($t3)
	printString(newLine)
	
	
done_displayHand:
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

.macro sumArray(%array, %size)	#sum saved to $v0
	move $a1, %array	#address of array
	li $t2, 0		#counter
	li $t1, 0		#sum
	
	add_sumArray:
		bge $t2, %size, addDone_sumArray
		lw $t3, 0($a1)		#load array element
		add $t1, $t1, $t3	#sum += element
		add $a1, $a1, 4		#next element
		add $t2, $t2, 1		#counter++
		j add_sumArray

	addDone_sumArray:
		ble $t1, 21, end_sumArray
		move $a1, %array	#reset array
		sub $a1, $a1, 4		#start 4 less than base so that can increment at start of checkAce
		li $t2, 0			#reset counter
		
		
		checkAce_sumArray:
			bge $t2, %size, end_sumArray
			ble $t1, 21, end_sumArray
			add $a1, $a1, 4
			lw $t3, 0($a1)		#load array element
			bne $t3, 11, checkAce_sumArray		#if not ace, don't care
			
			#ace
			sub $t1, $t1, 10
			li $t3, 1
			setEntry(%array, $t2, $t3)
			j checkAce_sumArray
		
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

