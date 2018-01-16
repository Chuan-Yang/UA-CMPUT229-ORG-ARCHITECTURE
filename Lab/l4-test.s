.data
          .space 1
  not_aligned:  .space 4

          .text
  main:
  	sw  $t0, not_aligned	                # address exception
	li  $t0, 0x7fffffff; addi $t1, $t0, 1	# overflow exception 
	break 4  			        # break exception
	li  $t0, 4;  teqi $t0, 4	        # trap exception
	li  $v0, 10; syscall                    # exit
  # ------------------------------
