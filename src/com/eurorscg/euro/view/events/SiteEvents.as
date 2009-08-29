package com.eurorscg.euro.view.events
{
	import flash.events.Event;
	
	public class SiteEvents extends Event
	{
		public static const GET_SECTION    :String = "getSection";
		public static const GET_SUBSECTION :String = "getSubsection";
		public static const FIRST_CLICK    :String = "firstClick";
		public static const PLAY_VIDEO     :String = "playVideo";
		public static const PLAY_PHOTO     :String = "playPhoto";
		
		public var command:String;
		public var value  :Object;
		
		public function SiteEvents( type:String, command:String = "" )
		{
			super( type );
			this.command = command;
		}

	}
}