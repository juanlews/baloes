package com.alducente.media.detection
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	* The purpose of the <code>FrameDifference</code> object is to compare two instances of <code>BitmapData</code>.
	* @see flash.display.BitmapData
	**/
	public class FrameDifference extends EventDispatcher
	{
		
		//PRIVATE VARS
		private var __previousBitmapData:BitmapData;
		private var __container:Sprite;
		private var __previousBitmap:Bitmap;
		private var __currentBitmap:Bitmap;
		private var __snapshot:BitmapData;
		private var __threshold:Number;
		
		//PROTECTED VARS
		
		//PUBLIC VARS
		
		//CONSTRUCTOR
		/**
		* Constructor.
		* @param threshold  A value from 0 to 1. 0 being the most sensitive to motion.
		**/
		public function FrameDifference(threshold:Number=0.1)
		{
			super(null);
			__threshold = threshold;
			init();
		}
		
		//PRIVATE FUNCTIONS
		private function init():void{
			__container = new Sprite();
			__previousBitmap = new Bitmap();
			__currentBitmap = new Bitmap();
			__currentBitmap.blendMode = BlendMode.DIFFERENCE;
			
			__container.addChild(__previousBitmap);
			__container.addChild(__currentBitmap);
		}
		
		private function flatten():void{
			__snapshot = new BitmapData(__currentBitmap.width, __currentBitmap.height, false);
			__snapshot.draw(__container);
		}
		
		//PROTECTED FUNCTIONS
		
		//PUBLIC FUNCTIONS
		/**
		* Compares a <code>BitmapData</code> instance with the instance passed in the last time this method was called. Call this at an interval to check for any changes over time.
		* @param currentBitmapData  A "snapshot" of the video's current frame.
		* @return  A black and white instance of <code>BitmapData</code>. White pixels for areas where changes to the frame (motion) has been detected. Returns <code>null</code> if the currentBitmapData passed in is the very first snapshot.
		**/
		public function compare(currentBitmapData:BitmapData):BitmapData{
			if(__previousBitmapData){
				__previousBitmap.bitmapData = __previousBitmapData;
				__currentBitmap.bitmapData = currentBitmapData;
				flatten();
				__previousBitmapData.dispose();
				__previousBitmapData = currentBitmapData;
				__snapshot.threshold(__snapshot, new Rectangle(0,0,__previousBitmapData.width,__previousBitmapData.height), new Point(0,0), "<", __threshold*0xffffff, 0xff000000, 0xffffff);
				__snapshot.threshold(__snapshot, new Rectangle(0,0,__previousBitmapData.width,__previousBitmapData.height), new Point(0,0), "!=", 0xff000000, 0xffffffff, 0xffffff);
				return __snapshot;
			}
			
			//first call
			__previousBitmapData = currentBitmapData;
			return null;
		}
		
		/**
		* Destroys all data being used in this object.
		**/
		public function destroy():void{
			if(__snapshot) __snapshot.dispose();
			if(__currentBitmap.bitmapData) __currentBitmap.bitmapData.dispose();
			if(__previousBitmap.bitmapData) __previousBitmap.bitmapData.dispose();
			__previousBitmapData = null;
			__currentBitmap = null;
			__previousBitmap = null;
			while(__container.numChildren){
				__container.removeChildAt(0);
			}
			__container = null;
		}
		
		//GETTERS & SETTERS
	}
}