package utils 
{
	/**
	 * @author damrem
	 */
	public function getSimpleToString(classToStringify:Class) : Function 
	{
		var string:String = classToStringify['toString']();
		string = string.replace('class ', '')+" ";
					
			var _toString:Function = function():String
			{
				return string;
			};
			return _toString;
	}
}
