package com.eurorscg.euro.view.components
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.events.MouseEvent;
	
	import com.eurorscg.euro.view.events.SiteEvents;
	
	import caurina.transitions.*;
 	import caurina.transitions.properties.TextShortcuts;
	
	public class SubNavButton extends Sprite
	{
		private var _id:Number;
		private var label:TextField;
		
		public function SubNavButton( id:Number, lnk:String )
		{
			TextShortcuts.init();
			
			_id = id;
			
			var s:Sprite = Assets.subBtn;
			addChild( s );
									 
			label = TextField( s.getChildByName("txt") );
			label.autoSize = TextFieldAutoSize.LEFT;
			label.htmlText = lnk;
			
			mouseEnabled = true;
			mouseChildren = false;
			buttonMode = true;
			
			addEventListener( MouseEvent.CLICK, onClickEventHandler );
			addEventListener( MouseEvent.MOUSE_OVER, onOverHandler );
			addEventListener( MouseEvent.MOUSE_OUT, onOutHandler );
		}
		
		public function get id() : Number { return _id; }
		
		public function enableButton( active:Boolean ) : void
		{
			removeEventListener( MouseEvent.MOUSE_OUT, onOutHandler );
			if( active )
			{
				addEventListener( MouseEvent.MOUSE_OUT, onOutHandler );
				
				Tweener.addTween( label, {_text_color:0x5D5D5D, time:.5, transition:"linear"});
				
				this.buttonMode    = true;
				this.mouseEnabled  = true;
				this.mouseChildren = false;
			}else{				
				this.buttonMode    = false;
				this.mouseEnabled  = false;
				this.mouseChildren = false;
			}
		}
		
		private function onClickEventHandler( e:MouseEvent ) : void
		{
			Tweener.addTween( label, {_text_color:0xfa0000, time:.2, transition:"linear"});
			var se:SiteEvents = new SiteEvents( SiteEvents.GET_SUBSECTION );
			se.value = _id;
			dispatchEvent(se);	
		
		}
		
		private function onOverHandler( e:MouseEvent ) : void
		{
			Tweener.addTween( label, {_text_color:0xfa0000, time:.2, transition:"linear"});
		}
		
		private function onOutHandler( e:MouseEvent ) : void
		{
			Tweener.addTween( label, {_text_color:0x5D5D5D, time:.5, transition:"linear"});
		}

	}
}