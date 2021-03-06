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
		
#---------- End First Scene: In the Dorm----------------------------------
	
	win1:
		# system call to print win message 
		li		$v0, 4				# load appropriate system call code into register $v0 (print string is code 4)
		la		$a0, winMsg1		# load 'winMsg1' string's address into $a0
		syscall						# do the call
		
		j 		end					# GAME IS OVER, so go to end
	
	win2:
		# system call to print win message 
		li		$v0, 4				# load appropriate system call code into register $v0 (print string is code 4)
		la		$a0, winMsg2		# load 'winMsg2' string's address into $a0
		syscall						# do the call
		
		j 		end					# GAME IS OVER, so go to end
		
	win3:
		# system call to print win message 
		li		$v0, 4				# load appropriate system call code into register $v0 (print string is code 4)
		la		$a0, winMsg3		# load 'winMsg3' string's address into $a0
		syscall						# do the call
		
		j 		end					# GAME IS OVER, so go to end
		
	win4:
		# system call to print win message 
		li		$v0, 4				# load appropriate system call code into register $v0 (print string is code 4)
		la		$a0, winMsg4		# load 'winMsg4' string's address into $a0
		syscall						# do the call
		
		j 		end					# GAME IS OVER, so go to end

#------------------- Ancient Egypt Scene CODE: 1-------------------------------
ancientEgypt:
	# Set the scene, and offer the player the chance to answer the door.
	la		$a0, scenePE1		# load the scene setting message into $a0
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
	la		$a0, sceneFE1		# load the scene setting message into $a0
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
	la		$a0, scenePA1.1		# load the scene setting message into $a0
	la		$a1, Nothing		# No options--just enter to continue
	jal		Scene				# print and get response in $v0
	
	# see ship and burly men
	la		$a0, scenePA1.2		# load the scene setting message into $a0
	la		$a1, Nothing		# No options--just enter to continue
	jal		Scene				# print and get response in $v0
	
	# Who are you, and what are you doing here?
	la		$a0, scenePA1.3		# load the scene setting message into $a0
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
		la		$a0, scenePA1.4		# load the scene setting message into $a0
		la		$a1, Nothing		# No options--just enter to continue
		jal		Scene				# print and get response in $v0
		
		# His response
		la		$a0, scenePA1.5		# load the scene setting message into $a0
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
			la		$a0, scenePA1.5.1		# load the scene setting message into $a0
			la		$a1, Nothing		# No options--just enter to continue
			jal		Scene				# print and get response in $v0
			
			# His response
			la		$a0, scenePA1.5.2		# load the scene setting message into $a0
			la		$a1, Nothing		# No options--just enter to continue
			jal		Scene				# print and get response in $v0
	
	PAContinue2:
		# Your answer
		la		$a0, scenePA1.6		# load the scene setting message into $a0
		la		$a1, Nothing		# No options--just enter to continue
		jal		Scene				# print and get response in $v0
		
		# His response
		la		$a0, scenePA1.7		# load the scene setting message into $a0
		la		$a1, Options1		# yes/no
		jal		Scene				# print and get response in $v0
		
		# They either said yes or they can't win, but don't know it yet.
		addi	$a0, $v0, 0			# Put response into the first argument for yesContinueNoLose function
		la		$a1, PAContinue3		# Put the 'wrong choice' label into second argument
		la		$a2, PAaddSword		# Put the 'right choice' label into third argument
		jal		yesContinueNoLose
		j		$v0
		
		PAaddSword:
			# Display the asciiart
			li		$v0, 4				# load appropriate system call code into register $v0 (print string is code 4)
			la		$a0, swordImage		# Load the image into the argument.
			syscall						# do the call
			
			jal		pause
			
			# Add the time machine he gave you into your inventory.
			addi	$a0, $zero, 2		# 2 = array location
			addi	$a1, $zero, 3		# 3 = sword item code
			jal		modifyInventory
	
	PAContinue3:
		# You follow the warriors west
		la		$a0, scenePA1.8		# load the scene setting message into $a0
		la		$a1, Nothing		# No options--just enter to continue
		jal		Scene				# print and get response in $v0
		
		# His response
		la		$a0, scenePA1.9		# load the scene setting message into $a0
		la		$a1, Options1		# yes/no
		jal		Scene				# print and get response in $v0
		
		# They either said yes or they can't win, but don't know it yet.
		addi	$a0, $v0, 0			# Put response into the first argument for yesContinueNoLose function
		la		$a1, PABranch2		# Put the 'wrong choice' label into second argument
		la		$a2, PABranch1		# Put the 'right choice' label into third argument
		jal		yesContinueNoLose
		j		$v0
		
	# The 'climb the tower branch'
	PABranch1:
		# You follow the warriors west
		la		$a0, scenePA1.10		# load the scene setting message into $a0
		la		$a1, Nothing		# No options--just enter to continue
		jal		Scene				# print and get response in $v0
		
		# Encounter Viz
		la		$a0, scenePA1.10.1		# load the scene setting message into $a0
		la		$a1, Options2		# talk/search/inventory
		jal		Scene				# print and get response in $v0
		
		#handle the options2 to use the sword.
		li		$t3, 3
		bne		$v0, $t3, lose5
		# else do this stuff
		la		$a0, scenePA1.10.2		# load the scene setting message into $a0
		la		$a1, Nothing		# talk/search/inventory
		jal		Scene				# print and get response in $v0
		
		j		win2
		
		
	# the not climb the tower branch
	PABranch2:
		# The berserkers work themselves into a furor
		la		$a0, scenePA1.11		# load the scene setting message into $a0
		la		$a1, Nothing		# No options--just enter to continue
		jal		Scene				# print and get response in $v0
		
		# Encounter Vis
		la		$a0, scenePA1.11.1		# load the scene setting message into $a0
		la		$a1, Options2		# talk/search/inventory
		jal		Scene				# print and get response in $v0
		
		#handle options2
		li		$t3, 3
		bne		$v0, $t3, lose7
		# else do this stuff		
		j		lose6

