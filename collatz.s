# Daniel Son, 119710265, djson721

collatz:
    #PROLOGUE
    subu $sp, $sp, 8                # Expand stack
    sw $ra, 8($sp)                  # Save return address on the stack
    sw $fp, 4($sp)                  # Save frame pointer on the stack
    addu $fp, $sp, 8                # Set new frame pointer

    lw $t0, 4($fp)                  # t0 = inputs[0] (n)
    lw $t1, 8($fp)                  # t1 = d
 
    beq $t0, 1, base_case           # if (n == 1)

    andi $t3, $t0, 1                # Bitwise AND with 1 to check the least significant bit 
    beq $t3, 1, odd                 # if (n % 2)

even:
    divu $t0, $t0, 2                # n / 2
    addi $t1, $t1, 1                # d + 1

    subu $sp, 8                     # Save n and d for use in recursive call 
    sw $t0, 4($sp)                  # Save n on stack
    sw $t1, 8($sp)                  # Save d on stack

    jal collatz                     # Recursive call

    j return                        # Return

odd:
    li $t3, 3                       # Load 3 into t3
    mul $t0, $t0, $t3               # Multiply n by 3
    addu $t0, $t0, 1                # 3 * n + 1
    addu $t1, $t1, 1                # d + 1

    subu $sp, 8                     # Expand stack to save n and d for use in recursive call
    sw $t0, 4($sp)                  # Save n on stack 
    sw $t1, 8($sp)                  # Save d on stack 

    jal collatz                     # Recursive call
    
    j return                        # Return

base_case:
    move $v0, $t1                   # Store d as return value (base case)

return:
    #EPILOGUE
    move $sp, $fp                   # Restore stack pointer
    lw $ra, ($fp)                   # Restore return address
    lw $fp, -4($fp)                 # Restore frame pointer
    jr $ra                          # Jump back to return address