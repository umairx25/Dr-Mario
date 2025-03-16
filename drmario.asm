################# CSC258 Assembly Final Project ###################
# This file contains our implementation of Dr Mario.
#
# Student 1: Umair Arham, 1010246565
# Student 2: Sameer Shahed, 1010313876 
#
# We assert that the code submitted here is entirely our own 
# creation, and will indicate otherwise when it is not.
#hello
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
COLOR_GREEN:    .word 0x00ff00 # For border/UI
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

##############################################################################
# Code
##############################################################################
	.text
	.globl main

    # Run the game.
main:
    # Initialize the game
    # Seed random number generator using system time
    li $v0, 30
    syscall
    move $a0, $0
    move $a1, $v0
    li $v0, 40
    syscall

    jal clear_board         # Clear board array
    jal draw_borders        # Draw game borders
    jal init_viruses        # Place viruses randomly
    jal spawn_capsule       # Create first capsule

game_loop:
    # 1a. Check if key has been pressed
    # 1b. Check which key has been pressed
    # 2a. Check for collisions
	# 2b. Update locations (capsules)
	# 3. Draw the screen
	# 4. Sleep

    # 5. Go back to Step 1
    j game_loop
