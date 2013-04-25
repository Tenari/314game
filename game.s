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
		
		jal		pause
		
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
	# More stuff happens.
		# Display the asciiart
		li		$v0, 4			# load appropriate system call code into register $v0 (print string is code 4)
		la		$a0, TMimg		# Load the image into the argument.
		syscall					# do the call
		
		jal		pause
		
		# Add the time machine he gave you into your inventory.
		addi	$a0, $zero, 1
		addi	$a1, $zero, 2
		jal		modifyInventory
		
		# Jeff says: "You use it by just selecting where you want to go, and when you want to arrive."
		la		$a0, jeff
		la		$a1, jeffHowToUse
		jal		dialouge
		
		jal		travelThroughTime	# Gets the address to jump to in $v0
		j		$v0					# Jump to the address
	
	win1:
		# system call to print win message 
		li		$v0, 4				# load appropriate system call code into register $v0 (print string is code 4)
		la		$a0, winMsg1		# load 'winMsg1' string's address into $a0
		syscall						# do the call
		
		j 		end					# GAME IS OVER, so go to end
		
#---------- End First Scene: In the Dorm----------------------------------

#------------------- Ancient Egypt Scene CODE: 1-------------------------------
ancientEgypt:
	# Set the scene, and offer the player the chance to answer the door.
	la		$a0, AEscene1		# load the scene setting message into $a0
	la		$a1, Options2		# Basic scene options
	jal		Scene				# print and get response in $v0
	
	# Handle the response
	addi	$a0, $v0, 0			# Set the input parameter to response
	addi	$a1, $zero, 1		# Set the scene code
	la		$a2, AETalk			# Set the talk jump point
	la		$a3, AESearch		# Set the search jump point
	jal		handleOptions2
	jr		$v0
	
	AETalk:
	
	AESearch:
	
	j		win1
#--------------- End Ancient Egypt Scene---------------------------------------

#-------------------- Future Egypt Scene CODE: 2-------------------------------
futureEgypt:
	# Set the scene, and offer the player the chance to answer the door.
	la		$a0, FEscene1		# load the scene setting message into $a0
	la		$a1, Options2		# Basic scene options
	jal		Scene				# print and get response in $v0
	
	# Handle the response
	addi	$a0, $v0, 0			# Set the input parameter to response
	addi	$a1, $zero, 2		# Set the scene code
	la		$a2, FETalk			# Set the talk jump point
	la		$a3, FESearch		# Set the search jump point
	jal		handleOptions2
	jr		$v0
	
	FETalk:
	
	FESearch:
	
	j		win1
#---------------- End Future Egypt Scene---------------------------------------

#------------------- Ancient America Scene CODE: 3-----------------------------
ancientAmerica:
	# Set the scene, forcing the player to press enter to continue
	la		$a0, scenePA11		# load the scene setting message into $a0
	la		$a1, Nothing		# No options--just enter to continue
	jal		Scene				# print and get response in $v0
	
	# see ship and burly men
	la		$a0, scenePA12		# load the scene setting message into $a0
	la		$a1, Nothing		# No options--just enter to continue
	jal		Scene				# print and get response in $v0
	
	# Who are you, and what are you doing here?
	la		$a0, scenePA13		# load the scene setting message into $a0
	la		$a1, Options1		# yes/no
	jal		Scene				# print and get response in $v0
	
	# They either said yes or they lose.
	addi	$a0, $v0, 0			# Put response into the first argument for yesContinueNoLose function
	la		$a1, lose3			# Put the 'wrong choice' label into second argument
	la		$a2, PAContinue1	# Put the 'right choice' label into third argument
	jal		yesContinueNoLose
	j		$v0
	
	PAContinue1:
		# Your answer
		la		$a0, scenePA14		# load the scene setting message into $a0
		la		$a1, Nothing		# No options--just enter to continue
		jal		Scene				# print and get response in $v0
		
		# His response
		la		$a0, scenePA15		# load the scene setting message into $a0
		la		$a1, Options5		# yes/no/talk
		jal		Scene				# print and get response in $v0
		
		# Handle response
		addi	$t2, $zero, 2
		beq		$v0, $t2, lose4
		addi	$t3, $zero, 3
		beq		$v0, $t3, morePATalk
		j		PAContinue2
		
		morePATalk:
			# Your answer
			la		$a0, scenePA151		# load the scene setting message into $a0
			la		$a1, Nothing		# No options--just enter to continue
			jal		Scene				# print and get response in $v0
			
			# His response
			la		$a0, scenePA152		# load the scene setting message into $a0
			la		$a1, Nothing		# No options--just enter to continue
			jal		Scene				# print and get response in $v0
	
	PAContinue2:
		# Your answer
		la		$a0, scenePA16		# load the scene setting message into $a0
		la		$a1, Nothing		# No options--just enter to continue
		jal		Scene				# print and get response in $v0
		
		# His response
		la		$a0, scenePA17		# load the scene setting message into $a0
		la		$a1, Options1		# yes/no
		jal		Scene				# print and get response in $v0

	# Set the scene, and offer the player the chance to answer the door.
