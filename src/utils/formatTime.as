package utils
{
	public function formatTime(sec:int):String
	{
		var pureSec:int = sec % 60;
		
		var secString:String = "" + pureSec;
		if (secString.length < 2)	secString = "0" + secString;
		
		var min:int = sec / 60;
		
		//var minString:String = "" + (sec - pureSec); 
		
		return min + ":" + secString;
	}
}