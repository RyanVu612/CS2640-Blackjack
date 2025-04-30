#Bryan Dinh, Caitlyn Hue, Joseline Ly, Sam Klapper, Ryan Vu
#CS2640
#BlackJack

.include "Macros.asm"

.data
dashboard: .asciiz "===========================================================\n=\t _     _            _    _            _\t\t  =\n=\t| |   | |          | |  (_)          | |\t  =\n=\t| |__ | | __ _  ___| | ___  __ _  ___| | __\t  =\n=\t| '_ \\| |/ _` |/ __| |/ / |/ _` |/ __| |/ /\t  =\n=\t| |_) | | (_| | (__|   <| | (_| | (__|   <\t  =\n=\t|_.__/|_|\\__,_|\\___|_|\\_\\ |\\__,_|\\___|_|\\_\\\t  =\n=\t                       _/ |\t\t\t  =\n=\t                      |__/\t\t\t  =\n"
dashboardOptions: .asciiz "=\t   (1) Play Game\t   (2) Exit\t\t  =\n"
dashboardNewLine: .asciiz "=\t\t\t\t\t\t\t  =\n"
dashboardNote: .asciiz "=\tNote: Make sure run speed is not instant\t  =\n"
endDashboard: .asciiz "===========================================================\n"

option: .asciiz "\nChoose your option: "

dealerHand: .asciiz "Dealer Hand: "
playerHand: .asciiz "Player Hand: "
total: .asciiz "Total: "

blankCard: .asciiz "X"
hitStandOption: .asciiz "Would you like to (1) hit or (2) stand?"

bustString: .asciiz "\n~~~~~~~~BUST~~~~~~~~\n"
standString: .asciiz "\n~~~~~~~STAND~~~~~~~\n"

dealerTurn: .asciiz "Dealer's Turn...\n"
dealerStandString: .asciiz "\n***Dealer Stands\n"
dealerDrawString: .asciiz "\n***Dealer Draws\n"
dealerBustString: .asciiz "\n***Dealer Busts\n"

TIE: .asciiz "TIE!!!"
YOULOSE: .asciiz "YOU LOSE!!!!"
thankYou: .asciiz "Thank you for playing! :)"

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
	printString(dashboardOptions)
	printString(dashboardNewLine)
	printString(dashboardNote)
	printString(endDashboard)
	printString(option)
	
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
	
	li $s6, 0	# dealer total
	li $s7, 0	# player total

	
	# Randomly select 2 cards for the dealer		save into $s1
	# Remove those 2 cards from deck as you take them
	
	# First card
	drawCard($s1, $s3, $s6)
	
	#second card
	drawCard($s1, $s3, $s6)
	
	
	#randomly select 2 cards for the player		save into $s2
	#remove those 2 cards from deck as you take them
	
	#first card
	drawCard($s2, $s4, $s7)
	
	#second card
	drawCard($s2, $s4, $s7)

	
	beq $t3, 21, win #if user gets 21 in their first two cards, they win
	
	
hitStandMenu:
	#display the cards of the dealer and the player. Dealer should be on top of player in UI/UX
	#only display the first of the dealers cards
	
	#manually display dealer first hand, since only show first card
	printString(newLine)
	printString(dealerHand)
	displayDealerHand($s1)
	printString(newLine)
	
	printString(newLine)
	printString(playerHand)
	displayHand($s2, $s4, $s7)
	printString(newLine)
	
	#ask player if they want to hit or stand
	printString(newLine)
	printString(hitStandOption)
	printString(newLine)
	getInt
	move $t0, $v0
	beq $t0, 1, hit
	beq $t0, 2, stand
	j hitStandMenu                  # loop until get valid input
	
	
	#-------------HIT------------#
	#randomly select 1 card for the player 		save into $s2
	#display card to player alongside other cards
	#remove this card from deck
	#if > 21, bust
	
hit:
	#draw a random card for the user
	drawCard($s2, $s4, $s7)
	
	bgt $s7, 21, bust
	j hitStandMenu #reprompt user to hit or stand

	
	#-------------STAND-----------#
	#display dealers second card
	#if < 16, select random card from deck and remove from deck. Save into $s1
	
stand:
	# if 21 > dealer > 17 compare to player
	#if player > dealer, player wins
	#if player = dealer, draw
	#if player < dealer, player loses
	
	
	#------------BUST------------#
	#player lost
	#display the cards of everyone
	
bust:
	printString(bustString)
	printString(dealerTurn)
	printString(dealerHand)
	displayHand($s1, $s3, $s6)
	printString(newLine)
	printString(playerHand)
	displayHand($s2, $s4, $s7)
	
	jal dealerDraw 		# dealer's turn
	
	bgt $s6, 21, tie 	# if dealer also busts, then it is a tie
	j lose 			# else, player loses
	
	
	#---------DEALERDRAW--------#
	#dealer draws until reaches 17+ or busts
	
dealerDraw:
	bgt $s6, 21, dealerBust
	bgt $s6, 16, dealerStand
	
	printString(dealerDrawString)
	drawCard($s1, $s3, $s6)

	printString(dealerTurn)
	printString(dealerHand)
	displayHand($s1, $s3, $s6)
	printString(newLine)
	printString(playerHand)
	displayHand($s2, $s4, $s7)
	j dealerDraw # repeat until dealer reaches 17+

	
dealerStand:
	printString(dealerStandString)
	jr $ra
	
dealerBust:
	printString(dealerBustString)
	jr $ra
	
	#------------WIN------------#
	#display winning screen
	#winning reward (double money, counter maybe)
	#go to play again screen
	
win:

	#------------TIE------------#
	#display tie screen
	#go to play again screen
	
tie:
	printString(TIE)
	j exit
	#------------LOSE-----------#
	#display losing screen
	#losing consequence (lose money, counter maybe)
	#go to play again screen
	
lose:
	printString(YOULOSE)
	j exit
	#---------Play-Again--------#
	#prompt user if want to play again
	
playAgain:
	#if yes loop back to play
	#if no, exit

exit:
	printString(newLine)
	printString(thankYou)
	li $v0, 10
	syscall
	
	
	
	
