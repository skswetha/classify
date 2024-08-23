.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:

    # Prologue
    li t0, 1
    blt a2, t0, end1
    blt a3, t0, end2
    blt a4, t0, end2
    
    li t1, 0 # counter
    li t2, 0 # product
   

loop_start:
    bge t1, a2, loop_end
    slli t3, t1, 2
    
    
    mul t4, t3, a3 # stride a0
    mul t5, t3, a4 # stride a1
    
    add t4, t4, a0 # curr a0
    add t5, t5, a1 # curr a1
    lw t4, 0(t4) 
    lw t5, 0(t5)
    
    mul t3, t4, t5 # product
    add t2, t2, t3 # add to sum
       
    addi t1, t1, 1
    j loop_start



loop_end:
    # Epilogue
    mv a0, t2

    jr ra


end1:
    li a0, 36
    j exit
    
end2: 
    li a0, 37
    j exit