#--------------- End Ancient America Scene-------------------------------------

#-------------------- Future America Scene CODE: 4-----------------------------
futureAmerica:
	# Set the scene, and offer the player the chance to answer the door.
	la		$a0, sceneFA1		# load the scene setting message into $a0
	la		$a1, Options1		# yes/no
	jal		Scene				# print and get response in $v0
	
	li		$t2, 2
	beq		$t2, $v0, FACont1
	j		lose8
	
	FACont1:
		la		$a0, sceneFA2		# load the scene setting message into $a0
		la		$a1, Options1		# yes/no
		jal		Scene				# print and get response in $v0
		
		li		$t1, 1
		beq		$t1, $v0, FACont2
		j		lose9
	
	FACont2:
		la		$a0, sceneFA3		# load the scene setting message into $a0
		la		$a1, Options5		# yes/no/talk
		jal		Scene				# print and get response in $v0
		
		# Handle response
		addi	$t2, $zero, 2
		beq		$v0, $t2, lose10
		addi	$t3, $zero, 3
		beq		$v0, $t3, FATalk
		j		FACont3
		
		FATalk:
			la		$a0, sceneFA3.1		# load the scene setting message into $a0
			la		$a1, Nothing		# blank
			jal		Scene				# print and get response in $v0
			
			la		$a0, sceneFA3.2		# load the scene setting message into $a0
			la		$a1, Nothing		# blank
			jal		Scene				# print and get response in $v0
			
	FACont3:
		la		$a0, sceneFA4		# load the scene setting message into $a0
		la		$a1, Nothing		# blank
		jal		Scene				# print and get response in $v0
		
		la		$a0, sceneFA5		# load the scene setting message into $a0
		la		$a1, Options2		# yes/no
		jal		Scene				# print and get response in $v0
		
		li		$t1, 1
		beq		$t1, $v0, FACont4
		j		lose11
		
	FACont4:
		la		$a0, sceneFA6		# load the scene setting message into $a0
		la		$a1, Nothing		# blank
		jal		Scene				# print and get response in $v0
		
		la		$a0, sceneFA7		# load the scene setting message into $a0
		la		$a1, Nothing		# blank
		jal		Scene				# print and get response in $v0
		
		la		$a0, sceneFA8		# load the scene setting message into $a0
		la		$a1, Options1		# yes/no
		jal		Scene				# print and get response in $v0
		
		li		$t1, 1
		beq		$t1, $v0, win3
		j		lose12
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
	
	# The lose point for not joining the quest.
	lose5:
		# system call to print lose message 
		li		$v0, 4				# load appropriate system call code into register $v0 (print string is code 4)
		la		$a0, scenePA1.10.3		# load 'loseMsg3' address into $a0
		syscall						# do the call
		# system call to print lose message 
		li		$v0, 4				# load appropriate system call code into register $v0 (print string is code 4)
		la		$a0, loseMsg5		# load 'loseMsg3' address into $a0
		syscall						# do the call
		j		end					# GAME IS OVER, so go to end
	
	# The lose point for not joining the quest.
	lose6:
		# system call to print lose message 
		li		$v0, 4				# load appropriate system call code into register $v0 (print string is code 4)
		la		$a0, loseMsg6		# load 'loseMsg3' address into $a0
		syscall						# do the call
		j		end					# GAME IS OVER, so go to end
	
	# The lose point for not joining the quest.
	lose7:
		# system call to print lose message 
		li		$v0, 4				# load appropriate system call code into register $v0 (print string is code 4)
		la		$a0, loseMsg7		# load 'loseMsg3' address into $a0
		syscall						# do the call
		j		end					# GAME IS OVER, so go to end
	
	lose8:
		# system call to print lose message 
		li		$v0, 4				# load appropriate system call code into register $v0 (print string is code 4)
		la		$a0, loseMsg8		# load 'loseMsg8' address into $a0
		syscall						# do the call
		j		end					# GAME IS OVER, so go to end
	
	lose9:
		# system call to print lose message 
		li		$v0, 4				# load appropriate system call code into register $v0 (print string is code 4)
		la		$a0, loseMsg9		# load 'loseMsg9' address into $a0
		syscall						# do the call
		j		end					# GAME IS OVER, so go to end
	
	lose10:
		# system call to print lose message 
		li		$v0, 4				# load appropriate system call code into register $v0 (print string is code 4)
		la		$a0, loseMsg10		# load 'loseMsg10' address into $a0
		syscall						# do the call
		j		end					# GAME IS OVER, so go to end
		
	lose11:
		# system call to print lose message 
		li		$v0, 4				# load appropriate system call code into register $v0 (print string is code 4)
		la		$a0, loseMsg11		# load 'loseMsg11' address into $a0
		syscall						# do the call
		j		end					# GAME IS OVER, so go to end
		
	lose12:
		# system call to print lose message 
		li		$v0, 4				# load appropriate system call code into register $v0 (print string is code 4)
		la		$a0, loseMsg12		# load 'loseMsg12' address into $a0
		syscall						# do the call
		j		end					# GAME IS OVER, so go to end
	
	lose13:
		# system call to print lose message 
		li		$v0, 4				# load appropriate system call code into register $v0 (print string is code 4)
		la		$a0, loseMsg13		# load 'loseMsg13' address into $a0
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
		li		$t4, 2			# Set $t4 equal to 2
		beq		$t3, $t4, printTimeMachine# Print the time machine
		
		# If it's a 3, print sword.
		li		$t4, 3			# Set $t4 equal to 3
		beq		$t3, $t4, printSword# Print the sword
		
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
			
		printSword:
			li      $v0,4           # system call to print string
			la      $a0, sword		# load the address of sword into argument $a0
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
scenePE1:	.asciiz "\n You open your eyes to see hundreds of people bowing before you. A man with a golden dress and staff approaches you.\n Ka: \"Ah, the gods have answered us! You were sent down to lead us! Please, allow me to place the crown on your head.\" Do you let him?\n"

