<?php

# Reading the input grid
$input = fopen("in.txt", "r") or die("Error opening file!");
while (!feof($input)) {
	$line = fgets($input);
	if ($line) {
		$grid[] = trim($line);
	}
}
fclose($input);

# Finding the starting position
for ($i = 0; $i < count($grid); $i++) {
	for ($j = 0; $j < strlen($grid[$i]); $j++) {
		if ($grid[$i][$j] == 'S') {
			$start = [$i, $j];
		}
	}
}

$pipes = ['|', '-', 'L', 'J', '7', 'F'];

# Directions: up, down, left, right
$dx = [-1, 1, 0, 0];
$dy = [0, 0, -1, 1];

# Directions for each pipe
$forks = [
	'|' => [0, 1],
	'-' => [2, 3],
	'L' => [0, 3],
	'J' => [0, 2],
	'7' => [1, 2],
	'F' => [1, 3],
];

# Testing each possible pipe
foreach ($pipes as $p) {
	$grid[$start[0]][$start[1]] = $p;
	$distance = [];

	$inloop = array_fill(0, count($grid), array_fill(0, count($grid), 0));

	# state: [i, j, direction]
	$i = $start[0];
	$j = $start[1];
	$dir = $forks[$p][0];
	do {
		$distance["$i,$j,$dir"] = count($distance);

		$i += $dx[$dir];
		$j += $dy[$dir];
		$dir = $dir^1;

		$inloop[$i][$j] = 1;

		if ($i < 0 or $i >= count($grid)) break;
		if ($j < 0 or $j >= count($grid)) break;
		if ($grid[$i][$j] == '.') break;

		if ($forks[$grid[$i][$j]][0] == $dir) {
			$dir = $forks[$grid[$i][$j]][1];
		} elseif ($forks[$grid[$i][$j]][1] == $dir) {
			$dir = $forks[$grid[$i][$j]][0];
		} else break;
	} while (!array_key_exists("$i,$j,$dir", $distance));

	if ($dir == $forks[$p][0] and $start == [$i, $j]) {
		$answer = 0;
		for ($i = 0; $i < count($grid); $i++) {
			for ($j = 0; $j < count($grid); $j++) {
				$inside = false;
				if (!$inloop[$i][$j]) {
					for ($i1 = $i-1; $i1 >= 0; $i1--) if ($inloop[$i1][$j]) {
						if ($grid[$i1][$j] == '-') {
							$inside = !$inside;
						} else if ($grid[$i1][$j] == 'J' or $grid[$i1][$j] == 'L') {
							$buffer = $grid[$i1][$j];
						} else if ($grid[$i1][$j] != '|') {
							if ($buffer == 'J' and $grid[$i1][$j] == 'F') $inside = !$inside;
							if ($buffer == 'L' and $grid[$i1][$j] == '7') $inside = !$inside;
						}
					}
				}
				if ($inside) $answer++;
				if ($inside) {
					echo "I";
				} else if ($inloop[$i][$j] == 1) {
					echo " ";#$grid[$i][$j];
				} else {
					echo "O";
				}
			}
			echo "\n";
		}
		echo "$answer\n";
	}
}
?>