#	la		$a0, AAscene1		# load the scene setting message into $a0
#	la		$a1, Options2		# Basic scene options
#	jal		Scene				# print and get response in $v0
	
	# Handle the response
#	addi	$a0, $v0, 0			# Set the input parameter to response
#	addi	$a1, $zero, 3		# Set the scene code
#	la		$a2, AATalk			# Set the talk jump point
#	la		$a3, AASearch		# Set the search jump point
#	jal		handleOptions2
#	jr		$v0
	
#	AATalk:
	
#	AASearch:
	
	j		win1
#--------------- End Ancient America Scene-------------------------------------

#-------------------- Future America Scene CODE: 4-----------------------------
futureAmerica:
	# Set the scene, and offer the player the chance to answer the door.
	la		$a0, FAscene1		# load the scene setting message into $a0
	la		$a1, Options2		# Basic scene options
	jal		Scene				# print and get response in $v0
	
	# Handle the response
	addi	$a0, $v0, 0			# Set the input parameter to response
	addi	$a1, $zero, 4		# Set the scene code
	la		$a2, FATalk			# Set the talk jump point
	la		$a3, FASearch		# Set the search jump point
	jal		handleOptions2
	jr		$v0
	
	FATalk:
	
	FASearch:
	
	j		win1
#---------------- End Future America Scene-------------------------------------

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
		
	# The lose point for not explaining who you are.
	lose3:
		# system call to print lose message 
		li		$v0, 4				# load appropriate system call code into register $v0 (print string is code 4)
		la		$a0, loseMsg3		# load 'loseMsg3' address into $a0
		syscall						# do the call
		j		end					# GAME IS OVER, so go to end
		
	# The lose point for not joining the quest.
	lose4:
		# system call to print lose message 
		li		$v0, 4				# load appropriate system call code into register $v0 (print string is code 4)
		la		$a0, loseMsg4		# load 'loseMsg3' address into $a0
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
# The pause function forces the user to press enter to continue the game.
# warning, pause will destroy $v0.
pause:
	# system call to pause
	li		$v0, 5			# load appropriate system call code into register $v0 (read int is code 5)
	syscall	
	
	# function is complete, return.
	jr $ra
#---------- end pause function ------------------------------------------

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
#---------- end displayInventory function -------------------------------------

#------------------------------------------------------------------------------
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
#---------- end modifyInventory function --------------------------------------

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
#---------- end yesContinueNoLose function ------------------------------------

#------------------------------------------------------------------------------	
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
#---------- end yesContinueNoLose function ------------------------------------

#------------------------------------------------------------------------------
# handleOptions2 takes the int response to an options2 question (in $a0)
# and an int scene-code (in $a1),
# and returns an address in $v0 to work.
handleOptions2:
	# Push $ra onto stack.
	addi	$sp, $sp, -4		# Decrement stack pointer
	sw		$ra, 0($sp)			# Save $ra to stack

	# Setup possible responses temp constants
	addi	$t1, $zero, 1	# $t1 = 1
	addi	$t2, $zero, 2	# $t2 = 2
	
	# If input is 1 do... if 2 do ... else do ...
	beq		$a0, $t1, handleTalk
	beq		$a0, $t2, handleSearch
	j		handleOpenInven
	
	handleTalk:
		addi	$a0, $a1, 0		# Put scene-code in first param
		jal		getSceneTalk
		
		j		endHandleOptions2
		
	handleSearch:
		addi	$a0, $a1, 0		# Put scene-code in first param
		jal		getSceneSearch
		
		j		endHandleOptions2
		
	handleOpenInven:
		jal		displayInventory
		
		jal		accessInventory
		
	endHandleOptions2:	
		# Function is complete, pop $ra and return.
		lw		$ra, 0($sp)			# Get return address from stack
		addi	$sp, $sp, 4			# Increment stack pointer by 4
		jr		$ra
