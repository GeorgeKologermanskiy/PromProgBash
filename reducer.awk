function reduce(word, count) {
	if (word == last_str) {
		cnt += count
		return
	}

	print last_str"\t"cnt
	last_str = word
	cnt = count
}
