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

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.TimerEvent;

    public class BaseActivity extends Sprite implements ISave, ILoad, IUpdate
    {
        public static var fullSizeWidth:int = 0;
        public static var fullSizeHeight:int = 0;
        private static const MILLISECONDS:int = 1000;

        protected var nextScreen:Class;
        protected var nextScreenCounter:Number = 0;
        protected var nextScreenDelay:Number = 0;
        protected var stateManager:IActivityManager;

        public function BaseActivity(stateManager:IActivityManager, date:* = null)
        {
            this.stateManager = stateManager;
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
            init();
        }

        protected function onAddedToStage(event:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, false, 0, true);

            // Add more added logic here
        }

        protected function onRemovedFromStage(event:Event):void
        {
            removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);

            // Add more remove logic here
        }

        protected function init():void
        {
            //Override and add custom logic here.
        }

        protected function startNextScreenTimer(state:Class, delay:int = 1):void
        {
            nextScreenDelay = delay * MILLISECONDS;
            nextScreen = state;
        }

        protected function onNextScreen(event:TimerEvent = null):void
        {
            nextActivity(nextScreen);
        }

        protected function nextActivity(activity:Class):void
        {
            stateManager.setCurrentActivity(activity);
        }

        public function update(elapsed:Number = 0):void
        {
            if (nextScreen)
            {
                nextScreenCounter += elapsed;
                if (nextScreenCounter >= nextScreenDelay)
                    onNextScreen();
            }

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
    }
}
