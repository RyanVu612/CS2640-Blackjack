#CS2640
#BlackJack

.include "Macros.asm"

.data
dashboard: .asciiz "===========================================================\n=\t _     _            _    _            _\t\t  =\n=\t| |   | |          | |  (_)          | |\t  =\n=\t| |__ | | __ _  ___| | ___  __ _  ___| | __\t  =\n=\t| '_ \\| |/ _` |/ __| |/ / |/ _` |/ __| |/ /\t  =\n=\t| |_) | | (_| | (__|   <| | (_| | (__|   <\t  =\n=\t|_.__/|_|\\__,_|\\___|_|\\_\\ |\\__,_|\\___|_|\\_\\\t  =\n=\t                       _/ |\t\t\t  =\n=\t                      |__/\t\t\t  =\n"
options: .asciiz "=\t   (1) Play Game\t   (2) Exit\t\t  =\n"
dashboardNewLine: .asciiz "=\t\t\t\t\t\t\t  =\n"
endDashboard: .asciiz "===========================================================\n"

.text
main:
	#Print out the dashboard
	printString(dashboard)
	printString(dashboardNewLine)
	printString(options)
	printString(dashboardNewLine)
	printString(endDashboard)
	