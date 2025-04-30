# CS2640 - 12 PM
# Blackjack
# Ryan Vu, Joseline Ly, Caitlyn Hue, Sam Klapper, Bryan Dinh

.include "Macros.asm"

.data
dashboard: .asciiz "===========================================================\n=\t _     _            _    _            _\t\t  =\n=\t| |   | |          | |  (_)          | |\t  =\n=\t| |__ | | __ _  ___| | ___  __ _  ___| | __\t  =\n=\t| '_ \\| |/ _` |/ __| |/ / |/ _` |/ __| |/ /\t  =\n=\t| |_) | | (_| | (__|   <| | (_| | (__|   <\t  =\n=\t|_.__/|_|\\__,_|\\___|_|\\_\\ |\\__,_|\\___|_|\\_\\\t  =\n=\t                       _/ |\t\t\t  =\n=\t                      |__/\t\t\t  =\n"
options: .asciiz "=\t   (1) Play Game\t   (2) Exit\t\t  =\n"
dashboardNewLine: .asciiz "=\t\t\t\t\t\t\t  =\n"
dashboardNote: .asciiz "=\tNote: Make sure run speed is not instant\t  =\n"
endDashboard: .asciiz "===========================================================\n"

total: .asciiz "Total: "
newLine: .asciiz "\n"
comma: .asciiz ", "

# deck of cards. Each index will represent a card with it's value.
deck: .word 2,3,4,5,6,7,8,9,10,10,10,10,11,2,3,4,5,6,7,8,9,10,10,10,10,11,2,3,4,5,6,7,8,9,10,10,10,10,11,2,3,4,5,6,7,8,9,10,10,10,10,11
dealer: .space 44
player: .space 44


.text
main:
menu:
	# Print out the dashboard
	printString(dashboard)
	printString(dashboardNewLine)
	printString(options)
	printString(dashboardNewLine)
	printString(dashboardNote)
	printString(endDashboard)
	
	# Save user int
	getInt
	move $t0, $v0		# Store user input in $t0
	beq $t0, 1, play
	beq $t0, 2, exit
	j menu		# loop until get valid input
	
play:
	#-----------Load-Game-----------#
	# Load deck
	la $s0, deck 		# $s0 = deck
	
	la $s1, dealer		# Dealer hand
	la $s2, player		# Player hand
	
	li $s3, 0	# Number of cards dealer has
	li $s4, 0	# Number of cards player has
	
	li $s5, 52 	#deckSize
	
	# Randomly select 2 cards for the dealer		save into $s1
	# Remove those 2 cards from deck as you take them
	
	# First card
	randomCard($s0, $s5)			# Get random card in $v0			#save index of card in $t1
	move $t1, $v0
	setEntry($s1, $s3, $t1)		# Put card into dealer hand
	add $s3, $s3, 1				# Increment number of cards dealer has
	removeEntry($s0, $t2)		# Remove card from deck
	
	#second card
	randomCard($s0, $s5)			#get random card in $v0			#save index of card in $t1
	move $t1, $v0
	setEntry($s1, $s3, $t1)		#put card into dealer hand
	add $s3, $s3, 1				#increment number of cards dealer has
	removeEntry($s0, $t2)		#remove card from deck
	
	
	#randomly select 2 cards for the player		save into $s2
	#remove those 2 cards from deck as you take them
	
	#first card
	randomCard($s0, $s5)			#get random card in $v0			#save index of card in $t1
	move $t1, $v0
	setEntry($s2, $s4, $t1)		#put card into player hand
	add $s4, $s4, 1				#increment number of cards player has
	removeEntry($s0, $t2)		#remove card from deck
	
	#second card
	randomCard($s0, $s5)			#get random card in $v0			#save index of card in $t1
	move $t1, $v0
	setEntry($s2, $s4, $t1)		#put card into player hand
	add $s4, $s4, 1				#increment number of cards dealer has
	removeEntry($s0, $t2)		#remove card from deck
	
	#debugging, print cards dealt to dealer and player
	li $t5, 0
	getEntry($s1, $t5)
	move $t6, $v0
	printInt($t6)
	printString(newLine)
	
	li $t5, 1
	getEntry($s1, $t5)
	move $t6, $v0
	printInt($t6)
	printString(newLine)
	
	sumArray($s1, $s3)
	move $t6 $v0
	printInt($t6)
	printString(newLine)
	
	li $t5, 0
	getEntry($s2, $t5)
	move $t6, $v0
	printInt($t6)
	printString(newLine)
	
	li $t5, 1
	getEntry($s2, $t5)
	move $t6, $v0
	printInt($t6)
	printString(newLine)
	
	sumArray($s2, $s4)
	move $t6 $v0
	printInt($t6)
	printString(newLine)
	
	printString(newLine)
	displayHand($s1, $s3)
	printString(newLine)
	
	displayHand($s2, $s4)
	printString(newLine)
	
	
	
	#display the cards of the dealer and the player. Dealer should be on top of player in UI/UX
	#only display the first of the dealers cards
	
	#ask player if want to hit or stand
	
	#-------------HIT------------#
	#randomly select 1 card for the player 		save into $s2
	#display card to player alongside other cards
	#remove this card from deck
	#if > 21, bust
	
	#display total for player
	
	#ask player if want to hit or stand
	
	#if hit, loop back
	
	
	#-------------STAND-----------#
	#display dealers second card
	#if < 16, select random card from deck and remove from deck. Save into $s1
	
	#dealer draws cards until reaches 17+ or busts
	
	# if 21 > dealer > 17 compare to player
	#if player > dealer, player wins
	#if player = dealer, draw
	#if player < dealer, player loses
	
	
	#------------BUST------------#
	#player lost
	#display the cards of everyone
	
	#------------WIN------------#
	#display winning screen
	#winning reward (double money, counter maybe)
	#go to play again screen
	
	#------------TIE------------#
	#display tie screen
	#go to play again screen
	
	#------------LOSE-----------#
	#display losing screen
	#losing consequence (lose money, counter maybe)
	#go to play again screen
	
	#---------Play-Again--------#
	#prompt user if want to play again
	
	#if yes loop back to play
	#if no, exit

exit:
	li $v0, 10
	syscall
	
	
	
	
