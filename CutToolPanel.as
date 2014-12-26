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
		private var lblStart:TextField;
		private var lblEnd:TextField;
		public function CutToolPanel(){
			btnStart = drawButton("设置开始点",0x0000ff,40);
			addChild(btnStart);
			btnStart.addEventListener(MouseEvent.CLICK, onStart);
			btnStart.tabIndex = 1;
			
			var tf:TextFormat = new TextFormat();
			tf.align = TextFormatAlign.CENTER;
			tf.size = 10;
			
			lblStart = new TextField();
			lblStart.y = 25;
			lblStart.textColor = 0xffffff;
			lblStart.defaultTextFormat = tf;
			lblStart.setTextFormat(tf);
			lblStart.selectable = false;
			lblStart.text = "00:00:00";
			btnStart.addChild(lblStart);
			
			btnEnd = drawButton("设置结束点",0xFF6100,40);
			btnEnd.y = 50;
			addChild(btnEnd);
			btnEnd.addEventListener(MouseEvent.CLICK, onStart);
			btnEnd.tabIndex = 2;
			
			lblEnd = new TextField();
			lblEnd.y = 25;
			lblEnd.textColor = 0xffffff;
			lblEnd.defaultTextFormat = tf;
			lblEnd.setTextFormat(tf);
			lblEnd.selectable = false;
			lblEnd.text = "00:00:00";
			btnEnd.addChild(lblEnd);
			
			btnCommit = drawButton("设置完成");
			btnCommit.y = 100;
			addChild(btnCommit);
			btnCommit.addEventListener(MouseEvent.CLICK, onStart);
			btnCommit.tabIndex = 3;
		}
		public function setCutTime(isStart:Boolean,offset:Number,islive:Boolean=false):void{
			if(islive==false){
				if(isStart==true)lblStart.text = formatTime(offset);
				else lblEnd.text = formatTime(offset);
			}else{
				var dt:Date = new Date(offset);
				var tmp:int = dt.hours*3600+dt.minutes*60+dt.seconds;
				if(isStart==true)lblStart.text = formatTime(tmp);
				else lblEnd.text = formatTime(tmp);
			}
		}
		private function onStart(evt:MouseEvent):void{
			var par:*=this.parent;
			par.onSetCut(evt.target.tabIndex);
		}
		private function drawButton(title:String,color:uint=0x0000ff,hei:int=30):Sprite{
			var button:Sprite = new Sprite();
			button.graphics.beginFill(color,1);
			button.graphics.drawRect(0,0,100,hei);
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
		private function formatTime(value:int):String{
			var sec:int=0;
			var min:int=0;
			var hrs:int=0;
			var strSec:String;
			var strMin:String;
			var strHrs:String;
			if(value<60){
				sec = value;
			}else if(value<3600){
				min = value/60;
				sec = value - min*60;
			}else {
				hrs = value/3600;
				min = (value - hrs*3600)/60;
				sec = value - hrs*3600 - min*60;
			}
			if(sec<10)strSec="0"+sec.toString();
			else strSec=sec.toString();
			if(min<10)strMin="0"+min.toString();
			else strMin=min.toString();
			if(hrs<10)strHrs="0"+hrs.toString();
			else strHrs=hrs.toString();
			return strHrs+":"+strMin+":"+strSec;
		}
	}
}