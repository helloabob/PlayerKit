package
{
    import flash.display.MovieClip;
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

        public function SmgbbPlayPanel()
        {
			posTime.text = "10:00:01";
            return;
        }// end function
    }
}
