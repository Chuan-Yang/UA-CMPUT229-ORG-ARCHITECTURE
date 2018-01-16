#Name : Chuan Yang
#ID :   1421992
#Section : LEC B1
#Lab Section : LAB H03


# --------------- Data Segment -----------
.data
msg_prompt:  .asciiz "\n"
msg_length:  .asciiz "length= "
msg_end:     .asciiz "end of program"
length:      .word   0
buff:        .space 81
swap:	     .space 81

# --------------- Text Segment -----------
	.text
main:	
	jal  getstr           # get input string	
	jal  getlen           # get string length
	
back:
	sw   $t2, length      # store length
	la   $a0, msg_length  # print length
	li   $v0, 4
	syscall
	lw   $a0, length
	li   $v0, 1
	syscall

	jal  print_NL         # print newline
#        ... more user code ...
	li   $t1, 0  
	la   $t3, buff
	li   $a1, 81

loop:   
	
	bgt  $t1, $t2, next    
#
#         ... loop body ...
	lb   $t4, 0($t3)    # restore 0($t1) in t4, 0($t1) in $t5 
	addi $t3, $t3, 1    # then make t1 -= 1 which makes t1 back to 
	lb   $t5, 0($t3)    # the last character then store t5 -> 0($t1)
	sb   $t4, 0($t3)    # then t4-> 1($t1)
	addi $t3, $t3, -1
	sb   $t5, 0($t3)	
	addi $t3, $t3, 2
	addi $t1, 2          # $t1= $t1 + 1
	b    loop
next:
#         ... more user code ...

	la   $a0, buff
	li   $v0, 4
	syscall

	jal  print_NL

	la   $a0, msg_end
	li   $v0, 4
	syscall	
	li   $v0, 10          # exit
	syscall

# ---------------
# procedure ’getstr’
getstr:
prompt:    
	la   $a0, msg_prompt  # display prompt
	li   $v0, 4
	syscall
	la   $a0, buff        # read string
	la   $t1, buff
	li   $a1, 81
	li   $t4, 0xA
	li   $t5, 0xD
	li   $t6, 0x0
	li   $v0, 8
	syscall
	jr $ra              # return from procedure
# ---------------
# procedure ’getlen’
getlen:
	lb    $t0, 0($t1)
	beq   $t0, $t4, back
        beq   $t0, $t5, back
	beq   $t0, $t6, back
	addi  $t1, $t1, 1
	addi  $t2, $t2, 1
	b     getlen
	jr    $ra

# ---------------
# procedure ’print_NL’
print_NL:
	li   $a0, 0xA          # newline character
	li   $v0, 11
	syscall
	jr   $ra

