.data

.text
isqrt:
    #Prologue
    subu $sp, $sp, 8      # Expand stack
    sw $ra, 8($sp)        # Save return address on the stack
    sw $fp, 4($sp)        # Save frame pointer on the stack
    addu $fp, $sp, 8      # Set new frame pointer

    move $t0, $s1
    li $v0, 1
    syscall