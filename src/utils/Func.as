package utils {
	/**
	 * @author damrem
	 */
	public class Func 
	{
		static public function getLazyFunc(that:*, funcName:String):Function
		{
			return function(...args):void{trace("-UNMODIFIED- " + that + funcName + "(" + args);};
		}
	}
}
