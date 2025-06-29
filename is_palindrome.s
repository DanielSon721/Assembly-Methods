# Daniel Son, 119710265, djson721

is_palindrome:
    #PROLOGUE
    subu $sp, $sp, 16                   # Expand stack
    sw $ra, 16($sp)                     # Save return address on the stack
    sw $fp, 4($sp)                      # Save frame pointer on the stack
    addu $fp, $sp, 16                   # Set new frame pointer
    
    li   $v0, 0                         # Initialize length = 0
    move $v1, $a0                       # Pointer to character in string

    jal strlen                          # Call to strlen function

    div $v0, $t0, 2                     # Divide strlen by 2
    move $t1, $v0                       # strlen / 2 in $t1

    li $t2, 0                           # int i = 0

iterative_loop:
    bge $t2, $t1, return_true           # while i < strlen / 2 (returns true if condition is reached)

    sub $v0, $t0, $t2                   # strlen / 2 - i
    sub $v0, $v0, 1                     # strlen / 2 - i - 1
    move $t3, $v0                       # Store strlen / 2 - i - 1 in t3

                                        # t0 = strlen
                                        # t1 = strlen / 2
                                        # t2 = i
                                        # t3 = strlen / 2 - i - 1
                                        # a0 = string
                                
    add $v0, $a0, $t2                   # Compute address for string[i]
    lb  $t4, 0($v0)                     # Load string[i]

    add $v0, $a0, $t3                   # Compute address for string[strlen / 2 - i - 1]
    lb  $t5, 0($v0)                     # Load string[strlen / 2 - i - 1]

    bne $t4, $t5, return_false          # If characters don't match, return false

    add $t2, $t2, 1                     # Increment i
    j iterative_loop                    # Recursive call

strlen:
    lb $t0, 0($v1)                    # Load character from string
    beqz $t0, strlen_loop_exit          # If character is null (end of string), break
    add $v0, $v0, 1                     # Increment length
    add $v1, $v1, 1                     # Increment to the next character
    j strlen                            # Recursive loop

strlen_loop_exit:
    move $t0, $v0                       # Store strlen in t0
    jr $ra                              # Return back to main function

return_true:
    li $v0, 1                           # Store 1 (true) as return value
    j return                            # Return

return_false:
    li $v0, 0                           # Store 0 (false) as return value
    j return                            # Return
   
return:
    #EPILOGUE
    move $sp, $fp                        # Restore stack pointer
    lw $ra, ($fp)                        # Restore return address
    lw $fp, -12($fp)                     # Restore frame pointer
    j $ra                                # Jump back to return address