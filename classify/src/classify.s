.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    # prologue
    addi sp, sp, -52
    
    sw ra 0(sp)
    sw s0 4(sp)  # a0 argc
    sw s1 8(sp)  # a1 argv
    sw s2 12(sp) # a2 int
    sw s3 16(sp)  # m0 row/col pointer
    sw s4 20(sp)  # m0 
    sw s5 24(sp) # m1 row + col pointer
    sw s6 28(sp)  # m1
    sw s7 32(sp)  # inp row + col
    sw s8 36(sp) # inp
    sw s9 40(sp) # h
    sw s10 44(sp) # o
    sw s11 48(sp) 
    
    # error check
    li t0 5
    bne a0 t0 numb_err
    
    mv s0 a0 # argc
    mv s1 a1 # argv
    mv s2 a2 # int

    
    # Read pretrained m0
    
    #malloc for m0
    li a0 8
    jal ra malloc
    
    beq a0 x0 malloc_err
    mv s3 a0 # m0 row + col
    
    
    #then read m0
    lw a0 4(s1)
    mv a1 s3 # row
    addi a2 s3 4 # col
    
    jal ra read_matrix
    mv s4 a0 # m0 pointer
    
    
    #malloc for m1
    li a0 8
    jal ra malloc
    
    beq a0 x0 malloc_err
    mv s5 a0 # m1 row + col
    
    # then read pretrained m1
    lw a0 8(s1)
    mv a1 s5  # row
    addi a2 s5 4 # col
    
    jal ra read_matrix
    mv s6 a0 # m1 pointer
    
    
    # malloc for input matrix
    li a0 8
    jal ra malloc
    
    beq a0 x0 malloc_err
    mv s7 a0 # input row + col
    
    # then read input
    lw a0 12(s1)
    mv a1 s7  # row
    addi a2 s7 4 # col
    
    jal ra read_matrix
    mv s8 a0 # inputer pointer
    
    
    # memory malloc for h / m0 rowcol, inp rowcol
    lw t0 0(s3)
    lw t1 0(s7)
    mul a0 t0 t1 # total
    slli a0 a0 2
    
    jal ra malloc
    beq a0 x0 malloc_err
    mv s9 a0 # h pointer

    
    # Compute h = matmul(m0, input) 
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d

    mv a0 s4 # m0
    lw a1 0(s3) # row m0
    lw a2 4(s3) # col m0
    mv a3 s8 # inp
    lw a4 0(s7) # row inp
    lw a5 4(s7) # col inp
    mv a6 s9 # h
    jal ra matmul



    # Compute h = relu(h)
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array

    mv a0 s9 # h
    lw t0 0(s3)
    lw t1 0(s7)
    mul a1 t0 t1 # total
    jal ra relu
    
    # mem allocate o / m1 rowcol, h rowcol
    li a0 80
    jal ra malloc
    beq a0 x0 malloc_err
    mv s10 a0 # o pointer

# Compute o = matmul(m1, h)
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
    mv a0 s6 # m1
    lw a1 0(s5) # row m1
    lw a2 4(s5) # col m1
    mv a3 s9 # h
    lw a4 0(s3) # row h
    lw a5 4(s7) # col h
    mv a6 s10 # o
    jal ra matmul
    
    
    # Write output matrix o
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
    lw a0 16(s1)
    mv a1 s10 # o
    lw a2 0(s5) # o row
    lw a3 4(s7) # o col
    jal ra write_matrix

    # Compute and return argmax(o)
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
    mv a0 s10 # o
    li a1 10
    jal ra argmax
    mv s11 a0 # argmax0

    # If enabled, print argmax(o) and newline
    li t0 1
    beq s2 t0 no_print
    j print
    
    
 print:
    mv a0 s11
    jal  print_int
    li a0 '\n'
    jal ra print_char
    
    
 no_print:
    # epiloge
    
    mv a0 s3
    jal ra free
    mv a0 s4
    jal ra free
    mv a0 s5
    jal ra free
    mv a0 s6
    jal ra free
    mv a0 s7
    jal ra free
    mv a0 s8
    jal ra free
    mv a0 s9
    jal ra free
    mv a0 s10
    jal ra free    
    
    mv a0 s11 # argmax0

    
    lw ra 0(sp)
    lw s0 4(sp) 
    lw s1 8(sp)
    lw s2 12(sp)
    lw s3 16(sp) 
    lw s4 20(sp) 
    lw s5 24(sp) 
    lw s6 28(sp) 
    lw s7 32(sp)
    lw s8 36(sp)
    lw s9 40(sp) 
    lw s10 44(sp) 
    lw s11 48(sp)  
    
    addi sp, sp, 52
    
    jr ra
    
    
    malloc_err:
        li a0 26
        j exit
    numb_err:
        li a0 31
        j exit