# The text for the Ancient America section of the game
AAscene1:	.asciiz "\nYou fly through time and space!!!\n...\nIt's pretty cool.\nYou arrive in what appears to be the friendly section of Ancient America.\n...\nA native girl approaches.\nWhat do you do?\n"
scenePA1.1:	.asciiz "\nRaining stars awaken the dark sky. A blazing fire pouring down, you drift into unconsciousness.\n"
scenePA1.2:	.asciiz "\nYou open your eyes, squinting at the bright sunlight.You are on a wooden ship in the ocean.You look around and see 20 burly men clad in leather and metal, rowing toward a large landmass. One of them with a large red beard approaches you.\n"
scenePA1.3:	.asciiz "\n ?: \"So, you're awake now, perhaps you can tell me who you are and what you're doing here?\"\nYou see the large man grasping an ornate poleaxe, glimmering in the sunlight.\n"
scenePA1.4:	.asciiz "\nYou: \"I've come from a far beyond time and land, seeking to go on an adventure!\"\n"
scenePA1.5:	.asciiz "\nLeif: \"My name is Leif, king of these northern lands. My men found you hovering above the sea in a trance-like state. They wanted to kill you, believing you were an agent of the wizard, Vis, that has plagued our colony in Vinland and kidnapped my bride. We are about to land in Vinland as we speak, and after we are heading to the wizard's tower just west of our settlement. I have selected this small, elite group of berserkers to end his reign of terror over our lands. If what you say is true, then join our quest.\"\n"
scenePA1.5.1:	.asciiz "\nYou: \"What can you tell me about Vis?\"\n"
scenePA1.5.2:	.asciiz "\nLeif: \"Vis is a powerful sorcerer. My people who were lucky enough to flee these lands say he possesses the magic of the gods, able to call forth lightning like Thor himself. I have prayed to Thor and the gods to vanquish this enemy from our lands and save my love. The answer to my prayers came to me in a dream. I knew I had to set out with only my most trusted warriors, and it was foretold that I would find a hero on this voyage. I believe that you are the hero I have seen in my dreams. You are the one who will slay the wizard and bring peace back to these lands.\"\n"
scenePA1.6:	.asciiz "\nYou: \"I will join you and your men, but I have no weapons with which to fight.\"\n"
scenePA1.7:	.asciiz "\nLeif: \"Here is my finest sword.\"\nLeif presents a large polished sword. In its hilt, carved runes delicately inlaid with gold and silver. Take the sword? \n"
scenePA1.8:	.asciiz "\nYou follow the warriors west, past the smoldering ruins of what once was a large settlement. In the fields and dirt paths, you see multiple piles of ash. Ahead you see a gray stone tower, rising above the trees.\n"
scenePA1.9:	.asciiz "\nAs you approach the tower, Leif commands that everyone hold their positions. He starts coming over to you. \nLeif: \"Hero, let me and my men charge the entrance to the tower and provide a distraction as you climb to the sole window and enter from the top.\"\nClimb the tower?\n"
scenePA1.10:	.asciiz "\nAs the men rush the entrance of the tower, you stay in the trees and make your way to the back. You see Vis' minions, goblins, charge out of the tower and meet the berserkers in battle. You reach the tower and start your upward climb to the window high above the ground.\n"
scenePA1.10.1:	.asciiz "\nYou climb through the window to see a woman sleeping. She doesn't respond to your touch or call. She does have a pulse. Suddenly, you feel an eerie gust of wind behind you. What do you do?\n"
scenePA1.10.2:	.asciiz "\nYou unexpectedly swing your sword in an arc, and catch Vis by surprise. The blade cuts through his neck, but no blood. He falls to his knees in defeat, and vanishes in a puff of dark cloud.\n"
scenePA1.10.3:	.asciiz "\nYou turn around to find Vis standing right behind you. He raises his hands and paralyzes your limbs with a bolt of lightning. \nYou: \"Why are you doing this?\"\nVis: \"I have spent centuries trying to find a starchild.\"\nHe looks towards the princess sleeping.\nVis: \"They truly are magical creatures. Even now she has no idea of the power that she holds. She will remain oblivious as I keep her in the dream world and use her energy to fuel my own power.\"\n"
scenePA1.11:	.asciiz "\nThe berserkers work themselves up into a furor, a blinding rage that allows them to feel no fear or pain. As you all rush the entrance, a large horn sounds, and goblins pour out of the door. You meet the first one with your sword, taking off its head. The goblins prove no match for the berserkers, and not a single man was lost in the initial battle.\n"
scenePA1.11.1:	.asciiz "\nBut now everything grows quiet. You funnel into the door and start making your way around the spiral staircase to the top of the tower. About halfway up, Vis appears on a floating platform in the middle of the tower. He activates a switch and the stairs start retracting into the tower walls and the floor below opens to reveal a pit with spikes\nWhat do you do?.\n"


