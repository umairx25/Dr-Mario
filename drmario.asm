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
MUSIC_LOADED: .word 0
last_note_time: .word 0     # Store time of last note played
current_note:   .word 0     # Current position in the music array
##############################################################################
# Immutable Data
##############################################################################
debug_msg: .asciiz "Debug: board value at position = "
newline: .asciiz "\n"
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
COLOR_WHITE:    .word 0xffffff 

COLOR_TABLE:
    .word 0x000000  # Black         (index 0)
    .word 0xff0000  # Red           (index 1)
    .word 0x0000ff  # Blue          (index 2)
    .word 0xffff00  # Yellow        (index 3)
    .word 0xff0000  # Red(virus)    (index 4)
    .word 0x0000ff  # Blue(virus)   (index 5)
    .word 0xffff00  # Yellow(virus) (index 6)

# Game board dimensions (in units)
BOARD_WIDTH:    .word 12       # Width of playable area
BOARD_HEIGHT:   .word 24      # Height of playable area
BOARD_OFFSET:   .word -5       # X and Y offset from left edge of display (yes, they are equal)

# Display dimensions (in units)
DISPLAY_WIDTH:  .word 32      # 256/8 = 32 units wide
DISPLAY_HEIGHT: .word 32      # 256/8 = 32 units high

# Capsule info
NUM_COLORS:     .word 3       # Number of different colors (red, blue, yellow)

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

##############################################################################
# Mutable Data  start from 1     #spawn new pills at 22,5
##############################################################################
capsule_x:      .word 10               # x coordinate of current capsule
capsule_y:      .word 2                # y coordinate of current capsule
next_capsule_x:  .word 22               # x coordinate of current capsule
next_capsule_y:  .word 5                # y coordinate of current capsule
capsule_orient: .word 0                # 0 = horizontal, 1 = vertical

capsule_color1: .word 0                # left (or top) color index (0=red,1=blue,2=yellow)
capsule_color2: .word 0                # right (or bottom) color index
next_capsule_color1: .word 0                # left (or top) color index (0=red,1=blue,2=yellow)
next_capsule_color2: .word 0                # right (or bottom) color index

board:          .space 1152            # Board array (12*24 bytes)

viruses_left:   .word 4                # Start with 4 viruses


dr_mario_pixels: # pixel representation of dr mario 
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

virus_pixels: #pixel representation of the viruses
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

data_board: #pixel representation of the viruses
    .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
          0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
          0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
          0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
          0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
          0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
          0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
          0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
          0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
          0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
          0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
          0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
          0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
          0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
          0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
          0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
          0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
          0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
          0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
          0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
          0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
          0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
          0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
          0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

viruses: #these store the display positions of the viruses, to align them with data_board, offset by -5.
  .word 0, 0
        0, 0
        0, 0
        0, 0
##############################################################################
# Code
##############################################################################
	.text
	.globl main

main:
    #implement gravity, capsule goes down 1 block per second
    li $t1, 0
    li $s6, 1000 # 1000 ms = 1 second
    jal draw_bottle
    jal init_viruses
    jal draw_dr_mario
    jal draw_viruses # on the side panel

game_loop:
    # 3. Draw the screen
    jal draw_curr
    # jal draw_nxt
    # jal draw_next
    # jal randomize_next
    # 1a. Check if key has been pressed
    # 1b. Check which key has been pressed
    # 1b. Check which key has been pressed
    # 2a. Check for collisions
	# 2b. Update locations (capsules)
    jal key_check

    # 5. Go back to Step 1
    j game_loop

exit:
    li $v0, 10             # Terminate the program gracefully
    syscall

##############################################################################
# Draw Dr Mario and Viruses
##############################################################################


draw_dr_mario:
    lw   $t6, ADDR_DSPL         # Load base display address
    la   $t1, dr_mario_pixels   # Load base address of dr mario pixel data
    li   $t3, 53                # Start X, set starting x coordinates for drawing
    li   $t4, 6                 # Start Y, set starting y coordinates for drawing
    
    addiu $sp, $sp, -4        # Push return address onto stack
    sw    $ra, 0($sp)
    
    jal  draw_characters      # Draw Dr. Mario

    lw    $ra, 0($sp)         # Restore return address
    addiu $sp, $sp, 4         # Pop stack
    jr   $ra                  # Return after drawing Mario

draw_viruses:
    lw   $t6, ADDR_DSPL       # Load base display address
    la   $t1, virus_pixels    # Load base address of pixel data
    li   $t3, 53              # Start X, set starting x coordinates for drawing
    li   $t4, 20              # Start Y, set starting y coordinates for drawing

    addiu $sp, $sp, -4        # Push return address onto stack
    sw    $ra, 0($sp)

    jal  draw_characters      # Draw viruses

    lw    $ra, 0($sp)         # Restore return address
    addiu $sp, $sp, 4         # Pop stack
    jr   $ra                  # Return after drawing viruses

