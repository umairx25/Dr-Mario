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
    li $t1, 0xff0000        # $t1 = red
    li $t2, 0x00ff00        # $t2 = green
    li $t3, 0x0000ff        # $t3 = blue
    li $t5, 0x3d3d3d        # $t5 = gray

    lw $t0, ADDR_DSPL       # $t0 = base address for display
    sw $t1, 0($t0)          # paint the first unit (i.e., top-left) red
    sw $t2, 4($t0)          # paint the second unit on the first row green
    sw $t3, 128($t0)        # paint the first unit on the second row blue
    
intitialize:
    move $t4, $t0
    addi $t4, $t4, 384        #move it one row below
    add $t6, $zero, $zero     # Loop counter
    
loop_left:
    beq $t6, 27, re_initialize     # exits if it reaches the leftmost of the last row
    sw  $t5, 16($t4)             # draw the gray color on the left most of each line
    addi $t4, $t4, 128          # increment t4 by 128
    addi $t6, $t6, 1 
    j loop_left

re_initialize:
    move $t4, $t0
    addi $t4, $t4, 384        #move it one row below
    li $t6, 0 

loop_right:
    beq $t6, 27, exit         # exits if it reaches the leftmost of the last row
    sw  $t5, 64($t4)        # draw the gray color on the left most of each line
    addi $t4, $t4, 128        # increment t4 by 128
    addi $t6, $t6, 1 
    j loop_right

exit:
    li $v0, 10              # terminate the program gracefully
    syscall
