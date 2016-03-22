package com.alducente.media.detection
{
	import com.alducente.events.MotionEvent;
	import com.alducente.video.WebcamVideo;
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	/**
	* Returns a list of smaller rectangular areas of motion within a frame.
	**/
	public class MultiMotion extends SimpleMotion
	{
		
		//PRIVATE VARS
		
		//PROTECTED VARS
		
		//PUBLIC VARS
		
		//CONTRUCTOR
		/**
		* Constructor.
		* @param video          The <code>WebcamVideo</code> instance to use for motion detection.
		* @param threshold      A value from 0 to 1. 0 being the most sensitive to motion.
		* @param checkInterval  The amount of time to pass before checking for a new frame in milliseconds.
		**/
		public function MultiMotion(video:WebcamVideo, threshold:Number=0.1, checkInterval:Number=40)
		{
			super(video, threshold, checkInterval);
		}
		
		//PRIVATE FUNCTIONS
		
		//PROTECTED FUNCTIONS
		override protected function checkForMotion(motionBitmapData:BitmapData):void{
			var a:uint;
			var b:uint;
			var areas:Vector.<Rectangle> = new Vector.<Rectangle>();
			motionBitmapData.lock();;
			for(a=0;a<video.height;a++){
				for(b=0;b<video.width;b++){
					if(motionBitmapData.getPixel(b, a) == 0xffffff){
						motionBitmapData.floodFill(b, a, 0xffff0000);
						var rect:Rectangle = motionBitmapData.getColorBoundsRect(0xffffffff, 0xffff0000);
						var motionArea:Number = rect.width*rect.height;
						if(motionArea > minMotionArea){
							areas.push(rect);
						}
						motionBitmapData.floodFill(b, a, 0);
					}
				}
			}
			motionBitmapData.unlock();
			if(areas.length){
				var parameters:Object = {
					rects: areas
				}
				dispatchEvent(new MotionEvent(MotionEvent.DETECTED, parameters));
			} else {
				dispatchEvent(new MotionEvent(MotionEvent.UNDETECTED));
			}
		}
		
		//PUBLIC FUNCTIONS
		
		//GETTERS & SETTERS
	}
}