draw_characters:              #Helper function to draw image given its exact pixel data
    addiu $sp, $sp, -4        # Save $ra before calling another function
    sw    $ra, 0($sp)        

initialize_position:
    mul  $t8, $t4, 128          # Y * row offset
    mul  $t9, $t3, 4            # X * column offset
    add  $t8, $t8, $t9          # Compute total offset
    add  $t0, $t6, $t8          # Compute base address (starting pos)

    li   $t2, 0               # Row counter (Y)

y_loop:
    li   $t8, 0               # Column counter (X)

x_loop:
    # Compute memory address for display
    mul  $t9, $t8, 4        # X offset
    add  $t9, $t0, $t9        # Compute final X address

    # Load pixel and store it
    lw   $t3, 0($t1)          # Load pixel color from sprite data
    sw   $t3, 0($t9)          # Store to display memory

    addi $t1, $t1, 4          # Move to next pixel in sprite data
    addi $t8, $t8, 1          # Next column
    bne  $t8, 10, x_loop      # If not end of row, continue

    add  $t0, $t0, 128        # Move to the next row (Y offset)
    addi $t2, $t2, 1          # Next row
    bne  $t2, 10, y_loop      # If not 10 rows, continue

    lw    $ra, 0($sp)         # Restore return address
    addiu $sp, $sp, 4         # Pop stack
    jr   $ra                  # Return

calculate_offset:
    mul $t2, $t6, 4         # x (column) * 4 (column offset)
    mul $t3, $t1, 128       # y (row) * 128 (row offset)
    add $t4, $t2, $t3       # total offset
    add $t4, $t4, $t0       # final address = base + offset t6 capsule x, t1 capsule y
    jr $ra
    
    
##############################################################################
# Draw the Medicine Bottle
##############################################################################
draw_bottle:
    lw $t7, COLOUR_GREY             # $t7 = grey
    lw $t0, ADDR_DSPL               # $t0 = base address for display
    
intitialize:
    move $t4, $t0
    addi $t4, $t4, 512
    li $t6, 0                       #loop counter
    
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

loop_right: #draw the right side of the bottle
    beq $t6, 26, initialize_bottom
    sw  $t7, 68($t4)
    addi $t4, $t4, 128
    addi $t6, $t6, 1 
    j loop_right

initialize_bottom: #draw the bottom side of the bottle
    move $t4, $t0
    addi $t4, $t4, 3728
    li $t6, 0 

loop_bottom: #draw the bottom side of the bottle
    beq $t6, 14, initialize_top
    sw  $t7, 0($t4)
    addi $t4, $t4, 4
    addi $t6, $t6, 1 
    j loop_bottom

initialize_top: #draw the top of the bottle
    move $t4, $t0
    addi $t4, $t4, 528       #move it one row below
    li $t6, 0
    li $t2, 0
    
loop_top:
    beq $t6, 14, draw_lid
    
    # Check if $t6 is greater than x (e.g., 1) and less than y (e.g., 3)
    li $t3, 4               # Set x = 3 (greater than 3)
    li $t5, 9              # Set y = 9 (less than 9)
    sgt $t2, $t6, $t3       # Set $t2 to 1reuse_ if $t6 > 3
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
    jr $ra

check_horz:
    sgt $t2, $t1, 1
    slt $t3, $t1, 5
    and $t4, $t2, $t3
    beq $t4, 1, check_lid_horz
    beq $t4, 0, check_reg_horz

check_lid_horz:
    addi $sp, $sp, -4       # Move stack pointer
    sw $ra, 0($sp)          # Save $ra on stack
    sgt $t2, $t7, 8
    slt $t3, $t7, 12
    and $t4, $t2, $t3
   
    lw $ra, 0($sp)    
    addi $sp, $sp, 4  
    jr $ra

check_reg_horz:
   addi $sp, $sp, -4       # Move stack pointer
   sw $ra, 0($sp)          # Save $ra on stack
   lw $t5, capsule_orient
   beq $t5, 1, check_vert_reg_right
    
   sgt $t2, $t7, 4
   slt $t3, $t7, 16
   and $t4, $t2, $t3
   
    lw $ra, 0($sp)    
    addi $sp, $sp, 4  
    jr $ra

  check_vert_reg_right:
    sgt $t2, $t7, 4
    slt $t3, $t7, 17
    and $t4, $t2, $t3
   
    lw $ra, 0($sp)    
    addi $sp, $sp, 4  
    jr $ra
  
  
check_vertical:
   lw $t6, capsule_x       # Load current x position (column)
   lw $t1, capsule_y       # Load current y position
    
   sgt $t2, $t1, 1
   slt $t3, $t1, 28
   and $t4, $t2, $t3
   beqz $t4, reset_next
   
   addi $sp, $sp, -4       # Move stack pointer
   sw $ra, 0($sp)          # Save $ra on stack
   
   lw $ra, 0($sp)    
   addi $sp, $sp, 4  
   jr $ra

reset_next:
    li $t0, 0
    sw $t0, next_capsule_color1
    sw $t0, next_capsule_color2
    jr $ra