# The text for the Future Egypt section of the game
sceneFE1:	.asciiz "\n You stumble through space and time and land hard on sand. You look around and see a group of tanks approaching you! One of the tanks fires and you are torn to pieces.\nYOU LOSE!\n"

# The text for the Future America section of the game
sceneFA1:	.asciiz "\nYou trip and stumble through time and space.\n...\nIt was kind of painful.\nYou arrive in what you hope is not the unfriendly section of Future America.\n...\nIt is. All of Future America is the unfriendly section.\nAn angry 5 year-old boy runs up to you asking you to follow him..\nDo you follow him?\n"
sceneFA2:	.asciiz "\nYou ignore the boy and head down the road. You come across a large gathering of people split into two sides. One one side you see protesters holding picket signs, on the other you see armed guards with anti-riot gear. One of the protesters motions you to come to her. Do you go?\n"
sceneFA3:	.asciiz "\n Lisa: \"Hello, my name is Lisa. We're here today protesting Halicorp's pollution of our city. For the past five years they've been poisoning our water supply, causing a massive increase in illness and death. The group here is just trying to raise awareness. Would you like to join our cause?\"\n"
sceneFA3.1:	.asciiz "\n You: \"How bad is the situation in this city?\"\n"
sceneFA3.2:	.asciiz "\n Lisa: \"You mean you don't know? The government is completely corrupt and corporations run this entire country. As a result, companies like Halicorp can get away with virtually anything. Those armed guards on the other side of the line are employed by Halicorp. They're not shooting us because it would be bad PR; but if we give them any inclination of violence they'll turn on us.\"\n"
sceneFA4:	.asciiz "\n You: \"How can I help?\"\n"
sceneFA5:	.asciiz "\n Lisa: \"Honestly, there's not much we can do other than spread the word and hope that people vote with their wallets to stop supporting Halicorp. Say, I've noticed you seem rather new around here. Who are you?\"\nTell her who you are?\n"
sceneFA6:	.asciiz "\n You: \"I am actually a time traveller. I've come here from approximately 20 years in the past.\"\nFor some reason you feel comfortable admitting the truth around Lisa. You show her your handy-dandy-time-machine as proof.\n"
sceneFA7:	.asciiz "\n Lisa appears to be stunned.\n Lisa: \"You can change what has happened to our country! You have the ability to change the future with your knowledge!\"\n"
sceneFA8:	.asciiz "\n You ask how that would be possible. Lisa tells you that when the world hit peak-oil, there was a worldwide panic and the USA's creditors called in their debts. This bankrupted the nation, leaving the void of power to be snatched up by huge multinational corporations. A viable alternative energy was discover 5 years later, but by then it was too late. Lisa explains that since the new energy is open-source, that you can bring back the solution to your timeperiod and prevent the global meltdown that occurred. At least, that was the plan. Do you go along with it?\n"

