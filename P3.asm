# Name:		Ron Landagan
# Email: 	rl0660551@swccd.edu
# Stu ID:	0660551

# Description:	

#################### MACROS ####################
.macro print(%string)
la $a0, %string
li $v0, 4 
syscall
.end_macro

.macro print_str (%str)
	.data
myLabel: .asciiz %str
	.text
	li $v0, 4
	la $a0, myLabel
	syscall
	.end_macro

.macro printInt(%int)
la $a0, %int
lb $a0, 0($a0)
li $v0, 1
syscall
.end_macro

.macro scanString(%string)
la $a0, %string
li $a1, 17
li $v0, 8
syscall
.end_macro

.macro scanInt(%int)
li $v0, 5
syscall

la $a0, %int
sb $v0, 0($a0)
.end_macro

.macro swap(%parentString, %childString, %positionInt)
la $a0, %parentString	#load the addresses of the two strings
la $a1, %childString

add $t0, %positionInt, $a0	#load the character at positionInt of parentString
lb  $t1, 0($t0)

add $t0, %positionInt, $a1	#store the character at positionInt of child
sb $t1, 0($t0)
.end_macro

.macro terminate (%termination_value)
li $a0, %termination_value
li $v0, 17
syscall
.end_macro

#################### DATA ####################
.data

	parent1:	.space 17	#empty space to receive input from user
	parent2:	.space 17
	upperLimit:	.space 1
	child1:		.space 17
	child2:		.space 17
	
	prompt1:	.asciiz "Enter your first string with no spaces (16 total): "
	prompt2:	.asciiz "\nEnter your second string with no spaces (16 total): "
	prompt3:	.asciiz "\nEnter an integer between 0 & 15: "
	
	result1:	.asciiz "You entered the following: \n"
	
########################## MAIN ###########################
# (main method, calls macros, which call underlying methods)
.globl main
.text

	main:
		jal getInput		# get user inputs
		jal outputCtrl		# print out what the user entered in
		jal copySwapController	# run the hard logic loops
		jal printResults	# finally, print out the results
		j   end			# jump to the end (don't repeate code below)
		
########################## get inputs #####################
	
	getInput:
	
	print(prompt1)
	scanString(parent1)
	
	print(prompt2)
	scanString(parent2)
	
	print(prompt3)
	scanInt(upperLimit)
	
	jr $ra
	
################### copy/swap controller ##################

	copySwapController:
	
	print_str("Creating newly evolved candidates from your specified inputs...\n")
	
	la $s0, upperLimit
	lb $s0, 0($s0)	# this loads the upperLimit to s0
	addi $s0, $s0, 1
	li $s1, 16	# this loads the string limit to s1
	
	li $t3, 0	# t3 is int i=0
WHILE1:	# this loop puts the first upperLimit characters of parent1 into child1
	
	swap(parent1, child1, $t3)
	addi $t3, $t3, 1
	bne $t3, $s0, WHILE1

WHILE2:	# this loop puts the last characters of parent2 into child1
	
	swap(parent2, child1, $t3)
	addi $t3, $t3, 1
	bne $t3, $s1, WHILE2
	
	li $t3, 0	# t3 is int i=0
WHILE3:	# this loop puts the first upperLimit characters of parent2 into child2
	
	swap(parent2, child2, $t3)
	addi $t3, $t3, 1
	bne $t3, $s0, WHILE3

WHILE4: # this loop puts the last characters of parent1 into child2
	
	swap(parent1, child2, $t3)
	addi $t3, $t3, 1
	bne $t3, $s1, WHILE4		
	
	jr $ra
	
##################### print output ########################

	outputCtrl:
	
	print(result1)
	
	print(parent1)
	print_str("\n")
	
	print(parent2)
	print_str("\n")
	
	printInt(upperLimit)
	print_str("\n\n")
	
	jr $ra
	
	
################### print results #######################

	printResults:
	
	print_str("Child One and Child Two are shown below:\n\n")
	
	print(child1)
	print_str("\n")
	
	print(child2)
	print_str("\n")

####################### end ############################### (end of program)

	end:
		terminate(0)
