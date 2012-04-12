function isNumber(str) {
	if (str.length == 0) {
		return false;
	}
	numdecs = 0;
	var i;
	for (i = 0; i < str.length; i++) {
		mychar = str.charAt(i);
		if ((mychar >= "0" && mychar <= "9") || mychar == "." || mychar == "$" || mychar == ",") {
			if (mychar == ".")
				numdecs++;
		}
		else 
			return false;
	}
	if (numdecs > 1) {
		return false;
	}
	return true;
}
