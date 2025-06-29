   .data
str1:
   .asciiz "abba"
str2:
   .asciiz "racecar"
str3:
   .asciiz "swap paws",
str4:
   .asciiz "not a palindrome"
str5:
   .asciiz "another non palindrome"
str6:
   .asciiz "almost but tsomla"

# array of char pointers = {&str1, &str2, ..., &str6}
ptr_arr:
   .word str1, str2, str3, str4, str5, str6, 0

yes_str:
   .asciiz " --> Y\n"
no_str:
   .asciiz " --> N\n"

   .text

# main(): ##################################################
#   char ** j = ptr_arr
#   while (*j != 0):
#     rval = is_palindrome(*j)
#     printf("%s --> %c\n", *j, rval ? yes_str: no_str)
#     j++
#
main:
   li   $sp, 0x7ffffffc    # initialize $sp

   # PROLOGUE
   subu $sp, $sp, 8        # expand stack by 8 bytes
   sw   $ra, 8($sp)        # push $ra (ret addr, 4 bytes)
   sw   $fp, 4($sp)        # push $fp (4 bytes)
   addu $fp, $sp, 8        # set $fp to saved $ra

   subu $sp, $sp, 8        # save s0, s1 on stack before using them
   sw   $s0, 8($sp)        # push $s0
   sw   $s1, 4($sp)        # push $s1

   la   $s0, ptr_arr        # use s0 for j. init ptr_arr
main_while:
   lw   $s1, ($s0)         # use s1 for *j
   beqz $s1, main_end      # while (*j != 0):
   move $a0, $s1           #    print_str(*j)
   li   $v0, 4
   syscall
   move $a0, $s1           #    v0 = is_palindrome(*j)
   jal  is_palindrome
   beqz $v0, main_print_no #    if v0 != 0:
   la   $a0, yes_str       #       print_str(yes_str)
   b    main_print_resp
main_print_no:             #    else:
   la   $a0, no_str        #       print_str(no_str)
main_print_resp:
   li   $v0, 4
   syscall

   addu $s0, $s0, 4       #     j++
   b    main_while        # end while
main_end:

   # EPILOGUE
   move $sp, $fp           # restore $sp
   lw   $ra, ($fp)         # restore saved $ra
   lw   $fp, -4($sp)       # restore saved $fp
   j    $ra                # return to kernel
# end main ################################################
# Daniel Son, 119710265, djson721

is_palindrome:
    #PROLOGUE
    subu $sp, $sp, 16                   # Make space on the stack for four words (16 bytes)
    sw $ra, 16($sp)                     # Save $ra (return address)
    sw $fp, 4($sp)                      # Save $fp (frame pointer)
    addu $fp, $sp, 16                   # Set new frame pointer
    
    li   $v0, 0                         # Initialize length = 0
    move $v1, $a0                       # Pointer to character in string

    jal strlen                          # Call to strlen function
    
    div $v0, $t0, 2                     # Divide strlen by 2
    move $t1, $v0                       # strlen / 2 in $t1

    li $t2,0                            # int i = 0

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
    lb   $t0, 0($v1)                    # Load byte from string
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
    move $sp, $fp                        # Restore $sp 
    lw $ra, ($fp)                        # Restore $ra
    lw $fp, -12($fp)                     # Restore frame pointer
    j $ra                                # Jump back to return address