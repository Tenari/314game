 .text
	.globl  main
main:   
#----------- First Scene: In the Dorm-------------------------------------
	# Set the scene, and offer the player the chance to answer the door.
	la		$a0, Dorm1			# load the argument 'Dorm1' into $a0
	la		$a1, Options1		# Options 1 is yes/no. The player either answers the door or not.
	jal		Scene				# print and get response in $v0

	# If they said yes, they continue. else, ask them again.
	addi	$a0, $v0, 0			# Put response into the first argument for yesContinueNoLose function
	la		$a1, almostLose1	# Put the 'wrong choice' label into second argument
	la		$a2, dormContinue1	# Put the 'right choice' label into third argument
	jal		yesContinueNoLose
	j		$v0
		
	almostLose1:	
		# Ask them again.
		la		$a0, KnockAgain		# Load appropriate message into argument $a0 for Scene function
		la		$a1, Options1		# Options 1 is yes/no. The player either answers the door or not.
		jal		Scene				# Guy knocks again. What do you do? $v0 holds int answer.
		
		# They either said yes or they lose.
		addi	$a0, $v0, 0			# Put response into the first argument for yesContinueNoLose function
		la		$a1, lose1			# Put the 'wrong choice' label into second argument
		la		$a2, dormContinue1	# Put the 'right choice' label into third argument
		jal		yesContinueNoLose
		j		$v0
		
	dormContinue1:
	# Let the guy in and he gives you a time machine and you go on to have grand adventures.
		# system call to print continue message 
		li		$v0, 4				# load appropriate system call code into register $v0 (print string is code 4)
		la		$a0, meetJeff		# load 'meetJeff' string's address into $a0
		syscall						# do the call
		
		# Print jeff's first line of dialouge
		la		$a0, jeff
		la		$a1, jeffIntro1
		jal		dialouge
		
		# Print jeff's second line of dialouge
		la		$a0, jeff
		la		$a1, jeffIntro2
		jal		dialouge
		
		# Print jeff's offer
		la		$a0, jeffOffer		# load the argument 'jeffOffer' into $a0
		la		$a1, Options1		# Options 1 is yes/no. The player either takes the machine or not.
		jal		Scene				# print and get response in $v0
		
		# They either said yes or they lose.
		addi	$a0, $v0, 0			# Put response into the first argument for yesContinueNoLose function
		la		$a1, lose2			# Put the 'wrong choice' label into second argument
		la		$a2, dormContinue2	# Put the 'right choice' label into third argument
		jal		yesContinueNoLose
		j		$v0
		
	dormContinue2:
	#
		# Add the time machine he gave you into your inventory.
		addi	$a0, $zero, 1
		addi	$a1, $zero, 2
		jal		modifyInventory
		
		# Jeff says: "You use it by just selecting where you want to go, and when you want to arrive."
		la		$a0, jeff
		la		$a1, jeffHowToUse
		jal		dialouge
		
		# Ask the player where he wants to go.
		la		$a0, travel1		# Load the scene message
		la		$a1, Options3		# is [Egypt, America]
		jal		Scene				# print and get response in $v0
		
		# Push $v0 onto stack.
		addi	$sp, $sp, -4		# Decrement stack pointer
		sw		$v0, 0($sp)			# Save $ra to stack
		
		# Ask the player WHEN he wants to go.
		la		$a0, travel2		# Load the scene message
		la		$a1, Options4		# is [Ancient, 20 yrs forward]
		jal		Scene				# print and get response in $v0
		
		# Get the first response into $t0
		lw		$t0, 0($sp)			# Get first response into $t0 from stack
		addi	$sp, $sp, 4			# Increment stack pointer by 4
		
		# Decide where to go from here, based on their responses (in $t0, and $v0)
		addi	$t1, $zero, 1		# Set $t1 = 1
		beq		$t0, $t1, egyptChoice	# If $t0 = 1, then thye picked egypt
		j		americaChoice		# Else, they picked America
		
	egyptChoice:	
		beq		$v0, $t1, ancientEgypt
		j		futureEgypt
	
	americaChoice:
		beq		$v0, $t1, ancientAmerica
		j		futureAmerica
		
		
	
	win1:
		# system call to print win message 
		li		$v0, 4				# load appropriate system call code into register $v0 (print string is code 4)
		la		$a0, winMsg1		# load 'winMsg1' string's address into $a0
		syscall						# do the call
		
		j 		end					# GAME IS OVER, so go to end
		
