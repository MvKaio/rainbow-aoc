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

	# state: [i, j, direction]
	$i = $start[0];
	$j = $start[1];
	$dir = $forks[$p][0];
	do {
		$distance["$i,$j,$dir"] = count($distance);

		$i += $dx[$dir];
		$j += $dy[$dir];
		$dir = $dir^1;

		if ($i < 0 or $i >= count($grid)) break;
		if ($j < 0 or $j >= count($grid)) break;
		if ($grid[$i][$j] == '.') break;

		if ($forks[$grid[$i][$j]][0] == $dir) {
			$dir = $forks[$grid[$i][$j]][1];
		} elseif ($forks[$grid[$i][$j]][1] == $dir) {
			$dir = $forks[$grid[$i][$j]][0];
		} else break;
	} while (!array_key_exists("$i,$j,$dir", $distance));

	if ($start == [$i, $j]) {
		var_dump("$p");
		var_dump((max($distance) + 1) / 2);
		break;
	}
}

echo "\n";
?>
