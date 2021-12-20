import 'dart:io';

const String input_file = './input.txt';
const int enchantment_iterations_part_1 = 2;
const int enchantment_iterations_part_2 = 50;

// Returns list for mapping value to bit (first line), list of lists for input (frame), y dimension, x dimension
List<dynamic> readFile(String fileName) {
  var content = File(fileName).readAsStringSync();
  var lines = content.split(RegExp(r'\s'));
  var mappings = lines[0].split('').map((String c) =>
    (c == '.') ? 0 : 1
  ).toList();

  var yDim = lines.length - 2;
  var xDim = lines[2].length;

  var frame = List.generate(2*enchantment_iterations_part_2+yDim+2, (row) => List.generate(2*enchantment_iterations_part_2+xDim+2, (cell) => 0, growable: false), growable: false);

  for(var y = 0; y < yDim; y++) {
    for(var x = 0; x < xDim; x++) {
      frame[enchantment_iterations_part_2+y+1][enchantment_iterations_part_2+x+1] = (lines[2+y][x] == '.') ? 0 : 1;
    }
  }

  return [mappings, frame, yDim, xDim];
}


void printFrame(List<List<int>> frame) {
  for(var y = 0; y < frame.length; y++) {
    for(var x = 0; x < frame[y].length; x++) {
      stdout.write(frame[y][x] == 0 ? '.' : '#');
    }
    print("");
  }
}

void printMapping(List<int> mapping) {
  for(var i = 0; i < mapping.length; i++) {
    stdout.write(mapping[i] == 0 ? '.' : '#');
  }
  print("");
}

int GetOutOfBoundsValue(List<int> mapping, int iteration) {
  var v = 0;
  for(var i = 1; i < iteration; i++) {
    v ^= mapping[0];
  }
  return v;
}

int GetNewValue(List<List<int>> frame, List<int> mapping, int y, int x, int iteration) {
  int value = 0;
  int bit = 8;
  int maxY = frame.length - 1;
  int maxX = frame[0].length - 1;
  for(var dy = -1; dy <= 1; dy++) {
    for(var dx = -1; dx <= 1; dx++) {
      var actualValue = 0;
      if(x+dx < 0 || x+dx >= maxX || y+dy < 0 || y+dy >= maxY) {
        actualValue = GetOutOfBoundsValue(mapping, iteration);
      } else {
        actualValue = frame[y+dy][x+dx];
      }
      value |= (actualValue << bit);
      bit--;
    }
  }
  return mapping[value];
}

// Returns next frame
List<List<int>> applyIteration(List<List<int>> frame, List<int> mapping, int yDim, int xDim, int iteration, int maxIteration) {

  var newFrame = List.generate(frame.length, (row) => List.generate(frame[0].length, (cell) => 0, growable: false), growable: false);

  for(var y = 0; y < yDim + 2 * maxIteration + 2; y++) {

    for(var x = 0; x < xDim + 2 * maxIteration + 2; x++) {
      newFrame[y][x] = GetNewValue(frame, mapping, y, x, iteration);
    }

  }

  return newFrame;
}

int countLitPixels(List<List<int>> frame) {
  int sum = 0;
  for(var y = 0; y < frame.length; y++) {
    for(var x = 0; x < frame[y].length; x++) {
      sum += frame[y][x];
    }
  }
  return sum;
}

void main() {
	var fileInfo = readFile(input_file);
  List<int> mapping = fileInfo[0];
  List<List<int>> frame = fileInfo[1];
  int yDim = fileInfo[2];
  int xDim = fileInfo[3];

  //printMapping(mapping);
  //print("");
  //printFrame(frame);
  //print('Lit pixels: ${countLitPixels(frame)}');

  for(var i = 1; i <= enchantment_iterations_part_1; i++) {
    frame = applyIteration(frame, mapping, yDim, xDim, i, enchantment_iterations_part_2); // part 2 instead of 1 since it has to do with how big the matrix is, and we have only one matrix with size for part 2
    //print("");
    //printFrame(frame);
    //print('Lit pixels: ${countLitPixels(frame)}');
  }
  print('Part 1: ${countLitPixels(frame)}');

  for(var i = enchantment_iterations_part_1 + 1; i <= enchantment_iterations_part_2; i++) {
    frame = applyIteration(frame, mapping, yDim, xDim, i, enchantment_iterations_part_2);
    //print("");
    //printFrame(frame);
    //print('Lit pixels: ${countLitPixels(frame)}');
  }
  print('Part 2: ${countLitPixels(frame)}');
}
