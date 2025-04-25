##############################################################################
# Example: Displaying Pixels
#
# This file demonstrates how to draw pixels with different colours to the
# bitmap display.
##############################################################################

######################## Bitmap Display Configuration ########################
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
##############################################################################
    .data
ADDR_DSPL:
    .word 0x10008000

    .text
	.globl main

main:
    li $t5, 0x3d3d3d        # $t5 = gray

    lw $t0, ADDR_DSPL       # $t0 = base address for display
    sw $t1, 0($t0)          # paint the first unit (i.e., top-left) red
    sw $t2, 4($t0)          # paint the second unit on the first row green
    sw $t3, 128($t0)        # paint the first unit on the second row blue
    
intitialize:
    move $t4, $t0
    addi $t4, $t4, 512
    li $t6, 0               #loop counter
    
loop_left:
    beq $t6, 26, re_initialize     # exits if it reaches the leftmost of the last row
    sw  $t5, 16($t4)             # draw the gray color on the left most of each line
    addi $t4, $t4, 128          # increment t4 by 128
    addi $t6, $t6, 1 
    j loop_left

re_initialize:
    move $t4, $t0
    addi $t4, $t4, 512
    li $t6, 0 

loop_right:
    beq $t6, 26, initialize_bottom
    sw  $t5, 64($t4)
    addi $t4, $t4, 128
    addi $t6, $t6, 1 
    j loop_right

initialize_bottom:
    move $t4, $t0
    addi $t4, $t4, 3728
    li $t6, 0 

loop_bottom:
    beq $t6, 13, initialize_top
    sw  $t5, 0($t4)
    addi $t4, $t4, 4
    addi $t6, $t6, 1 
    j loop_bottom

initialize_top:
    move $t4, $t0
    addi $t4, $t4, 528       #move it one row below
    li $t6, 0
    li $t2, 0
    
loop_top:
    beq $t6, 13, draw_lid
    
    # Check if $t6 is greater than x (e.g., 1) and less than y (e.g., 3)
    li $t3, 3               # Set x = 3 (greater than 3)
    li $t7, 9               # Set y = 9 (less than 9)
    sgt $t2, $t6, $t3       # Set $t2 to 1 if $t6 > 3
    slt $t8, $t6, $t7       # Set $t5 to 1 if $t6 < 9
    and $t2, $t2, $t8       # $t2 is 1 only if $t2 and $t8 are 1

    beq $t2, 1, skip_iteration  # If $t2 == 1, skip this iteration

    #else:
    sw  $t5, 0($t4)    
    addi $t4, $t4, 4
    addi $t6, $t6, 1 
    j loop_top
    
skip_iteration:
    addi $t4, $t4, 4        # Move to next pixel
    addi $t6, $t6, 1        # Increment loop counter
    j loop_top              # Jump to the next iteration

draw_lid:
    move $t4, $t0
    sw $t5, 412($t4)
    sw $t5, 436($t4)
    sw $t5, 284($t4)
    sw $t5, 308($t4)    
    
exit:
    li $v0, 10              # terminate the program gracefully
    syscall
