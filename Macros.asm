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