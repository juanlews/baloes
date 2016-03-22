package com.alducente.video
{
	
	import flash.media.Video;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	/**
	* A video object with some added functionality.
	* @see flash.media.Video
	**/
	public class WebcamVideo extends Video
	{
		//PRIVATE VARS
		private const DEFAULT_X:Number = 0;
		private const DEFAULT_SCALE_X:Number = 1;
		
		private var __flipped:Boolean;
		private var __realX:Number;
		private var __realScaleX:Number;
		
		//PROTECTED VARS
		
		//PUBLIC VARS
		
		//CONSTRUCTOR
		/**
		* Constructor.
		* @param width    The width of the video object in pixels
		* @param height   The height of the video object in pixels
		* @param flipped  Whether the video object "mirrors" what's in front of the camera.
		**/
		public function WebcamVideo(width:int=320, height:int=240, flipped:Boolean=true)
		{
			super(width, height);
			__realX = DEFAULT_X;
			__realScaleX = DEFAULT_SCALE_X;
			this.flipped = flipped;
		}
		
		//PRIVATE FUNCTIONS
		
		//PROTECTED FUNCTIONS
		
		//PUBLIC FUNCTIONS
		/**
		* Returns a snapshot of the video's current frame.
		**/
		public function getBitmapData():BitmapData{
			var bmd:BitmapData = new BitmapData(this.width, this.height);
			var matrix:Matrix;
			if(flipped){
				matrix = new Matrix();
				matrix.scale(-1, 1);
				matrix.tx = this.width;
			}
			bmd.draw(this, matrix);
			
			return bmd;
		}
		
		//GETTERS & SETTERS
		override public function get x():Number{
			if(flipped){
				return __realX;
			}
			return super.x;
		}
		
		override public function set x(value:Number):void{
			if(flipped){
				super.x = value + ((scaleX > 0)?(width):-width);
				__realX = value;
			} else {
				super.x = value;
				__realX = value;
			}
		}
		
		override public function get scaleX():Number{
			if(flipped){
				return __realScaleX;
			}
			return super.scaleX;
		}
		
		override public function set scaleX(value:Number):void{
			if(flipped){
				super.scaleX = -value;
				__realScaleX = value;
				x = __realX;
			} else {
				super.scaleX = value;
				x = __realX;
			}
		}
		
		public function get flipped():Boolean{
			return __flipped;
		}
		
		public function set flipped(value:Boolean):void{
			__flipped = value;
			scaleX = (value)?super.scaleX:__realScaleX;
		}
	}
}