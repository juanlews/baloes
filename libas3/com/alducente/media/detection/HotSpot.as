package com.alducente.media.detection
{
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	
	/**
	* Used along with <code>HotSpotMotion</code> object. This specifies a rectangular area within the video to detect motion.
	* @see com.alducente.media.detection.HotSpotMotion
	* @see flash.geom.Rectangle
	**/
	public class HotSpot extends EventDispatcher
	{
		
		//PRIVATE VARS
		private var __sample:BitmapData;
		private var __rect:Rectangle;
		
		//PROTECTED VARS
		
		//PUBLIC VARS
		
		//CONSTRUCTOR
		/**
		* Constructor.
		* @param x       The x position of the hot spot.
		* @param y       The y position of the hot spot.
		* @param width   The width of the hot spot in pixels.
		* @param height  The height of the hot spot in pixels.
		**/
		public function HotSpot(x:Number=0, y:Number=0, width:Number=0, height:Number=0)
		{
			super(null);
			__rect = new Rectangle(x, y, width, height);
		}
		
		//PRIVATE FUNCTIONS
		
		//PROTECTED FUNCTIONS
		
		//PUBLIC FUNCTIONS
		
		//GETTERS & SETTERS
		/**
		* A <code>BitmapData</code> instance that consists of black and white pixels representing motion.
		* @see com.alducente.media.detection.FrameDifference
		**/
		public function get sample():BitmapData{
			return __sample;
		}
		
		/**
		* @private
		**/
		public function set sample(value:BitmapData):void{
			__sample = value;
		}
		
		/**
		* The x position of the hot spot.
		**/
		public function get x():Number{
			return __rect.x;
		}
		
		public function set x(value:Number):void{
			__rect.x = value;
		}
		
		/**
		* The y position of the hot spot.
		**/
		public function get y():Number{
			return __rect.y;
		}
		
		public function set y(value:Number):void{
			__rect.y = value;
		}
		
		/**
		* The width of the hot spot in pixels.
		**/
		public function get width():Number{
			return __rect.width;
		}
		
		public function set width(value:Number):void{
			__rect.width = value;
		}
		
		/**
		* The height of the hot spot in pixels.
		**/
		public function get height():Number{
			return __rect.height;
		}
		
		public function set height(value:Number):void{
			__rect.height = value;
		}
		
		/**
		* A rectangle object containing the same values as the hot spot.
		**/
		public function get rect():Rectangle{
			return __rect;
		}
	}
}