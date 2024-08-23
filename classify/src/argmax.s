.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    # Prologue
    # if less than 1, end
    li t0, 1
    blt a1, t0, end
    
    li t1, 0 # counter
    
    lw t2, 0(a0) # first element
    li t3, 0 # index
    


loop_start:
    # end once t1 equals a1
    bge t1, a1, loop_end
    
    slli t4, t1, 2
    
    add t5, a0, t4 # current
    lw t6, 0(t5)
    
    blt t2, t6, edit  
    j loop_continue

edit:
    mv t2, t6
    mv t3, t1

loop_continue:
    addi t1, t1, 1
    j loop_start


loop_end:
    # Epilogue
    mv a0, t3

    jr ra
    
end: 
    li a0, 36
    j exit
    ebreak