#---------- end handleOptions2 function ---------------------------------------

#------------------------------------------------------------------------------
# getSceneTalk does nothing
getSceneTalk:
	# Push $ra onto stack.
	addi	$sp, $sp, -4		# Decrement stack pointer
	sw		$ra, 0($sp)			# Save $ra to stack
	
	addi	$v0, $a2, 0			#set the jump
	
	endGetSceneTalk:	
		# Function is complete, pop $ra and return.
		lw		$ra, 0($sp)			# Get return address from stack
		addi	$sp, $sp, 4			# Increment stack pointer by 4
		jr		$ra
#---------- end handleOptions2 function ---------------------------------------

#------------------------------------------------------------------------------
# getSceneSearch does nothing
getSceneSearch:
	# Push $ra onto stack.
	addi	$sp, $sp, -4		# Decrement stack pointer
	sw		$ra, 0($sp)			# Save $ra to stack
	
	addi	$v0, $a3, 0			# set the outjumppoint
	
	endGetSceneSearch:	
		# Function is complete, pop $ra and return.
		lw		$ra, 0($sp)			# Get return address from stack
		addi	$sp, $sp, 4			# Increment stack pointer by 4
		jr		$ra
#---------- end handleOptions2 function ---------------------------------------

#------------------------------------------------------------------------------
# accessInventory asks what item to use, and if it's the time machine, 
# returns $v0 with the address for where to jump to.
accessInventory:
	# Push $ra onto stack.
	addi	$sp, $sp, -4		# Decrement stack pointer
	sw		$ra, 0($sp)			# Save $ra to stack
	
	# Ask them which item to use.
	la		$a0, Nothing
	la		$a1, InvenAccess
	jal		Scene
	
	addi	$t2, $zero, 2
	bne		$v0, $t2, endAccessInventory
	
	jal		travelThroughTime
	
	endAccessInventory:	
		# Function is complete, pop $ra and return.
		lw		$ra, 0($sp)			# Get return address from stack
		addi	$sp, $sp, 4			# Increment stack pointer by 4
		jr		$ra
#---------- end handleOptions2 function ---------------------------------------

#------------------------------------------------------------------------------
# travelThroughTime returns an address to jump to, based on the player's choice
# The address is in $v0.
travelThroughTime:
	# Push $ra onto stack.
	addi	$sp, $sp, -4		# Decrement stack pointer
	sw		$ra, 0($sp)			# Save $ra to stack

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
		beq		$v0, $t1, ancientEgyptTravel
		j		futureEgyptTravel
	
	americaChoice:
		beq		$v0, $t1, ancientAmericaTravel
		j		futureAmericaTravel
		
		
	ancientEgyptTravel:
		la		$v0, ancientEgypt
		j		endTravelThroughTime
	
	futureEgyptTravel:
		la		$v0, futureEgypt
		j		endTravelThroughTime
	
	ancientAmericaTravel:
		la		$v0, ancientAmerica
		j		endTravelThroughTime
	
	futureAmericaTravel:
		la		$v0, futureAmerica
		j		endTravelThroughTime
	
	endTravelThroughTime:
		# Function is complete, pop $ra and return.
		lw		$ra, 0($sp)			# Get return address from stack
		addi	$sp, $sp, 4			# Increment stack pointer by 4
		jr		$ra
#---------- end travelThroughTime function ------------------------------------

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
		
#-----  DATA ------------------------------------------------------------------
        .data
