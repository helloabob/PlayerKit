package
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.external.ExternalInterface;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;

	public class SoundRate extends Sprite
	{
		public var conWidth:int=0;
		public var conHeight:int=0;
		//声明一个ByteArray对象
		private var bArray:ByteArray = new ByteArray();
		//声明一个数组对象
		private var Ary:Array;
		//声明一个数字对象
		private var n:Number = 0;
		public function SoundRate()
		{
			super();
		}
		public function showBar():void{
//			return;
			if(SoundMixer.areSoundsInaccessible()==true){
				log("sound access error");
				return;
			}
			if(conWidth<=0||conHeight<=0)return;
			var offsetY:int = conHeight/2;
			var count:int = 256;
			var thick:int = conWidth/count;
			n = 0;
//			//清除绘图
//			this.graphics.clear();
//			
//			//将当前声音输出为ByteArray  -1.0~1.0
//			SoundMixer.computeSpectrum(bArray,true,0);
//			for(var i:int=0; i < count; i+=1){
//				//在ByteArray中读取一个32位的单精度浮点数(这个是livedoc上写的,实际就是把数据流读取成浮点数)
//				n = bArray.readFloat();
//				//这个实际作用是把n扩大一下
//				var num:Number = n*offsetY;
//				//设置线条样式,颜色绿色,宽度10,透明度100
//				this.graphics.lineStyle(thick,0x04076A,1,false,"noSacle","none");
//				//移动到x坐标50+i,y坐标100的位置
//				this.graphics.moveTo(thick*i,offsetY);
//				//向上画图
//				this.graphics.lineTo(thick*i,offsetY-num/2);
			
			
			
			/*case 2*/
			
			SoundMixer.computeSpectrum(bArray,false,0);
			
			var g:Graphics = this.graphics;
			g.clear();
			
			/*draw background*/
			g.beginFill(0x000000,1);
			g.drawRect(0,0,conWidth,conHeight);
			g.endFill();
			
			g.lineStyle(0, 0x6600CC);
			g.beginFill(0x6600CC);
			g.moveTo(0, offsetY);
			
			var n:Number = 0;
			
			// left channel
			for (var i:int = 0; i < count; i++) 
			{
				n = (bArray.readFloat() * offsetY);
				log("hei1_:"+i+" value:"+n);
				g.lineTo(i * thick, offsetY - n);
			}
			g.lineTo(count * thick, offsetY);
			g.endFill();
			
			// right channel
			g.lineStyle(0, 0xCC0066);
			g.beginFill(0xCC0066, 0.5);
			g.moveTo(count * thick, offsetY);
			
			for (i = count; i > 0; i--) 
			{
				n = (bArray.readFloat() * offsetY);
				log("hei2_:"+i+" value:"+n);
				g.lineTo(i * thick, offsetY - n);
			}
			g.lineTo(0, offsetY);
			g.endFill();
		}
		private function log(str:String):void{
			trace(str);
			if(flash.external.ExternalInterface.available)flash.external.ExternalInterface.call("console.log",str);
		}
	}
}