package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class CutToolPanel extends Sprite
	{
		private var btnStart:Sprite;
		private var btnEnd:Sprite;
		private var btnCommit:Sprite;
		public function CutToolPanel(){
			btnStart = drawButton("设置开始点");
			addChild(btnStart);
			btnStart.addEventListener(MouseEvent.CLICK, onStart);
			btnStart.tabIndex = 1;
			
			btnEnd = drawButton("设置结束点",0xFF6100);
			btnEnd.y = 40;
			addChild(btnEnd);
			btnEnd.addEventListener(MouseEvent.CLICK, onStart);
			btnEnd.tabIndex = 2;
			
			btnCommit = drawButton("设置完成");
			btnCommit.y = 80;
			addChild(btnCommit);
			btnCommit.addEventListener(MouseEvent.CLICK, onStart);
			btnCommit.tabIndex = 3;
		}
		private function onStart(evt:MouseEvent):void{
			var par:*=this.parent;
			par.onSetCut(evt.target.tabIndex);
		}
		private function drawButton(title:String,color:uint=0x0000ff):Sprite{
			var button:Sprite = new Sprite();
			button.graphics.beginFill(color,1);
			button.graphics.drawRect(0,0,100,30);
			button.graphics.endFill();
			button.buttonMode = true;
			
			var tf:TextFormat = new TextFormat();
			tf.align = TextFormatAlign.CENTER;
			tf.size = 14;
			
			var label:TextField = new TextField();
			label.text = title;
			label.height = 25;
			label.textColor = 0xffffff;
			label.defaultTextFormat = tf;
			label.y = 5;
			label.mouseEnabled=false;
			label.setTextFormat(tf);
			label.selectable=false;
			button.addChild(label);
			
			return button;
		}
	}
}