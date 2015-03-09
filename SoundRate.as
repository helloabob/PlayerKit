package
{
	import flash.display.Sprite;
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
			trace("sound_rate_init");
		}
		public function showBar():void{
			trace("showBar");
			if(conWidth<=0||conHeight<=0)return;
			var offsetY:int = conHeight/2;
			var count:int = 200;
			var thick:int = conWidth/count;
			n = 0;
			//清除绘图
			this.graphics.clear();
			
			this.graphics.beginFill(0xff0000,1);
			this.graphics.drawRect(0,0,conWidth,conHeight);
			this.graphics.endFill();
			
			//将当前声音输出为ByteArray  -1.0~1.0
			SoundMixer.computeSpectrum(bArray,true,0);
			for(var i=0; i < count; i+=1){
				//在ByteArray中读取一个32位的单精度浮点数(这个是livedoc上写的,实际就是把数据流读取成浮点数)
				n = bArray.readFloat();
				//这个实际作用是把n扩大一下
				var num:Number = n*offsetY;
				//设置线条样式,颜色绿色,宽度10,透明度100
				this.graphics.lineStyle(thick,0x04076A,1,false,"noSacle","none");
				//移动到x坐标50+i,y坐标100的位置
				this.graphics.moveTo(thick*i,offsetY);
				//向上画图
				this.graphics.lineTo(thick*i,offsetY-num/2);
			}
			trace("w:"+conWidth+"   h:"+conHeight);
		}
	}
}