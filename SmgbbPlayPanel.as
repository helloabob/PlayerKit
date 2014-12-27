package
{
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;
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

		private var spSeek:Sprite;
		private var canUpdateSeek:Boolean;
		public var seekFunc:Function;
		
        public function SmgbbPlayPanel()
        {
//			posTime.text = "10:00:01";
			timeBar.liveTime.visible = false;
			timeBar.playedLine.width = 0;
			timeBar.seekSuite.x = 0;
			timeBar.bufferingLine.width = 0;
			
			timeBar.startpt.visible=false;
			timeBar.endpt.visible=false;
			
			spSeek = timeBar.seekSuite;
			canUpdateSeek = true;
			enableControl();
			
			return;
        }// end function
		private function enableControl():void{
			spSeek.addEventListener(MouseEvent.MOUSE_DOWN,onDown);
		}
		private function onDown(evt:MouseEvent):void{
			spSeek.addEventListener(MouseEvent.MOUSE_UP,onUp);
			spSeek.startDrag(false,new Rectangle(0,3.35,timeBar.timeLine.width,0));
			canUpdateSeek = false;
		}
		private function onUp(evt:MouseEvent):void{
			spSeek.removeEventListener(MouseEvent.MOUSE_UP,onUp);
			spSeek.stopDrag();
			seekFunc.apply(null,[spSeek.x/443.0]);
			canUpdateSeek = true;
		}
		public function setCutPoint(time:Number,type:int):void{
			return;
			if(type==1){
				timeBar.startpt.x = time/durationTime * 443.0;
				timeBar.startpt.visible=true;
			}else if(type==2){
				timeBar.endpt.x = time/durationTime * 443.0;
				timeBar.endpt.visible=true;
			}else{
				timeBar.startpt.visible=false;
				timeBar.endpt.visible=false;
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
		}
		public function updateTime(currentTime:Number):void{
			if(canUpdateSeek==false)return;
			if(currentTime>durationTime)currentTime = durationTime;
			posTime.text = formatTime(currentTime);
			timeBar.playedLine.width = currentTime / durationTime * 443.0;
			timeBar.seekSuite.x = timeBar.playedLine.width;
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
