package utils 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author damrem
	 */
	public class ToString 
	{
		
		public static function dictionary(_dictionary:Dictionary):String
		{
			var string:String = "<dictionary>";
			for(var index:Object in _dictionary) 
			{
				string += '"'+index + '":' + _dictionary[index]+'; ';
			}
			string = string.substr(0, -2) + "</dictionary>";
			return string;
		}
		
	}

}