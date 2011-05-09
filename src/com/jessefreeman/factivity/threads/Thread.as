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

        public function Thread(updateCallback:Function = null, finishCallback:Function = null)
        {
            this.finishCallback = finishCallback;
            this.updateCallback = updateCallback;

        }

        public function start():void
        {
            running = true;
        }

        public function run(elapsed:Number = 0):void
        {
            if (updateCallback != null)
                updateCallback();
        }

        public function isRunning():Boolean
        {
            return running;
        }

        protected function finish():void
        {
            running = false;
            if (finishCallback != null)
                finishCallback();
        }
    }
}
