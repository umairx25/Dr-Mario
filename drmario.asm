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
    
dr_mario_theme:
.word 85, 0
.word 85, 245
.word 85, 156
.word 85, 234
.word 85, 156
.word 85, 246
.word 86, 824
.word 88, 481
.word 86, 33
.word 88, 223
.word 88, 156
.word 85, 379
.word 85, 268
.word 86, 200
.word 86, 190
.word 85, 135
.word 85, 245
.word 86, 847
.word 86, 178
.word 86, 212
.word 88, 100
.word 88, 392
.word 88, 234
.word 85, 134
.word 85, 267
.word 85, 167
.word 85, 234
.word 81, 134
.word 81, 267
.word 81, 145
.word 86, 670
.word 86, 402
.word 88, 100
.word 88, 245
.word 88, 156
.word 85, 368
.word 85, 258
.word 86, 144
.word 86, 246
.word 85, 156
.word 85, 245
.word 38, 914
.word 37, 402
.word 35, 491
.word 85, 289
.word 33, 0
.word 57, 12
.word 37, 267
.word 85, 11
.word 37, 123
.word 88, 56
.word 88, 133
.word 81, 78
.word 30, 113
.word 81, 22
.word 33, 368
.word 45, 11
.word 33, 156
.word 90, 535
.word 30, 167
.word 90, 223
.word 88, 101
.word 28, 100
.word 88, 89
.word 32, 169
.word 85, 33
.word 83, 290
.word 45, 89
.word 85, 11
.word 57, 0
.word 33, 22
.word 88, 357
.word 37, 89
.word 88, 56
.word 81, 167
.word 88, 11
.word 30, 112
.word 45, 368
.word 33, 33
.word 33, 134
.word 30, 447
.word 81, 78
.word 30, 78
.word 28, 379
.word 80, 33
.word 32, 368
.word 83, 22
.word 81, 301
.word 85, 89
.word 57, 0
.word 45, 0
.word 33, 0
.word 85, 269
.word 37, 67
.word 88, 45
.word 37, 89
.word 88, 55
.word 81, 168
.word 30, 111
.word 33, 368
.word 33, 178
.word 45, 45
.word 81, 468
.word 30, 89
.word 90, 291
.word 88, 112
.word 28, 122
.word 88, 11
.word 32, 246
.word 85, 22
.word 51, 0
.word 83, 290
.word 81, 100
.word 85, 11
.word 57, 0
.word 33, 22
.word 81, 234
.word 37, 67
.word 81, 123
.word 37, 22
.word 81, 190
.word 42, 122
.word 36, 380
.word 35, 391
.word 86, 66
.word 41, 346
.word 40, 401
.word 83, 56
.word 64, 67
.word 40, 22
.word 34, 212
.word 85, 402
.word 45, 0
.word 57, 11
.word 33, 134
.word 85, 145
.word 37, 56
.word 88, 122
.word 37, 23
.word 88, 111
.word 81, 89
.word 30, 123
.word 81, 11
.word 33, 401
.word 33, 134
.word 45, 45
.word 90, 480
.word 30, 11
.word 30, 156
.word 90, 223
.word 88, 101
.word 28, 100
.word 32, 278
.word 85, 12
.word 83, 289
.word 45, 101
.word 33, 0
.word 85, 11
.word 57, 11
.word 85, 256
.word 37, 46
.word 88, 56
.word 37, 89
.word 88, 56
.word 81, 167
.word 88, 11
.word 30, 89
.word 33, 424
.word 45, 100
.word 33, 34
.word 81, 535
.word 30, 167
.word 28, 280
.word 80, 33
.word 32, 379
.word 83, 11
.word 81, 290
.word 85, 89
.word 57, 11
.word 45, 0
.word 33, 45
.word 85, 234
.word 40, 134
.word 88, 111
.word 81, 156
.word 37, 112
.word 81, 22
.word 33, 324
.word 33, 212
.word 45, 22
.word 38, 201
.word 81, 301
.word 42, 100
.word 80, 390
.word 52, 0
.word 40, 0
.word 81, 212
.word 32, 167
.word 83, 23
.word 81, 380
.word 57, 0
.word 33, 11
.word 85, 22
.word 81, 101
.word 33, 22
.word 81, 111
.word 57, 134
.word 33, 56
.word 81, 11
.word 81, 201
.word 35, 100
.word 86, 56
.word 81, 66
.word 35, 34
.word 81, 156
.word 47, 56
.word 35, 133
.word 81, 45
.word 47, 167
.word 36, 100
.word 87, 34
.word 36, 358
.word 37, 401
.word 88, 100
.word 37, 156
.word 37, 212
.word 49, 201
.word 93, 412
.word 30, 78
.word 81, 13
.word 90, 378
.word 45, 12
.word 83, 55
.word 33, 45
.word 47, 301
.word 35, 11
.word 86, 100
.word 86, 145
.word 36, 212
.word 86, 45
.word 86, 144
.word 47, 134
.word 35, 0
.word 81, 34
.word 88, 89
.word 90, 134
.word 52, 79
.word 45, 33
.word 64, 23
.word 90, 11
.word 83, 55
.word 33, 23
.word 30, 278
.word 81, 45
.word 45, 357
.word 33, 0
.word 33, 156
.word 57, 133
.word 85, 12
.word 76, 189
.word 37, 0
.word 85, 312
.word 40, 0
.word 78, 45
.word 85, 223
.word 42, 123
.word 86, 112
.word 86, 145
.word 88, 122
.word 43, 0
.word 88, 134
.word 88, 145
.word 76, 145
.word 42, 0
.word 40, 379
.word 78, 56
.word 76, 378
.word 37, 34
.word 33, 146
.word 93, 457
.word 30, 100
.word 81, 11
.word 30, 157
.word 90, 222
.word 45, 0
.word 33, 12
.word 83, 55
.word 90, 67
.word 90, 134
.word 86, 123
.word 47, 22
.word 35, 0
.word 86, 111
.word 86, 134
.word 86, 134
.word 36, 78
.word 86, 190
.word 47, 134
.word 35, 0
.word 81, 34
.word 88, 78
.word 90, 145
.word 45, 111
.word 33, 0
.word 90, 33
.word 83, 0
.word 64, 0
.word 30, 368
.word 81, 34
.word 88, 368
.word 40, 11
.word 88, 122
.word 88, 134
.word 32, 111
.word 39, 12
.word 88, 66
.word 88, 191
.word 35, 56
.word 88, 145
.word 35, 22
.word 35, 178
.word 88, 123
.word 32, 11
.word 88, 123
.word 36, 256
.word 88, 11
.word 36, 123
.word 88, 11
.word 88, 167
.word 88, 156
.word 88, 223
.word 82, 358
.word 85, 524
.word 57, 0
.word 45, 0
.word 33, 11
.word 85, 134
.word 37, 122
.word 85, 12
.word 88, 111
.word 37, 11
.word 88, 134
.word 81, 145
.word 30, 122
.word 33, 369
.word 83, 703
.word 30, 178
.word 81, 223
.word 30, 0
.word 47, 89
.word 83, 11
.word 28, 112
.word 32, 256
.word 86, 78
.word 88, 234
.word 85, 90
.word 57, 0
.word 33, 0
.word 37, 268
.word 85, 11
.word 81, 100
.word 37, 23
.word 81, 122
.word 76, 179
.word 30, 100
.word 33, 423
.word 83, 637
.word 30, 89
.word 81, 323
.word 28, 45
.word 83, 33
.word 32, 390
.word 86, 0
.word 86, 145
.word 88, 168
.word 85, 100
.word 57, 0
.word 33, 67
.word 85, 67
.word 85, 144
.word 88, 101
.word 37, 22
.word 88, 123
.word 88, 179
.word 81, 67
.word 30, 22
.word 81, 257
.word 33, 111
.word 81, 714
.word 30, 167
.word 81, 189
.word 80, 134
.word 28, 89
.word 81, 202
.word 32, 78
.word 83, 22
.word 81, 279
.word 31, 100
.word 81, 134
.word 81, 145
.word 81, 256
.word 81, 134
.word 81, 134
.word 31, 0
.word 81, 289
.word 31, 90
.word 26, 982
.word 45, 602
.word 85, 401
.word 57, 0
.word 45, 0
.word 33, 0
.word 85, 257
.word 37, 56
.word 88, 56
.word 37, 89
.word 88, 56
.word 81, 145
.word 30, 122
.word 33, 379
.word 33, 178
.word 90, 524
.word 30, 68
.word 90, 313
.word 88, 100
.word 28, 111
.word 88, 23
.word 86, 156
.word 32, 78
.word 51, 33
.word 85, 123
.word 83, 167
.word 85, 100
.word 57, 11
.word 33, 67
.word 45, 45
.word 85, 156
.word 88, 122
.word 37, 0
.word 88, 190
.word 81, 101
.word 30, 123
.word 33, 357
.word 45, 234
.word 81, 468
.word 30, 78
.word 80, 412
.word 28, 112
.word 81, 100
.word 32, 157
.word 83, 23
.word 81, 256
.word 33, 123
.word 85, 11
.word 57, 0
.word 81, 11
.word 45, 167
.word 85, 100
.word 88, 123
.word 37, 0
.word 88, 178
.word 81, 112
.word 30, 100
.word 33, 379
.word 33, 178
.word 81, 525
.word 30, 168
.word 90, 211
.word 28, 78
.word 88, 11
.word 88, 145
.word 32, 246
.word 85, 33
.word 83, 279
.word 33, 89
.word 81, 22
.word 57, 0
.word 85, 34
.word 81, 224
.word 37, 122
.word 81, 134
.word 81, 134
.word 42, 122
.word 36, 402
.word 35, 379
.word 86, 66
.word 41, 357
.word 40, 380
.word 83, 56
.word 64, 67
.word 40, 11
.word 34, 223
.word 85, 412
.word 33, 23
.word 57, 44
.word 33, 89
.word 85, 134
.word 37, 112
.word 88, 11
.word 88, 189
.word 81, 89
.word 30, 112
.word 81, 12
.word 45, 379
.word 33, 34
.word 33, 133
.word 90, 524
.word 30, 78
.word 90, 312
.word 88, 101
.word 28, 111
.word 32, 258
.word 85, 22
.word 83, 290
.word 45, 89
.word 85, 11
.word 57, 33
.word 33, 78
.word 85, 23
.word 85, 145
.word 37, 111
.word 88, 67
.word 88, 134
.word 81, 111
.word 30, 112
.word 33, 356
.word 45, 11
.word 33, 168
.word 81, 525
.word 30, 78
.word 80, 412
.word 28, 100
.word 32, 279
.word 83, 22
.word 81, 257
.word 85, 122
.word 57, 0
.word 81, 23
.word 33, 78
.word 85, 168
.word 88, 111
.word 40, 23
.word 88, 122
.word 81, 168
.word 88, 11
.word 37, 78
.word 33, 434
.word 33, 134
.word 45, 56
.word 38, 156
.word 81, 323
.word 42, 89
.word 52, 380
.word 40, 0
.word 81, 23
.word 81, 278
.word 32, 90
.word 83, 11
.word 81, 390
.word 33, 33
.word 85, 0
.word 57, 23
.word 81, 78
.word 33, 33
.word 81, 111
.word 33, 123
.word 57, 11
.word 81, 56
.word 81, 201
.word 35, 100
.word 86, 56
.word 81, 68
.word 35, 22
.word 81, 156
.word 47, 111
.word 35, 90
.word 81, 33
.word 47, 167
.word 36, 78
.word 87, 56
.word 36, 368
.word 37, 379
.word 88, 122
.word 37, 168
.word 37, 190
.word 49, 212
.word 93, 401
.word 30, 89
.word 81, 34
.word 90, 368
.word 45, 0
.word 33, 11
.word 83, 44
.word 90, 78
.word 90, 134
.word 86, 123
.word 47, 11
.word 35, 11
.word 86, 112
.word 86, 133
.word 36, 191
.word 86, 67
.word 86, 134
.word 88, 133
.word 47, 11
.word 35, 0
.word 81, 34
.word 90, 245
.word 52, 22
.word 45, 67
.word 33, 0
.word 83, 34
.word 64, 0
.word 90, 67
.word 81, 334
.word 30, 11
.word 45, 346
.word 33, 100
.word 57, 189
.word 85, 23
.word 85, 168
.word 76, 0
.word 37, 0
.word 85, 312
.word 40, 0
.word 78, 56
.word 85, 212
.word 42, 145
.word 86, 111
.word 86, 134
.word 88, 122
.word 43, 12
.word 88, 133
.word 88, 134
.word 42, 145
.word 76, 0
.word 40, 369
.word 78, 67
.word 37, 323
.word 76, 33
.word 93, 658
.word 30, 100
.word 81, 145
.word 30, 23
.word 90, 222
.word 45, 0
.word 33, 0
.word 83, 67
.word 90, 67
.word 90, 146
.word 86, 112
.word 47, 11
.word 35, 11
.word 86, 245
.word 86, 134
.word 36, 0
.word 86, 268
.word 47, 133
.word 35, 11
.word 81, 12
.word 88, 100
.word 90, 134
.word 45, 122
.word 33, 0
.word 83, 23
.word 64, 0
.word 90, 11
.word 30, 356
.word 81, 34
.word 88, 358
.word 40, 11
.word 88, 178
.word 88, 212
.word 32, 0
.word 88, 256
.word 35, 67
.word 35, 156
.word 88, 45
.word 35, 156
.word 88, 100
.word 32, 22
.word 88, 246
.word 36, 111
.word 88, 22
.word 36, 102
.word 88, 200
.word 88, 145
.word 88, 223
.word 82, 368
.word 84, 268
.word 85, 256
.word 57, 11
.word 45, 0
.word 33, 11
.word 85, 123
.word 85, 145
.word 88, 100
.word 37, 11
.word 88, 124
.word 30, 0
.word 88, 178
.word 81, 0
.word 30, 90
.word 33, 434
.word 83, 658
.word 30, 78
.word 81, 312
.word 28, 57
.word 83, 22
.word 32, 379
.word 86, 0
.word 86, 145
.word 88, 178
.word 85, 89
.word 57, 0
.word 33, 112
.word 85, 167
.word 81, 123
.word 37, 0
.word 81, 133
.word 76, 168
.word 30, 122
.word 33, 358
.word 83, 691
.word 30, 178
.word 81, 212
.word 83, 112
.word 28, 89
.word 85, 178
.word 32, 100
.word 86, 145
.word 88, 158
.word 85, 100
.word 57, 0
.word 33, 89
.word 85, 190
.word 37, 122
.word 88, 123
.word 88, 145
.word 30, 111
.word 88, 22
.word 81, 0
.word 54, 0
.word 81, 268
.word 33, 156
.word 81, 759
.word 30, 56
.word 30, 234
.word 80, 89
.word 28, 100
.word 81, 112
.word 32, 167
.word 83, 22
.word 31, 379
.word 81, 11
.word 81, 134
.word 81, 134
.word 81, 145
.word 81, 157
.word 81, 145
.word 31, 67
.word 81, 111
.word 81, 190
.word 31, 78
.word 26, 1259
.word 33, 704
.word 45, 11
.word 85, 11
.word 57, 0
.word 85, 134
.word 85, 133
.word 88, 112
.word 37, 11
.word 88, 134
.word 81, 167
.word 88, 11
.word 30, 112
.word 33, 356
.word 90, 704
.word 30, 78
.word 90, 312
.word 88, 89
.word 28, 122
.word 88, 12
.word 32, 256
.word 85, 11
.word 83, 290
.word 33, 90
.word 85, 11
.word 57, 23
.word 33, 100
.word 45, 0
.word 85, 145
.word 37, 123
.word 88, 122
.word 81, 178
.word 30, 90
.word 33, 390
.word 45, 234
.word 81, 447
.word 30, 178
.word 28, 279
.word 80, 33
.word 81, 290
.word 32, 100
.word 83, 11
.word 81, 301
.word 85, 90
.word 33, 0
.word 57, 11
.word 33, 133
.word 45, 0
.word 85, 145
.word 37, 112
.word 88, 11
.word 88, 189
.word 81, 80
.word 30, 100
.word 33, 401
.word 81, 691
.word 30, 89
.word 90, 301
.word 28, 78
.word 88, 34
.word 32, 369
.word 85, 11
.word 83, 279
.word 33, 100
.word 81, 22
.word 57, 11
.word 45, 123
.word 81, 134
.word 37, 122
.word 81, 11
.word 81, 268
.word 42, 123
.word 36, 379
.word 35, 380
.word 86, 78
.word 41, 345
.word -1, -1        # Add this as the LAST entry to mark end-of-song
MUSIC_LOADED: .word 0
last_note_time: .word 0     # Store time of last note played
current_note:   .word 0     # Current position in the music array
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
    
    #Refresh the screen every second 60 times
    li $a0, 16              # Sleep for ~16ms (1/60th second)
    li $v0, 32              # Syscall for sleep
    move $a0, $zero         # Store time as seed
    syscall

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
#function to draw the starting screen
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
   # bnez $t4, reset_next
   
   addi $sp, $sp, -4       # Move stack pointer
   sw $ra, 0($sp)          # Save $ra on stack
   
   # Return directly without looping
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
    jal plink_sound
    lw $t6, capsule_x       # Load current x position (column)
    lw $t1, capsule_y       # Load current y position
    lw $t0, ADDR_DSPL       # Load base address of display
    move $t7, $t6            
    addi $t7, $t7, -1       # Store potential x position in t7
    
    jal check_horz          # Call check_horz with new x position
    beq $t4, 0, game_loop   # If out of bounds (t4 == 1), don't move
    
    jal check_vertical
    beq $t4, 0, game_loop   # If out of bounds (t4 == 1), don't move
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
 