loseMsg1:	.asciiz "\nYou continue sitting at your desk. The knocking subsides, and you hear a voice on the other side of the door say, \"Well, I guess I could talk to George Washington...\".\nYou are left with the vague feeling that you just missed the opportunity of a lifetime.\nYOU LOSE!\n"
loseMsg2:	.asciiz "\nJeff looks upset and leaves. The world goes back to being as humdrum as it was before.\nYOU LOSE!\n"
loseMsg3:	.asciiz "\nYou quickly leap forward and slap the man in the face. He swings his large axe and cuts you in two.\nYOU LOSE!\n"
loseMsg4:	.asciiz "\nLeif grows impatient with your insolence. He decides to sacrifice you to Odin so that victory will be favorable in their endeavor.\nYOU LOSE!\n"
loseMsg5:	.asciiz "\nVis telports you 1000 years into the future. He shows you his empire that was built with magic and slavery. You are then teleported to a dark void where you will spend the rest of eternity alone.\nYOU LOSE!\n"
loseMsg6:	.asciiz "\nYou take your sword and leap toward Vis on the platform. You thrust your sword towards his heart, but you miss and hit his shoulder. The platform disappears under your feet. As you fall to your death you see the rest of stairs retract and the men follow you into the pit.\nYOU LOSE!\n"
loseMsg7:	.asciiz "\nYou open your mouth but no words come out. You see Leif jump onto the platform and cut off Vis' arm with his axe. Vis sends a shockwave towards Leif that propels him off the platform and down the pit. Other berserkers jump to the platform, but they too are repelled. As you stand there in silence you wait until the stair fully retracts, causing you to fall to your death with the other men.\nYOU LOSE!\n"
loseMsg8:	.asciiz "\nThe boy leads you to the city docks where you are surrounded by a group of men. They beat you unconscious, steal your possessions, and dump you into the river where you drown. \nYOU LOSE!\n"
loseMsg9:	.asciiz "\n You are pushed into the armed guards by rowdy protesters, and taken to a private jail. The guards can't find your DNA in their system, so they interrogate you. They discover your time machine and stop asking you questions. Then a large man enters the room and injects you with a syringe. You die a few minutes later.\nYOU LOSE! \n"
loseMsg10:	.asciiz "\nYou decline and continue on your way. As you walk down the street you are stabbed by a random stranger and die. \nYOU LOSE!\n"
loseMsg11:	.asciiz "\nYou refuse to reveal any information. You continue making friends among the protesters until the armed guards open fire on the crowd. You are shot.  \nYOU LOSE!\n"
loseMsg12:	.asciiz "\nYou don't think that's a very good idea, playing around with global events. A fellow protester hears the proposal, however, and steals your time machine and runs off. You are now stuck 20 years in future America. You develop cancer a year later and die.\nYOU LOSE!\n"
loseMsg13:	.asciiz "\nYou refuse and try to tell the man that you are not a god, nor a king. The crowd erupts in panic and anger, and soldiers come over and cut off your head.\nYOU LOSE!\n"

