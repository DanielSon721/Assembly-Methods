# Daniel Son, 119710265, djson721

isqrt:
    #PROLOGUE
    subu $sp, $sp, 8                    # Expand stack
    sw $ra, 8($sp)                      # Save return address on the stack
    sw $fp, 4($sp)                      # Save frame pointer on the stack
    addu $fp, $sp, 8                    # Set new frame pointer

    blt $a0, 2, return_n                # if (n < 2)

    subu $sp, $sp, 4                    # Expand stack
    sw $a0, 4($sp)                      # Save a0 for later

    srl $a0, $a0, 2                     # Shift n right by 2 (n >> 2)
    jal isqrt                           # Recursive call
    sll $t0, $v0, 1                     # t0 = small
    addu $t1, $t0, 1                    # t1 = large

    mul $t2, $t1, $t1                   # t2 = large * large
    lw $t3, 4($sp)                      # Load original value of n
    addu $sp, $sp, 4                    # Move stack pointer back to original location

    bgt $t2, $t3, return_small          # Return small
    j return_large                      # Return large

return_small:
    move $v0, $t0                       # Store small as return value
    j return                            # Return

return_large:
    move $v0, $t1                       # Store small as return value
    j return                            # Return

return_n:
    move $v0, $a0                       # Store n as return value
    j return                            # Return

return:
    #EPILOGUE
    move $sp, $fp                       # Restore stack pointer
    lw $ra, ($fp)                       # Restore return address
    lw $fp, -4($fp)                     # Restore frame pointer
    jr $ra                              # Jump to return address