respond_to_S: #move capsule down when S is pressed
    jal plink_sound
    lw $t6, capsule_x       # Load current x position (column)
    lw $t1, capsule_y       # Load current x position (column)
    lw $t0, ADDR_DSPL       # Load base address of display
    jal check_vertical
    
    beq $t4, 0, redraw_capsules   # If out of bounds (t4 == 1), don't move
    jal calculate_offset
    beq $t5, 1, down_vert_S 
    
    sw $t7, 0($t4)          # Store black at (x, y)
    sw $t7, 4($t4)          # Store black at (x+1, y)
    addi $t1, $t1, 1        # Move down (y = y + 1)
    sw $t1, capsule_y       # Store updated y position
    
    # Then redraw capsule at new position
    # jal draw_start_capsule
    jal draw_curr
    j game_loop
    
    down_vert_S:
        sw $t1, capsule_y       # Store updated y position
        sw $t7, 0($t4)          # Store black at (x, y)
        sw $t7, -128($t4)       # Store black at (x+1, y)
        addi $t1, $t1, 1        # Move down (y = y + 1)
        sw $t1, capsule_y       # Store updated y position
    
        # Then redraw capsule at new position
        # jal draw_start_capsule
        jal draw_curr
        j game_loop

redraw_capsules:

    lw $t2, capsule_y        # Load current y position
    # li $t4, 480              # Assuming 480 is the bottom of the screen
    # bne $t2, $t4, game_loop  # If not at the bottom, continue game

    # Reset capsule to start position (10,2)
    li $t2, 10      
    li $t3, 2
    sw $t2, capsule_x        # Store x = 10
    sw $t3, capsule_y        # Store y = 2

    # Load capsule colors
    lw $t2, capsule_color1   
    lw $t3, capsule_color2   

    # Reset capsule colors if needed
    li $t6, 0
    sw $t6, capsule_color1
    sw $t6, capsule_color2
    
    jal reset_next
    li $s6, 1000

    j game_loop              # Continue game loop

    
