# Dr. Mario - MIPS Assembly Project

## Overview

This project is an implementation of the **Dr. Mario** game in **MIPS assembly**, designed to run on the **Saturn** or **MARS** simulators. The game is a **falling block puzzle game** where the objective is to eliminate all viruses by strategically placing medical capsules.

Dr. Mario was originally released by **Nintendo** in 1990. The game mechanics involve rotating and moving capsules to match colors with existing viruses and other capsules. When four or more of the same color align **horizontally or vertically**, they disappear, creating chain reactions that further clear the playing field.

In this project, we will implement the game step by step, following a set of milestones. Each milestone represents a crucial part of the game, from drawing the scene to implementing advanced game features.

---

## Features (⬜ represents in progress and ✅ represents completed) 

### ⬜ Milestone 1: Draw the Scene  
- Display the medicine bottle (playing field).  
- Show the initial capsule in the starting position with randomized colors.  

### ⬜  Milestone 2: Implement Movement and Controls  
- Enable movement using the keyboard:  
  - `A` → Move capsule left.  
  - `D` → Move capsule right.  
  - `W` → Rotate capsule.  
  - `S` → Drop capsule.  
- Allow the player to quit the game with a key press.  

### ⬜  Milestone 3: Collision Detection  
- Prevent capsules from moving beyond the boundaries of the playing field.  
- Detect when a capsule lands on another capsule, virus, or the bottom of the field.  
- Lock the capsule in place upon collision and generate a new capsule.  
- Remove groups of four or more matching colors and allow falling capsules to continue clearing rows.  
- Implement the **Game Over** condition when capsules reach the top of the field.  

### ⬜ Milestone 4: Game Features (Choose at least one option)  
- Implement **gravity** to make capsules fall automatically.  
- Introduce **level progression**, increasing the number of viruses and speed.  
- Display a **Game Over screen** when the game ends.  
- Add **sound effects** for actions like rotating, dropping, and clearing viruses.  
- Implement a **pause feature** (`P` key) to pause and resume the game.  

### ⬜ Milestone 5: Advanced Game Features (Choose at least one option)  
- Display **score tracking** in pixels, based on game difficulty and cleared viruses.  
- Introduce **special capsule power-ups** with unique effects.  
- Add **animations** for disappearing capsules and virus reactions.  
- Play **Dr. Mario’s theme music** in the background.  
- Implement a **multiplayer mode**, adding a second playing field for another player.  

---

## How to Play

1. **Run the program in Saturn or MARS** (refer to the project instructions).  
2. Use the following controls to play:  
   - `A` → Move left  
   - `D` → Move right  
   - `W` → Rotate capsule  
   - `S` → Drop capsule  
   - `Q` → Quit the game  
   - (Optional) `P` → Pause/resume the game  
3. Align **four or more matching colors** to eliminate viruses and capsules.  
4. **Avoid filling up the bottle** to prevent a Game Over!  

---

## Setup Instructions

### Running in **Saturn**
1. Open `DrMario.asm` in Saturn.  
2. Press `Ctrl + T` (or `Cmd + T` on macOS) to open the terminal.  
3. Navigate to the **Bitmap** tab and configure the display.  
4. Click **Run** to start the game!  

### Running in **MARS**
1. Open `DrMario.asm` in MARS.  
2. Navigate to **Tools → Bitmap Display**, configure, and click **Connect to MIPS**.  
3. Navigate to **Tools → Keyboard and Display MMIO Simulator**, click **Connect to MIPS**.  
4. Assemble and run the game.  

---

## Project Deliverables

### ⬜  **Deliverable 1** (March 24/26)  
- **Demonstration 1:** Show milestones **1-3** in the lab.  
- **Files to submit:**
  - `DrMario.asm` (MIPS assembly code)  
  - `project_report.pdf` (documentation)  

### ⬜ **Deliverable 2** (March 31/April 2)  
- **Final Demonstration:** Show the completed game (**Milestone 4+**).  
- **Files to submit:**
  - Final version of `DrMario.asm`  
  - Updated `project_report.pdf`  

---

## Development Notes

- The game uses **Memory Mapped I/O** for keyboard input and pixel rendering.  
- Collision detection is crucial for **capsule interactions, virus removal, and Game Over detection**.  
- The game loop follows this structure:  
  1. **Check keyboard input** (player movement).  
  2. **Check for collisions** (capsule vs. walls, viruses, capsules).  
  3. **Update game state** (move capsules, eliminate viruses).  
  4. **Redraw the screen** (60 frames per second recommended).  
  5. **Pause execution briefly** to simulate smooth gameplay.  

---

## Contributors  
- **[Your Name]**  
- **[Partner's Name] (if applicable)**  
- **Course:** CSC258 – Computer Organization  
- **Instructor:** Steve Engels & Mario Badr  

---

This project is a great way to practice **low-level programming** while building a fun, nostalgic game. Happy coding! 🎮
