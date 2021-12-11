#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#define INPUT_FILE "./input.txt"
#define BOARD_SIZE 10
#define LAST_STEP 100

#define ARRAY_SIZE BOARD_SIZE + 2

void read_input(const char *file_name, int board[ARRAY_SIZE][ARRAY_SIZE]) {
    FILE *fp;

    int buffer_length = BOARD_SIZE + 3;
    char *line = malloc(buffer_length * sizeof(char));

    fp = fopen(file_name, "r");

    for(int line_number = 0; line_number < BOARD_SIZE; line_number++) {
        fgets(line, buffer_length, fp);
        line[10] = '\0';

        for(int char_number = 0; char_number < BOARD_SIZE; char_number++) {
            board[line_number + 1][char_number + 1] = line[char_number] - '0';
        }
    }

    fclose(fp);
    free(line);
}

void increment_board(int board[ARRAY_SIZE][ARRAY_SIZE]) {
    for(int i = 1; i <= BOARD_SIZE; i++) {
        for(int j = 1; j <= BOARD_SIZE; j++) {
            board[i][j] += 1;
        }
    }
}

bool are_tens_or_more_in_board(int board[ARRAY_SIZE][ARRAY_SIZE]) {
    for(int i = 1; i <= BOARD_SIZE; i++) {
        for(int j = 1; j <= BOARD_SIZE; j++) {
            if(board[i][j] >= 10) {
                return true;
            }
        }
    }
    return false;
}

void emit_light(int y, int x, int board[ARRAY_SIZE][ARRAY_SIZE]) {
    for(int i = -1; i <= 1; i++) {
        for(int j = -1; j <= 1; j++) {
            if(board[y+i][x+j] != 0)
                board[y+i][x+j] += 1;
            if(i == 0 && j == 0)
                board[y+i][x+j] = 0;
        }
    }
}

void emit_light_from_tens_and_above(int board[ARRAY_SIZE][ARRAY_SIZE]) {
    for(int i = 1; i <= BOARD_SIZE; i++) {
        for(int j = 1; j <= BOARD_SIZE; j++) {
            if(board[i][j] >= 10) {
                emit_light(i, j, board);
            }
        }
    }
}

int count_zeros(int board[ARRAY_SIZE][ARRAY_SIZE]) {
    int sum = 0;
    for(int i = 1; i <= BOARD_SIZE; i++) {
        for(int j = 1; j <= BOARD_SIZE; j++) {
            if(board[i][j] == 0) {
                sum++;
            }
        }
    }
    return sum;
}

int process_step(int board[ARRAY_SIZE][ARRAY_SIZE]) {
    increment_board(board);

    while(are_tens_or_more_in_board(board)) {
        emit_light_from_tens_and_above(board);
    }

    return count_zeros(board);
}

void print_board(int board[ARRAY_SIZE][ARRAY_SIZE]) {
    for(int i = 1; i <= BOARD_SIZE; i++) {
        for(int j = 1; j <= BOARD_SIZE; j++) {
            printf("%d ", board[i][j]);
        }
        printf("\n");
    }
    printf("\n");
}

void zero_board(int board[ARRAY_SIZE][ARRAY_SIZE]) {
    for(int i = 0; i < ARRAY_SIZE; i++) {
        for(int j = 0; j < ARRAY_SIZE; j++) {
            board[i][j] = 0;
        }
    }
}

int main() {
    int board[ARRAY_SIZE][ARRAY_SIZE];
    zero_board(board);

    int score = 0;

    read_input(INPUT_FILE, board);

    for(int i = 0; i < LAST_STEP; i++) {  
        score += process_step(board);
    }

    printf("Part 1: %d\n", score);

    int step = LAST_STEP + 1;
    while(process_step(board) != BOARD_SIZE * BOARD_SIZE) {
        step++;
    }

    printf("Part 2: %d\n", step);
}