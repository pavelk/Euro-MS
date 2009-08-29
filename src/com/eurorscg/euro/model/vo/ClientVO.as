package com.eurorscg.euro.model.vo
{
	public class ClientVO
	{
		private var _id     :String;
		private var _label  :String;
		private var _content:XMLList;
		
		public function get id()     :String { return _id;      }
		public function get label()  :String { return _label;   }
		public function get content():XMLList{ return _content; }
		
		public function ClientVO( id:String, label:String, content:XMLList )
		{
			_id      = id;
			_label   = label;
			_content = content;
		}
	}
}