#---------- End First Scene: In the Dorm----------------------------------

#------------------- Ancient Egypt Scene----------------------------------
ancientEgypt:
	j		win1
#--------------- End Ancient Egypt Scene----------------------------------

#-------------------- Future Egypt Scene----------------------------------
futureEgypt:
	j		win1
#---------------- End Future Egypt Scene----------------------------------

#------------------- Ancient America Scene--------------------------------
ancientAmerica:
	j		win1
#--------------- End Ancient America Scene--------------------------------

#-------------------- Future America Scene--------------------------------
futureAmerica:
	j		win1
#---------------- End Future America Scene--------------------------------

#-------------- Lose Points/Labels ---------------------------------------

	# The lose point for never answering the door.
	lose1:
		# system call to print lose message 
		li		$v0, 4				# load appropriate system call code into register $v0 (print string is code 4)
		la		$a0, loseMsg1		# load 'loseMsg1' address into $a0
		syscall						# do the call
		j		end					# GAME IS OVER, so go to end
	
	# The lose point for not accepting the machine.
	lose2:
		# system call to print lose message 
		li		$v0, 4				# load appropriate system call code into register $v0 (print string is code 4)
		la		$a0, loseMsg2		# load 'loseMsg2' address into $a0
		syscall						# do the call
		j		end					# GAME IS OVER, so go to end
#------------- End Lose Points/Labels ------------------------------------

#-------------------------------------------------------------------------	
#The scene function prints the standard scene message (adress passed in to $a0) and asks for user response
#$v0 SceneInt($a0 = msgAddress, $a1 = optionsAddress) where $v0 = user response input as an int.
#note that $a0 is changed by operation.
Scene:
	# system call to print message stored at $a0
		li		$v0, 4			# load appropriate system call code into register $v0 (print string is code 4)
		syscall					# $a0 already equals the address of the string, so do the call
		
	# system call to print options, stored at $a1
		li		$v0, 4			# load appropriate system call code into register $v0 (print string is code 4)
		addi	$a0, $a1, 0		# move the options message($a1) into the correct argument($a0).
		syscall					# do the call
		
	# system call to print prompt
		li		$v0, 4			# load appropriate system call code into register $v0 (print string is code 4)
		la		$a0, Prompt		# load 'prompt' address into $a0
		syscall					# do the call
		
	# system call to get user number input
		li		$v0, 5			# load appropriate system call code into register $v0 (read int is code 5)
		syscall 				# do call -- returns answer in $v0
	
	# function is complete, return.
		jr $ra
#---------- end Scene function ------------------------------------------

