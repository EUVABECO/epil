function csvToNuva(csvString) {
	let result = {}
    const rows = csvString
        .split("\r\n");
    for (let i = 1; i < rows.length; i++) {
        const values = rows[i]
            .split(";");
		if (values.length != 3) continue
        result[values[0]] = values[1];
    }
	return result
}
