/*
 * Copyright (c) 2011 Jesse Freeman
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

package com.jessefreeman.factivity
{
    import com.jessefreeman.factivity.activities.IActivityManager;
    import com.jessefreeman.factivity.sounds.ISoundManager;
    import com.jessefreeman.factivity.managers.SingletonManager;
    import com.jessefreeman.factivity.sounds.SoundManager;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    import flash.utils.getTimer;

    public class AbstractApplication extends Sprite
    {

        protected var soundManager:ISoundManager;

        protected var defaultX:int = 0;
        protected var defaultY:int = 0;
        protected var period:Number;
        protected var beforeTime:int = 0;
        protected var afterTime:int = 0;
        protected var timeDiff:int = 0;
        protected var sleepTime:int = 0;
        protected var overSleepTime:int = 0;
        protected var excess:int = 0;
        protected var updateTimer:Timer;
        protected var activityManager:IActivityManager;
        protected var defaultStartActivity:Class;
        protected var frameRate:int;

        /**
         * This is the main application class. Extend this from your main class. This class handles setting up the
         * ActivityManager and creating the main application game loop. It is important to note that this class doesn't
         * have to be your main class. In situtaions when the AbstractApplication is implemented without a reference
         * to stage, the Application waits for the added to stage event to begin initialization.
         *
         * @param activityManager Requires an instance of an ActivityManager.
         * @param startActivity This is the default Activity you application will display.
         * @param x This is the default X position of the application.
         * @param y This is the default Y position of the application.
         * @param scale This is the X and Y scale of the application. This can be used to
         *        upscale the app on mobile devices
         */
        public function AbstractApplication(activityManager:IActivityManager, startActivity:Class, x:int = 0, y:int = 0, scale:Number = 1, frameRate:int = 30)
        {
            soundManager = activityManager.soundManager;
            this.frameRate = frameRate;
            period = 1000 / frameRate;
            this.x = defaultX = x;
            this.y = defaultY = y;
            scaleX = scaleY = scale;
            defaultStartActivity = startActivity;
            this.activityManager = activityManager;

            init();

            if (!stage)
                addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            else
                addStageFocusEvents();

        }

        /**
         * Resumes the application loop.
         */
        public function resume():void
        {
            updateTimer.start();
        }

        /**
         * Pauses the application loop.
         */
        public function pause():void
        {
            updateTimer.stop();
        }

        /**
         * Handles stage adding listeners to manage Flash focus.
         */
        protected function addStageFocusEvents():void
        {
            if (!stage.hasEventListener(Event.ACTIVATE))
                stage.addEventListener(Event.ACTIVATE, onFlashResume);

            if (!stage.hasEventListener(Event.DEACTIVATE))
                stage.addEventListener(Event.DEACTIVATE, onFlashDeactivate);

            resume();
        }

        /**
         * This is called when the Flash Player gets a resume event. By default onFlashResume reactivates all sounds in
         * the sound manager and resumes the application loop.
         *
         * @param event
         */
        protected function onFlashResume(event:Event):void
        {
            soundManager.playSounds();
            resume();
        }

        /**
         * This is called when the Flash Player loses focus.By default onFlashDeactivate pauses all sounds and pauses
         * the application loop.
         * @param event
         */
        protected function onFlashDeactivate(event:Event):void
        {
            soundManager.pauseSounds();
            pause();
        }

        /**
         * During the init process the ActivityManager gets an instance to the AbstractApplication so Activities can
         * be attached to the display. Also the default activity is added to the ActivityManager and the application
         * loop is setup.
         *
         */
        protected function init():void
        {

            activityManager.target = this;
            activityManager.setCurrentActivity(defaultStartActivity);

            updateTimer = new Timer(period, 1);
            updateTimer.addEventListener(TimerEvent.TIMER, onUpdateLoop);


        }

        /**
         * This handles cleaning up stage events when this class is initalized without a reference to stage.
         *
         * @param event
         */
        protected function onAddedToStage(event:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
            addStageFocusEvents();
        }

        /**
         * Removed stage listener when this is removed from the stage.
         *
         * @param event
         */
        protected function onRemovedFromStage(event:Event):void
        {
            removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
        }

        /**
         * This is the main application loop. This handles keeping a consistent FPS based on the supplied Frame Rate. It
         * will also manage excess frame time as well as dropping frames where needed.
         *
         * @param event
         */
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

    }
}
