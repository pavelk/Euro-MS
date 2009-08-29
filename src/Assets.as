package
{
	import flash.display.Sprite;
	
	public class Assets
	{
		[Embed(source="/assets/assets.swf", symbol="navBtn")]
		private static var NavBtn:Class;
		
		[Embed(source="/assets/assets.swf", symbol="header")]
		private static var Header:Class;
		
		[Embed(source="/assets/assets.swf", symbol="subBtn")]
		private static var SubBtn:Class;
		
		[Embed(source="/assets/assets.swf", symbol="bg")]
		private static var Bg:Class;
		
		[Embed(source="/assets/assets.swf", symbol="bgcopy")]
		private static var BgCopy:Class;
		
		[Embed(source="/assets/assets.swf", symbol="paper")]
		private static var Paper:Class;
		
		[Embed(source="/assets/assets.swf", symbol="copy")]
		private static var Copy:Class;
		
		[Embed(source="/assets/assets.swf", symbol="videobtn")]
		private static var VideoBtn:Class;
		
		[Embed(source="/assets/assets.swf", symbol="playerControls")]
		private static var PlayerControls:Class;							
		
		private static var _navBtn  :Sprite;
		private static var _subBtn  :Sprite;
		private static var _header  :Sprite;
		private static var _bg      :Sprite;
		private static var _bgcopy  :Sprite;
		private static var _paper   :Sprite;
		private static var _copy    :Sprite;
		private static var _videobtn:Sprite;
		private static var _playerControls:Sprite;
		
		public static function get navBtn()    : Sprite { return new NavBtn();     }
		public static function get subBtn()    : Sprite { return new SubBtn();     }
		public static function get header()    : Sprite { return new Header();     }
		public static function get bg()        : Sprite { return new Bg();         }
		public static function get bgcopy()    : Sprite { return new BgCopy();     }
		public static function get paper()     : Sprite { return new Paper();      }
		public static function get copy()      : Sprite { return new Copy();       }
		public static function get videobtn()  : Sprite { return new VideoBtn();   }
		public static function get playerControls()  : Sprite { return new PlayerControls();   }
		
		public function Assets()
		{
		}

	}
}