meetJeff:	.asciiz "\nYou answer the door, and a strange man in a perfectly white suit comes in.\n"
jeff:		.asciiz "Jeff: "
jeffIntro1:	.asciiz "\"Hello, my name is Jeffrey Bloomford, formerly of the Ministry of Causal and Temporal Affairs.\"\n"
jeffIntro2:	.asciiz "\"Today, I'd like to offer you the ability to travel through time.\"\n"
jeffHowToUse:.asciiz "\"You use it by selecting where you want to go, and when you want to arrive.\"\n"
jeffOffer:	.asciiz "Jeff offers you a time machine. Take it?\n"

winMsg1:	.asciiz "\nYou go on to have grand adventures.\nYOU WIN!\n"
winMsg2:	.asciiz "\nThe princess is released from Vis' magic. She awakens to find you holding her hand. Leif and his berserkers make their way into the chamber and offer you their heartfelt thanks. Leif is reunited with his bride. You travel back to the present time, to your dorm room again, and you go on to live a happy life.\nYOU WIN!\n"
winMsg3:	.asciiz "\nWith your newfound knowledge you head back in time and develop the world's best alternative to oil. Over the next few years, nations gradually decrease their oil imports, and peak-oil passes by without a panic. You go on to live a happy and healthy life.\nYOU WIN!\n"
winMsg4:	.asciiz "\nThe magistrate places the crown on your head and you become the leader of these people. Your knowledge allows you to build the greatest empire the world has ever seen.\nYOU WIN!\n"

InvenAccess:.asciiz "Which item would you like to use? (number left to right from 1)\n"
InvenHead:	.asciiz "\nYou are carrying:\n["
wallet:		.asciiz "a wallet, "
timeMachine:.asciiz "a hand-dandy time machine, "
sword:		.asciiz "a sword, "
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
swordImage:	.asciiz "....                       =MMMMMMMMM$  
........                  MM$   ...M ...
  ..                    =MM        M    
  ..                  .MM$       . M . .
  ..                 ?MM    =MM  . M . .
        ............MM ...NMM .....M....
        ........  =MM   MMM.    ..MM....
        ........ NM$..=MM....... MM ....
 =MMM?  .......=MM...=MM.......?MM......
NM$ ZM  ......NM$...=M$......NMM........
MMMMM$       MM ...MM$......MM..........
IM7MM    . .MM....MM .....NMM...........
   MM     .MM   =MM ....DMM.............
  .MM?   .MM . .I$..=MMMM...............
   MMM   MZ. . ....NMZ..................
    MMM?MM      =MM$....................
    MM.MMM . . NM$ ..................
    MM   .  +MMM$...................
    MM NMM . M$...................
  .NM    . . MM?.................
 =MM..=MMMMM?.. MMMMNMMM........
MM$. NM$.. IMMD....NMM.M........
M..=MM$.......MMMMMMMMMZ........
M .MM...........................
MMMMM.........................\n"

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