#####################################
# Draw the Capsule
#####################################

draw_curr:
    lw $s3, next_capsule_color1
    lw $s4, next_capsule_color2
    add $t4, $s3, $s4
    bne $t4, 0, reuse_old_next

    addiu $sp, $sp, -4       # Allocate stack space (8 bytes)
    sw    $ra, 0($sp)        # Save return address
    
    jal draw_current
    jal draw_nxt
    
    lw    $ra, 0($sp)         # Restore return address
    addiu $sp, $sp, 4         # Pop stack
    
    jr $ra

reuse_old_next:
    addiu $sp, $sp, -4       # Allocate stack space (8 bytes)
    sw    $ra, 0($sp)        # Save return address
    
    lw $s1, capsule_color1  # Load left side of capsule color
    lw $s2, capsule_color2  # Load right side of capsule color
    move $s1, $s3
    move $s2, $s4
    sw $s1, capsule_color1
    sw $s2, capsule_color2 
    # Compute the memory address from (x, y)
    lw $a2, capsule_x       # X-coordinate (column)
    lw $a3, capsule_y       # Y-coordinate (row)
    li $s5, 0
    
    jal draw_cap
    
    lw    $ra, 0($sp)         # Restore return address
    addiu $sp, $sp, 4         # Pop stack
    
    jr $ra
    
draw_current:
    addiu $sp, $sp, -4       # Allocate stack space (8 bytes)
    sw    $ra, 0($sp)        # Save return address
    
    lw $s1, capsule_color1  # Load left side of capsule color
    lw $s2, capsule_color2  # Load right side of capsule color
    # Compute the memory address from (x, y)
    lw $a2, capsule_x       # X-coordinate (column)
    lw $a3, capsule_y       # Y-coordinate (row)
    li $s5, 0
    
    jal draw_cap
    
    lw    $ra, 0($sp)         # Restore return address
    addiu $sp, $sp, 4         # Pop stack
    
    jr $ra

draw_nxt:
    addiu $sp, $sp, -4       # Allocate stack space (8 bytes)
    sw    $ra, 0($sp)        # Save return address
    
    lw $s1, next_capsule_color1  # Load left side of capsule color
    lw $s2, next_capsule_color2  # Load right side of capsule color
    # Compute the memory address from (x, y)
    li $a2, 22       # X-coordinate (column)
    li $a3, 5       # Y-coordinate (row)
    li $s5, 1
    
    jal draw_cap
    
    lw    $ra, 0($sp)         # Restore return address
    addiu $sp, $sp, 4         # Pop stack
    
    jr $ra

draw_cap:
    # Load stored capsule colors
    add $t4, $s1, $s2       # Check if both are zero
    beq $t4, 0, randomize_capsule  # If both are zero, randomize a new capsule

    # Load base address of display
    lw $t0, ADDR_DSPL 

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
    # lw $a2, capsule_x      
    # lw $a3, capsule_y      

    mul $t2, $a2, 4        
    mul $t3, $a3, 128      
    add $t4, $t2, $t3      
    add $t4, $t4, $t0      

    # Generate a random left capsule color
    li $v0, 42      
    li $a1, 3 
    li $a0, 0               # reinitialize a0 to 0
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
    # j store_capsule_colors 
    beq $s5, 0, store_capsule_colors
    beq $s5, 1, store_nextcapsule_colors

pick_right_red:
    sw $t9, 4($t4)        
    move $s2, $t9
    beq $s5, 0, store_capsule_colors
    beq $s5, 1, store_nextcapsule_colors
    # j store_capsule_colors 

pick_right_yellow:
    sw $t6, 4($t4)        
    move $s2, $t6 
    beq $s5, 0, store_capsule_colors
    beq $s5, 1, store_nextcapsule_colors

store_capsule_colors:
    # Store colors in global variables for next check
    sw $s1, capsule_color1
    sw $s2, capsule_color2
    jr $ra

store_nextcapsule_colors:
    # Store colors in global variables for next check
    sw $s1, next_capsule_color1
    sw $s2, next_capsule_color2
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
    
    
    move $a0, $s6                   # Sleep for 1 second
    li $v0, 32                      # Syscall for sleep
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
    
    lw $t3, KEY_W
    beq $t2, $t3, respond_to_W

    j game_loop
    
respond_to_Q: # Quit Game 
    j exit

