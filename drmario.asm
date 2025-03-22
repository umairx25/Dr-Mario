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
KEY_W:          .word 0x77    # general rotate
KEY_Q:          .word 0x71    # quit
KEY_P:          .word 0x70    # pause

# filename: .asciiz "/Users/umairarham/Documents/CSC258/Dr-Mario/fever.wav"

##############################################################################
# Mutable Data  start from 1
##############################################################################
capsule_x:      .word 10               # x coordinate of current capsule
capsule_y:      .word 2                # y coordinate of current capsule
capsule_orient: .word 0                # 0 = horizontal, 1 = vertical

capsule_color1: .word 0                # left (or top) color index (0=red,1=blue,2=yellow)
capsule_color2: .word 0                # right (or bottom) color index

board:          .space 1152             # Board array (12*24 bytes)

viruses_left:   .word 4                # Start with 4 viruses

gravity_timer:  .word 0                # No idea what this is
gravity_speed:  .word 20
is_colour_set:  .word 4

dr_mario_pixels:
    .word 0x000000, 0xFFCB8E, 0xFFB570, 0x000000, 0xABABAB, 0xACACAC, 0x974A00, 0x964B00, 0x954B00, 0x000000
    .word 0x000000, 0xFDFDFE, 0xFCFFFA, 0xFFB66F, 0x000000, 0x000000, 0xFFB671, 0xFFB770, 0xFFB96D, 0x000000
    .word 0x000000, 0xFFFBFE, 0xFFFFFF, 0x000000, 0xFEB46E, 0xFFB56E, 0xFFB56E, 0xFFB56E, 0x954B00, 0x000000
    .word 0x000000, 0xFFFBFE, 0xFFFFFF, 0xFFFFFE, 0xB0ACA8, 0xAFABAA, 0xFFFEFA, 0xFFFEFA, 0x000000, 0x000000
    .word 0x000000, 0x000000, 0x000000, 0xFFFFFF, 0xADADAD, 0xACACAC, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0x000000
    .word 0x000000, 0x000000, 0x000000, 0xFFFFFF, 0xFFFFFF, 0xFEFEFE, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0x000000
    .word 0x000000, 0x000000, 0x000000, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFEFEFF, 0xFFB56B, 0x000000
    .word 0x000000, 0x000000, 0x000000, 0xFFFFFF, 0x000000, 0x000000, 0xFFFFFF, 0xFEFFFE, 0xBF7F7F, 0x000000
    .word 0x000000, 0x9A4E1D, 0x964B00, 0x964B00, 0x000000, 0x000000, 0x964B00, 0x964B00, 0x954B00, 0x000000
    .word 0x000000, 0x8C5434, 0x8B4712, 0x8D4816, 0x000000, 0x000000, 0x894A12, 0x864713, 0x874A17, 0x000000

virus_pixels:
    .word 0x2F2A2E, 0x2B2C32, 0x698CEA, 0x6D90EE, 0x6585E2, 0x638BEC, 0x658BEA, 0x6F90EF, 0x6587E9, 0x2A3250
    .word 0x242A2A, 0x6A8FED, 0x7399F3, 0xAF4A54, 0x698FE8, 0x6A8EEE, 0x8D9EFF, 0xD8C358, 0x423D31, 0x678BEB
    .word 0x6186DE, 0xCE434D, 0x302E31, 0x312D34, 0x7395EF, 0x7698F3, 0xCEBE5A, 0xD9C554, 0xD7C251, 0x587AD2
    .word 0x8AA3EF, 0x742634, 0x833642, 0xC6BC7B, 0x45350F, 0x7093F0, 0x738FE7, 0x373D3F, 0x113A4A, 0x67B1E4
    .word 0x7091EE, 0x343134, 0xD7C557, 0xDE455A, 0x869FFF, 0x779AF2, 0x799BF1, 0x7F98F0, 0x7A97F0, 0x7794EE
    .word 0x6F92EC, 0x6B8EEA, 0x7996EE, 0x7A97F2, 0x7090F7, 0x7491ED, 0x123148, 0x6F8EEF, 0x85A1FA, 0x7092EB
    .word 0x7191E6, 0x6689E5, 0x889FF1, 0x7495EE, 0x43371B, 0x38383F, 0x3A3B38, 0x7693EE, 0x7695EE, 0x7597F0
    .word 0xADAFB7, 0x89A7FE, 0x7193ED, 0x7A99F0, 0x254147, 0x62B0E4, 0x6CB3E9, 0x708FF6, 0x6C91EC, 0x7995F3
    .word 0xA3A7B4, 0x372F30, 0x7395EF, 0x7394F3, 0x7798F0, 0x62B1EA, 0x08243B, 0x36393E, 0x6B8AEB, 0x7799F9
    .word 0x5B605F, 0x302F32, 0x3E414F, 0x7391EF, 0x7592F0, 0x6989E8, 0x7898F2, 0x6288EE, 0x9FA0C0, 0x2F2F31
    # (Add the remaining 18 rows of Dr. Mario's pixels)
