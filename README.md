# Memory Management in x86 Assembly

This repository contains two x86 Assembly (AT&T syntax) programs that simulate basic memory management functionalities. These programs implement algorithms for allocating, retrieving, deleting, and defragmenting memory blocks within a simulated 16MB memory space.

## Implementations

The repository includes two distinct implementations, each demonstrating a different approach to modeling and managing the memory space.

### 1. Linear Memory Model (`151_Filote_AlexandruIonut_0.s`)

This program simulates memory as a large, one-dimensional array. Files are allocated as contiguous blocks within this linear space.

*   **Memory Representation**: A single 16MB block of memory (`.space 16777216`).
*   **Allocation**: Searches for a contiguous sequence of free cells (`0`) large enough to accommodate the requested file size.
*   **Location Tracking**: The position of a file is represented by its start and end indices in the array. Example output for adding file `101`: `101: (0, 3)`, meaning it occupies indices 0 through 3.

### 2. 2D Grid Memory Model (`151_Filote_AlexandruIonut_1.s`)

This program models the 16MB of memory as a two-dimensional grid. Allocation involves finding a suitable contiguous block within this grid structure.

*   **Memory Representation**: A 2D grid, conceptually treated as rows and columns. The code uses calculations with a stride of `1024` to navigate this structure.
*   **Allocation**: Searches for a free rectangular area that can fit the requested file size.
*   **Location Tracking**: The position of a file is represented by two pairs of coordinates: the top-left and bottom-right corners of the allocated block. Example output: `101: ((0, 0), (0, 3))`.

## Functionality

Both programs accept a series of commands via standard input. The first input is the total number of commands to be processed. Each subsequent command is an integer from 1 to 4, followed by its specific arguments.

*   **`1` (add):** Allocates memory for one or more files.
    *   **Input**: The number of files to add, followed by pairs of `file_descriptor` and `file_size` for each file.
    *   **Action**: Finds a contiguous block of free memory for the file. The size is rounded up to the nearest multiple of 8 bytes. If successful, it stores the file descriptor in the allocated memory cells and prints the file's location. If no suitable space is found, it reports failure.

*   **`2` (get):** Retrieves the location of a specific file.
    *   **Input**: The `file_descriptor`.
    *   **Action**: Searches the memory for the given file descriptor and prints its location (start/end indices for the 1D model, or coordinates for the 2D model). If not found, it reports `(0, 0)`.

*   **`3` (delete):** Frees the memory occupied by a file.
    *   **Input**: The `file_descriptor`.
    *   **Action**: Finds all memory cells corresponding to the file descriptor and resets their value to `0`, effectively marking them as free. After deletion, it prints the status of the remaining allocated files.

*   **`4` (defragmentation):** Consolidates free memory by moving allocated blocks.
    *   **Action**: Scans the memory and moves all allocated files to the beginning of the memory space, eliminating fragmentation between them. After the process, it prints the new locations of all allocated files.

## Building and Running

These programs are written for a 32-bit architecture and can be compiled and run on a Linux system using `gcc`.

### Compilation

To compile each file, use the `-m32` flag.

```sh
# Compile the linear memory model
gcc -m32 -o memory_1d 151_Filote_AlexandruIonut_0.s

# Compile the 2D grid memory model
gcc -m32 -o memory_2d 151_Filote_AlexandruIonut_1.s
```

### Execution

Run the compiled executable and provide input through standard input.

```sh
./memory_1d < input.txt
```

#### Example Input (`input.txt`):

```
4      # Total number of commands
1      # Command 1: Add
2      # Number of files to add
101 10 # File 1: descriptor=101, size=10
102 20 # File 2: descriptor=102, size=20
2      # Command 2: Get
101    # Descriptor of file to get
3      # Command 3: Delete
102    # Descriptor of file to delete
4      # Command 4: Defragmentation