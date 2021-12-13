# Input

INPUT_PATH = "./input.txt"

input_file = open(INPUT_PATH, "r")

numbers = [int(x) for x in input_file.readlines()]

input_file.close()

# Part 1

def increasing_list_elements(list):
    increasing = 0

    last_number = list[0]

    for n in list[1:]:
        if(n > last_number):
            increasing += 1
        last_number = n
        
    return increasing
        

increasing_elements = increasing_list_elements(numbers)
print(increasing_elements)

# Part 2

list_summed = []

for i in range(len(numbers) - 2):
    temp_sum = numbers[i] + numbers[i+1] + numbers[i+2]
    list_summed.append(temp_sum)
    
increasing_elements = increasing_list_elements(list_summed)
print(increasing_elements)