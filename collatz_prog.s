.data

arrow: .asciiz " -> "

.text

main:
    li      $sp,        0x7ffffffc      # initialize $sp

# PROLOGUE
    subu    $sp,        $sp,        8   # expand stack by 8 bytes
    sw      $ra,        8($sp)          # push $ra (ret addr, 4 bytes)
    sw      $fp,        4($sp)          # push $fp (4 bytes)
    addu    $fp,        $sp,        8   # set $fp to saved $ra

    subu    $sp,        $sp,        12  # save s0 and s1 on stack before using them
    sw      $s0,        12($sp)         # push $s0
    sw      $s1,        8($sp)          # push $s1
    sw      $s2,        4($sp)          # push $s2

    la      $s0,        xarr            # load address to s0

main_for:
    lw      $s1,        ($s0)           # use s1 for xarr[i] value
    li      $s2,        0               # use s2 for initial depth (steps)
    beqz    $s1,        main_end        # if xarr[i] == 0, stop.

# save args on stack rightmost one first
    subu    $sp,        $sp,        8   # save args on stack
    sw      $s2,        8($sp)          # save depth
    sw      $s1,        4($sp)          # save xarr[i]

    li      $v0,        1
    move    $a0,        $s1             # print_int(xarr[i])
    syscall 

    li      $v0,        4               # print " -> "
    la      $a0,        arrow
    syscall 

    jal     collatz                     # result = collatz(xarr[i])

    move    $a0,        $v0             # print_int(result)
    li      $v0,        1
    syscall 

    li      $a0,        10              # print_char('\n')
    li      $v0,        11
    syscall 

    addu    $s0,        $s0,        4   # make s0 point to the next element

    lw      $s2,        8($sp)          # save depth
    lw      $s1,        4($sp)          # save xarr[i]
    addu    $sp,        $sp,        8   # save args on stack
    j       main_for

main_end:
    lw      $s0,        12($sp)         # push $s0
    lw      $s1,        8($sp)          # push $s1
    lw      $s2,        4($sp)          # push $s2

# EPILOGUE
    move    $sp,        $fp             # restore $sp
    lw      $ra,        ($fp)           # restore saved $ra
    lw      $fp,        -4($sp)         # restore saved $fp
    jr      $ra                         # return to kernel
.data

# array terminated by 0 (which is not part of the array)
xarr:
.word 2, 4, 6, 8, 10, 0
.data

.text
collatz:
    #PROLOGUE
    subu $sp, $sp, 8                # Expand stack
    sw $ra, 8($sp)                  # Save return address on the stack
    sw $fp, 4($sp)                  # Save frame pointer on the stack
    addu $fp, $sp, 8                # Set new frame pointer 

    lw $t0, 4($fp)                   # t0 = inputs[0] (n)
    lw $t1, 8($fp)                   # t1 = d
 
    beq $t0, 1, base_case              # if (n == 1)

    andi $t3, $t0, 1      # Bitwise AND with 1 to check the least significant bit 
    beq $t3, 1, odd                 # if (n % 2)

even:
    divu $t0, $t0, 2                 # n / 2
    addi $t1, $t1, 1                 # d + 1

    subu $sp, 8           # Expand stack to save n and d for use in recursive call 
    sw $t0, 4($sp)        # Save n on stack
    sw $t1, 8($sp)        # Save d on stack

    jal collatz                # Recursive call

    j return

odd:
    li $t3, 3                       # Load 3 into t3
    mul $t0, $t0, $t3               # Multiply n by 3
    addu $t0, $t0, 1                 # 3 * n + 1
    addu $t1, $t1, 1                 # d + 1

    subu $sp, 8           # Expand stack to save n and d for use in recursive call
    sw $t0, 4($sp)        # Save n on stack 
    sw $t1, 8($sp)        # Save d on stack 

    jal collatz                # Recursive call
    
    j return

base_case:
    move $v0, $t1

return:
    #EPILOGUE
    move $sp, $fp                   # Restore $sp
    lw $ra, ($fp)                   # Restore $ra
    lw $fp, -4($fp)                 # Restore $fp
    jr $ra