##############################################################################
# Code
##############################################################################
	.text
	.globl main
    
main:
    li $t1, 0
    li $s6, 1000 # gradual speed increase
    # jal play_sound
    jal draw_bottle

    jal draw_dr_mario
    jal draw_viruses

game_loop:
    
    # 3. Draw the screen
    jal draw_start_capsule
    # 1a. Check if key has been pressed
    # 1b. Check which key has been pressed
    # 1b. Check which key has been pressed
    # 2a. Check for collisions
	# 2b. Update locations (capsules)
    jal key_check
    
    # 4. Sleep
    # li $a0, 100       # Sleep for 1 second
    # li $v0, 32         # Syscall for sleep
    # syscall
    # j respond_to_S
    li $a0, 16             # Sleep for ~16ms (1/60th second)
    li $v0, 32             # Syscall for sleep
    move $a0, $zero  # Store time as seed
    syscall

    # 5. Go back to Step 1
    j game_loop

exit:
    li $v0, 10             # Terminate the program gracefully
    syscall
    
# play_sound:
    # li $v0, 31          # Syscall for playing audio
    # la $a0, filename    # Load the address of the filename
    # syscall             # Play the sound
    # jr $ra

##############################################################################
# Draw Dr Mario and Viruses
##############################################################################


draw_dr_mario:
    lw   $t6, ADDR_DSPL       # Load base display address
    la   $t1, dr_mario_pixels # Load base address of pixel data
    li   $t3, 53              # Start X
    li   $t4, 6              # Start Y
    
    addiu $sp, $sp, -4        # Push return address onto stack
    sw    $ra, 0($sp)
    
    jal  draw_characters      # Draw Dr. Mario

    lw    $ra, 0($sp)         # Restore return address
    addiu $sp, $sp, 4         # Pop stack
    jr   $ra                  # Return after drawing Mario

draw_viruses:
    lw   $t6, ADDR_DSPL       # Load base display address
    la   $t1, virus_pixels    # Load base address of pixel data
    li   $t3, 53              # Start X
    li   $t4, 20              # Start Y

    addiu $sp, $sp, -4        # Push return address onto stack
    sw    $ra, 0($sp)

    jal  draw_characters      # Draw viruses

    lw    $ra, 0($sp)         # Restore return address
    addiu $sp, $sp, 4         # Pop stack
    jr   $ra                  # Return after drawing viruses

draw_characters:
    addiu $sp, $sp, -4        # Save $ra before calling another function
    sw    $ra, 0($sp)        

    li   $t5, 128             # Row offset (bytes)
    li   $t7, 4               # Column offset (bytes)

initialize_position:
    mul  $t8, $t4, $t5        # Y * row offset
    mul  $t9, $t3, $t7        # X * column offset
    add  $t8, $t8, $t9        # Compute total offset
    add  $t0, $t6, $t8        # Compute base address (starting pos)

    li   $t2, 0               # Row counter (Y)

y_loop:
    li   $t8, 0               # Column counter (X)

