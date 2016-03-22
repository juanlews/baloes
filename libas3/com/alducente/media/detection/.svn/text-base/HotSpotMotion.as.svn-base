package com.alducente.media.detection
{
	import com.alducente.events.MotionEvent;
	import com.alducente.video.WebcamVideo;
	
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	/**
	* Used to check specific rectangle areas of a video object for motion.
	**/
	public class HotSpotMotion extends SimpleMotion
	{
		
		//PRIVATE VARS
		private var __hotSpotVector:Vector.<HotSpot>;
		
		//PROTECTED VARS
		
		//PUBLIC VARS
		
		//CONSTRUCTOR
		/**
		* Constructor.
		* @param video          The <code>WebcamVideo</code> instance to use for motion detection.
		* @param threshold      A value from 0 to 1. 0 being the most sensitive to motion.
		* @param checkInterval  The amount of time to pass before checking for a new frame in milliseconds.
		**/
		public function HotSpotMotion(video:WebcamVideo, threshold:Number=0.1, checkInterval:Number=40)
		{
			super(video, threshold, checkInterval);
			__hotSpotVector = new Vector.<HotSpot>();
		}
		
		//PRIVATE FUNCTIONS
		
		//PROTECTED FUNCTIONS
		override protected function checkForMotion(motionBitmapData:BitmapData):void{
			var a:uint = __hotSpotVector.length;
			var sample:BitmapData;
			var pixelData:ByteArray;
			var hotspot:HotSpot;
			while(a--){
				hotspot = __hotSpotVector[a] as HotSpot;
				sample = new BitmapData(hotspot.width, hotspot.height, false);
				sample.lock();
				pixelData = motionBitmapData.getPixels(hotspot.rect);
				pixelData.position = 0;
				sample.setPixels(new Rectangle(0,0,hotspot.width, hotspot.height), pixelData);
				sample.unlock();
				hotspot.sample = sample;
				var rect:Rectangle = sample.getColorBoundsRect(0xffffffff, 0xffffffff);
				if(rect.x*rect.y >= minMotionArea){
					hotspot.dispatchEvent(new MotionEvent(MotionEvent.DETECTED));
				} else {
					hotspot.dispatchEvent(new MotionEvent(MotionEvent.UNDETECTED));
				}
			}
		}
		
		//PUBLIC FUNCTIONS
		/**
		* Adds a <code>HotSpot</code> object.
		* @param hotspot  An instance of the <code>HotSpot</code> object
		* @see com.alducente.media.detection.HotSpot
		**/
		public function addHotSpot(hotspot:HotSpot):void{
			if(__hotSpotVector.indexOf(hotspot) == -1){
				__hotSpotVector.push(hotspot);
			}
		}
		
		/**
		* Removes a <code>HotSpot</code> object.
		* @param hotspot  An instance of the <code>HotSpot</code> object
		* @return The removed <code>HotSpot</code> instance.
		* @see com.alducente.media.detection.HotSpot
		**/
		public function removeHotSpot(hotspot:HotSpot):HotSpot{
			var index:Number = __hotSpotVector.indexOf(hotspot);
			var hs:HotSpot;
			if(index != -1){
				hs = __hotSpotVector.splice(index, 1)[0];
			}
			return hs;
		}
		
		//GETTERS & SETTERS
	}
}