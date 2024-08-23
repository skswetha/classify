.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue
    # if less than 1, terminate
    li t0, 1
    blt a1, t0, end
    
    li t1, 0


loop_start:
    # end once t1 equals a1
    bge t1, a1, loop_end
    
    slli t2, t1, 2
    
    add t3, a0, t2 #current
    lw t4, 0(t3)
    
    # if pos, move to next
    bge t4, zero, loop_continue
    li t4, 0
    sw t4, 0(t3)
    


loop_continue:
    # add one and back to loop
    addi t1, t1, 1
    j loop_start



loop_end:
    # Epilogue

    jr ra

end:
    li a0, 36
    j exit
    ebreak