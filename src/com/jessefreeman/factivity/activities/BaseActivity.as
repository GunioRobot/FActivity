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
    import com.jessefreeman.factivity.activities.IActivityManager;
    import com.jessefreeman.factivity.sounds.ISoundManager;
    import com.jessefreeman.factivity.threads.IRunnable;
    import com.jessefreeman.factivity.threads.IThreadManager;

    import flash.display.Sprite;
    import flash.events.TimerEvent;

    public class BaseActivity extends Sprite implements ISave, ILoad, IUpdate
    {
        public static const MILLISECONDS:int = 1000;
        public static var fullSizeWidth:int = 0;
        public static var fullSizeHeight:int = 0;

        protected var nextScreen:Class;
        protected var nextScreenData:*;
        protected var nextScreenCounter:Number = 0;
        protected var nextScreenDelay:Number = 0;
        protected var activityManager:IActivityManager;
        protected var threadManager:IThreadManager;
        protected var soundManager:ISoundManager;
        protected var data:*;

        /**
         * This is the main display of your application. Each application is made up of multiple activities. An activity
         * manages all of the state fo your application while it is activated. The Activity also has access to the
         * Application's thread and sound manager. Finally each activity is updated based on the applications main
         * update loop.
         *
         * @param activityManager - a reference to the Activity Manager.
         * @param data - any additional data used by the activity.
         */
        public function BaseActivity(activityManager:IActivityManager, data:* = null)
        {
            //Need to look into possibly injecting this
            this.activityManager = activityManager;
            this.threadManager = activityManager.threadManager;
            this.soundManager = activityManager.soundManager;
            this.data = data;
            onCreate();
        }

        /**
         * This is the main construction method. At this point the activity does not have access to stage so put all of
         * your pre-stage configuration here. You can still add DisplayObjects and setup visuals but you will not be
         * able to directly manipulate the stage. At this point the Activity is not visible.
         */
        protected function onCreate():void
        {
            //Override and add custom logic here.
        }

        /**
         * This is a helper to delay the activation of the next activity. During this delay code is still able to
         * execute in the update and render methods while the time runs down.
         *
         * @param activity - The next activity to load.
         * @param delay - The delay, in seconds.
         * @param data - Any data that should be passed onto the next activity.
         */
        protected function startNextActivityTimer(activity:Class, delay:int = 1, data:* = null):void
        {
            this.nextScreenData = data;
            nextScreenDelay = delay * MILLISECONDS;
            nextScreen = activity;
        }

        /**
         * Called when the next screen timer runs out.
         *
         * @param event
         */
        protected function onNextScreen(event:TimerEvent = null):void
        {
            nextActivity(nextScreen, nextScreenData);
        }

        /**
         * This is the main method to launch a new activity. Calling this will imediatly notify the Activity Manager to
         * load the next activity.
         *
         * @param activity - The next activity to load.
         * @param data - Any data that should be passed onto the next activity.
         */
        protected function nextActivity(activity:Class, data:* = null):void
        {
            activityManager.setCurrentActivity(activity, data);
        }

        /**
         * This is the main update loop for you activity. It is called by the Activity Manager based on the target
         * Framerate of the application. When update is called, it is supplied a ms elapsed to help sync up any
         * timers or animations going on in your activity.
         *
         * During an update, the nextScreen timer is run if one is set. Then the thread manager is called and finally
         * render is called to execute any final visual updates.
         *
         * It is best practice to only put code execution in the update and use render for any visual changes.
         *
         * @param elapsed
         */
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

        /**
         * This is a placeholder to handle any custom render logic you may need. It is called at the end of the update
         * method.
         */
        protected function render():void
        {
            //Override and add custom logic here.
        }

        /**
         * Placeholder for saving out the state of your application.
         */
        public function saveState():void
        {
            //Override and add custom logic here.
        }

        /**
         * Placeholder for loading the state of your application.
         */
        public function loadState():void
        {
            //Override and add custom logic here.
        }

        /**
         * Called when the activity is added to the stage. At this point it's safe to access stage.
         */
        public function onStart():void
        {
            //Override and add custom logic here.
        }

        /**
         * Called when an activity is removed from the stage. At this point you should fully shut down your activity
         * and release any references to memory you want to be garbage collected to the activity can safely be removed
         * from memory. You should also remove any active threads at this time.
         */
        public function onStop():void
        {
            //Override and add custom logic here.
        }

        /**
         * This method allows you to add a thread to the Thread Manager. It returns an ID to the added thread. This
         * method will return -1 if the thread was not able to be added to the Thread Manager.
         *
         * @param value
         * @return
         */
        protected function addThread(value:IRunnable):int
        {
            //TODO this should keep track of threads added in this activity so they can be safely removed
            return threadManager.addThread(value);
        }

        /**
         * This allows you to remove a Thread from the ThreadManager. It will return an instance of the thread that was
         * removed.
         *
         * @param value
         * @return
         */
        protected function removeThread(value:IRunnable):IRunnable
        {
            return threadManager.removeThread(value);
        }

        /**
         * This is a placeholder mehod to handle when the back button is pressed. Override this method to trigger a new
         * activity.
         */
        public function onBack():void
        {
            // This should be overridden
        }
    }
}
