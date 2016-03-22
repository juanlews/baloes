package com.alducente.media {
	
	import flash.media.Camera;
	
	/**
	* A helper class to retrieve the user's camera.
	**/
	public class Webcam{
		
		//PRIVATE VARS
		
		//PROTECTED VARS
		
		//PUBLIC VARS
		public static const MUTED:String = "Camera.Muted";
		public static const UNMUTED:String = "Camera.Unmuted";
		
		//CONSTRUCTOR
		
		//PRIVATE FUNCTIONS
		
		//PROTECTED FUNCTIONS
		
		//PUBLIC FUNCTIONS
		/**
		* Checks for the default camera, returns <code>null</code> if none is detected.
		* @param name       Specifies which camera to get, as determined from the array returned by the names property. For most applications, get the default camera by omitting this parameter. To specify a value for this parameter, use the string representation of the zero-based index position within the Camera.names array. For example, to specify the third camera in the array, use Camera.getCamera("2").
		* @param width      The current capture width, in pixels.
		* @param height     The current capture height, in pixels.
		* @param fps        The requested rate at which the camera should capture data, in frames per second. The default value is 15.
		* @param favorArea  Specifies whether to manipulate the width, height, and frame rate if the camera does not have a native mode that meets the specified requirements. The default value is true, which means that maintaining capture size is favored; using this parameter selects the mode that most closely matches width and height values, even if doing so adversely affects performance by reducing the frame rate. To maximize frame rate at the expense of camera height and width, pass false for the favorArea parameter.
		**/
		public static function getCamera(name:String=null, width:int=160, height:int=120, fps:Number=15, favorArea:Boolean=true):Camera{
			var camera:Camera;
			if(!name){
				var cameraNames:Array = Camera.names;
				if(cameraNames.indexOf("USB Video Class Video") != -1){
					camera = Camera.getCamera(String(cameraNames.indexOf("USB Video Class Video")));
				} else {
					camera = Camera.getCamera();
				}
			} else {
				camera = Camera.getCamera(name);
			}
			if(camera){
				camera.setMode(width, height, fps, favorArea);
			}
			
			return camera;
		}
		
		
		//GETTERS & SETTERS
		
	}
	
}