.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:

    # Prologue
    addi sp sp -28
    sw ra, 0(sp)
    sw s0, 4(sp) 
    sw s1 8(sp) 
    sw s2 12(sp) 
    sw s3 16(sp) # descriptor
    sw s4 20(sp) # matrix pointer
    sw s5 24(sp) # num bytes
    
    mv s0 a0 # file name pointer
    mv s1 a1 # num rows pointer
    mv s2 a2 # num cols pointer
    
    
    # open file
    li a1 0 # read only perm
    jal ra fopen
     
    # if -1, err
    li t0 -1
    beq a0 t0 fopen_err
    
    # file descriptor
    mv s3 a0
    
    # num rows
    mv a1 s1 # pointer num rows
    li a2 4 # bytes
    jal ra fread
    
    # is /=. err
    li t0 4
    bne a0 t0 fread_err
    
    
    # num cols
    mv a0 s3 # file descriptor again
    
    mv a1 s2 # pointer num col
    li a2 4 # bytes
    jal ra fread
    
    # is /=. err
    li t0 4
    bne a0 t0 fread_err
    
    # alloc space
    lw s1 0(s1) # num rows
    lw s2 0(s2) # num cols
    mul t1 s1 s2 # t1 = total num (rows*col)
    slli a0 t1 2 # in bytes num
    mv s5 a0 # moved to s5

    
    jal ra malloc
    # if 0, err
    beq a0 x0 malloc_err
    
    # read matrix to mem
    mv s4 a0 # matrix pointer
    
    mv a0 s3 # file descriptor
    
    mv a1 s4 # move to curr pointer
    
    mv a2 s5 # num bytes to file
    
    
    jal ra fread
     
    
    # close file
    
    mv a0 s3 # file desc
    jal ra fclose
    bne a0 x0 fclose_err
    
    mv a0 s4
    
    # return matrix pointer
        
        
    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1 8(sp)
    lw s2 12(sp)
    lw s3 16(sp)
    lw s4 20(sp)
    lw s5 24(sp)
    addi sp sp 28


    jr ra
    
    
malloc_err:
    li a0, 26
    j exit
    
     
fopen_err:
    li a0, 27
    j exit   
     
fclose_err:
    li a0, 28
    j exit   
    
fread_err:
    li a0, 29
    j exit
    
    
