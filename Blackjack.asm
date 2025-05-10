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

WIN: .asciiz "YOU WIN!!!!"
TIE: .asciiz "TIE!!!"
YOULOSE: .asciiz "YOU LOSE!!!!"

playAgainPrompt: .asciiz "\nWould you like to (1) Play Again or (2) Quit?\n"
finalScreen: .asciiz "==================================================================\n=\t  __ _  __ _ _ __ ___   ___    _____   _____ _ __   \t =\n=\t / _` |/ _` | '_ ` _ \\ / _ \\  / _ \\ \\ / / _ \\ '__|\t =\n=\t| (_| | (_| | | | | | |  __/ | (_) \\ V /  __/ |   \t =\n=\t \\__, |\\__,_|_| |_| |_|\\___|  \\___/ \\_/ \\___|_|      \t =\n=\t  __/ |                                           \t =\n=\t |___/                                            \t =\n"
finalNewLine: .asciiz "=\t\t\t\t\t\t\t\t =\n"
finalNote: .asciiz "=\t\t    Thank you for playing! :)\t\t\t =\n"
endFinalScreen: .asciiz "==================================================================\n"


newLine: .asciiz "\n"
comma: .asciiz ", "

# deck of cards. Each index will represent a card with it's value.
deckValue: .word 2,3,4,5,6,7,8,9,10,10,10,10,11,2,3,4,5,6,7,8,9,10,10,10,10,11,2,3,4,5,6,7,8,9,10,10,10,10,11,2,3,4,5,6,7,8,9,10,10,10,10,11		#a singular 1 for when aces need to be changed to 1
deckCards: .word 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
dealer: .space 44
player: .space 44

#text for Jack, Queen, King, Ace
jackCard: .asciiz "J"
queenCard: .asciiz "Q"
kingCard: .asciiz "K"
aceCard: .asciiz "A"


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
	la $s0, deckValue 		# $s0 = deckValues
	la $s1, deckCards		# $s1 = deckCard
	
	la $s2, dealer		# Dealer hand
	la $s3, player		# Player hand
	
	li $s4, 0	# Number of cards dealer has
	li $s5, 0	# Number of cards player has
	
	li $s6, 52 	#deckSize
	
	li $t4, 0	# dealer total
	li $t5, 0	# player total

	
	# Randomly select 2 cards for the dealer		save into $s2
	# Remove those 2 cards from deck as you take them
	
	# First card
	drawCard($s2, $s4, $t4)
	
	#second card
	drawCard($s2, $s4, $t4)
	
	
	#randomly select 2 cards for the player		save into $s3
	#remove those 2 cards from deck as you take them
	
	#first card
	drawCard($s3, $s5, $t5)
	
	#second card
	drawCard($s3, $s5, $t5)
	
	
hitStandMenu:
	# display the cards of the dealer and the player. Dealer should be on top of player in UI/UX
	# only display the first of the dealers cards
	
	# manually display dealer first hand, since only show first card
	printString(newLine)
	printString(dealerHand)
	displayDealerHand($s2)
	printString(newLine)
	
	printString(newLine)
	printString(playerHand)
	displayHand($s3, $s5, $t5)
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
#randomly select 1 card for the player 		save into $s3
#display card to player alongside other cards
#remove this card from deck
#if > 21, bust
	
hit:
	#draw a random card for the user
	drawCard($s3, $s5, $t5)
	
	bgt $t5, 21, bust
	j hitStandMenu #reprompt user to hit or stand

	
#-------------STAND-----------#
#display dealers second card
#if < 16, select random card from deck and remove from deck. Save into $s2
	
stand:
	printString(standString)
	
	# Display current hands
	printString(dealerTurn)
	printString(dealerHand)
	displayHand($s2, $s4, $t4)
	printString(newLine)
	printString(playerHand)
	displayHand($s3, $s5, $t5)
	
	jal dealerDraw 		# dealer's turn
	 
	bgt $t4, 21, win	#if dealer busts, player wins
	bgt $t5, $t4, win	#if player > dealer, player wins
	bge $t5, $t4, tie	#if player = dealer, draw
	
	j lose			#else, player < dealer, player loses
	
	
#------------BUST------------#
# player lost
# display the cards of everyone
	
bust:
	printString(newLine)
	printString(dealerHand)
	displayDealerHand($s2)
	printString(newLine)
	
	printString(newLine)
	printString(playerHand)
	displayHand($s3, $s5, $t5)  #print out what player got before saying they busted
	printString(bustString)
	
	j lose 			# else, player loses
	
	
#---------DEALERDRAW--------#
#dealer draws until reaches 17+ or busts
	
dealerDraw:
	bgt $t4, 21, dealerBust
	bgt $t4, 16, dealerStand
	
	printString(dealerDrawString)
	drawCard($s2, $s4, $t4)

	printString(dealerTurn)
	printString(dealerHand)
	displayHand($s2, $s4, $t4)
	printString(newLine)
	printString(playerHand)
	displayHand($s3, $s5, $t5)
	j dealerDraw # repeat until dealer reaches 17+

#---------DEALERSTAND--------#
# dealer stands with current cards

dealerStand:
	printString(dealerStandString)
	jr $ra
	
#---------DEALERBUST--------#
# dealer busts, over 21
dealerBust:
	printString(dealerBustString)
	jr $ra
	
#------------WIN------------#
# display winning screen
# winning reward (double money, counter maybe)
# go to play again screen

win:
	printString(WIN)
	j playAgain
	
#------------TIE------------#
# display tie screen
# go to play again screen
	
tie:
	printString(TIE)
	j playAgain

#------------LOSE-----------#
# display losing screen
# losing consequence (lose money, counter maybe)
# go to play again screen
	
lose:
	printString(YOULOSE)
	j playAgain

#---------Play-Again--------#
#prompt user if want to play again
	
playAgain:
	printString(playAgainPrompt)
	getInt
	move $t0, $v0
	beq $t0, 1, play
	beq $t0, 2, exit

exit:
	# Print out final screen
	printString(finalScreen)
	printString(finalNewLine)
	printString(finalNote)
	printString(endFinalScreen)
	li $v0, 10
	syscall
	
