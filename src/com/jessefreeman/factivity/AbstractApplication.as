/*
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 *
 *  User: Jesse Freeman
 *  Date: 2/23/11
 *  Time: 9:08 PM
 *
 */

package com.jessefreeman.factivity
{
    import com.jessefreeman.factivity.managers.IActivityManager;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    import flash.utils.getTimer;

    public class AbstractApplication extends Sprite
    {

        public static const FRAME_RATE:int = 30;

        protected var defaultX:int = 0;
        protected var defaultY:int = 0;
        protected var period:Number = 1000 / FRAME_RATE;
        protected var beforeTime:int = 0;
        protected var afterTime:int = 0;
        protected var timeDiff:int = 0;
        protected var sleepTime:int = 0;
        protected var overSleepTime:int = 0;
        protected var excess:int = 0;
        protected var updateTimer:Timer;
        protected var activityManager:IActivityManager;
        protected var defaultStartActivity:Class;

        public function AbstractApplication(activityManager:IActivityManager, startActivity:Class, x:int = 0, y:int = 0, scale:Number = 1)
        {

            this.x = defaultX = x;
            this.y = defaultY = y;
            scaleX = scaleY = scale;
            defaultStartActivity = startActivity;
            this.activityManager = activityManager;

            if (stage)
                addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

            init();
        }

        protected function init():void
        {
            activityManager.target = this;
            activityManager.setCurrentActivity(defaultStartActivity);

            updateTimer = new Timer(period, 1);
            updateTimer.addEventListener(TimerEvent.TIMER, onUpdateLoop);


        }

        protected function onAddedToStage(event:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
        }

        protected function onRemovedFromStage(event:Event):void
        {
            removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
        }

        protected function onUpdateLoop(event:TimerEvent):void
        {
            beforeTime = getTimer();
            overSleepTime = (beforeTime - afterTime) - sleepTime;

            activityManager.updateCurrentActivity((beforeTime - afterTime));

            afterTime = getTimer();
            timeDiff = afterTime - beforeTime;
            sleepTime = (period - timeDiff) - overSleepTime;
            if (sleepTime <= 0)
            {
                excess -= sleepTime
                sleepTime = 2;
            }
            updateTimer.reset();
            updateTimer.delay = sleepTime;
            updateTimer.start();

            while (excess > period)
            {
                activityManager.updateCurrentActivity();
                excess -= period;
            }

            event.updateAfterEvent();

        }

        public function activate():void
        {
            updateTimer.start();
        }

        public function pause():void
        {
            updateTimer.stop();
        }

    }
}
