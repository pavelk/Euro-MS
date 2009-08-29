package com.eurorscg.euro.view.components
{
	import flash.display.Sprite;
	import caurina.transitions.*;
	import flash.events.MouseEvent;

	public class MainNav extends Sprite
	{
		private var navButtons:Array = new Array();
		
		public function MainNav()
		{
			this.x = 19;
			this.y = 177;
		}
		
		public function init( navData:Object ) : void
		{
			var j:Number = 1;
			for each( var i:String in navData )
			{
				var nb:MainNavButton = new MainNavButton( j, i );
				nb.y = (j - 1) * (nb.height + 5);
				navButtons.push( nb );
				addChild( nb );
				nb.alpha = 0;
				Tweener.addTween(nb, {alpha:1, time:.5, delay:.8 + 0.3*j, transition:"linear"});
				j ++;
			}
		}
		
		public function startFirst() : void
		{
			navButtons[0].dispatchEvent( new MouseEvent( MouseEvent.CLICK ) );
			navButtons[0].dispatchEvent( new MouseEvent( MouseEvent.MOUSE_OVER ) );
		}
		
		public function update( n:Number ) : void
		{
			for each (var b:MainNavButton in navButtons)
			{
				if( Number(b.id) == n )
				{
					b.enableButton(false);
				}else{
					b.enableButton(true);
				}
			}
		}		
	}
}