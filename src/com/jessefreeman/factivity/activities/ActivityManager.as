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

        public function ActivityManager(tracker:ITrack = null, threadManager:IThreadManager = null, soundManager:ISoundManager = null)
        {
            _tracker = tracker;
            _threadManager = threadManager ? threadManager : new ThreadManager();
            _soundManager = soundManager ? soundManager : new SoundManager();
            os = DeviceUtil.os;
        }

        public function set target(target:DisplayObjectContainer):void
        {
            _target = target;
        }

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

        public function updateCurrentActivity(elapsed:Number = 0):void
        {
            if (currentActivity)
                currentActivity.update(elapsed);
        }

        protected function onSwapActivities(newActivity:BaseActivity):void
        {
            if (currentActivity)
            {
                removeActivity();
            }

            addActivity(newActivity);
        }

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

        protected function removeActivity():void
        {
            currentActivity.onStop();

            _target.removeChild(currentActivity);


        }

        public function back():void
        {
            currentActivity.onBack()
        }

        public function get tracker():ITrack
        {
            return _tracker;
        }

        public function get threadManager():IThreadManager
        {
            return _threadManager;
        }

        public function get soundManager():ISoundManager
        {
            return _soundManager;
        }
    }
}
