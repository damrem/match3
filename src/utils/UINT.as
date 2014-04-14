package utils {
	/**
	 * @author damrem
	 */
	public class UINT 
	{
		static public function vector_getCopy(original:Vector.<uint>):Vector.<uint>
		{
			var copy:Vector.<uint> = new <uint>[];
			for(var i:uint=0; i<original.length; i++)
			{
				copy[i] = original[i];
			}
			return copy;
		}
	}
}
