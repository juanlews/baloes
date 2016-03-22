package com.alducente.media.detection
{
	import com.alducente.events.MotionEvent;
	import com.alducente.video.WebcamVideo;
	
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	/**
	* The most basic form of motion detection. Returns one rectangle area per frame that contains all motion detected.
	**/
	public class SimpleMotion extends EventDispatcher
	{
		
		//PRIVATE VARS
		private const DEFAULT_MIN_MOTION_AREA:int = 10;
		
		private var __frameDifference:FrameDifference;
		private var __video:WebcamVideo;
		private var __running:Boolean;
		private var __checkTimer:Timer;
		private var __minMotionArea:int;
		
		//PROTECTED VARS
		
		//CONSTRUCTOR
		/**
		* Constructor.
		* @param video          The <code>WebcamVideo</code> instance to use for motion detection.
		* @param threshold      A value from 0 to 1. 0 being the most sensitive to motion.
		* @param checkInterval  The amount of time to pass before checking for a new frame in milliseconds.
		**/
		public function SimpleMotion(video:WebcamVideo, threshold:Number = 0.1, checkInterval:Number = 40)
		{
			super(null);
			__video = video;
			__frameDifference = new FrameDifference(threshold);
			__checkTimer = new Timer(checkInterval);
			__checkTimer.addEventListener(TimerEvent.TIMER, update, false, 0, true);
			minMotionArea = DEFAULT_MIN_MOTION_AREA;
		}
		
		//PRIVATE FUNCTIONS
		private function update(evt:TimerEvent):void{
			var difference:BitmapData = __frameDifference.compare(__video.getBitmapData());
			if(difference) checkForMotion(difference);
		}
		
		//PROTECTED FUNCTIONS
		protected function checkForMotion(motionBitmapData:BitmapData):void{
			var rect:Rectangle = motionBitmapData.getColorBoundsRect(0xffffffff, 0xffffffff);
			var motionArea:Number = rect.width*rect.height;
			if(motionArea > minMotionArea){
				var parameters:Object = {
					rect: rect
				}
				dispatchEvent(new MotionEvent(MotionEvent.DETECTED, parameters));
			} else {
				dispatchEvent(new MotionEvent(MotionEvent.UNDETECTED));
			}
		}
		
		//PUBLIC FUNCTIONS
		/**
		* Starts the detector.
		**/
		public function start():void{
			if(!__running){
				__checkTimer.start();
				__running = true;
			}
		}
		
		/**
		* Stops the detector.
		**/
		public function stop():void{
			if(__running){
				__checkTimer.stop();
				__running = false;
			}
		}
		
		//GETTERS & SETTERS
		/**
		* <code>true</code> if the detector is currently running.
		**/
		public function get running():Boolean{
			return __running;
		}
		
		/**
		* The smallest area of motion needed to consider it valid.
		**/
		public function get minMotionArea():int{
			return __minMotionArea;
		}
		
		public function set minMotionArea(value:int):void{
			__minMotionArea = value;
		}
		
		/**
		* The <code>WebcamVideo</code> instance being used by this detector.
		**/
		public function get video():WebcamVideo{
			return __video;
		}
	}
}