#-------------------------------------------------------------------------	
# The displayInventory function prints the array that holds the inventory, 
# INVEN.
displayInventory:
	# Initialize counters
	la		$t0, LEN		# Load the address of the length of the inventory array into $t0
	lw		$t8, 0($t0)		# Load the length of the inventory array into $t8
	li		$t1, 0			# Start $t1 at 0. $t1 is the loop counter
	li		$t0, 0			# Start $t0, the offset register, at 0
	
	# Print the header
	li      $v0,4           # system call to print InvenHead
	la      $a0, InvenHead	# load the address of InvenHead into argument $a0
	syscall
	
	# The main function loop
	displayInventoryLoop:
	
		add		$t0, $t1, $t1	#double $t1 (loop counter) into $t0
		add		$t0, $t0, $t0	#double it again to get $t0 = currentOffset
		
		addi    $t1, $t1, 1     # increment loop counter by 1
		
		la      $t5, INVEN		# Load the address of the inventory array
		add		$t5, $t5, $t0	# Add offset and array start to get actual address
        lw      $t3, 0($t5)     # Load Inventory code from ARRAY[$t1 - 1]
		
		# If inventory code is 0, move on to the next part of the loop.
		beq		$t3, $zero, displayInventoryLoopCheck
		
		# Else, decipher the code.
		# If it's a 1, print wallet.
		li		$t4, 1			# Set $t4 equal to 1
		beq		$t3, $t4, PrintWallet	# Print the wallet
		
		# If it's a 2, print time machine.
		li		$t4, 2			# Set $t4 equal to 1
		beq		$t3, $t4, printTimeMachine# Print the time machine
		
		# another code check.
		
		# all the code checks failed, so go to the next item.
		j		displayInventoryLoopCheck
		
		PrintWallet:
			li      $v0,4           # system call to print wallet
			la      $a0, wallet		# load the address of wallet into argument $a0
			syscall
			j		displayInventoryLoopCheck	# We printed the thing, so do the next item
		
		printTimeMachine:
			li      $v0,4           # system call to print wallet
			la      $a0, timeMachine# load the address of timeMachine into argument $a0
			syscall
			j		displayInventoryLoopCheck	# We printed the thing, so do the next item
        
		displayInventoryLoopCheck:
			beq     $t8, $t1, displayInventoryEnd  # if counter = arrayLen, goto exit label
			j		displayInventoryLoop	# Do the loop again.
	
	# function is complete, return.
	displayInventoryEnd:
	
		# Print the footer
		li      $v0, 4			# system call to print InvenFoot
		la      $a0, InvenFoot	# load the address of InvenFoot into argument $a0
		syscall
	
		jr 		$ra
#---------- end displayInventory function ------------------------------------------

#-------------------------------------------------------------------------	
# The modifyInventory function take two params ($a0 = array location, $a1=
# item code) and puts them in the array, INVEN, which represents the 
# inventory. Then prints the new inventory.

modifyInventory:
	
	# Push $ra onto stack.
	addi	$sp, $sp, -4		# Decrement stack pointer
	sw		$ra, 0($sp)			# Save $ra to stack
	
	# Add the item.
	add		$t0, $a0, $a0		#double $a0 (array location) into $t0
	add		$t0, $t0, $t0		#double it again to get $t0 = currentOffset
		
	la      $t5, INVEN			# Load the address of the start of the inventory array
	add		$t5, $t5, $t0		# Add offset and array start to get actual address of the array location we are updating.
	sw      $a1, 0($t5)     	# Store the passed item code argument in ARRAY[$a0]
	
	# Added the item, so print the inventory.
	jal		displayInventory
	
	# Function is complete, pop $ra and return.
	lw		$ra, 0($sp)			# Get return address from stack
	addi	$sp, $sp, 4			# Increment stack pointer by 4
	
	jr 		$ra
#---------- end displayInventory function ------------------------------------------

#-------------------------------------------------------------------------	
# The yesContinueNoLose function takes three params:
#	($a0 = int response, $a1 = loseLabel, $a2 = continueLabel) 
# and decides where to jump to, leaving that label location in $v0
# If the response was a yes (a '1') $v0 = continueLabel.
# otherwise, $v0 = loseLabel

yesContinueNoLose:

	# If they said yes, they continue. else, ask them again.
	addi	$t1, $zero, 1			# Put 1 into $t1
	beq		$a0, $t1, setYesLabelOut# If response = 1, jump to setYesLabelOut
									# Else, just continue. Next section labeled for convinience.
	setNoLabelOut:
		addi 	$v0, $a1, 0			# Set $v0 to the address of the passed in loseLabel
		j		endYesContinueNoLose# Jump to the end--this function is done.
		
	setYesLabelOut:
		addi 	$v0, $a2, 0			# Set $v0 to the address of the passed in continueLabel
		j		endYesContinueNoLose
		
	endYesContinueNoLose:
		# Function is complete, return to caller.		
		jr 		$ra
