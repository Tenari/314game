 .text
	.globl  main
main:   
#----------- First Scene: In the Dorm-------------------------------------
		jal		displayInventory
		# Set the scene, and offer the player the chance to answer the door.
		la		$a0, Dorm1			# load the argument 'Dorm1' into $a0
		la		$a1, Options1		# Options 1 is yes/no. The player either answers the door or not.
		jal		Scene				# print and get response in $v0

		# If they said yes, they continue. else, ask them again.
		addi	$t1, $zero, 1		# put 1 into $t1
		beq		$v0, $t1, dormContinue1# if response = 1, jump to dormContinue1
		
		# Ask them again.
		la		$a0, KnockAgain		# Load appropriate message into argument $a0 for Scene function
		la		$a1, Options1		# Options 1 is yes/no. The player either answers the door or not.
		jal		Scene				# Guy knocks again. What do you do? $v0 holds int answer.
		
		# They either said yes or they lose.
		beq		$v0, $t1, dormContinue1# $t1 still - 1. Thus, if response = $t1, jump to dormContinue1
		j 		lose1				# else, jump to lose1, because the player never answered the door.
		
	dormContinue1:
		# system call to print win message 
		li		$v0, 4				# load appropriate system call code into register $v0 (print string is code 4)
		la		$a0, Win1			# load 'Win1' address into $a0
		syscall						# do the call
		j 		end					# GAME IS OVER, so go to end
		
#---------- End First Scene: In the Dorm----------------------------------
#-------------- Lose Points/Labels ---------------------------------------

	# The lose point for never answering the door.
	lose1:
		# system call to print lose message 
		li		$v0, 4				# load appropriate system call code into register $v0 (print string is code 4)
		la		$a0, Lose1			# load 'Lose1' address into $a0
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
		
		# another code check.
		
		# all the code checks failed, so go to the next item.
		j		displayInventoryLoopCheck
		
		PrintWallet:
			li      $v0,4           # system call to print wallet
			la      $a0, wallet		# load the address of wallet into argument $a0
			syscall
			j		displayInventoryLoopCheck	# We printed the thing, so do the next item
        
		displayInventoryLoopCheck:
			beq     $t8, $t1, displayInventoryEnd  # if counter = arrayLen, goto exit label
			j		displayInventoryLoop	# Do the loop again.
	
	# function is complete, return.
	displayInventoryEnd:
	
		# Print the header
		li      $v0,4           # system call to print InvenFoot
		la      $a0, InvenFoot	# load the address of InvenFoot into argument $a0
		syscall
	
		jr 		$ra
#---------- end displayInventory function ------------------------------------------

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

Lose1:		.asciiz "\nYou continue sitting at your desk. The knocking subsides, and you hear a voice on the other side of the door say, \"Well, I guess I could talk to George Washington...\".\nYou are left with the vague feeling that you just missed the opportunity of a lifetime.\nYOU LOSE!"
Win1:		.asciiz "\nYou answer the door, and go on to have grand adventures.\nYOU WIN!"

InvenHead:	.asciiz "You are carrying:\n["
wallet:		.asciiz "a wallet, "
InvenFoot:	.asciiz "]\n"

Options1:	.asciiz "[yes = 1, no = 2]\n"
Options2:	.asciiz "[talk = 1, search = 2, open inventory = 3]\n"
Prompt:   	.asciiz "\nWell? => "
Again:		.asciiz "\n\n--------------------------------------------------------------------------------\nPlay Again?\n"

# a word boundary alignment
        .align 2

# reserve a word space
INVEN:		.word 1, 0, 0, 0, 0, 0, 0, 0, 0, 0	# The inventory just stores ints. Ints represent specific items. 0 = blank slot.
LEN:		.word 10