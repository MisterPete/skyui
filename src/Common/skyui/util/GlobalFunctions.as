﻿class skyui.util.GlobalFunctions
{
  /* PUBLIC FUNCTIONS */
	
	public static function extract(a_str: String, a_startChar: String, a_endChar: String): String
	{
		return a_str.slice(a_str.indexOf(a_startChar) + 1,a_str.lastIndexOf(a_endChar));
	}

	// Remove comments and leading/trailing white space
	static function clean(a_str: String): String
	{
		if (a_str.indexOf(";") > 0)
			a_str = a_str.slice(0,a_str.indexOf(";"));

		var i = 0;
		while (a_str.charAt(i) == " " || a_str.charAt(i) == "\t")
			i++;

		var j = a_str.length - 1;
		while (a_str.charAt(j) == " " || a_str.charAt(j) == "\t")
			j--;

		return a_str.slice(i,j + 1);
	}

	private static var _arrayExtended = false;

	public static function addArrayFunctions(): Void
	{
		if (_arrayExtended)
			return;
			
		_arrayExtended = true;
		
		Array.prototype.indexOf = function (a_element): Number
		{
			for (var i=0; i<this.length; i++)
				if (this[i] == a_element)
					return i;
					
			return undefined;
		};
		
		Array.prototype.equals = function (a: Array): Boolean 
		{
			if (a == undefined)
				return false;
			
	    	if (this.length != a.length)
	        	return false;
			
	    	for (var i = 0; i < a.length; i++)
	        	if (a[i] !== this[i])
					return false;
					
	    	return true;
    	};
		
		Array.prototype.contains = function (a_element): Boolean 
		{
			for (var i=0; i<this.length; i++)
				if (this[i] == a_element)
					return true;
					
	    	return false;
    	};
	}

	// Maps Unicode inputted character code to it's CP819/CP1251 character code
	public static function mapUnicodeChar(a_charCode: Number): Number
	{
		//NUMERO SIGN
		if (a_charCode == 0x2116)
			return 0xB9;
			
		else if (0x0401 <= a_charCode && a_charCode <= 0x0491) {
			switch (a_charCode) {
				//CYRILLIC CAPITAL LETTER IO
				case 0x0401 :
					return 0xA8;
				//CYRILLIC CAPITAL LETTER UKRAINIAN IE
				case 0x0404 :
					return 0xAA;
				//CYRILLIC CAPITAL LETTER DZE
				case 0x0405 :
					return 0xBD;
				//CYRILLIC CAPITAL LETTER BYELORUSSIAN-UKRAINIAN I
				case 0x0406 :
					return 0xB2;
				//CYRILLIC CAPITAL LETTER YI
				case 0x0407 :
					return 0xAF;
				//CYRILLIC CAPITAL LETTER JE
				case 0x0408 :
					return 0xA3;
				//CYRILLIC CAPITAL LETTER SHORT U
				case 0x040E :
					return 0xA1;
				//CYRILLIC SMALL LETTER IO
				case 0x0451 :
					return 0xB8;
				//CYRILLIC SMALL LETTER UKRAINIAN IE
				case 0x0454 :
					return 0xBA;
				//CYRILLIC SMALL LETTER DZE
				case 0x0455 :
					return 0xBE;
				//CYRILLIC SMALL LETTER BYELORUSSIAN-UKRAINIAN I
				case 0x0456 :
					return 0xB3;
				//CYRILLIC SMALL LETTER YI
				case 0x0457 :
					return 0xBF;
				//CYRILLIC SMALL LETTER JE
				case 0x0458 :
					return 0xBC;
				//CYRILLIC SMALL LETTER SHORT U
				case 0x045E :
					return 0xA2;
				//CYRILLIC CAPITAL LETTER GHE WITH UPTURN
				case 0x0490 :
					return 0xA5;
				//CYRILLIC SMALL LETTER GHE WITH UPTURN
				case 0x0491 :
					return 0xA4;
				//Standard Cyrillic characters
				default :
					if (0x040F <= a_charCode && a_charCode <= 0x044F)
						return a_charCode - 0x0350;
			}
		}
		return a_charCode;
	}
}