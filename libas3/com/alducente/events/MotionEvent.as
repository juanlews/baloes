package com.alducente.events
{
	
	import flash.events.Event;
	
	final public class MotionEvent extends ParameterEvent
	{
		
		//PRIVATE VARS
		
		//PROTECTED VARS
		
		//PUBLIC VARS
		/**
		* Dispatched when enough motion has been detected based on the threshold.
		**/
		public static const DETECTED:String = "motion_detected_event";
		
		/**
		* Dispatched when there isn't enough motion detected based on threshold.
		**/
		public static const UNDETECTED:String = "motion_undetect_event";
		
		//CONSTRUCTOR
		public function MotionEvent(type:String, parameters:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, parameters, bubbles, cancelable);
		}
		
		//PRIVATE FUNCTIONS
		
		//PROTECTED FUNCTIONS
		
		//PUBLIC FUNCTIONS
		override public function clone():Event{
			return new MotionEvent(type, this.parameters, bubbles, cancelable);
		}
		
		override public function toString():String{
			return formatToString("MotionEvent", "parameters", "type", "bubbles", "cancelable");
		}
		
		//GETTERS & SETTERS
	}
}