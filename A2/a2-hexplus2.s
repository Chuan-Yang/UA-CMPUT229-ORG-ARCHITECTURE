#Name : Chuan Yang
#ID :   1421992
#Section : LEC B1
#Lab Section : LAB H03

	.data
msg_input:    .asciiz "Please input the number: "
number:	      .space 9
length:       .word 0
result:       .word 0
	.text
main:	
	la   $a0, msg_input
	li   $v0, 4
	syscall
	li   $t2, 0
	la   $a0, number
	la   $t1, number
	li   $a1, 10
	li   $t4, 0xA
	li   $t5, 0xD
	li   $t6, 0x0
	li   $v0, 8
	syscall
	li    $t7, 0xf0000000
	li   $t9, 0xf
	jal  getlen

back:   sw   $t8, length	
	lw   $t0, length
	la   $t1, number
	li   $a1, 81

	
calculate:
	addi  $t0, -1       
	bltz  $t0, next
	sll   $t2, $t2, 4
	lb    $t3, 0($t1)
	bgt   $t3, 0x39, atof1    # if (character > ’9’) goto atof
	sub   $t3, $t3, 0x30
	or    $t2, $t3, $t2
	addi  $t1, $t1, 1
	b     calculate
# input: 12345678
# $t3 : '1' -> 1
# $t3: '2' -> 2
# $t1 : 0
# shift t1 to the left by 4 bits: sll $t1, $t1, 4
# t1 = 0
# t1 or t3 : 01 -> $t1 -> 10 -> or t3 -> 12 -> shift 120 -> or 3 -> 123


# end result
# $t4: 0x12345678
	
atof1: 
	sub   $t3, $t3, 0x57
	or    $t2, $t3, $t2
	addi  $t1, $t1, 1
	b     calculate


next:	
	la   $t1, number
	li   $a1, 10
	lw   $t0, length   
	addi $t2, $t2, 2	# t2 += 2
	beqz  $t9, reset        # check if t9 == 0x0 which means length = 8 
	beq  $t9, $t7, check    # then no need for shifting
	and  $t8, $t9, $t2
	bne  $t8, 0, add_length
	
reset:  li, $t9, 0xf0000000
	jal check

check: 	and  $t8, $t7, $t2
	beq  $t8, 0, shift

	jal  print_out 

shift:
	sll  $t2, $t2, 4
	and  $t8, $t7, $t2     # take the every character out 
	beq  $t8, 0, shift 
	jal  print_out 

add_length:
	addi  $t0, $t0, 1
	jal  check 

end:
	la    $a0, number
	li    $v0, 4
	syscall
	li   $v0, 10
	syscall	

print_out:
	addi  $t0, -1       
	bltz  $t0, end
	and   $t3, $t2, $t7
	srl   $t3, $t3, 28
	bgt   $t3, 0x9, atof2    # if (character > ’9’) goto atof
	addi  $t3, $t3, 0x30
	sb    $t3, 0($t1)
	sll   $t2, $t2, 4
	addi  $t1, $t1, 1
	b     print_out
	


atof2: 
	addi  $t3, $t3, 0x57
	sb    $t3, 0($t1)
	sll   $t2, $t2, 4
	addi  $t1, $t1, 1  
	b     print_out

getlen:
	lb    $t0, 0($t1)
	beq   $t0, $t4, back
        beq   $t0, $t5, back
	beq   $t0, $t6, back
	addi  $t1, $t1, 1
	addi  $t8, $t8, 1
	sll   $t9, $t9, 4
	b     getlen
	jr    $ra


print_NL:
	li   $a0, 0xA          # newline character
	li   $v0, 11
	syscall
	jr   $ra

# hex -> ascii for printin
# t1 = 1234 ..8
# mask:f0000000
# and 
#      10000000
# shift t1-> 23456780