x_loop:
    # Compute memory address for display
    mul  $t9, $t8, $t7        # X offset
    add  $t9, $t0, $t9        # Compute final X address

    # Load pixel and store it
    lw   $t3, 0($t1)          # Load pixel color from sprite data
    sw   $t3, 0($t9)          # Store to display memory

    addi $t1, $t1, 4          # Move to next pixel in sprite data
    addi $t8, $t8, 1          # Next column
    bne  $t8, 10, x_loop      # If not end of row, continue

    add  $t0, $t0, $t5        # Move to the next row (Y offset)
    addi $t2, $t2, 1          # Next row
    bne  $t2, 10, y_loop      # If not 10 rows, continue

    lw    $ra, 0($sp)         # Restore return address
    addiu $sp, $sp, 4         # Pop stack
    jr   $ra                  # Return

    
##############################################################################
# Draw the Medicine Bottle
##############################################################################
#function to draw the starting screen
draw_bottle:
    lw $t7, COLOUR_GREY     # $t7 = grey
    lw $t0, ADDR_DSPL       # $t0 = base address for display
    
intitialize:
    move $t4, $t0
    addi $t4, $t4, 512
    li $t6, 0               #loop counter
    
loop_left:
    beq $t6, 26, re_initialize      # exits if it reaches the leftmost of the last row
    sw  $t7, 16($t4)                # draw the gray color on the left most of each line
    addi $t4, $t4, 128              # increment t4 by 128
    addi $t6, $t6, 1 
    j loop_left

re_initialize:
    move $t4, $t0
    addi $t4, $t4, 512
    li $t6, 0 

loop_right:
    beq $t6, 26, initialize_bottom
    sw  $t7, 68($t4)
    addi $t4, $t4, 128
    addi $t6, $t6, 1 
    j loop_right

initialize_bottom:
    move $t4, $t0
    addi $t4, $t4, 3728
    li $t6, 0 

loop_bottom:
    beq $t6, 14, initialize_top
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
    beq $t6, 14, draw_lid
    
    # Check if $t6 is greater than x (e.g., 1) and less than y (e.g., 3)
    li $t3, 4               # Set x = 3 (greater than 3)
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
    sw $t7, 416($t4) # bottom left
    sw $t7, 436($t4) # bottom right
    sw $t7, 288($t4) # top left
    sw $t7, 308($t4) # top right 
    jr $ra  # saves the line address to register 31

check_horz:
    sgt $t2, $t1, 1
    slt $t3, $t1, 5
    and $t4, $t2, $t3
    beq $t4, 1, check_lid_horz
    beq $t4, 0, check_reg_horz


check_lid_horz:
    #t2, t3, t4
    addi $sp, $sp, -4       # Move stack pointer
    sw $ra, 0($sp)          # Save $ra on stack

   # lw $t6, capsule_x       # Load current x position (column)
    # lw $t1, capsule_y       # Load current y position
    
    # mul $t6, $t6, 4         # x (column) * 4 (column offset)
    # mul $t1, $t1, 128       # y (row) * 128 (row offset)
   sgt $t2, $t7, 8
   slt $t3, $t7, 12
   and $t4, $t2, $t3
   
   # Return directly without looping
    lw $ra, 0($sp)    
    addi $sp, $sp, 4  
    jr $ra

check_reg_horz:

    #t2, t3, t4
   addi $sp, $sp, -4       # Move stack pointer
   sw $ra, 0($sp)          # Save $ra on stack
   lw $t5, capsule_orient
   beq $t5, 1, check_vert_reg_right
    
   sgt $t2, $t7, 4
   slt $t3, $t7, 16
   and $t4, $t2, $t3
   
   # Return directly without looping
    lw $ra, 0($sp)    
    addi $sp, $sp, 4  
    jr $ra

  check_vert_reg_right:
    sgt $t2, $t7, 4
    slt $t3, $t7, 17
    and $t4, $t2, $t3
   
   # Return directly without looping
    lw $ra, 0($sp)    
    addi $sp, $sp, 4  
    jr $ra
  
  
