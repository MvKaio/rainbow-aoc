// My approach (brute force), is quite slow and uses a lot
// of memory. It is easy to write a ternary search to optimize
// it, but there is no need here.
//
// To increase java's heap size, I've used the flag -Xmx2g

import kotlin.io.path.Path
import kotlin.io.path.readLines

fun main() {
	val lines = Path("in.txt").readLines()
	val (time, distance) = lines.map{
		it.split(" ")
		  .map { str -> str.toIntOrNull() }
		  .filterNotNull()
		  .joinToString("")
		  .toLong()
	}

	fun getScore(time: Long, hold: Long) = hold * (time - hold)

	val wins = (0..time.toInt())
				.map { getScore(time, it.toLong()) }
				.filter { it > distance }
	println(wins.size)
}
