import kotlin.io.path.Path
import kotlin.io.path.readLines

fun main() {
	val lines = Path("in.txt").readLines()
	val (times, distances) = lines.map{
		it.split(" ")
		  .map { str -> str.toIntOrNull() }
		  .filterNotNull()
	}

	fun getScore(time: Int, hold: Int) = hold * (time - hold)

	var answer = 1
	for (race in 0 until times.size) {
		val wins = (0..times[race])
					.map { getScore(times[race], it) }
					.filter { it > distances[race] }
		answer = answer * wins.size
	}

	println(answer)
}
