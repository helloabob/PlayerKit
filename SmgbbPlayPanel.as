package
{
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import flash.text.TextField;

	/**
	 * smgbb tool bar
	 * 
	 */
    dynamic public class SmgbbPlayPanel extends MovieClip
    {
        public var posTime:TextField;
        public var duration:TextField;
        public var timeBar:MovieClip;
		public var durationTime:Number;

		/*分段视频显示层*/
		private var spCut:Sprite;
		
		/*拖拉的圆点*/
		private var spSeek:Sprite;
		private var canUpdateSeek:Boolean;
		public var seekFunc:Function=null;
		
		/*进度条，支持拖拉跳播*/
		private var spLine:Sprite;
		
        public function SmgbbPlayPanel()
        {
//			posTime.text = "10:00:01";
			timeBar.liveTime.visible = false;
			timeBar.playedLine.width = 0;
			timeBar.seekSuite.x = 0;
			timeBar.bufferingLine.width = 0;
			
//			timeBar.startpt.visible=false;
//			timeBar.endpt.visible=false;
			
			spSeek = timeBar.seekSuite;
			spLine = timeBar.seekLine;
			spCut = timeBar.cutLine;
			spCut.width = 0;
			canUpdateSeek = true;
			enableControl();
			
			return;
        }// end function
		private function enableControl():void{
			spSeek.addEventListener(MouseEvent.MOUSE_DOWN,onDown);
			spLine.addEventListener(MouseEvent.CLICK, onSeek);
		}
		private function onDown(evt:MouseEvent):void{
			spSeek.addEventListener(MouseEvent.MOUSE_UP,onUp);
			spSeek.startDrag(false,new Rectangle(0,3.35,timeBar.timeLine.width,0));
			canUpdateSeek = false;
		}
		private function onUp(evt:MouseEvent):void{
			spSeek.removeEventListener(MouseEvent.MOUSE_UP,onUp);
			spSeek.stopDrag();
			if(seekFunc!=null)seekFunc.apply(null,[spSeek.x/443.0]);
			canUpdateSeek = true;
		}
		private function onSeek(evt:MouseEvent):void{
			if(seekFunc!=null)seekFunc.apply(null,[evt.localX/443.0]);
			trace(evt.localX);
		}
		public function setCutPoint(time:Number,type:int):void{
//			return;
			if(type==CutUtils.TypeStart){
				CutUtils.cutOpen = true;
				spCut.x = time/durationTime * 443.0 + 1;
				spCut.width = 0;
			}else if(type==CutUtils.TypeEnd){
				CutUtils.cutOpen = false;
				var end_time:Number = time/durationTime * 443.0 + 1;
				if(end_time>spCut.x)spCut.width = end_time - spCut.x;
			}else{
				spCut.x = 0;
				spCut.width = 0;
				CutUtils.cutOpen = false;
			}
		}
		public function setDuration(total:Number):void{
			if(total >= 0){
				durationTime = total;
				duration.text = formatTime(total);
			}else{
				duration.text = "--:--:--";
				posTime.text = "--:--:--";
			}
			timeBar.playedLine.width=0;
			timeBar.seekSuite.x=0;
		}
		public function updateTime(currentTime:Number):void{
			if(canUpdateSeek==false)return;
			if(currentTime>durationTime)currentTime = durationTime;
			posTime.text = formatTime(currentTime);
			timeBar.playedLine.width = currentTime / durationTime * 443.0;
			timeBar.seekSuite.x = timeBar.playedLine.width;
			
			/*刷新打点进度条*/
			if(CutUtils.cutOpen){
				var end_time:Number = currentTime/durationTime * 443.0 + 1;
				if(end_time>spCut.x)spCut.width = end_time - spCut.x;
			}
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
