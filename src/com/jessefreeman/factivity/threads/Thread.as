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

package com.jessefreeman.factivity.threads
{
    public class Thread implements IRunnable
    {
        protected var updateCallback:Function;
        protected var finishCallback:Function;
        protected var running:Boolean;

        /**
         * This is a basic thread. I implements IRunnable and can accept a update call back as well as a finished call
         * back.
         *
         * @param updateCallback - function to be called when thread is run.
         * @param finishCallback - function to be called when thread is finished.
         */
        public function Thread(updateCallback:Function = null, finishCallback:Function = null)
        {
            this.finishCallback = finishCallback;
            this.updateCallback = updateCallback;

        }

        /**
         * Called when the thread starts up.
         */
        public function start():void
        {
            running = true;
        }

        /**
         * Called when the thread is executed. This method get's a reference to the time elapsed from the last update
         * call from the main app loop. You can use this to limit the thread's execution time if you see that the
         * elapsed time is longer then you expect the thread to run for.
         *
         * @param elapsed - time in MS from the time update was called in the application.
         */
        public function run(elapsed:Number = 0):void
        {
            if (updateCallback != null)
                updateCallback();
        }

        /**
         * A getter to see if the thread is still running.
         *
         * @return
         */
        public function isRunning():Boolean
        {
            return running;
        }

        /**
         * This method should be called when the thread's main task has been completed. It will handle toggling the
         * running flag as well as executing the finish callback.
         *
         */
        protected function finish():void
        {
            running = false;
            if (finishCallback != null)
                finishCallback();
        }

        public function toString():String
        {
            return "Thread";
        }

    }
}