respond_to_A: # Move left
    lw $t6, capsule_x       # Load current x position (column)
    lw $t1, capsule_y       # Load current y position
    move $t7, $t6            
    addi $t7, $t7, -1       # Store potential x position in t7
    
    jal check_horz          # Call check_horz with new x position
    beq $t4, 0, game_loop   # If out of bounds (t4 == 1), don't move
    
    move $a0, $t7
    move $a1, $t1
    li $a2, 0 # 0 means we're moving left
    move $a3, $t5 # 0 means capsule is currently horizontal
    jal check_leftright_translate
    jal plink_sound
    
    jal check_vertical
    beq $t4, 0, game_loop   # If out of bounds (t4 == 1), don't move
    
    lw $t1, capsule_y       # Load current y position
    lw $t0, ADDR_DSPL       # Load base address of display
    jal calculate_offset
    lw $t7, COLOR_BLACK
    beq $t5, 1, left_vert_A
    sw $t7, 0($t4)          # Store black at (x, y)
    sw $t7, 4($t4)          # Store black at (x+1, y)
    
    addi $t6, $t6, -1       # Move actual x postion left (x = x - 1)
    sw $t6, capsule_x       # Store updated x position
    
    # Then redraw capsule at new position
    jal draw_curr
    j game_loop
    
    left_vert_A:
        sw $t7, 0($t4)          # Store black at (x+1, y)
        sw $t7, -128($t4)       # Store black at (x+1, y)
        addi $t6, $t6, -1       # Move actual x postion left (x = x - 1)
        sw $t6, capsule_x       # Store updated x position
    
        # Then redraw capsule at new position
        jal draw_curr
        j game_loop
        
# $a0=x-position, $a1=y-position, $a2=direction(0=left,1=right), $a3=orientation
check_leftright_translate:
    addi $sp, $sp, -4       # Move stack pointer
    sw $ra, 0($sp)          # Save $ra on stack
    beq $a2, 0, check_left_translate
    beq $a2, 1, check_right_translate
    
    check_left_translate:
        beq $a3, 1, check_vert_translate
        jal get_board_cell  # check the left cell of the capsule
        bnez $v0, game_loop # skip if there is already a block there
        
        lw $ra, 0($sp)
        addi $sp, $sp, 4  
        jr $ra  
    check_right_translate:    
        beq $a3, 1, check_vert_translate
        addi $a0, $a0, 1    # check the right cell of the capsule
        jal get_board_cell
        bnez $v0, game_loop # skip if there is already a block there
        
        lw $ra, 0($sp)
        addi $sp, $sp, 4  
        jr $ra  
    check_vert_translate:
        move $t7, $a0
        move $t8, $a1
        jal get_board_cell  # check the potential location of pivot cell
        bnez $v0, game_loop # skip if there is already a block there
        addi $t8, $t8, -1
        
        move $a0, $t7
        move $a1, $t8
        jal get_board_cell  # check the cell on top of pivot
        bnez $v0, game_loop # skip if there is already a block there 
        
        lw $ra, 0($sp)
        addi $sp, $sp, 4  
        jr $ra  
     

respond_to_S: #move capsule down when S is pressed
    lw $t6, capsule_x       # Load current x position (column)
    lw $t1, capsule_y       # Load current y position (column)
    lw $t5, capsule_orient
    
    jal check_vertical
    beq $t4, 0, redraw_capsules   # If out of bounds (t4 == 0), don't move
    
    bgt $t1, 5, call_can_down
        
    continue_s_movement:
      jal plink_sound
      lw $t1, capsule_y       # Load current y position (column) (fix the function use arg regs)
      lw $t0, ADDR_DSPL       # Load base address of display
      jal calculate_offset
      beq $t5, 1, down_vert_S 
      lw $t7, COLOR_BLACK
      sw $t7, 0($t4)          # Store black at (x, y)
      sw $t7, 4($t4)          # Store black at (x+1, y)
      addi $t1, $t1, 1        # Move down (y = y + 1)
      sw $t1, capsule_y       # Store updated y position
      
      # Then redraw capsule at new position
      jal draw_curr
      j game_loop
    
    down_vert_S:
        sw $t1, capsule_y       # Store updated y position
        sw $t7, 0($t4)          # Store black at (x, y)
        sw $t7, -128($t4)       # Store black at (x+1, y)
        addi $t1, $t1, 1        # Move down (y = y + 1)
        sw $t1, capsule_y       # Store updated y position

        jal draw_curr
        j game_loop
    
    call_can_down:
        move $a0, $t6
        move $a1, $t1
        move $a2, $t5 
        jal can_down
        j continue_s_movement
        
    # $a0=x-position, $a1=y-position, $a2=orientation
    can_down:
        addi $sp, $sp, -4       # Move stack pointer
        sw $ra, 0($sp)          # Save $ra on stack
        
        addi $a1, $a1, 1           # add 1 to the y-coordinate to move it to potential location
        beq $a2, 1, can_down_vert
        
        move $t7, $a0
        move $t8, $a1
        jal get_board_cell
        bnez $v0, redraw_capsules
        
        move $a0, $t7
        move $a1, $t8
        addi $a0, $a0, 1           # add 1 to the x-coordinate to access the right cell of capsule
        jal get_board_cell
        bnez $v0, redraw_capsules # skip if there is already a block there
        
        lw $ra, 0($sp)
        addi $sp, $sp, 4  
        jr $ra   
        
    can_down_vert:
        jal get_board_cell
        bnez $v0, redraw_capsules # skip if there is already a block there
        
        lw $ra, 0($sp)
        addi $sp, $sp, 4  
        jr $ra   

