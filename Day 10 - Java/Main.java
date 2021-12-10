package aoc2021;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;

public class Main {

    public static final String fileName = "./input.txt";

    public static final Map<Character, Integer> InvalidCharacterPoints = Map.of(
            ')', 3,
            ']', 57,
            '}', 1197,
            '>', 25137
    );

    public static final Map<Character, Integer> ValidCharacterPoints = Map.of(
            ')', 1,
            ']', 2,
            '}', 3,
            '>', 4
    );

    public static final Map<Character, Character> ClosingCounterpart = Map.of(
            '(', ')',
            '[', ']',
            '{', '}',
            '<', '>'
    );

    public static boolean IsOpenCharacter(char c) {
        return c == '(' || c == '[' || c == '{' || c == '<';
    }

    /**
     * Checks if line is valid, returns 0 if so, returns points related to invalid character if it is
     */
    public static int GetInvalidLinePoints(String line) {
        Stack<Character> opens = new Stack<>();

        for(char c : line.toCharArray()) {
            if(IsOpenCharacter(c)){
                opens.push(c);
                continue;
            }

            if(opens.empty()){
                return InvalidCharacterPoints.get(c);
            }

            Character lastOpen = opens.pop();
            if(c != ClosingCounterpart.get(lastOpen)) {
                return InvalidCharacterPoints.get(c);
            }
        }

        return 0;
    }

    /**
     * Returns autocomplete tool score for a valid but incomplete line
     */
    public static long GetValidLineAutocompletePoints(String line) {
        Stack<Character> opens = new Stack<>();
        long totalScore = 0;

        for(char c : line.toCharArray()) {
            if(IsOpenCharacter(c)){
                opens.push(c);
            } else {
                opens.pop();
            }
        }

        while(!opens.empty()) {
            char c = opens.pop();
            Character closingCharacter = ClosingCounterpart.get(c);
            totalScore *= 5;
            totalScore += ValidCharacterPoints.get(closingCharacter);
        }

        return totalScore;
    }

    public static void main(String[] args) throws  IOException {
        List<String> fileLines = Files.readAllLines(Paths.get(fileName));

        int partOnePoints = 0;
        List<Long> partTwoValidLineScores = new ArrayList<>();
        for (String line : fileLines) {
            int invalidLinePoints = GetInvalidLinePoints(line);
            partOnePoints += invalidLinePoints;

            if(invalidLinePoints == 0) { // Line is valid, for part 2
                partTwoValidLineScores.add(GetValidLineAutocompletePoints(line));
            }
        }

        System.out.printf("Part 1: %d%n", partOnePoints);

        Collections.sort(partTwoValidLineScores);

        System.out.printf("Part 2: %d%n", partTwoValidLineScores.get(partTwoValidLineScores.size()/2));
    }
}
