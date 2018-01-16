#---------------------------------------------------------------
# Assignment:           4
# Due Date:             April 1, 2016
# Name:                 Chuan Yang
# Unix ID:              chuan1
# Lecture Section:      B1
# Lab Section:          H3
# Teaching Assistant(s):   ----- -----
#---------------------------------------------------------------
# run with command : xspim -mapped_io -exception_file lab4-exception.s -file a4-pyramid.s
#---------------------------------------------------------------

################################################################################
# lab4_hanler: the main function in this assignment
#	       when we press a key, then jump to the do_keyboard
#
# loop: main loop 
#	use to update the string and print the pyramid
# register use:
#	t0: imm value
#	t2: value of added, use to check if the frist valid key pressed
#	t9: addr of string	
#
# do_keyboard: get the information of the pressed key
# 	       then chekc if the key if in (i,d,r,l,q)
#	i : Increase the width N by 1 up to a maximum value of N=20
#	d : Decrease the width N by 1 up to a maximum value of N=1
#	r (right): Increase the left margin K by 1 up to a minimum value of K = 40
#	l (left): Decrease the left margin K by 1 down to a minimum value of K = 0
#	q: Quit the program
# 	then jumo to the funtion that the key is responded to 
# 	finally call lab4_handler_ret 
# register usage :
#	t3: the pressed key
#	t4: use to save the imm value

# pyramid & pyramid_print part is from the lab website		
#	
#
#
################################################################################

	.data
input_command: .asciiz "Please input the command (i, d, r, l, q):"	
N: .word 1
K: .word 0
command: .space 2
info1: .asciiz  "pyramid: N = "
info2: .asciiz  ", K = "
i: .byte 'i'		# check the input
d: .byte 'd'
r: .byte 'r'
l: .byte 'l'
q: .byte 'q'
s_v0:     .word 0
s_a0:     .word 0
char_fill:  .byte  '*'
char_space: .byte  ' '
string: .space 61
added:  .word 0 	# check if the valid key is pressed
addr:   .word 0

	.text
main:	
	# Enable keyboard interrupts	  
	li	$a3, 0xffff0000        # base address of I/O
	li	$s1, 2		       # $s1= 0x 0000 0002
	sw 	$s1, 0($a3)	       # enable keyboard interrupts

	# Enable global intserrupts
	li	$s1, 0x0000ff01	       # set IE= 1 (enable interrupts) , EXL= 0
	mtc0	$s1, $12	       # SR (=R12) = enable bits
	

#-------------------------------------------------------------------------------------

# main infinite loop

loop: 	
	la  $t9, string
	lb  $t1, 0($t9)

	lb  $t0, i	
	beq $t1, $t0, increase_N	# if t1 = i
		
	lb  $t0, d
	beq $t1, $t0, decrease_N	# if t1 = d

	lb  $t0, r
	beq $t1, $t0, increase_K	# if t1 = r

	lb  $t0, l
	beq $t1, $t0, decrease_K	# if t1 = l

	b print_info_pyramid

back:	  
	
	li  $t0, 0x0			# reset string
	la  $t9, string	
	sb  $t0, 0($t9)			
	
	li  $t2, 0			# reset added
	sw  $t2, added	

	li  $t0, 1000000		# delay loop
	jal delay_loop	
	
	b loop
	
delay_loop:
	addi $t0, $t0, -1
	bgez $t0, delay_loop		# back to the main loop	
	jr  $ra


#----------------------------------------------------------------------------
	.globl  lab4_handler   


lab4_handler:	
	# Save $at, $v0, and $a0
	.set noat
	move $k1 $at		# Save $at
	.set at
	sw   $v0 s_v0		# Not re-entrant and we can't trust $sp
	sw $a0, s_a0		# But we need to use these registers

	# Identify the interrupt source
	mfc0   $k0, $13		# $k0 = Cause Reg (R13)
	srl    $a0, $k0, 11	# isolate IP3 (interrupt bit 1) (for keyboard)
	andi   $a0, 0x1
	bgtz   $a0, do_keyboard

	b   lab4_handler_ret

#-------------------------------------------------------------------------------

