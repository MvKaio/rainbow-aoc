import std.stdio, std.array, std.algorithm, std.conv;

auto get_prev(long[] v) {
	if (v.length == 1) return v[0];

	bool allzero = true;
	for (int i = 1; i < v.length; i++) {
		allzero &= v[i] == 0;
	}
	if (allzero) return 0;

	long[] next = new long[v.length - 1];
	for (int i = 0; i + 1 < v.length; i++) {
		next[i] = v[i + 1] - v[i];
	}

	return v[0] - get_prev(next);
}

void main() {
	stdin
		.byLineCopy
		.array
		.map!(a => a
				.split
				.map!(b => to!long(b))
				.array
				)
		.map!(a => get_prev(a))
		.reduce!((a,b) => a + b)
		.writeln;
}
