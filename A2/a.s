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
# main:   push the indexs of L into S
#	a0: the base addr of L
#	a1: the base addr of S
#	s0: use to check if the first index saved correctly(at pop function)
#
# qsort:  the main loop of the program, to sort evert part of the array L
#	t0: use for debugging 
#	a0: the base addr of L
#	a1: first 
#	a2: last
# back:  the function use to jump back after popping
#
# split: the second loop to sort the sub-array, for every unsorted part
# 	s1: 2*a1 use to be the index for half
#       s2: 2*a2
#	t1 = L[first]
#	t8 = addrs of L (use to change and loop)
#	t9 = unknown (index)
#	v0 = splitpoint
#
# rearrange: use to reaarange L when we find the smaller element than
# 	     the L[first] (the method talked in teh lecture)
#	t7 = L[unknown]
#
# change_pos: after the rearrange, we need to change the L[first]
#	      into the correct position
#	t3 = addr of S (for the new push)
#
# push_new: at the end of the split, we need to push the [sp+1, last]
#	       into stack S
#
# push: push L into S
#	
# pop: pop every element out of S
#
# print_out: print the results
#
# end: end
#---------------------------------------------------------------





	.data 
L:	.half 1,1,1,1,1,1,1,2,1,1,1,1,0
	.align 1
S:	.space 40
offset: .half 0
length:	.half 0
s_space: .asciiz " "

	.text
main:	la  $a0, L
	addi  $a1, $sp, 0
	addi  $s0, $sp, 0
	addi  $s0, -2
	jal push

qsort:  lh  $t0, offset
	addi $t0, 1
	ble $sp, $s0, print_out
	la  $a0, L
	addi $sp, $sp, -2	
	lh  $a2, 0($sp)		# get last = S[last]
	jal pop
back:	addi  $a1, $t1, 0 	# get first = S[first]
	#sh  $0, offset
	jal split
	
split:	bge $a1, $a2, qsort
	add $s1, $a1, $a1
	add $s2, $a2, $a2
	add $t0, $a0, $s1
	lh  $t1, 0($t0)		# get x->t1 = L[first]
	addi  $t8, $a0, 0	# t8 = addrs of L
	addi  $t9, $s1, 0	# t9 = first
	addi  $v0, $t9, 0	# get v0 = sp, sp = first
	jal rearrange

rearrange:
	addi $t9, $t9, 2
	bgt $t9, $s2, change_pos #if unknown > last, return sp 
	add  $t8, $a0, $t9	# get addr of L[unknown]
	lh   $t7, 0($t8)	# t7 = L[unknown]
	bge  $t7, $t1, rearrange
	addi $v0, $v0, 2	# sp+=1
	add  $a0, $a0, $v0
	lh  $t3, 0($a0)
	sh  $t3, 0($t8)		# L[unknown] = L[sp]
	sh  $t7, 0($a0)		# L[sp] = L[unknown]
	sub $a0, $a0, $v0
	b   rearrange

change_pos:
	add  $a0, $a0, $v0
	lh   $t3, 0($a0)	# L[sp] = x
	sh   $t1, 0($a0) 
	sub $a0, $a0, $v0
	add  $a0, $a0, $s1
	sh   $t3, 0($a0)	# L[first] = L[sp]
	sub  $a0, $a0, $s1
	#la   $t3, S		# t3 = addr of S (for the new push)
	li   $t5, 2
	div  $t4, $v0, $t5
	addi $t4, $t4, 1
	li   $t5, -1
	b    push_new
	

push_new:
	bgt $t4, $a2, change_last
	sh  $t4, 0($sp)
	addi $sp, $sp, 2
	addi $t5, $t5, 1
	addi $t4, $t4, 1
	b push_new

	
change_last:
	addi $t4, $t4, -1		
	sh  $t5, offset	
	li   $t5, 2
	div   $t4, $v0, $t5
	addi  $a2, $t4, -1
	b   split


push:	sh $t1, 0($sp)
	addi $a0, 2		# move to the next element of L & S
	addi $sp, 2
	lh $t0, 0($a0)		# get the next element of L
	addi $t1, $t1, 1	# t1 + 1 when we get an element	
	bnez $t0, push		# check if it's equal to 0, if so end, or continue
	#addi $s0, $a1, 0
	addi $t1, $t1, -1		
	sh  $t1, offset	
	addi $t1, $t1, 1
	sh  $t1, length
	jal qsort
	
pop:	lh $t1, 0($sp)
	li $t2, 0
	sh $t2, 0($sp)
	addi $sp, $sp, -2
	lh $t2, 0($sp)
	addi $t2, 1
	addi $t0, -1
	beq $sp, $s0, jump
	# beqz $t0, jump
	beq $t1, $t2, pop
	addi $sp, $sp, 2
	b back
jump:	addi $sp, $sp, 2
	b back

print_out:
	la  $a0, L
	lh  $a1, length
	li  $t0, 0
loop:	bge $t0, $a1, end
	lh  $t1, 0($a0)
	addi $t2, $a0, 0
	addi  $a0, $t1,0
	li  $v0, 1
	syscall
	jal print_space
	addi $a0, $t2, 2
	addi $t0, $t0, 1
	b loop

print_space:
	li $a0, 0x20
	li $v0, 11
	syscall
	jr $ra

end:	
	li   $a0, 0xA          # newline character
	li   $v0, 11
	syscall
	li $v0, 10
	syscall