redraw_capsules:
    lw $t2, capsule_x
    lw $t3, capsule_y
    move $a0, $t2       # x-coordinate
    move $a1, $t3       # y-coordinate
    lw $a3, capsule_color1
    jal get_index
    move $a2, $v0
    jal set_board_cell  # save position
    
    lw $t1, capsule_orient
    beq $t1, 1, save_top_cell_vert # If capsule is vertical we save differently
    
    lw $t2, capsule_x
    lw $t3, capsule_y
    move $a0, $t2       # x-coordinate
    move $a1, $t3       # y-coordinate
    lw $a3, capsule_color2
    jal get_index
    move $a2, $v0
    addi $a0, $a0, 1    # increase x-coordinate by 1 to move to right cell, y-ccordinate remains
    jal set_board_cell  # save position
    
    # Reset capsule to start position (10,2)
    li $t2, 10      
    li $t3, 2
    sw $t2, capsule_x        # Store x = 10
    sw $t3, capsule_y        # Store y = 2
    
    # Reset capsule colors if needed
    li $t6, 0
    sw $t6, capsule_color1
    sw $t6, capsule_color2
    
    jal reset_next
    li $s6, 1000
    
    jal check_matches
    j game_loop              # Continue game loop
    
    save_top_cell_vert:
        lw $t2, capsule_x
        lw $t3, capsule_y
        move $a0, $t2       # x-coordinate
        move $a1, $t3       # y-coordinate
        lw $a3, capsule_color2
        jal get_index
        move $a2, $v0
        addi $a1, $a1, -1   # subtract 1 from y-coordinate to move to top cell, x-coordinate remains
        jal set_board_cell  # save position
    
        # Reset capsule to start position (10,2)
        li $t2, 10      
        li $t3, 2
        sw $t2, capsule_x        # Store x = 10
        sw $t3, capsule_y        # Store y = 2
    
        # Reset capsule colors if needed
        li $t6, 0
        sw $t6, capsule_color1
        sw $t6, capsule_color2
        
        jal reset_next
        li $s6, 1000
        
        jal check_matches
        sw $zero, capsule_orient
        j game_loop              # Continue game loop
        
    
respond_to_D:
    lw $t6, capsule_x       # Load current x position (column)
    lw $t1, capsule_y       # Load current y position
    move $t7, $t6            
    addi $t7, $t7, 1        # Store potential x position in t7
    
    jal check_horz          # Call check_horz with potential x position
    beq $t4, 0, game_loop   # If out of bounds (t4 == 1), don't move
    
    move $a0, $t7
    move $a1, $t1
    li $a2, 1 # 0 means we're moving right
    move $a3, $t5 # 0 means capsule is currently horizontal
    jal check_leftright_translate
    jal plink_sound
    
    lw $t1, capsule_y       # Load current y position
    lw $t0, ADDR_DSPL       # Load base address of display
    jal calculate_offset
    lw $t7, COLOR_BLACK
    beq $t5, 1, right_vert_D
    sw $t7, 0($t4)          # Store black at (x, y)
    sw $t7, 4($t4)          # Store black at (x+1, y)
    
    addi $t6, $t6, 1        # Move actual x positon left (x = x - 1)
    sw $t6, capsule_x       # Store updated x position
    
    # Then redraw capsule at new position
    jal draw_curr
    j game_loop
    
    right_vert_D:
        sw $t7, 0($t4)          # Store black at (x, y)
        sw $t7, -128($t4)       # Store black at (x+1, y)
    
        addi $t6, $t6, 1        # Move actual x positon left (x = x - 1)
        sw $t6, capsule_x       # Store updated x position
    
        # Then redraw capsule at new position
        jal draw_curr
        j game_loop     

respond_to_W:
    jal plink_sound
    lw $s4, capsule_orient 
    lw $t6, capsule_x       # Load current x position (column)
    lw $t1, capsule_y       # Load current y position
    lw $t0, ADDR_DSPL       # Load base address of display
    
    sgt $t2, $t1, 1         # Do not rotate if in the lid
    slt $t3, $t1, 5
    and $t2, $t2, $t3
    beq $t2, 1, game_loop
    
    beq $s4, 0, horz_to_vert
    beq $s4, 1, vert_to_horz

horz_to_vert:
    move $a0, $t6
    move $a1, $t1
    move $a2, $s4
    jal can_rotate
    
    lw $s4, capsule_orient 
    lw $t6, capsule_x       # Load current x position (column)
    lw $t1, capsule_y       # Load current y position
    lw $t0, ADDR_DSPL       # Load base address of display
    jal calculate_offset
    sw $t7, 4($t4)          # Store black at (x+1, y)
    addi $s4, $s4, 1        # Change orientation to vertical
    
    lw $t2, capsule_color1
    lw $t3, capsule_color2
    sw $t3, capsule_color1
    sw $t2, capsule_color2
    
    sw $s4, capsule_orient
    jal draw_curr
    j game_loop

