################# CSC258 Assembly Final Project ###################
# This file contains our implementation of Dr Mario.
#
# Student 1: Umair Arham, 1010246565
# Student 2: Sameer Shahed, 1010313876 
#
# We assert that the code submitted here is entirely our own 
# creation, and will indicate otherwise when it is not.

######################## Bitmap Display Configuration ########################
# - Unit width in pixels:       TODO
# - Unit height in pixels:      TODO
# - Display width in pixels:    TODO
# - Display height in pixels:   TODO
# - Base Address for Display:   0x10008000 ($gp)
##############################################################################

    .data
##############################################################################
# Immutable Data
##############################################################################
# The address of the bitmap display. Don't forget to connect it!
ADDR_DSPL:
    .word 0x10008000
# The address of the keyboard. Don't forget to connect it!
ADDR_KBRD:
    .word 0xffff0000

# Colors
COLOR_BLACK:    .word 0x000000
COLOR_RED:      .word 0xff0000
COLOR_BLUE:     .word 0x0000ff
COLOR_YELLOW:   .word 0xffff00
COLOUR_GREY:    .word 0x3d3d3d
COLOR_WHITE:    .word 0xffffff # For text/UI

# Game board dimensions (in units)
BOARD_WIDTH:    .word 8       # Width of playable area
BOARD_HEIGHT:   .word 16      # Height of playable area
BOARD_X_OFFSET: .word 4       # X offset from left edge of display
BOARD_Y_OFFSET: .word 4       # Y offset from top edge of display

# Display dimensions (in units)
DISPLAY_WIDTH:  .word 32      # 256/8 = 32 units wide
DISPLAY_HEIGHT: .word 32      # 256/8 = 32 units high

# Capsule info
NUM_COLORS:     .word 3       # Number of different colors (red, blue, yellow)

# Movement deltas
MOVE_LEFT:      .word -1
MOVE_RIGHT:     .word 1
MOVE_DOWN:      .word 1

# Game state flags
GAME_ACTIVE:    .word 1       # 1 = game is active, 0 = game over
GAME_PAUSED:    .word 0       # 1 = paused, 0 = not paused

# Key codes
KEY_A:          .word 0x61    # move left
KEY_S:          .word 0x73    # move down
KEY_D:          .word 0x64    # move right
KEY_X:          .word 0x78    # rotate right
KEY_Z:          .word 0x7A    # rotate left
KEY_Q:          .word 0x71    # quit
KEY_P:          .word 0x70    # pause

##############################################################################
# Mutable Data
##############################################################################
capsule_x:      .word 41                # x coordinate of current capsule
capsule_y:      .word 1                # y coordinate of current capsule
capsule_orient: .word 0                  # 0 = horizontal, 1 = vertical

capsule_color1: .word 0                # left (or top) color index (0=red,1=blue,2=yellow)
capsule_color2: .word 0                # right (or bottom) color index

board:          .space 512             # Board array (8*16*4 bytes)

viruses_left:   .word 4                # Start with 4 viruses

gravity_timer:  .word 0                # No idea what this is
gravity_speed:  .word 20
##############################################################################
# Code
##############################################################################
	.text
	.globl main

    # Run the game.
main:
    jal draw_bottle
    jal draw_start_capsule
    # jal key_check

game_loop:
    # 1a. Check if key has been pressed
    # 1b. Check which key has been pressed
    # 2a. Check for collisions
	# 2b. Update locations (capsules)
	# 3. Draw the screen
	# 4. Sleep
	jal key_check

    # 5. Go back to Step 1
    j game_loop
    

exit:
    li $v0, 10             # Terminate the program gracefully
    syscall

#function to draw the starting screen
draw_bottle:
    lw $t7, COLOUR_GREY     # $t7 = grey

    lw $t0, ADDR_DSPL       # $t0 = base address for display
    
intitialize:
    move $t4, $t0
    addi $t4, $t4, 512
    li $t6, 0               #loop counter
    
loop_left:
    beq $t6, 26, re_initialize     # exits if it reaches the leftmost of the last row
    sw  $t7, 16($t4)             # draw the gray color on the left most of each line
    addi $t4, $t4, 128          # increment t4 by 128
    addi $t6, $t6, 1 
    j loop_left

re_initialize:
    move $t4, $t0
    addi $t4, $t4, 512
    li $t6, 0 

loop_right:
    beq $t6, 26, initialize_bottom
    sw  $t7, 64($t4)
    addi $t4, $t4, 128
    addi $t6, $t6, 1 
    j loop_right

