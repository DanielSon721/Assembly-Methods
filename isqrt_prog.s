   .data

# array terminated by 0 (which is not part of the array)
xarr:
   .word 1
   .word 12
   .word 225
   .word 169
   .word 16
   .word 25
   .word 100
   .word 81
   .word 99
   .word 121
   .word 144
   .word 0 

   .text

# main(): ##################################################
#   uint* j = xarr
#   while (*j != 0):
#     printf(" %d\n", isqrt(*j))
#     j++
#
main:
   # PROLOGUE
   subu $sp, $sp, 8        # expand stack by 8 bytes
   sw   $ra, 8($sp)        # push $ra (ret addr, 4 bytes)
   sw   $fp, 4($sp)        # push $fp (4 bytes)
   addu $fp, $sp, 8        # set $fp to saved $ra

   subu $sp, $sp, 8        # save s0, s1 on stack before using them
   sw   $s0, 8($sp)        # push $s0
   sw   $s1, 4($sp)        # push $s1

   la   $s0, xarr          # use s0 for j. init to xarr
main_while:
   lw   $s1, ($s0)         # use s1 for *j
   beqz $s1, main_end      # if *j == 0 go to main_end
   move $a0, $s1           # result (in v0) = isqrt(*j)
   jal  isqrt              # 
   move $a0, $v0           # print_int(result)
   li   $v0, 1
   syscall
   li   $a0, 10            # print_char('\n')
   li   $v0, 11
   syscall
   addu $s0, $s0, 4        # j++
   b    main_while
main_end:
   lw   $s0, -8($fp)       # restore s0
   lw   $s1, -12($fp)      # restore s1

   # EPILOGUE
   move $sp, $fp           # restore $sp
   lw   $ra, ($fp)         # restore saved $ra
   lw   $fp, -4($sp)       # restore saved $fp
   j    $ra                # return to kernel
# end main #################################################
.data

.text
isqrt:
    #PROLOGUE
    subu $sp, $sp, 8                    # Expand stack
    sw $ra, 8($sp)                      # Save return address on the stack
    sw $fp, 4($sp)                      # Save frame pointer on the stack
    addu $fp, $sp, 8                    # Set new frame pointer

    blt $a0, 2, return_n

    subu $sp, $sp, 4                    # Expand stack
    sw $a0, 4($sp)                      # Save a0 for later

    srl $a0, $a0, 2                     # Shift n right by 2 (n >> 2)
    jal isqrt                           # Recursive recursive_loop
    sll $t0, $v0, 1                     # t0 = small
    addu $t1, $t0, 1                    # t1 = large

    mul $t2, $t1, $t1                   # t2 = large * large
    lw $t3, 4($sp)                      # Load original value of n
    addu $sp, $sp, 4                    # Move stack pointer back to original location

    bgt $t2, $t3, return_small          # Return small
    j return_large

return_small:
    move $v0, $t0
    j return

return_large:
    move $v0, $t1
    j return

return_n:
    move $v0, $a0
    j return

return:
    #EPILOGUE
    move $sp, $fp         # Restore $sp
    lw $ra, ($fp)         # Restore $ra
    lw $fp, -4($fp)       # Restore $fp
    jr $ra