check_vertical:
   
   lw $t6, capsule_x       # Load current x position (column)
   lw $t1, capsule_y       # Load current y position
    
   sgt $t2, $t1, 1
   slt $t3, $t1, 28
   and $t4, $t2, $t3
   
   addi $sp, $sp, -4       # Move stack pointer
   sw $ra, 0($sp)          # Save $ra on stack
   
   # Return directly without looping
   lw $ra, 0($sp)    
   addi $sp, $sp, 4  
   jr $ra


#####################################
# Draw the Capsule
#####################################

draw_start_capsule:
    # Load stored capsule colors
    lw $s1, capsule_color1  # Load left side of capsule color
    lw $s2, capsule_color2  # Load right side of capsule color

    add $t4, $s1, $s2       # Check if both are zero
    beq $t4, 0, randomize_capsule  # If both are zero, randomize a new capsule

    # Load base address of display
    lw $t0, ADDR_DSPL 

    # Compute the memory address from (x, y)
    lw $a2, capsule_x       # X-coordinate (column)
    lw $a3, capsule_y       # Y-coordinate (row)

    mul $t2, $a2, 4         # x (column) * 4 (column offset)
    mul $t3, $a3, 128       # y (row) * 128 (row offset)
    add $t4, $t2, $t3       # total offset
    add $t4, $t4, $t0       # final address = base + offset
    
    lw $t5, capsule_orient
    beq $t5, 1, draw_vert 
    
    # Store existing capsule colors in memory
    sw $s1, 0($t4)  
    sw $s2, 4($t4)  

    jr $ra  # Return

draw_vert:
    sw $s1, 0($t4)  
    sw $s2, -128($t4)  
    jr $ra  # Return
    

randomize_capsule:
    # Load base address of display
    lw $t0, ADDR_DSPL 
    
    # Load capsule colors
    lw $t8, COLOR_BLUE      
    lw $t9, COLOR_RED       
    lw $t6, COLOR_YELLOW     
    lw $t7, COLOR_BLACK    

    # Compute the memory address from (x, y)
    lw $a2, capsule_x      
    lw $a3, capsule_y      

    mul $t2, $a2, 4        
    mul $t3, $a3, 128      
    add $t4, $t2, $t3      
    add $t4, $t4, $t0      

    # Generate a random left capsule color
    li $v0, 42      
    li $a1, 3
    li $a0, 0
    syscall         
    addi $a0, $a0, 1  
    
    beq $a0, 1, pick_left_blue
    beq $a0, 2, pick_left_red
    beq $a0, 3, pick_left_yellow

pick_left_blue:
    sw $t8, 0($t4)         
    move $s1, $t8          
    j right_capsule_colour 

pick_left_red:
    sw $t9, 0($t4)         
    move $s1, $t9          
    j right_capsule_colour 

pick_left_yellow:
    sw $t6, 0($t4)         
    move $s1, $t6          
    j right_capsule_colour 

right_capsule_colour:
    li $v0, 42     
    li $a1, 3 
    li $a0, 0
    syscall         
    addi $a0, $a0, 1  
    
    beq $a0, 1, pick_right_blue
    beq $a0, 2, pick_right_red
    beq $a0, 3, pick_right_yellow

pick_right_blue:
    sw $t8, 4($t4)        
    move $s2, $t8        
    j store_capsule_colors 

pick_right_red:
    sw $t9, 4($t4)        
    move $s2, $t9        
    j store_capsule_colors 

pick_right_yellow:
    sw $t6, 4($t4)        
    move $s2, $t6        

store_capsule_colors:
    # Store colors in global variables for next check
    sw $s1, capsule_color1
    sw $s2, capsule_color2
    jr $ra
    
    
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
    
    
    move $a0, $s6       # Sleep for 1 second
    li $v0, 32         # Syscall for sleep
    syscall
    addi $s6, $s6, -40
    j respond_to_S
    j key_check
    
keyboard_input:                     # A key is pressed
    lw $t2, 4($t0)                  # Load second word from keyboard into $t2 (actual key pressed)
    lw $t5, capsule_orient

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
    
    lw $t3, KEY_W
    beq $t2, $t3, respond_to_W

    j game_loop
    
respond_to_Q: # Quit Game 
    j exit