#---------- end yesContinueNoLose function ------------------------------------------

#-------------------------------------------------------------------------	
# The dialouge function takes two params:
#	($a0 = speakerLabel, $a1 = lineLabel) 
# and prints the text at speakerLabel followed by the text at lineLabel

dialouge:

	# Print the speakerLabel
	li      $v0, 4			# System call to print text
							# Address of speakerLabel already in $a0
	syscall
	
	# Print the lineLabel
	li		$v0, 4			# System call to print text
	addi	$a0, $a1, 0		# Put lineLabel in syscall's first argument
	syscall
	
	# Function is complete, return to caller.		
	jr 		$ra
#---------- end yesContinueNoLose function ------------------------------------------

end:	
	# Ask them to play again.
	la		$a0, Again			# load the argument 'Again' into $a0
	la		$a1, Options1		# Options 1 is yes/no. The player either wants to play or not.
	jal		Scene				# print and get response in $v0
	
	# If they said yes, jump to main. else, quit the game.
	addi	$t1, $zero, 1		# put 1 into $t1
	beq		$v0, $t1, main		# if response = 1, jump to main

	# Quit the game.
	li      $v0, 10         # system call 10; exit
	syscall
		
#-----  DATA ------------------------------------------------------------
        .data
Dorm1:		.asciiz "You are bored, sitting at your desk, thinking about playing another game of LoL. College isn't all it was cracked up to be. Suddenly, a knock at the door. Answer it?\n"
KnockAgain:	.asciiz "\nYou ignore the knocking, being too busy staring at the wall. Soon, you hear another, louder knock at the door. Answer it?\n"

loseMsg1:	.asciiz "\nYou continue sitting at your desk. The knocking subsides, and you hear a voice on the other side of the door say, \"Well, I guess I could talk to George Washington...\".\nYou are left with the vague feeling that you just missed the opportunity of a lifetime.\nYOU LOSE!\n"
loseMsg2:	.asciiz "\nJeff looks upset and leaves. The world goes back to being as humdrum as it was before.\nYOU LOSE!\n"

meetJeff:	.asciiz "\nYou answer the door, and a strange man in a perfectly white suit comes in.\n"
jeff:		.asciiz "Jeff: "
jeffIntro1:	.asciiz "\"Hello, my name is Jeffrey Bloomford, formerly of the Ministry of Causal and Temporal Affairs.\"\n"
jeffIntro2:	.asciiz "\"Today, I'd like to offer you the ability to travel through time.\"\n"
jeffHowToUse:.asciiz "\"You use it by selecting where you want to go, and when you want to arrive.\"\n"
jeffOffer:	.asciiz "Jeff offers you a time machine. Take it?\n"

winMsg1:	.asciiz "\nYou go on to have grand adventures.\nYOU WIN!\n"

InvenHead:	.asciiz "\nYou are carrying:\n["
wallet:		.asciiz "a wallet, "
timeMachine:.asciiz "a hand-dandy time machine, "
InvenFoot:	.asciiz "]\n"

travel1:	.asciiz "Where do you want to go?\n"
travel2:	.asciiz "When do you want to get there?\n"

Options1:	.asciiz "[yes = 1, no = 2]\n"							# Basic yes/no
Options2:	.asciiz "[talk = 1, search = 2, open inventory = 3]\n"	# Usual scene options.
Options3:	.asciiz "[Egypt = 1, America = 2]"						# Location travel options
Options4:	.asciiz "[Ancient Times = 1, Twenty years ahead = 2]"	# Time travel options
Prompt:   	.asciiz "\nWell? => "
Again:		.asciiz "\n\n--------------------------------------------------------------------------------\nPlay Again?\n"

# a word boundary alignment
        .align 2

# reserve a word space
INVEN:		.word 1, 0, 0, 0, 0, 0, 0, 0, 0, 0	# The inventory just stores ints. Ints represent specific items. 0 = blank slot.
LEN:		.word 10