vert_to_horz:
    move $a0, $t6
    move $a1, $t1
    move $a2, $s4
    jal can_rotate
    
    lw $s4, capsule_orient 
    lw $t6, capsule_x       # Load current x position (column)
    lw $t1, capsule_y       # Load current y position
    lw $t0, ADDR_DSPL       # Load base address of display
    jal calculate_offset
    sw $t7, -128($t4)          # Store black at (x+1, y)
    addi $s4, $s4, -1          # Change orientation to horizontal
    
    sw $s4, capsule_orient
    jal draw_curr
    j game_loop

# $a0=x-position, $a1=y-position, $a2=orientation
can_rotate:
        addi $sp, $sp, -4       # Move stack pointer
        sw $ra, 0($sp)          # Save $ra on stack
        
        move $t7, $a0
        move $t8, $a1
        addi $a1, $a1, -1          # subtract 1 from the y-coordinate to move it to potential location
        addi $a0, $a0, 1           # add 1 to the x-coordinate to move it to potential location
        jal get_board_cell
        bnez $v0, game_loop
        
        beq $a2, 1, can_rotate_vert
        
        move $a0, $t7
        move $a1, $t8
        addi $a1, $a1, -1           # subtract 1 from the y-coordinate to move it to potential location
        jal get_board_cell
        bnez $v0, game_loop # skip if there is already a block there
        
        lw $ra, 0($sp)
        addi $sp, $sp, 4  
        jr $ra   
        
    can_rotate_vert:
        move $a0, $t7
        move $a1, $t8
        addi $a0, $a0, 1           # add 1 to the x-coordinate to move it to potential location
        jal get_board_cell
        bnez $v0, game_loop        # skip if there is already a block there
        
        lw $ra, 0($sp)
        addi $sp, $sp, 4  
        jr $ra   
    
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
    jal pause_sound
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
    jal pause_sound
    addi $t6, $t6, -1
    sw $t6, GAME_PAUSED      # Update GAME_PAUSED to 0
    lw $t7, COLOR_BLACK
    sw $t7, 260($t8)
    sw $t7, 132($t8)
    sw $t7, 268($t8)
    sw $t7, 140($t8)
    j key_check              # Allows other keys to be pressed
    

#####################################
# Board Routines
#####################################
# Set a cell in the board
# Parameters: $a0 = x, $a1 = y, $a2 = value
set_board_cell:
    lw $t4, BOARD_WIDTH
    lw $s3, BOARD_OFFSET
    add $a0, $a0, $s3     # Scale the x and y values from the display to the board by subtracting the offset
    add $a1, $a1, $s3
    
    mul $t0, $a1, $t4     # t0 = y * BOARD_WIDTH
    add $t0, $t0, $a0     # t0 = y * BOARD_WIDTH + x
    sll $t0, $t0, 2       # t2 = x * 4 (x offset)
    
    la $t1, data_board
    add $t1, $t1, $t0
    sw $a2, 0($t1)
    jr $ra

# Get a cell value from the board
# Parameters: $a0 = x, $a1 = y; Returns in $v0
get_board_cell:
    lw $t4, BOARD_WIDTH
    lw $s3, BOARD_OFFSET
    add $a0, $a0, $s3     # Scale the x and y values from the display to the board by subtracting the offset
    add $a1, $a1, $s3
    
    mul $t0, $a1, $t4     # t0 = y * BOARD_WIDTH
    add $t0, $t0, $a0     # t0 = y * BOARD_WIDTH + x
    sll $t0, $t0, 2       # t2 = x * 4 (x offset)
    
    la $t1, data_board
    add $t1, $t1, $t0
    lw $v0, 0($t1)
    jr $ra

# Convert colour indexes to hex codes
# Parameters: $a0 = colour_index; Returns RGB colour in $v0
get_color:
    la $t0, COLOR_TABLE     # Load address of color table
    sll $t1, $a0, 2         # Multiply index by 4 (word size)
    add $t0, $t0, $t1       # Compute address of COLOR_TABLE[index]
    lw  $v0, 0($t0)         # Load color value
    jr  $ra                 # Return
    
# Convert hex color codes to color index
# Parameters: $a3 = RGB color (hex value)
# Returns: $v0 = color index (or -1 if not found)
get_index:
    la   $t0, COLOR_TABLE    # Load base address of COLOR_TABLE
    li   $t1, 0              # Initialize index counter

search_loop:
    lw   $t3, 0($t0)         # Load color from table
    beq  $t3, $a3, found     # If match, return index
    addi $t0, $t0, 4         # Move to the next entry
    addi $t1, $t1, 1         # Increment index
    bne  $t1, 7, search_loop # Continue loop if not at the end

not_found:
    li   $v0, -1             # Return -1 if not found
    jr   $ra

found:
    move $v0, $t1            # Return correct index in $v0
    jr   $ra                 # Return