initialize_bottom:
    move $t4, $t0
    addi $t4, $t4, 3728
    li $t6, 0 

loop_bottom:
    beq $t6, 13, initialize_top
    sw  $t7, 0($t4)
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
    li $t5, 9              # Set y = 9 (less than 9)
    sgt $t2, $t6, $t3       # Set $t2 to 1 if $t6 > 3
    slt $t1, $t6, $t5       # Set $t5 to 1 if $t6 < 9
    and $t2, $t2, $t1       # $t2 is 1 only if $t2 and $t1 are 1

    beq $t2, 1, skip_iteration  # If $t2 == 1, skip this iteration

    #else:
    sw  $t7, 0($t4)    
    addi $t4, $t4, 4
    addi $t6, $t6, 1 
    j loop_top
    
skip_iteration:
    addi $t4, $t4, 4        # Move to next pixel
    addi $t6, $t6, 1        # Increment loop counter
    j loop_top              # Jump to the next iteration

draw_lid:
    move $t4, $t0
    sw $t7, 412($t4)
    sw $t7, 436($t4)
    sw $t7, 284($t4)
    sw $t7, 308($t4)   
    jr $ra  # saves the line address to register 31

#####################################
# Draw the Capsule
#####################################
draw_start_capsule:
    # Load base address of display
    lw $t0, ADDR_DSPL   

    # Compute the memory address from (x, y)
    # Note that this calculates the position of the left/top capsule
    lw $a2, capsule_x       # X-coordinate (column) 41
    lw $a3, capsule_y       # Y-coordinate (row) 1

    mul $t2, $a2, 4         # x (column) * 4 (column offset)
    mul $t3, $a3, 128       # y (row) * 128 (row offset)
    add $t4, $t2, $t3       # total offset
    add $t4, $t4, $t0       # final address = base + offset

    # Load capsule colors
    lw $t8, COLOR_BLUE      # Left/top capsule color
    lw $t9, COLOR_RED       # Right/bottom capsule color

    # Store colors at the computed memory address
    sw $t8, 0($t4)          # Store blue at (x, y)
    sw $t9, 4($t4)          # Store red at (x+1, y)
    jr $ra                  # Return
#####################################
# Keyboard Input and Control Handlers
#####################################
key_check:
  	li 		$v0, 32
	li 		$a0, 1
	syscall

    lw $t0, ADDR_KBRD               # $t0 = base address for keyboard
    lw $t1, 0($t0)                  # Load first word from keyboard (key state)
    beq $t1, 1, keyboard_input      # If first word 1, key is pressed
    jr $ra
    j key_check
    
keyboard_input:                     # A key is pressed
    lw $t2, 4($t0)                  # Load second word from keyboard into $t2 (actual key pressed)

    lw $t3, KEY_Q
    beq $t2, $t3, respond_to_Q

    lw $t3, KEY_P
    beq $t2, $t3, respond_to_P

    lw $t3, KEY_A
    beq $t2, $t3, respond_to_A

    lw $t3, KEY_S
    beq $t2, $t3, respond_to_S

    lw $t3, KEY_D
    beq $t2, $t3, respond_to_D

    lw $t3, KEY_X
    beq $t2, $t3, respond_to_X

    lw $t3, KEY_Z
    beq $t2, $t3, respond_to_Z

    j game_loop
    
respond_to_Q:
    # li $v0, 10  # Exit system call
    # syscall   
    j exit

respond_to_A: # Move left
    lw $t6, capsule_x       # Load current x position (column)
    addi $t6, $t6, -1       # Move left (x = x - 1)
    sw $t6, capsule_x       # Store updated x position
    
    # Then redraw capsule at new position
    jal draw_start_capsule
    j game_loop

respond_to_S:
    lw $t6, capsule_y       # Load current x position (column)
    addi $t6, $t6, 1        # Move right (x = x + 1)
    sw $t6, capsule_y       # Store updated x position
    
    # Then redraw capsule at new position
    jal draw_start_capsule
    j game_loop
    
respond_to_D:
    lw $t6, capsule_x       # Load current y position (column)
    addi $t6, $t6, 1        # Move left (y = y - 1)
    sw $t6, capsule_x       # Store updated y positiond
    
    # Then redraw capsule at new position
    jal draw_start_capsule
    j game_loop
    
respond_to_X:
    j key_check
respond_to_Z:
    j key_check
respond_to_P:
    j key_check
  