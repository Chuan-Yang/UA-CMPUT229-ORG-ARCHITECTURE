#Name : Chuan Yang
#ID :   1421992
#Section : LEC B1
#Lab Section : LAB H03

# --------------- Data Segment -----------
.data
msg_prompt:  .asciiz "\n"
msg_length:  .asciiz "length= "
length:      .word   0
buff:        .space 81

# --------------- Text Segment -----------
	.text
main:	
	jal  getstr           # get input string
	jal  getlen           # get string length
back:   sw   $t2, length      # store length
	la   $a0, msg_length  # print length
	li   $v0, 4
	syscall
	lw   $a0, length
	li   $v0, 1
	syscall

	jal  print_NL         # print newline
#        ... more user code ...

	lw   $t1, length      # $t1= length

loop:   
	addi $t1, -1          # $t1= $t1 - 1
	bltz $t1, next        # if (t1 < 0) goto next
#
#         ... loop body ...
	b    loop
next:
#         ... more user code ...
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
#	li   $t6, '\0'
	li   $v0, 8
	syscall
	jr $ra              # return from procedure
# ---------------
# procedure ’getlen’
getlen:
	lb    $t0, 0($t1)
	beq   $t0, $t4, back # check the character if it's equal to '\n','\r',
        beq   $t0, $t5, back # '/0', return to the main function
	beq   $t0, $t6, back
	addi  $t1, $t1, 1    # t1 = the address of the string
	addi  $t2, $t2, 1    # t2 = length
	b     getlen
	jr    $ra

# ---------------
# procedure ’print_NL’
print_NL:
	li   $a0, 0xA          # newline character
	li   $v0, 11
	syscall