#####################################
# Virus and Elimination Routines
#####################################
# Initialize viruses randomly in the lower half of board
init_viruses:
    li $t9, 0           # virus counter
    addi $sp, $sp, -4       # Move stack pointer
    sw $ra, 0($sp)          # Save $ra on stack
init_virus_loop:
    beq $t9, 4 , init_virus_done # set the number of viruses
    
    # Random x coordinate between 0 and BOARD_WIDTH-1
    li $v0, 42
    lw $a1, BOARD_WIDTH
    li $a0, 0               # reinitialize a0 to 0
    syscall #returns in a0
    addi $a0, $a0, 5
    move $s4, $a0
    
    # Random y coordinate in lower half (BOARD_HEIGHT/2 to BOARD_HEIGHT-1)
    lw   $t3, BOARD_HEIGHT   # Load board height into $t3
    div  $t3, $t3, 2         # Divide BOARD_HEIGHT by 2; quotient in LO
    mflo $t3                # $t3 = BOARD_HEIGHT/2
    move $t4, $t3           # keep for further use
    li   $v0, 42            # Syscall for random number (Saturn convention)
    move $a1, $t3
    li   $a0, 0               # reinitialize a0 to 0
    syscall                 # Random y-coordinate is returned in $a0
    addi $a0, $a0, 5
    add  $s5, $t4, $a0
    
    # Get random color for virus (viruses encoded as 4,5,6)
    li $v0, 42
    li $a1, 3  # pick a number from 0 to (4-1) and we will add 4 to get 4-6
    li $a0, 0               # reinitialize a0 to 0 from prev syscall
    syscall
    addi $a0, $a0, 4
    move $t3, $a0           # t3 stores the colour index
    jal get_color
    move $t7, $v0           # t7 stores the colour
    
    # Set board cell at (random x, random y) if empty
    move $a0, $s4
    move $a1, $s5
    jal get_board_cell
    bnez $v0, skip_virus_place # skip if there is already a block there

    move $a0, $s4  # x-coordinate
    move $a1, $s5  # y-coordinate
    move $a2, $t3  # virus color (4, 5, or 6)
    jal set_board_cell  # Place the virus


    mul $t2, $s4, 4         # x (column) * 4 (column offset)
    mul $t3, $s5, 128       # y (row) * 128 (row offset)
    add $t3, $t2, $t3       # total offset
    lw $t0, ADDR_DSPL       # Load base address of display
    add $t3, $t3, $t0       # final address = base + offset
    sw $t7, 0($t3)          # draw virus to display
    addi $t9, $t9, 1        # add 1 to virus counter
skip_virus_place:
    j init_virus_loop
init_virus_done:
    lw $ra, 0($sp)    
    addi $sp, $sp, 4  
    jr $ra


#####################################
# MUSIC
#####################################
plink_sound:
    addi $sp, $sp, -4       # Move stack pointer
    sw $ra, 0($sp)          # Save $ra on stack

    li $v0, 31     # MIDI Sound Syscall
    li $a0, 35     # Pitch (Middle C)
    li $a1, 10   # Duration in ms
    li $a2, 10      # Instrument (Piano)
    li $a3, 127    # Volume (Max)
    syscall
    
    lw $ra, 0($sp)    
    addi $sp, $sp, 4  
    jr $ra

pause_sound:
    addi $sp, $sp, -4       # Move stack pointer
    sw $ra, 0($sp)          # Save $ra on stack

    li $v0, 31     # MIDI Sound Syscall
    li $a0, 80     # Pitch (Middle C)
    li $a1, 10   # Duration in ms
    li $a2, 80      # Instrument (Piano)
    li $a3, 127    # Volume (Max)
    syscall
    
    lw $ra, 0($sp)    
    addi $sp, $sp, 4  
    jr $ra

# game_over_sound:
    # addi $sp, $sp, -4       # Move stack pointer
    # sw $ra, 0($sp)          # Save $ra on stack
    
    # lw $ra, 0($sp)    
    # addi $sp, $sp, 4  
    # jr $ra

# you_win_sound:
    # addi $sp, $sp, -4       # Move stack pointer
    # sw $ra, 0($sp)          # Save $ra on stack
  
    # lw $ra, 0($sp)    
    # addi $sp, $sp, 4  
    # jr $ra

#####################################
# CHECK FOR MATCHES
#####################################
check_matches:              #Helper function to draw image given its exact pixel data
    addiu $sp, $sp, -4        # Save $ra before calling another function
    sw    $ra, 0($sp) 
    
    lw   $t1, ADDR_DSPL         # Load base display address
    addi $t1, $t1, 660          # add 5,5
    la   $t0, data_board        # Load base address of dr mario pixel data
    li   $t5, 24                #number of rows
    li   $t7, 12                #number of columns
    
    li   $t2, 0                 # Initialize row counter (Y)

y_loop1:
    li   $t8, 0               # Column counter (X)

