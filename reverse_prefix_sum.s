# Daniel Son, 119710265, djson721

reverse_prefix_sum:
    #PROLOGUE
    subu $sp, $sp, 8                    # Expand stack
    sw $ra, 8($sp)                      # Save return address on the stack
    sw $fp, 4($sp)                      # Save frame pointer on the stack
    addu $fp, $sp, 8                    # Set new frame pointer

    lw $t0, 0($a0)                      # Load array element (n) into t0
    beq $t0, -1, return_zero            # if(*arr == -1) return 0

    subu $sp, $sp, 4                    # Expand stack
    sw $a0, 4($sp)                      # Save a0 for later

    addu $a0, $a0, 4                    # Increment arr
    jal reverse_prefix_sum              # Recursive call

    lw $a0, 4($sp)                      # Load original value of n
    lw $t0, 0($a0)                      # Load value at a0 
    addu $sp, $sp, 4                    # Move stack pointer back to original location

    addu $v0, $t0, $v0                  # r = reverse_prefix_sum(arr+1) + (uint32_t)*arr
    sw $v0, 0($a0)                      # Store r into array at current address

    j return                            # Return

return_zero:
    li $v0, 0                           # Store 0 as return value
    j return                            # Return

return:
    #EPILOGUE
    move $sp, $fp                       # Restore stack pointer
    lw $ra, ($fp)                       # Restore return address
    lw $fp, -4($fp)                     # Restore frame pointer
    jr $ra                              # Jump back to return address