Nothing:	.asciiz ""
Dorm1:		.asciiz "You are bored, sitting at your desk, thinking about playing another game of LoL. College isn't all it was cracked up to be. Suddenly, a knock at the door. Answer it?\n"
KnockAgain:	.asciiz "\nYou ignore the knocking, being too busy staring at the wall. Soon, you hear another, louder knock at the door. Answer it?\n"

# The text for the Ancient Egypt section of the game
AEscene1:	.asciiz "\nYou fly through time and space!!!\n...\nIt's not as cool as it sounds.\nYou arrive in what you hope is the friendly section of Ancient Egypt.\n...\nIt's not.\nAn angry looking man walks up to you, yelling in a language that you don't speak.\nWhat do you do?\n"

# The text for the Ancient America section of the game
AAscene1:	.asciiz "\nYou fly through time and space!!!\n...\nIt's pretty cool.\nYou arrive in what appears to be the friendly section of Ancient America.\n...\nA native girl approaches.\nWhat do you do?\n"
scenePA11:	.asciiz "\nRaining stars awaken the dark sky. A blazing fire pouring down, you drift into unconsciousness.\n"
scenePA12:	.asciiz "\nYou open your eyes, squinting at the bright sunlight.You are on a wooden ship in the ocean.You look around and see 20 burly men clad in leather and metal, rowing toward a large landmass. One of them with a large red beard approaches you.\n"
scenePA13:	.asciiz "\n ?: \"So, you're awake now, perhaps you can tell me who you are and what you're doing here?\"\nYou see the large man grasping an ornate poleaxe, glimmering in the sunlight.\n"
scenePA14:	.asciiz "\nYou: \"I’ve come from a far beyond time and land, seeking to slay the wizard, Vis, and rescue my true love.\"\n"
scenePA15:	.asciiz "\nLeif: \”My name is Leif, king of these northern lands. My men found you hovering above the sea in a trance-like state. They wanted to kill you, believing you were an agent of the wizard that has plagued our colony in Vinland. We are about to land in Vinland as we speak, and after we are heading to the wizard’s tower just west of our settlement. I have selected this small, elite group of berserkers to end Vis’ reign of terror over our lands. If what you say is true, then join our quest.\"\n"
scenePA151:	.asciiz "\nYou: \"What can you tell me about Vis?\”\n"
scenePA152:	.asciiz "\nLeif: \"Vis is a powerful sorcerer. My people who were lucky enough to flee these lands say he possesses the magic of the gods, able to call forth lightning like Thor himself. I have prayed to Thor and the gods to vanquish this enemy from our lands. The answer to my prayers came to me in a dream. I knew I had to set out with only my most trusted warriors, and it was foretold that I would find a hero on this voyage. I believe that you are the hero I have seen in my dreams. You are the one who will slay the wizard and bring peace back to these lands.\”\n"
scenePA16:	.asciiz "\nYou: \"I will join you and your men, but I have no weapons with which to fight.\”\n"
scenePA17:	.asciiz "\nLeif: \"Here is my finest sword.\”\nLeif presents a large polished sword. In its hilt, carved runes delicately inlaid with gold and silver. Take the sword? \n"


# The text for the Future Egypt section of the game
FEscene1:	.asciiz "\nYou coast through time and space.\n...\nIt takes longer than you expected.\nYou arrive in what looks like the unfriendly section of Future Egypt.\n...\nIt's not.\nA simling, attractive lady walks up to you.\nWhat do you do?\n"

# The text for the Future America section of the game
FAscene1:	.asciiz "\nYou trip and stumble through time and space.\n...\nIt was kind of painful.\nYou arrive in what you hope is not the unfriendly section of Future America.\n...\nIt is. All of Future America is the unfriendly section.\nAn angry 5 year-old boy runs up to you.\nWhat do you do?\n"

loseMsg1:	.asciiz "\nYou continue sitting at your desk. The knocking subsides, and you hear a voice on the other side of the door say, \"Well, I guess I could talk to George Washington...\".\nYou are left with the vague feeling that you just missed the opportunity of a lifetime.\nYOU LOSE!\n"
loseMsg2:	.asciiz "\nJeff looks upset and leaves. The world goes back to being as humdrum as it was before.\nYOU LOSE!\n"
loseMsg3:	.asciiz "\nYou quickly leap forward and slap the man in the face. He swings his large axe and cuts you in two.\nYOU LOSE!\n"
loseMsg4:	.asciiz "\nLeif grows impatient with your insolence. He decides to sacrifice you to Odin so that victory will be favorable in their endeavor.\nYOU LOSE!\n"

