

function csv_parse_line(line, csv) {
	prev_pos=0
	pos=1
	num_fields=0
	quoted=0

	while (pos <= length(line)) {

		if (substr(line, pos, 1) == "\"") {
			quoted=1-quoted 
		}

		if (quoted == 1) {
			pos++
			continue
		}

		if (substr(line, pos, 1) == ",") {
			csv[num_fields++] = substr(line, prev_pos+1, pos-prev_pos-1)
			
			prev_pos=pos
		}

		pos++
	}

	if (pos - prev_pos > 1) {
		csv[num_fields++] = substr(line, prev_pos+1, pos-prev_pos-2)
	}

	return num_fields

}

function csv_parse(line, colnum) {
	if (colnum == -1) {
		return
	}
	num_fields = csv_parse_line(line, csv)
	print csv[colnum]
}

function csv_find_colnum(line, colname) {
	num_fields = csv_parse_line(line, csv)
	pos=0

	while (pos <= num_fields) {
		if (csv[pos] == colname) {
			print pos
			return
		}
		pos++
	}
	print -1
}

function csv_train_filter(line, train_size, colnum, stype) {
	if (colnum == -1) {
		return
	}

	num_fields = csv_parse_line(line, csv)
	if (csv[colnum] == stype) {
		count++
		if (count <= train_size) {
			print line
		}
	}
}

function csv_test_filter(line, train_size, colnum, stype) {
	if (colnum == -1) {
		return
	}

	num_fields = csv_parse_line(line, csv)
	if (csv[colnum] == stype) {
		count++
		if (count > train_size) {
			print line	
		}
	}
}

#awk -f csv-parser.awk -F '\n' -v colnum=$COL_POS -v train_size=$TS -v stype=$v --source 'BEGIN {count=0}{csv_train_filter($0, train_size, colnum, stype)}' $INPUT_TEMP_PATH >> $TRAIN_PATH
