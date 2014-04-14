package utils
{
	public class Random
	{
		static public function getInteger(min:int, max:int=NaN):int
		{
			if(min == max)	return min;
			if(isNaN(max))
			{
				max = min;
				min = 0;
			}
			if(min > max)
			{
				var temp:int = min;
				min = max;
				max = temp;
			}	
	    	return Math.round(Math.random() * (max - min) + min);
		}
		
		static public function getListOfUniqueIntegers(length:int, min:int=0, max:int=-1):Vector.<int>
		{
			var list:Vector.<int> = new <int>[];
			if(max < min)	max = length;
			if(length > (max - min + 1))
			{
				throw new Error("[fonction Random.getListOfUniqueIntegers] Le paramètre length="+length+" est supérieur à la taille de l'intervalle [min="+min+"; max="+max+"].");
				return list;
			}
			
			while(list.length < length)
			{
				var randomInt:int = getInteger(min, max);
				if(list.indexOf(randomInt) < 0)
				{
					list.push(randomInt);
				}
			}
			
			return list;
		}
	}
}