meetJeff:	.asciiz "\nYou answer the door, and a strange man in a perfectly white suit comes in.\n"
jeff:		.asciiz "Jeff: "
jeffIntro1:	.asciiz "\"Hello, my name is Jeffrey Bloomford, formerly of the Ministry of Causal and Temporal Affairs.\"\n"
jeffIntro2:	.asciiz "\"Today, I'd like to offer you the ability to travel through time.\"\n"
jeffHowToUse:.asciiz "\"You use it by selecting where you want to go, and when you want to arrive.\"\n"
jeffOffer:	.asciiz "Jeff offers you a time machine. Take it?\n"

winMsg1:	.asciiz "\nYou go on to have grand adventures.\nYOU WIN!\n"

InvenAccess:.asciiz "Which item would you like to use? (number left to right from 1)\n"
InvenHead:	.asciiz "\nYou are carrying:\n["
wallet:		.asciiz "a wallet, "
timeMachine:.asciiz "a hand-dandy time machine, "
InvenFoot:	.asciiz "]\n"

diamond:	.asciiz "      ^\n     /|\\n    / ^ \\n   / / \ \\n  / / ^ \ \\n  \ \ v / /\n   \ \ / /\n    \ v /\n     \|/\n      v\n"
betterDiamond: .asciiz "
      __________________
    .-'  \ _.-''-._ /  '-.
  .-/\   .'.      .'.   /\-.
 _'/  \.'   '.  .'   './  \'_
:======:======::======:======:
 '. '.  \     ''     /  .' .'
   '. .  \   :  :   /  . .'
     '.'  \  '  '  /  '.'
       ':  \:    :/  :'
         '. \    / .'
           '.\  /.'
             '\/'"
TMimg:		.asciiz "You got a Handy-Dandy Time Machine!
           NMMMMMZ    $M
          .MM    8MMMMMM
           IMMMMMMM    
                DMMMMMMMMMMM? 
  ..  DMMMMMMMMMM          IMMM  
    MM  ......................MM
    MM  .DMMMMMMMMMMMMMMM     MM
    MM  ..M............ M.....MM
    MM  ..MM............M.....MM
    IM  ..MMMMMMMMMMMMMMM.....MM
    MM          ...............M
    MM   . . . =MMMMMMMMMMM...=M
    MM     DMMMM7       ..MM..MM
    MM   .M$ . .......=?..MM..MM
    MM   .M. 7M.......MM..MM..MM
     M    M     ..........MM..MM
     M   .M. . ...........MM..MM
     M    M    M.....=?...MM..M 
     M   NM. .IZ.....MM....M..M.
     M   MM? . ...........NM..M.
  .. M..... $MMMMMMMMMMMMM7 .=M. 
  .. M  .................. NMM$.
 ... MMMMMMMMMMMMMMMMMMMMMMM\n"

travel1:	.asciiz "Where do you want to go?\n"
travel2:	.asciiz "When do you want to get there?\n"

Options1:	.asciiz "[yes = 1, no = 2]\n"							# Basic yes/no
Options2:	.asciiz "[talk = 1, search = 2, open inventory = 3]\n"	# Usual scene options.
Options3:	.asciiz "[Egypt = 1, America = 2]"						# Location travel options
Options4:	.asciiz "[Ancient Times = 1, Twenty years ahead = 2]"	# Time travel options
Options5:	.asciiz "[join quest = 1, don't join = 2, talk more = 3]"
Prompt:   	.asciiz "\nWell? => "
Again:		.asciiz "\n\n--------------------------------------------------------------------------------\nPlay Again?\n"

# a word boundary alignment
        .align 2

# reserve a word space
INVEN:		.word 1, 0, 0, 0, 0, 0, 0, 0, 0, 0	# The inventory just stores ints. Ints represent specific items. 0 = blank slot.
LEN:		.word 10	# constant configuration number that sets teh length of the inventory array