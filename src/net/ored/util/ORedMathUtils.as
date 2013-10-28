package net.ored.util
{
	public class ORedMathUtils
	{
		/**
		 * This function calculates the scale of 1 set of dimensions to another 
		 * @param $w1	- smaller rect width
		 * @param $h1	- smaller rect height
		 * @param $w2	- larger rect width
		 * @param $h2	- larger rect height
		 * 
		 * @return 		- the larger of the 2 scales 
		 * 
		 */		
		public static function calcScaleFromDimensions($w1,$h1,$w2,$h2):Number{
			var s1,s2:Number;
			s1 = $w1/$w2;
			s2 = $h1/$h2;
			
		}
	}
}