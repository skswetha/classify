.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:

    # Error checks
    li t0, 0
    ble a1, t0, err
    ble a2, t0, err
    ble a3, t0, err
    ble a4, t0, err
    ble a5, t0, err
    ble a6, t0, err
    bne a2, a4, err

    # Prologue
    addi sp, sp, -40
    
    sw ra 0(sp)
    sw s0 4(sp) 
    sw s1 8(sp)
    sw s2 12(sp)
    sw s3 16(sp)
    sw s4 20(sp)
    sw s5 24(sp)
    sw s6 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    
    
    mv s0, a0 # pointer to the start of m0
    mv s1, a1 # # of rows (height) of m0
    mv s2, a2 # # of columns (width) of m0
    mv s3, a3 # pointer to the start of m1
    mv s4, a4 # # of rows (height) of m1
    mv s5, a5 # # of columns (width) of m1
    mv s6, a6 # pointer to the the start of d
    
    li s7, 0 # counter row (outer loop)
    li s8, 0 # counter col (inner loop)
    
    

outer_loop_start:
    bge s7, s1, outer_loop_end
    li s8, 0 # counter col (inner loop)
  

inner_loop_start:
    bge s8, s5, inner_loop_end
    
    # for offsets
    li t0 4
    mul t0 t0 s2
    mul t0 t0 s7 
    add t0 t0 s0 
    
    li t1 4
    mul t1 t1 s8
    add t1 t1 s3
    
    mv a0 t0 
    mv a1 t1
    mv a2 s2
    li a3 1
    mv a4 s5
    
    addi sp sp -12
    sw t0 0(sp)
    sw t1 4(sp)
    sw t2 8(sp)
    
    
    jal ra dot
    
    li t0 4
    mul t0 t0 s5
    mul t0 t0 s7 
    
    li t1 4
    mul t1 t1 s8
    
    add t2 t0 t1
    add t2 t2 s6
    sw a0 0(t2)
    
    lw t0 0(sp)
    lw t1 4(sp)
    lw t2 8(sp)
    addi sp sp 12
    
    addi s8, s8, 1 # counter col ++ 
    j inner_loop_start




inner_loop_end:

    li s8 0
    addi s7, s7, 1 # counter row ++
  
    j outer_loop_start




outer_loop_end:


    # Epilogue
    lw ra 0(sp)
    lw s0 4(sp) 
    lw s1 8(sp)
    lw s2 12(sp)
    lw s3 16(sp)
    lw s4 20(sp)
    lw s5 24(sp)
    lw s6 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    addi sp, sp, 40
    
    jr ra
    
    
err:
    li a0, 38
    j exit
