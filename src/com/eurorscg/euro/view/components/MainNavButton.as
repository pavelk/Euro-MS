package com.eurorscg.euro.view.components
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.StyleSheet;
	import flash.events.MouseEvent;
	
	import caurina.transitions.*;
 	import caurina.transitions.properties.TextShortcuts;
	
	import com.eurorscg.euro.view.events.SiteEvents;

	public class MainNavButton extends Sprite
	{
		private var label:TextField;
		private var _id   :Number;
		
		public function MainNavButton( id:Number, desc:String )
		{
			TextShortcuts.init();
			
			_id = id;
			
			var s:Sprite = Assets.navBtn;
			addChild( s );
									 
			label = TextField( s.getChildByName("txt") );
			label.autoSize = TextFieldAutoSize.LEFT;
			label.htmlText = desc;
			
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
				Tweener.addTween( label, {x:0, time:0.2, transition:"linear"});
				
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
			Tweener.addTween( label, {x:label.x, time:0.2, transition:"linear"});
			var se:SiteEvents = new SiteEvents( SiteEvents.GET_SECTION );
			se.value = id;
			dispatchEvent(se);	
		}
		
		private function onOverHandler( e:MouseEvent ) : void
		{
			Tweener.addTween( label, {_text_color:0xfa0000, time:.2, transition:"linear"});
			Tweener.addTween( label, {x:label.x + 5, time:0.2, transition:"linear"});
		}
		
		private function onOutHandler( e:MouseEvent ) : void
		{
			Tweener.addTween( label, {_text_color:0x5D5D5D, time:.5, transition:"linear"});
			Tweener.addTween( label, {x:0, time:0.2, transition:"linear"});
		}
		
	}
}