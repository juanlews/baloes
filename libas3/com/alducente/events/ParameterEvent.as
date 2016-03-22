package com.alducente.events
{
	import flash.events.Event;
	
	public class ParameterEvent extends Event
	{
		
		//PRIVATE VARS
		private var __parameters:Object;
		
		//PROTECTED VARS
		
		//PUBLIC VARS
		
		//CONSTRUCTOR
		public function ParameterEvent(type:String, parameters:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.parameters = parameters;
		}
		
		//PRIVATE FUNCTIONS
		
		//PROTECTED FUNCTIONS
		
		//PUBLIC FUNCTIONS
		override public function clone():Event{
			return new ParameterEvent(type, this.parameters, bubbles, cancelable);
		}
		
		override public function toString():String{
			return formatToString("ParameterEvent", "parameters", "type", "bubbles", "cancelable");
		}
		
		//GETTERS & SETTERS
		public function get parameters():Object{
			return __parameters;
		}
		
		public function set parameters(value:Object):void{
			__parameters = value;
		}
	}
}