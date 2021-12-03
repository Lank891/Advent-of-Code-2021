#include <fstream>
#include <vector>
#include <string>
#include <iostream>
#include <algorithm>

// Returns bit that was more common at posiotion in vector of numbers, returns -1 if they are equal
int most_common_bit_at_position(const std::vector<int> &numbers, const int position) {
    int zeros_and_ones[] {0, 0};
    for(const auto n : numbers)
            zeros_and_ones[(n >> position) & 1]++;
    if(zeros_and_ones[0] > zeros_and_ones[1])
            return 0;
    else if(zeros_and_ones[1] > zeros_and_ones[0])
            return 1;
    return -1;
}

// Removes from vector values where at given posiotion there is given bit
void remove_values_with_bit_at_position(std::vector<int> &numbers, const int position, const bool bit) {
    numbers.erase(std::remove_if(
        numbers.begin(),
        numbers.end(),
        [position, bit](int n) {return ((n >> position) & 1) == (int)bit;}
    ), numbers.end());
}

int main() {
    std::fstream file("./input.txt");
    int bits_in_number = 12;

    std::vector<int> numbers;

    std::string line;
    while(file >> line)
        numbers.emplace_back(std::stoi(line, nullptr, 2));

    // Part 1
    long long gamma_rate = 0;
    long long epsilon_rate = 0;

    for(int i = 0; i < bits_in_number; i++) {
        int most_common_bit = most_common_bit_at_position(numbers, i);
        
        switch(most_common_bit) {
            case 1:
                gamma_rate += 1 << i;
                break;
            case 0:
                epsilon_rate += 1 << i;
                break;
            default:
                std::cout << "The same number of zeros and ones for bit " << i << std::endl;
                break;
        }
    }

    std::cout << "Gamma: " << gamma_rate << ";\nEpsilon: " << epsilon_rate << ";\nPart 1 answer : " << gamma_rate * epsilon_rate <<";" << std::endl;

    // Part 2
    std::vector<int> filtered_oxygen_generator_rating(numbers);
    std::vector<int> filtered_co2_scrubber_rating(numbers);

    for(int i = bits_in_number - 1; i >= 0; i--) {
        int most_common_bit_oxygen = most_common_bit_at_position(filtered_oxygen_generator_rating, i);
        int most_common_bit_co2 = most_common_bit_at_position(filtered_co2_scrubber_rating, i);

        if(filtered_oxygen_generator_rating.size() > 1) {
            switch(most_common_bit_oxygen) {
                case 1:
                    remove_values_with_bit_at_position(filtered_oxygen_generator_rating, i, 0);
                    break;
                case 0:
                    remove_values_with_bit_at_position(filtered_oxygen_generator_rating, i, 1);
                    break;
                default:
                    remove_values_with_bit_at_position(filtered_oxygen_generator_rating, i, 0);
                    break;
            }
        }
        
        if(filtered_co2_scrubber_rating.size() > 1) {
            switch(most_common_bit_co2) {
                case 1:
                    remove_values_with_bit_at_position(filtered_co2_scrubber_rating, i, 1);
                    break;
                case 0:
                    remove_values_with_bit_at_position(filtered_co2_scrubber_rating, i, 0);
                    break;
                default:
                    remove_values_with_bit_at_position(filtered_co2_scrubber_rating, i, 1);
                    break;
            }
        }
        
    }

    if(filtered_oxygen_generator_rating.size() != 1) {
        std::cout << "No value or multiple values for oxygen generator rating found" << std::endl;
        std::cout << "Size: " << filtered_oxygen_generator_rating.size() << std::endl;
        for(auto n : filtered_oxygen_generator_rating)
            std::cout << n << std::endl;
        return 1;
    }
    if(filtered_co2_scrubber_rating.size() != 1) {
        std::cout << "No value or multiple values for co2 scrubber rating found" << std::endl;
        std::cout << "Size: " << filtered_co2_scrubber_rating.size() << std::endl;
        for(auto n : filtered_co2_scrubber_rating)
            std::cout << n << std::endl;
        return 1;
    }

    std::cout << "Oxygen: " << filtered_oxygen_generator_rating.at(0) << 
        ";\nCO2: " << filtered_co2_scrubber_rating.at(0) << ";\nPart 2 answer : " << 
        filtered_oxygen_generator_rating.at(0) * filtered_co2_scrubber_rating.at(0) <<";" << std::endl;
        
}