x_loop1:
    # lw   $t3, 0($t0)          # Load pixel color from data board
    lw   $t3, 0($t1)          # Load pixel color from data board
    beq $t3, 0, continue_traversal
    addiu $sp, $sp, -20       # Reserve space on stack
    sw    $t0, 0($sp)         # Save board address
    sw    $t1, 4($sp)         # Save display address
    sw    $t2, 8($sp)         # Save row index
    sw    $t8, 12($sp)        # Save column index
    sw    $t3, 16($sp)        # Save pixel value i.e the color
    # lw $t3, COLOR_WHITE
    # sw   $t3, 0($t1)          # Load pixel color from data board
    jal   check_horizontal_match
    jal   check_vertical_match

##################
    lw    $t0, 0($sp)         # Restore board address
    lw    $t1, 4($sp)         # Restore display address
    lw    $t2, 8($sp)         # Restore row index
    lw    $t8, 12($sp)        # Restore column index
    lw    $t3, 16($sp)        # Restore pixel value
    addiu $sp, $sp, 20        # Free stack space
    
continue_traversal:
    addi $t0, $t0, 4          # Move to the next pixel in data board  #stop increasing then skipping row
    addi $t1, $t1, 4          # Move to next pixel in bitmap display
    addi $t8, $t8, 1          # Next column
    bne  $t8, 12, x_loop1     # If not end of row, continue

    add  $t1, $t1, 80         # Move to the next row in the bitmap display
    addi $t2, $t2, 1          # Next row
    bne  $t2, 24, y_loop1      # If not 24 rows, continue
    
    lw    $ra, 0($sp)         # Restore return address
    addiu $sp, $sp, 4         # Pop stack
    jr   $ra                  # Return

check_horizontal_match:
    lw   $t3, 16($sp)         # Pixel value
    lw   $t0, 0($sp)          # Board address

    lw   $t8, 12($sp)         # Load column index
    li   $t9, 9               # (12 - 3) = 9, last valid column for checking 4
    bge  $t8, $t9, no_horiz_match  # Skip if out of bounds

    # lw   $t4, 4($t0)          # board[i][j+1]
    # lw   $t5, 8($t0)          # board[i][j+2]
    # lw   $t6, 12($t0)         # board[i][j+3]
    lw   $t4, 48($t1)          # board[i][j+1]
    lw   $t5, 96($t1)          # board[i][j+2]
    lw   $t6, 144($t1)         # board[i][j+3]

    # Check if all 4 are the same and not zero
    beqz $t3, no_horiz_match
    beq $t3, $t4, check_horiz_2
    j no_horiz_match

check_horiz_2:
    beq $t4, $t5, check_horiz_3
    j no_horiz_match

check_horiz_3:
    beq $t5, $t6, horiz_match_found
    j no_horiz_match

horiz_match_found: # clear on bitmap display
    lw    $t0, 0($sp)          # board address
    lw    $t1, 4($sp)          # bitmap address
    
    # Clear matched blocks in the board
    sw   $zero, 0($t0)
    sw   $zero, 4($t0)
    sw   $zero, 8($t0)
    sw   $zero, 12($t0)
    
    # Clear matched blocks in the bitmap
    lw $t3, COLOR_BLACK
    sw   $t3, 0($t1)
    sw   $t3, 4($t1)
    sw   $t3, 8($t1)
    sw   $t3, 12($t1)
    
    # insert point increase logic

no_horiz_match:
    jr   $ra

check_vertical_match:
    lw   $t3, 16($sp)         # Pixel value
    lw   $t0, 0($sp)          # Board address
    lw   $t2, 8($sp)          # Row index
    
    li   $t8, 21              # (24 - 3) = 21, last valid row for checking 4
    bge  $t2, $t8, no_vert_match  # Skip if out of bounds
    
    # lw   $t4, 48($t0)          # board[i][j+1]
    # lw   $t5, 96($t0)          # board[i][j+2]
    # lw   $t6, 144($t0)         # board[i][j+3]
    lw   $t4, 48($t1)          # board[i][j+1]
    lw   $t5, 96($t1)          # board[i][j+2]
    lw   $t6, 144($t1)         # board[i][j+3]  
  
    # Check if all 4 are the same and not zero
    beqz $t3, no_vert_match
    beq $t3, $t4, check_vert_2
    j no_vert_match

check_vert_2:
    beq $t4, $t5, check_vert_3
    j no_vert_match

check_vert_3:
    beq $t5, $t6, vert_match_found
    j no_vert_match

vert_match_found:
    lw    $t0, 0($sp)          # board address
    lw    $t1, 4($sp)          # bitmap address
    
    # Clear matched blocks in the board
    sw   $zero, 0($t0)
    sw   $zero, 48($t0)
    sw   $zero, 96($t0)
    sw   $zero, 144($t0)
    # Clear matched blocks in the display
    lw $t3, COLOR_BLACK
    sw   $t3, 0($t1)
    sw   $t3, 128($t1)
    sw   $t3, 256($t1)
    sw   $t3, 384($t1)

 #insert point increase logic

no_vert_match:
    jr $ra