respond_to_D:
    jal plink_sound
    lw $t6, capsule_x       # Load current x position (column)
    lw $t1, capsule_y       # Load current y position
    lw $t0, ADDR_DSPL       # Load base address of display
    move $t7, $t6            
    addi $t7, $t7, 1        # Store potential x position in t7
    
    jal check_horz          # Call check_horz with potential x position
    beq $t4, 0, game_loop   # If out of bounds (t4 == 1), don't move
    
    jal check_vertical
    beq $t4, 0, game_loop   # If out of bounds (t4 == 1), don't move
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
    
respond_to_X: # Rotate Right
    j key_check
respond_to_Z: # Rotate Left
    j key_check

respond_to_W:
    jal plink_sound
    lw $s4, capsule_orient 
    lw $t6, capsule_x       # Load current x position (column)
    lw $t1, capsule_y       # Load current y position
    lw $t0, ADDR_DSPL       # Load base address of display
    beq $s4, 0, horz_to_vert
    beq $s4, 1, vert_to_horz

horz_to_vert:
    jal calculate_offset
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
    jal draw_curr
    j game_loop

vert_to_horz:
    jal calculate_offset
    sw $t7, -128($t4)          # Store black at (x+1, y)
    
    addi $s4, $s4, -1
    jal check_vertical
    beq $t4, 0, game_loop       # If out of bounds (t4 == 1), don't move
    sw $s4, capsule_orient
    jal draw_curr
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
    sll $t2, $a0, 2       # t2 = x * 4 (x offset)
    add $t0, $t0, $t2     # t0 = (y * BOARD_WIDTH) + (x * 4)
    la $t1, board
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
    sll $t2, $a0, 2       # t2 = x * 4 (x offset)
    add $t0, $t0, $t2     # t0 = (y * BOARD_WIDTH) + (x * 4)
    la $t1, board
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

#####################################
# Virus and Elimination Routines
#####################################
# Initialize viruses randomly in the lower half of board
init_viruses:
    li $t9, 0           # virus counter
    addi $sp, $sp, -4       # Move stack pointer
    sw $ra, 0($sp)          # Save $ra on stack
init_virus_loop:
    beq $t9, 5 , init_virus_done # set the number of viruses
    
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
    add  $s5, $t4, $a0
    
    # Get random color for virus (viruses encoded as 4,5,6)
    li $v0, 42
    li $a1, 3  # pick a number from 0 to (4-1) and we will add 4 to get 4-6
    li $a0, 0               # reinitialize a0 to 0 from prev syscall
    syscall
    addi $a0, $a0, 4
    jal get_color
    move $t7, $v0
    li $v0, 0
    
    # Set board cell at (random x, random y) if empty
    move $a0, $s4
    move $a1, $s5
    jal get_board_cell
    bnez $v0, skip_virus_place # skip if there is already a block there

    move $a0, $s4  # x-coordinate
    move $a1, $s5  # y-coordinate
    move $a2, $t7  # virus color (4, 5, or 6)
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

    
    
