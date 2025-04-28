#CS2640
#BlackJack

.include "Macros.asm"

.data
dashboard: .asciiz "===========================================================\n=\t _     _            _    _            _\t\t  =\n=\t| |   | |          | |  (_)          | |\t  =\n=\t| |__ | | __ _  ___| | ___  __ _  ___| | __\t  =\n=\t| '_ \\| |/ _` |/ __| |/ / |/ _` |/ __| |/ /\t  =\n=\t| |_) | | (_| | (__|   <| | (_| | (__|   <\t  =\n=\t|_.__/|_|\\__,_|\\___|_|\\_\\ |\\__,_|\\___|_|\\_\\\t  =\n=\t                       _/ |\t\t\t  =\n=\t                      |__/\t\t\t  =\n"
options: .asciiz "=\t   (1) Play Game\t   (2) Exit\t\t  =\n"
dashboardNewLine: .asciiz "=\t\t\t\t\t\t\t  =\n"
endDashboard: .asciiz "===========================================================\n"


# deck of cards. Each index will represent a card with it's value.
deck: .word 1,2,3,4,5,6,7,8,9,10,10,10,10,1,2,3,4,5,6,7,8,9,10,10,10,10,1,2,3,4,5,6,7,8,9,10,10,10,10,1,2,3,4,5,6,7,8,9,10,10,10,10
dealer: .space 45
player: .space 45


.text
main:
menu:
	#Print out the dashboard
	printString(dashboard)
	printString(dashboardNewLine)
	printString(options)
	printString(dashboardNewLine)
	printString(endDashboard)
	
	# Save user int
	getInt
	move $t0, $v0
	beq $t0, 1, play
	beq $t0, 2, exit
	j menu		# loop until get valid input
	
play:
	#-----------Load-Game-----------#
	#load deck
	la $s0, deck 		# $s0 = deck
	li $t1, 52			#count of cards
	
	la $s1, dealer		#dealer hand
	la $s2, player		#player hand
	
	#randomly select 2 cards for the dealer		save into $s1
	#remove those 2 cards from deck as you take them
	
	#randomly select 2 cards for the player		save into $s2
	#remove those 2 cards from deck as you take them
	
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
	
	
	
	