do_keyboard:
	li  $t4, 0xffff0004		# get the information from the keyboard	
	lb  $t3, 0($t4)

	lw  $t2, added			# t2 = added
	bnez $t2, lab4_handler_ret

	lb  $t4, i			# if t3 = i
	beq $t3,$t4, add_string

	lb  $t4, d			# if t3 = d
	beq $t3,$t4, add_string

	lb  $t4, r			# if t3 = r
	beq $t3,$t4, add_string

	lb  $t4, l			# if t3 = l
	beq $t3,$t4, add_string

	lb  $t4, q			# if t3 = q
	beq $t3,$t4, exit

	b   lab4_handler_ret		# else : END

add_string:
	la  $t9, string	
	sb  $t3, 0($t9)			# update string
	li  $t2, 1			# update added
	sw  $t2, added			# after the first valid key pressed
	b   lab4_handler_ret

#-----------------------------------------------------------------------

increase_N:			# N += 1	
	lw  $t0, N
	li  $t1, 20
	addi $t0, $t0, 1
	bgt $t0, $t1, print_info_pyramid
	sw  $t0, N
	b  print_info_pyramid
	

decrease_N:			# N -= 1	
	lw  $t0, N
	li  $t1, 1
	addi $t0, $t0, -1
	blt $t0, $t1, print_info_pyramid
	sw  $t0, N
	b  print_info_pyramid
	
		
increase_K:			# K += 1
	lw  $t0, K
	li  $t1, 40
	addi $t0, $t0, 1
	bgt $t0, $t1, print_info_pyramid
	sw  $t0, K
	b  print_info_pyramid
	

decrease_K:			# K -= 1
	lw  $t0, K
	li  $t1, 0
	addi $t0, $t0, -1
	blt $t0, $t1, print_info_pyramid
	sw  $t0, K
	b  print_info_pyramid
	

exit: 	li $v0, 10		# exit
	syscall

#-----------------------------------------------------------------

print_info_pyramid:
	# print the line information for the pyramid
	la  $a0, info1
	li  $v0, 4
	syscall
	lw  $a0, N
	li  $v0, 1
	syscall
	la  $a0, info2
	li  $v0, 4
	syscall
	lw  $a0, K
	li  $v0, 1
	syscall
	jal print_NL

	addi  $sp, $sp, -8		# allocate frame: $a0, $a1
	lw    $a0, N	  		# $a0= N
	lw    $a1, K			# $a1= K
	jal   pyramid			# call pyramid(N,K)
	
	b  back			# back to the main loop

pyramid:  
	  addi $sp, $sp, -12		# allocate frame: $a0, $a1, $ra
	  sw   $a0, 12($sp)		# store $a0= N in caller's frame
	  sw   $a1, 16($sp)		# store $a1= K in caller's frame
	  sw   $ra,  8($sp)		# store $ra in pyramid's frame	

	  li   $t0, 2			# $t0= 2
	  ble  $a0, $t0, pyramid_line	# n <= 2: goto write line
	  addi $a0, $a0, -2		# n= n-2
	  addi $a1, $a1, 1              # k= k+1
	  jal  pyramid

pyramid_line:
	  lb   $a0, char_space		# $a0 = ' '
	  lw   $a1, 16($sp)		# $a1= K
	  jal  write_char

	  lb   $a0, char_fill		# $a0 = '*'
	  lw   $a1, 12($sp)		# $a1= N
	  jal  write_char

	  jal  print_NL			# print NL


pyramid_end:
	  lw   $ra, 8($sp)		# restore $ra
	  addi $sp, $sp, 12		# release stack frame
	  jr   $ra  			# return

# ------------------------------
# function write_char ($a0= char, $a1= count)
#

write_char:
	  beqz  $a1, write_char_end	# $a1 == 0: return
	  li    $v0, 11			# print character
	  syscall
	  addi  $a1, $a1, -1		# $a1 = $a1 -1
	  b     write_char

write_char_end:
	  jr    $ra		        # return


print_NL:
          li   $a0, 0xA   # newline character
          li   $v0, 11
          syscall
          jr    $ra


#--------------------------------------------------------------------------

lab4_handler_ret:
	lw  $v0  s_v0		# restore $v0, $a0, and $at
	lw  $a0, s_a0

	.set noat
	move $at $k1		# Restore $at
	.set at
	mtc0 $0 $13		# Clear Cause register
	mfc0  $k0 $12		# Set Status register
	ori   $k0 0x1		# Interrupts enabled
	mtc0  $k0 $12
	eret			# exception return









