 .text
	.globl  main
main:   
	#start code----------------------------------------------------------
		# Set the scene, and offer the player the chance to answer the door.
		la		$a0, Dorm1			#load the argument 'Dorm1' into $a0
		jal		Scene				#print and get response in $v0

		# If they said yes, they win. else, ask them again.
		addi	$t1, $zero, 1		# put 1 into $t1
		beq		$v0, $t1, win1		# if response = 1, jump to win1
		
		# Ask them again.
		la		$a0, KnockAgain		# Load appropriate message into argument $a0 for Scene function
		jal		Scene				# Guy knocks again. What do you do? $v0 holds int answer.
		
		# They either said yes or they lose.
		beq		$v0, $t1, win1		# $t1 still - 1. Thus, if response = $t1, jump to win1
		j 		lose1				# else, jump to lose1, because the player never answered the door.
		
	win1:	
		# system call to print win message 
		li		$v0, 4				# load appropriate system call code into register $v0 (print string is code 4)
		la		$a0, Win1			# load 'Win1' address into $a0
		syscall						# do the call
		j 		end					# GAME IS OVER, so go to end
		
	lose1:
		# system call to print lose message 
		li		$v0, 4				# load appropriate system call code into register $v0 (print string is code 4)
		la		$a0, Lose1			# load 'Lose1' address into $a0
		syscall						# do the call
		j		end					# GAME IS OVER, so go to end
	#end code	---------------------------------------------------------

#-------------------------------------------------------------------------	
#The scene function prints the standard scene message (adress passed in to $a0) and asks for user response
#$v0 SceneInt($a0 = msgAddress) where $v0 = user response input as an int.
#note that $a0 is changed by operation.
Scene:
	# system call to print message stored at $a0
		li		$v0, 4			# load appropriate system call code into register $v0 (print string is code 4)
		syscall					# $a0 already equals the address of the string, so do the call
		
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


end:	
        li      $v0, 10         # system call 10; exit
        syscall
		
#-----  DATA ------------------------------------------------------------
        .data
Prompt:   	.asciiz "\nWell? => "
Dorm1:		.asciiz "You are bored, sitting at your desk, thinking about playing another game of LoL. College isn't all it was cracked up to be. Suddenly, a knock at the door. Answer it?\n[yes = 1, no = 2]\n"
KnockAgain:	.asciiz "\nYou ignore the knocking, being too busy staring at the wall. Soon, you hear another, louder knock at the door. Answer it?\n[yes = 1, no = 2]\n"
Lose1:		.asciiz "\nYou continue sitting at your desk. The knocking subsides, and you are left with the vague feeling that you just missed the opportunity of a lifetime.\nYOU LOSE!"
Win1:		.asciiz "\nYou answer the door, and go on to have grand adventures.\nYOU WIN!"

# a word boundary alignment
        .align 2

# reserve a word space
N: .space 4
curr:	.word	0
result: .space 	8