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

package com.jessefreeman.factivity.activities
{
    import com.jessefreeman.factivity.managers.IActivityManager;

    import com.jessefreeman.factivity.threads.IRunnable;
    import com.jessefreeman.factivity.threads.ThreadManager;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.TimerEvent;

    public class BaseActivity extends Sprite implements ISave, ILoad, IUpdate
    {
        public static var fullSizeWidth:int = 0;
        public static var fullSizeHeight:int = 0;
        public static const MILLISECONDS:int = 1000;

        protected var nextScreen:Class;
        protected var nextScreenData:*;
        protected var nextScreenCounter:Number = 0;
        protected var nextScreenDelay:Number = 0;
        protected var activityManager:IActivityManager;
        protected var data:*;
        protected var threadManager:ThreadManager;

        public function BaseActivity(activityManager:IActivityManager, data:* = null)
        {
            //Need to look into possibly injecting this
            this.threadManager = new ThreadManager();
            this.data = data;
            this.activityManager = activityManager;
            onCreate();
        }

        protected function onCreate():void
        {
            //Override and add custom logic here.
        }

        protected function startNextActivityTimer(activity:Class, delay:int = 1, data:* = null):void
        {
            this.nextScreenData = data;
            nextScreenDelay = delay * MILLISECONDS;
            nextScreen = activity;
        }

        protected function onNextScreen(event:TimerEvent = null):void
        {
            nextActivity(nextScreen, nextScreenData);
        }

        protected function nextActivity(activity:Class, data:* = null):void
        {
            activityManager.setCurrentActivity(activity, data);
        }

        public function update(elapsed:Number = 0):void
        {
            if (nextScreen)
            {
                nextScreenCounter += elapsed;
                if (nextScreenCounter >= nextScreenDelay)
                    onNextScreen();
            }

            threadManager.update(elapsed);

            render();
        }

        protected function render():void
        {
        }

        public function saveState(obj:Object, activeState:Boolean = true):void
        {
            //TODO add core save logic here
        }

        public function loadState(obj:Object):void
        {
            //TODO add core load logic here
        }

        public function onStart():void
        {

        }

        public function onStop():void
        {

        }

        protected function addThread(value:IRunnable):int
        {
            return threadManager.addThread(value);
        }

        protected function removeThread(value:IRunnable):IRunnable
        {
            return threadManager.removeThread(value);
        }
    }
}
