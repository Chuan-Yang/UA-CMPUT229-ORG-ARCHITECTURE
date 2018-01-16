#Name : Chuan Yang
#ID :   1421992
#Section : LEC B1
#Lab Section : LAB H03


	.data
strOld: .space 81
strNew: .space 81
strMain: .space 81
msg_input1:    .asciiz "Please input srtMain: "
msg_input2:    .asciiz "Please input srtOld: "
msg_input3:    .asciiz "Please input srtNew: "
lengthMain:  .word 0
lengthNew:   .word 0


	.text
main:
	li   $t4, 0xA
	li   $t5, 0xD
	li   $t6, 0x0	
	
	la   $a0, msg_input1
	li   $v0, 4
	syscall
	la   $a0, strMain
	la   $t1, strMain
	li   $a1, 81
	li   $v0, 8
	syscall
	li  $t8, 0
	jal getlen1
back2:	sw   $t8, lengthMain	
	
	la   $a0, msg_input2
	li   $v0, 4
	syscall
	la   $a0, strOld
	la   $t1, strOld
	li   $a1, 81
	li   $v0, 8
	syscall
	li  $t8, 0
	jal getlen2
back4:	sw   $t8, lengthNew	

	la   $a0, msg_input3
	li   $v0, 4
	syscall
	la   $a0, strNew
	la   $t1, strNew
	li   $a1, 81
	li   $v0, 8
	syscall
	la   $t1, strMain         # the address of strMain
	la   $t2, strOld 	  # the address of strMain
	lw   $t8, lengthMain      # the length of strMain
	lw   $t9, lengthNew       # teh length of strOld(New)
	

loop:	
	addi $t9, $t9, -1    
	bltz $t9, change	  # if t9 = 0, change the same part of strMain
	addi $t8, $t8, -1	  # and strOld to srtNew
	bltz $t8, print_out       # if t8 = 0, print_out the new strMain 
back1:	lb  $t4, 0($t1)	 	  # t4 = current character of strMain
	lb  $t5, 0($t2)		  # t5 = current character of strOld
	addi $t1, $t1, 1
	addi $t2, $t2, 1
	bne  $t4, $t5, reset      # if t4!= t5, reset the vaule of t9 and t2
	jal loop		



reset:  lw  $t9, lengthNew
	la  $t2, strOld
	b   loop	


change: la  $t3, strNew 	# the address of the strNew
	lw  $t7, lengthNew
	sub $t1, $t1, $t7		 
back3:  addi $t7, $t7, -1	# if t7 = 0 -> change done
	bltz $t7, update	
	lb  $t5, 0($t3)		# save every character into t5
	sb  $t5, 0($t1)		# change strMain by strNew
	addi $t1, $t1, 1
	addi $t3, $t3, 1
	b   back3
update:
	lw  $t9, lengthNew
	addi $t9, $t9, -1
	la  $t2, strOld
	b   back1

print_out:
	la   $a0, strMain
	li   $v0, 4
	syscall
	li   $v0, 10
	syscall


getlen1:
	lb    $t0, 0($t1)
	beq   $t0, $t4, back2
        beq   $t0, $t5, back2
	beq   $t0, $t6, back2
	addi  $t1, $t1, 1
	addi  $t8, $t8, 1
	b     getlen1
	jr    $ra

getlen2:
	lb    $t0, 0($t1)
	beq   $t0, $t4, back4
        beq   $t0, $t5, back4
	beq   $t0, $t6, back4
	addi  $t1, $t1, 1
	addi  $t8, $t8, 1
	b     getlen2
	jr    $ra

print_NL:
	li   $a0, 0xA          # newline character
	li   $v0, 11
	syscall
	jr   $ra
