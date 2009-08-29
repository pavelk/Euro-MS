package com.eurorscg.utils.media
{
	import flash.events.Event;
	
	public class MediaEvent extends Event
	{
		public static const FINISHED_PLAYING:String = "finished_playing";
		public static const FULLY_LOADED    :String = "fully_loaded";
		public static const ERROR           :String = "error";
		public static const STARTED_PLAYING :String = "started_playing";
		
		protected var _text:String;
		
		public function get text():String { return _text; }
		
		public function MediaEvent(type:String, text:String = "")
		{
			super(type);
			_text = text;
		}
		
		public override function toString() : String
		{
			return "media.MediaEvent";
		}

	}
}