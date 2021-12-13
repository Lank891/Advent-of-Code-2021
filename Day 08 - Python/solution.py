INPUT_PATH = "./input.txt"

input_file = open(INPUT_PATH, "r")
lines = input_file.readlines()
input_file.close()


divided_input = [[[set(x) for x in x.split()] for x in line.split(" | ")] for line in lines]

# Part 1
print("Part 1: ", sum([len([x for x in entry[1] if len(x) in [2, 3, 4, 7]]) for entry in divided_input]))

# Cursed part 1 1-liner assuming INPUT_PATH is defined with path to the input file
#print("Part 1: ", sum([len([x for x in entry[1] if len(x) in [2, 3, 4, 7]]) for entry in [[[set(x) for x in x.split()] for x in line.split(" | ")] for line in open(INPUT_PATH, "r").readlines()]]))

# Part 2
total_sum = 0
for elem in divided_input:
    left = elem[0]
    right = elem[1]
    numbers = {
        "0": None,
        "1": [x for x in left if len(x) == 2][0],
        "2": None,
        "3": None,
        "4": [x for x in left if len(x) == 4][0],
        "5": None,
        "6": None,
        "7": [x for x in left if len(x) == 3][0],
        "8": [x for x in left if len(x) == 7][0],
        "9": None
    }
    segments = {
        "a": None,
        "b": None,
        "c": None,
        "d": None,
        "e": None,
        "f": None,
        "g": None
    }
    
    (segments["a"],) = numbers["7"].difference(numbers["1"])
    
    numbers["6"] = [x for x in left if len(x) == 6 and len(x.intersection(numbers["1"])) == 1][0]
    zero_and_nine = [x for x in left if len(x) == 6 and len(x.difference(numbers["6"])) != 0]
    numbers["9"] = [x for x in zero_and_nine if len(x.intersection(numbers["4"])) == 4][0]
    numbers["0"] = [x for x in zero_and_nine if len(x.intersection(numbers["4"])) == 3][0]
    
    (segments["f"],) = numbers["6"].intersection(numbers["1"])
    (segments["c"],) = numbers["1"].difference(set(segments["f"]))
    
    (segments["e"],) = numbers["6"].difference(numbers["9"])
    (segments["d"],) = numbers["8"].difference(numbers["0"])
    (segments["b"],) = numbers["4"].difference(set([x for x in segments.values() if x is not None]))
    (segments["g"],) = numbers["8"].difference(set([x for x in segments.values() if x is not None]))
    
    numbers["2"] = set([segments["a"], segments["c"], segments["d"], segments["e"], segments["g"]])
    numbers["5"] = set([segments["a"], segments["b"], segments["d"], segments["f"], segments["g"]])
    numbers["3"] = set([segments["a"], segments["c"], segments["d"], segments["f"], segments["g"]])
    
    value = 0
    for digit_set in right:
        value *= 10
        digit = int([k for k, v in numbers.items() if v == digit_set][0])
        value += digit
    
    total_sum += value

print("Part 2: ", total_sum)