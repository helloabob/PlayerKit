package
{
    import flash.display.MovieClip;
    import flash.events.Event;
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

        public function SmgbbPlayPanel()
        {
//			posTime.text = "10:00:01";
			timeBar.liveTime.visible = false;
			timeBar.playedLine.width = 0;
			timeBar.seekSuite.x = 0;
			timeBar.bufferingLine.width = 0;
			return;
        }// end function
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
