#---------------------------------------------------------------
# Assignment:           3
# Due Date:             March 11, 2016
# Name:                 Chuan Yang
# Unix ID:              chuan1
# Lecture Section:      B1
# Lab Section:          H3
# Teaching Assistant(s):   ----- -----
#---------------------------------------------------------------

#---------------------------------------------------------------
# main: check if N>1, if not directly print 1, or jump to the 
#	recursice calls
#	$a0 = X
#	$a1 = N
#	$a2 = addr of result
#
# powN_1, powN_2: the recursive funtion
#
# clear_reg: reset all the regs used to 0
#
# print_frame: print every step of the calls 
#
# end: print the result & end
#---------------------------------------------------------------


	.data
N:	.half 10	 # stores the positive integer n
X:	.half 3		 # stores the positive integer x
result: .word 0		 # stroes 'result'
#-----------------------the following are all for print
line1:	.asciiz  "=============================================================\n"
line2:	.asciiz  "\n-------------------------------------\n"
part1: 	.asciiz  "address("
part2:	.asciiz  ")|a0 = "
part3:	.asciiz  ")|a1 = "
part4:	.asciiz  ")|ra = "
p_result: .asciiz "result = "


	.text
main:	la $a2, result
	la  $a0, line1
	li  $v0, 4
	syscall
	lh $a0, X
	lh $a1, N
	subu  $sp, 16
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $a3, 12($sp)
	bgt   $a1, 1, powXN_1	# check if N>1, if not directly print out 1
	li $a3, 1
	b end

powXN_1:	
	addi  $sp, -20
	sw    $ra, 16($sp)
	sw    $a0, 20($sp)
	sw    $a1, 24($sp)
	sw    $a2, 28($sp)
	sw    $a3, 32($sp)	
	b     clear_reg		# clean a0-a3
back1:	
	lw    $a0, 20($sp)
	lw    $a1, 24($sp)
	lw    $a2, 28($sp)
	lw    $a3, 32($sp)	
	bge   $a0, 1, powXN_2	# check if X > 1 
	li    $a3, 1
	sw    $a3, 0($a2)
	jal return

powXN_2:	
	subu  $a0, $a0, 1	# X-= 1
	jal   powXN_1		# recursive call
	addu  $a0, $a0, 1	# X += 1 
	mulou $a3, $a1, $a3	# a3 *= N
	sw    $a3, 0($a2)
	jal return

return:	jal print_frame 
	lw $ra, 16($sp)		# pop $ra
	addi $sp, $sp, 20
	jr $ra

print_frame:
#------------------------------- print a0
	la  $a0, part1
	li  $v0, 4
	syscall
	addi  $a0, $sp, 20
	li  $v0, 1
	syscall
	la  $a0, part2
	li  $v0, 4
	syscall
	addi  $a0, $sp, 20
	lw  $a0, 0($a0)
	li  $v0, 1
	syscall
	la  $a0, line2
	li  $v0, 4
	syscall
#------------------------------- print a1
	la  $a0, part1
	li  $v0, 4
	syscall
	addi  $a0, $sp, 24
	li  $v0, 1
	syscall
	la  $a0, part3
	li  $v0, 4
	syscall
	addi  $a0, $sp, 24
	lw  $a0, 0($a0)
	li  $v0, 1
	syscall
	la  $a0, line2
	li  $v0, 4
	syscall
#------------------------------- print ra
	la  $a0, part1
	li  $v0, 4
	syscall
	addi  $a0, $sp, 16
	li  $v0, 1
	syscall
	la  $a0, part4
	li  $v0, 4
	syscall
	addi  $a0, $sp, 16
	lw  $a0, 0($a0)
	li  $v0, 1
	syscall
	li  $a0, 0xA
	li  $v0, 11
	syscall
	la  $a0, line1
	li  $v0, 4
	syscall

	jr  $ra


clear_reg: 
	li $a0, 0	# reset all teh values into 0
	li $a1, 0
	li $a2, 0
	li $a3, 0
	b  back1

end:	sw $a3, 0($a2)	
	addi  $a0, $a3, 0
	la  $a0, p_result
	li  $v0, 4
	syscall
	li  $v0, 1
	syscall
	li   $a0, 0xA          # newline character
	li   $v0, 11
	syscall
	li  $v0, 10
	syscall