respond_to_A: # Move left
    lw $t6, capsule_x       # Load current x position (column)
    lw $t1, capsule_y       # Load current y position
    lw $t0, ADDR_DSPL       # Load base address of display
    move $t7, $t6            
    addi $t7, $t7, -1       # Store potential x position in t7
    
    jal check_horz          # Call check_horz with new x position
    beq $t4, 0, game_loop   # If out of bounds (t4 == 1), don't move
    
    jal check_vertical
    beq $t4, 0, game_loop   # If out of bounds (t4 == 1), don't move
    
    mul $t2, $t6, 4         # x (column) * 4 (column offset)
    mul $t3, $t1, 128       # y (row) * 128 (row offset)
    add $t4, $t2, $t3       # total offset
    add $t4, $t4, $t0       # final address = base + offset
    
    lw $t7, COLOR_BLACK
    beq $t5, 1, left_vert_A
    sw $t7, 0($t4)          # Store black at (x, y)
    sw $t7, 4($t4)          # Store black at (x+1, y)
    
    addi $t6, $t6, -1       # Move actual x postion left (x = x - 1)
    sw $t6, capsule_x       # Store updated x position
    
    # Then redraw capsule at new position
    jal draw_start_capsule
    j game_loop
    
    left_vert_A:
        sw $t7, 0($t4)          # Store black at (x+1, y)
        sw $t7, -128($t4)          # Store black at (x+1, y)
        addi $t6, $t6, -1       # Move actual x postion left (x = x - 1)
        sw $t6, capsule_x       # Store updated x position
    
        # Then redraw capsule at new position
        jal draw_start_capsule
        j game_loop
 
respond_to_S: #move capsule down when S is pressed
    lw $t6, capsule_x       # Load current x position (column)
    lw $t1, capsule_y       # Load current x position (column)
    lw $t0, ADDR_DSPL       # Load base address of display
    jal check_vertical
    
    beq $t4, 0, game_loop   # If out of bounds (t4 == 1), don't move
    
    mul $t2, $t6, 4         # x (column) * 4 (column offset)
    mul $t3, $t1, 128       # y (row) * 128 (row offset)
    add $t4, $t2, $t3       # total offset
    add $t4, $t4, $t0       # final address = base + offset
    beq $t5, 1, down_vert_S 
    
    sw $t7, 0($t4)          # Store black at (x, y)
    sw $t7, 4($t4)          # Store black at (x+1, y)
    addi $t1, $t1, 1        # Move down (y = y + 1)
    sw $t1, capsule_y       # Store updated y position
    
    # Then redraw capsule at new position
    jal draw_start_capsule
    j game_loop
    
    down_vert_S:
        sw $t1, capsule_y       # Store updated y position
        sw $t7, 0($t4)          # Store black at (x, y)
        sw $t7, -128($t4)          # Store black at (x+1, y)
        addi $t1, $t1, 1        # Move down (y = y + 1)
        sw $t1, capsule_y       # Store updated y position
    
        # Then redraw capsule at new position
        jal draw_start_capsule
        j game_loop
    
respond_to_D:
    lw $t6, capsule_x       # Load current x position (column)
    lw $t1, capsule_y       # Load current y position
    lw $t0, ADDR_DSPL       # Load base address of display
    move $t7, $t6            
    addi $t7, $t7, 1        # Store potential x position in t7
    
    jal check_horz          # Call check_horz with potential x position
    beq $t4, 0, game_loop   # If out of bounds (t4 == 1), don't move
    
    jal check_vertical
    beq $t4, 0, game_loop   # If out of bounds (t4 == 1), don't move
    
    mul $t2, $t6, 4         # x (column) * 4 (column offset)
    mul $t3, $t1, 128       # y (row) * 128 (row offset)
    add $t4, $t2, $t3       # total offset
    add $t4, $t4, $t0       # final address = base + offset
    
    lw $t7, COLOR_BLACK
    beq $t5, 1, right_vert_D
    sw $t7, 0($t4)          # Store black at (x, y)
    sw $t7, 4($t4)          # Store black at (x+1, y)
    
    addi $t6, $t6, 1        # Move actual x positon left (x = x - 1)
    sw $t6, capsule_x       # Store updated x position
    
    # Then redraw capsule at new position
    jal draw_start_capsule
    j game_loop
    
    right_vert_D:
        sw $t7, 0($t4)          # Store black at (x, y)
        sw $t7, -128($t4)          # Store black at (x+1, y)
    
        addi $t6, $t6, 1        # Move actual x positon left (x = x - 1)
        sw $t6, capsule_x       # Store updated x position
    
        # Then redraw capsule at new position
        jal draw_start_capsule
        j game_loop     
    
