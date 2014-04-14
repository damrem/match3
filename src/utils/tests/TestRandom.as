package utils.tests {
	import utils.Random;

	import flash.display.Sprite;
	/**
	 * @author damrem
	 */
	public class TestRandom extends Sprite
	{
		function TestRandom()
		{
			var i:uint;
			
			for(i=0; i<10; i++)
			{
				//trace("Random.getInteger(10) = "+Random.getInteger(10));
				trace("Random.getListOfUniqueIntegers(5) = "+Random.getListOfUniqueIntegers(5));
			}
			 
			
			/*
			for(i=0; i<10; i++)
			{
				trace("Random.getListOfUniqueIntegers(10) = "+Random.getListOfUniqueIntegers(10));
			}
			 
			 */
			 
		}
	}
}
