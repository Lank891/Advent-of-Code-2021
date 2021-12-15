use std::fs;
use regex::Regex;
use std::collections::HashSet;
use std::collections::HashMap;
use std::time::Instant;

const INPUT_FILE: &str = "./input.txt";

fn is_upper_case(s: &String) -> bool {
  return s.chars().all(|b| matches!(b, 'A'..='Z'));
}

fn dfs_part_one(vertex: &String, adj_list: &HashMap<String, HashSet<String>>, mut visited: HashSet<String>) -> i32 {
  let mut paths = 0;

  if vertex.eq(&"end".to_string()) {
    return 1;
  }

  if !is_upper_case(&vertex) {
    visited.insert(vertex.clone());
  }

  let neighbours = &adj_list[vertex];
  let unvisited_neighbours = neighbours.difference(&visited);

  for neighbour in unvisited_neighbours {
    paths += dfs_part_one(neighbour, adj_list, visited.clone());
  }

  return paths;
}

fn dfs_part_two(vertex: &String, adj_list: &HashMap<String, HashSet<String>>, mut visited: HashSet<String>, small_revisited: bool) -> i32 {
  let mut paths = 0;

  if vertex.eq(&"end".to_string()) {
    return 1;
  }

  if !is_upper_case(&vertex) {
    visited.insert(vertex.clone());
  }

  let neighbours = &adj_list[vertex];

  for neighbour in neighbours {
    if neighbour.eq(&"start".to_string()) {
      continue;
    }

    if !visited.contains(neighbour) {
      paths += dfs_part_two(neighbour, adj_list, visited.clone(), small_revisited);
    } else if !small_revisited {
      paths += dfs_part_two(neighbour, adj_list, visited.clone(), true);
    }
    
  }

  return paths;
}

fn main() {
  let mut start = Instant::now();

  let mut adj_list: HashMap<String, HashSet<String>> = HashMap::new();  

  let file_content = fs::read_to_string(INPUT_FILE).expect("File not found");
  let line_regex = Regex::new(r"(\w+)-(\w+)").unwrap();

  for capture in line_regex.captures_iter(&file_content) {
    let left = (&capture[1]).to_string();
    let left_copy = left.clone();
    let right = (&capture[2]).to_string();
    let right_copy = right.clone();

    (*adj_list.entry(left).or_insert(HashSet::new())).insert(right_copy);
    (*adj_list.entry(right).or_insert(HashSet::new())).insert(left_copy);
  }

  /*
  for (vertex, egde_list) in (&adj_list).into_iter() {
    println!("\"{:5}\": {:?}", &vertex, &egde_list);
  }
  */

  println!("Parsing: {} ms", start.elapsed().as_millis());

  start = Instant::now();
  let p1_result = dfs_part_one(&"start".to_string(), &adj_list, HashSet::new());
  println!("Part 1: {} in {} ms", p1_result, start.elapsed().as_millis());

  start = Instant::now();
  let p2_result = dfs_part_two(&"start".to_string(), &adj_list, HashSet::new(), false);
  println!("Part 2: {} in {} ms", p2_result, start.elapsed().as_millis());
}