respond_to_X: # Rotate Right
    j key_check
respond_to_Z: # Rotate Left
    j key_check

respond_to_W:
    lw $s4, capsule_orient 
    lw $t6, capsule_x       # Load current x position (column)
    lw $t1, capsule_y       # Load current y position
    lw $t0, ADDR_DSPL       # Load base address of display
    beq $s4, 0, horz_to_vert
    beq $s4, 1, vert_to_horz

horz_to_vert:
    mul $t2, $t6, 4         # x (column) * 4 (column offset)
    mul $t3, $t1, 128       # y (row) * 128 (row offset)
    add $t4, $t2, $t3       # total offset
    add $t4, $t4, $t0       # final address = base + offset
    
    sw $t7, 4($t4)          # Store black at (x+1, y)
    addi $s4, $s4, 1
    
    jal check_vertical
    beq $t4, 0, game_loop   # If out of bounds (t4 == 1), don't move
    
    lw $t2, capsule_color1
    lw $t3, capsule_color2
    move $t4, $t2
    move $t2, $t3
    move $t3, $t4
    sw $t2, capsule_color1
    sw $t3, capsule_color2
    
    sw $s4, capsule_orient
    jal draw_start_capsule
    j game_loop

vert_to_horz:
    # addi $t6, $t6, 1
    # addi $t1, $t1, 1
    
    mul $t2, $t6, 4         # x (column) * 4 (column offset)
    mul $t3, $t1, 128       # y (row) * 128 (row offset)
    add $t4, $t2, $t3       # total offset
    add $t4, $t4, $t0       # final address = base + offset
    # sw $t7, 0($t4)          # Store black at (x, y)
    sw $t7, -128($t4)          # Store black at (x+1, y)
    
    addi $s4, $s4, -1
    jal check_vertical
    beq $t4, 0, game_loop   # If out of bounds (t4 == 1), don't move
    # sw $t1, capsule_y
    # sw $t6, capsule_x
    sw $s4, capsule_orient
    jal draw_start_capsule
    j game_loop
    
respond_to_P:
    lw $t6, GAME_PAUSED
    beq $t6, 0, pause        # Pause if p pressed first time
    lw $t1, 0($t0)           # If GAME_PAUSED is already 1, load first word from keyboard (key state)
    beq $t1, 1, check_p      # If key is pressed, send to check_p for exact key
    j respond_to_P           
check_p:
    lw $t2, 4($t0)           # Load second word from keyboard into $t2 (actual key pressed)
    lw $t3, KEY_P
    beq $t2, $t3, unpause    # Unpause if p was pressed, otherwise loop back
    j respond_to_P           # This prevents any other key from being presßsed while paused
pause:
    addi $t6, $t6, 1
    sw $t6, GAME_PAUSED      # Update GAME_PAUSED to 1  
    lw $t7, COLOR_WHITE
    lw $t8, ADDR_DSPL       # Load base address of displayp
    sw $t7, 260($t8)
    sw $t7, 132($t8)
    sw $t7, 268($t8)
    sw $t7, 140($t8)
    j respond_to_P
unpause:
    addi $t6, $t6, -1
    sw $t6, GAME_PAUSED      # Update GAME_PAUSED to 0
    lw $t7, COLOR_BLACK
    sw $t7, 260($t8)
    sw $t7, 132($t8)
    sw $t7, 268($t8)
    sw $t7, 140($t8)
    j key_check              # Allows other keys to be pressed
