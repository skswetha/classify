.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

    # Prologue
    addi sp sp -28
    sw ra, 0(sp)
    sw s0, 4(sp) 
    sw s1 8(sp) 
    sw s2 12(sp) 
    sw s3 16(sp) 
    sw s4 20(sp) 
    sw s5 24(sp) 
    
    mv s0 a0 # pointer to string representing the filename
    mv s1 a1 # pointer to the start of the matrix in memory
    mv s2 a2 # number of rows in the matrix
    mv s3 a3 # number of columns in the matrix
    
    mul s5 s3 s2 # total num
        
    
    # open file w/ write permissions
    li a1 1
    jal ra fopen
    
    # if -1, err
    li t0 -1
    beq a0 t0 fopen_err
    
    # file descriptor 
    mv s4 a0
    
    
    # num row ( fwrite = file, buffer, num el, size el )
    addi sp sp -8
    sw s2 0(sp)
    sw s3 4(sp)
    
    mv a0 s4 # file desc
    mv a1 sp # num rows
    li a2 2 # 2 element
    li a3 4 # 4 bytes
    
    jal ra fwrite
    
    lw s2 0(sp)
    lw s3 4(sp)
    addi sp sp 8
    
    # is /=. err
    li t0 2
    bne a0 t0 fwrite_err
    
    
    # num col ( fwrite = file, buffer, num el, size el )
    # mv a0 s4 # file desc
    # addi a1 s2 4 # num cols in matric
    # li a2 1 # 1 element
    # li a3 4 # 4 bytes
    
    # jal ra fwrite
    
    # is /=. err
    # li t0 1
    # bne a0 t0 fwrite_err
    
    # write num rows and col to file
    mv a0 s4
    mv a1 s1
    mv a2 s5
    li a3 4
    jal ra fwrite
    
    mv t0 s5
    bne a0 t0 fwrite_err
    
    # write data to file
    
    mv a0 s4
    jal ra fclose
    bne a0 x0 fclose_err
    
    # close file
    



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
    
    
    fopen_err:
        li a0 27
        j exit
        
    fclose_err:
        li a0 28
        j exit
        
    fwrite_err:
        li a0 30
        j exit
        
