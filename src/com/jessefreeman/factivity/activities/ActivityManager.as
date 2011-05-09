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
 * User: Jesse Freeman
 * Date: 2/23/11
 * Time: 9:08 PM
 * .
 */
package com.jessefreeman.factivity.activities
{
    import com.jessefreeman.factivity.managers.*;
    import com.jessefreeman.factivity.activities.BaseActivity;
    import com.jessefreeman.factivity.analytics.ITrack;
    import com.jessefreeman.factivity.sounds.ISoundManager;
    import com.jessefreeman.factivity.sounds.SoundManager;
    import com.jessefreeman.factivity.threads.IThreadManager;
    import com.jessefreeman.factivity.threads.ThreadManager;
    import com.jessefreeman.factivity.utils.DeviceUtil;

    import flash.display.DisplayObjectContainer;

    public class ActivityManager implements IActivityManager
    {
        protected var currentActivity:BaseActivity;
        protected var _target:DisplayObjectContainer;
        private var _tracker:ITrack;
        protected var activeClassName:String;
        protected var os:String;
        private var _threadManager:IThreadManager;
        private var _soundManager:ISoundManager;

        /**
         * The Activity Manager is the main class that handles displaying and removing activities from the display. It
         * also manages basic tracking if a tracker is provided, threads and the sound manager.
         *
         * @param tracker - requires a class that implements ITrack in order to do basic activity switching tracking.
         * @param threadManager - This is the main thread manager to be used in the application. If one is not supplied
         * an instance of the generic ThreadManager will be created automatically.
         * @param soundManager  - This is the main sound manager to be used in the application. If one is not supplied
         * an instance of the generic ThreadManager will be created automatically.
         */
        public function ActivityManager(tracker:ITrack = null, threadManager:IThreadManager = null, soundManager:ISoundManager = null)
        {
            _tracker = tracker;
            _threadManager = threadManager ? threadManager : new ThreadManager();
            _soundManager = soundManager ? soundManager : new SoundManager();
            os = DeviceUtil.os;
        }

        /**
         * This is how to set the main display root. Ideally this is set to your main class that extends either Sprite
         * or MovieClip. This is where all activities will be attached to.
         *
         * @param target
         */
        public function set target(target:DisplayObjectContainer):void
        {
            _target = target;
        }

        /**
         * This switches out the currently displaying activity for a new one. Activities are automatically created from
         * the supplied class reference.
         *
         * @param activity - Class of the Activity to be created.
         * @param data - This is the data to be passed into the Activity's constructor.
         */
        public function setCurrentActivity(activity:Class, data:* = null):void
        {
            if (_tracker)
            {
                activeClassName = String(activity).split(" ")[1].substr(0, -1);
                _tracker.trackPageview("/MatchHack/" + os + "/" + activeClassName);
            }

            var newActivity:BaseActivity = new activity(this, data);
            onSwapActivities(newActivity);
        }

        /**
         * This is called by the main application loop. It allows the application to update the active activity.
         *
         * @param elapsed - time elapsed in MS since the last update.
         */
        public function updateCurrentActivity(elapsed:Number = 0):void
        {
            if (currentActivity)
                currentActivity.update(elapsed);
        }

        /**
         * Called when two activities are swapped. This is a good place to override when you want to add animation
         * between two activities switching.
         *
         * @param newActivity - The new Activity to display.
         */
        protected function onSwapActivities(newActivity:BaseActivity):void
        {
            if (currentActivity)
            {
                removeActivity();
            }

            addActivity(newActivity);
        }

        /**
         * Called when the Activity is actually added to the display. Once an activity is added, a track is called
         * assuming a tracker has been set up. Finally onStart is called on the activity.
         *
         * @param newActivity - The new Activity to display.
         */
        protected function addActivity(newActivity:BaseActivity):void
        {
            if (_tracker)
            {
                //Inject tracker to any new Activity
                if (newActivity.hasOwnProperty("_tracker"))
                    newActivity["_tracker"] = _tracker;
            }

            currentActivity = newActivity;

            _target.addChild(currentActivity);

            currentActivity.onStart();
        }

        /**
         * This is called when an activity is removed from the display. Before an Activity is removed, onStop is called.
         */
        protected function removeActivity():void
        {
            currentActivity.onStop();

            _target.removeChild(currentActivity);

        }

        /**
         * This method exposes the onBack call on the current activity.
         */
        public function back():void
        {
            //TODO should this be built into a history of some kind.
            currentActivity.onBack();
        }

        /**
         * Reference to the tracker instance.
         */
        public function get tracker():ITrack
        {
            return _tracker;
        }

        /**
         * Reference to the thread manager instance.
         */
        public function get threadManager():IThreadManager
        {
            return _threadManager;
        }

        /**
         * Reference to the sound manager instance.
         */
        public function get soundManager():ISoundManager
        {
            return _soundManager;
        }
    }
}
