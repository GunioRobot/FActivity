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

    public class ThreadManager implements IThreadManager
    {
        private var maxActive:int;
        private var threads:Array = [];

        public function ThreadManager(maxActive:int = 10)
        {
            this.maxActive = maxActive;
        }

        public function addThread(value:IRunnable):int
        {
            var index:int = threads.indexOf(value);
            if (index == -1)
            {
                index = (threads.push(value) - 1);
            }
            value.start();

            return index;
        }

        public function update(elapsed:Number = 0):void
        {
            var total:int = threads.length;

            if (total == 0)
                return;

            var i:int;
            var finishedThreads:Array = [];

            var thread:IRunnable;
            for (i = 0; i < total; i++)
            {
                thread = threads[i];

                thread.run(elapsed);
                if (!thread.isRunning())
                    finishedThreads.push(thread);
            }

            if(finishedThreads.length > 0)
                removeThreads.apply(this, finishedThreads);
        }

        public function removeThreads(...threads):void
        {
            trace("Remove Threads", threads);
            var thread:IRunnable;
            for each(thread in threads)
            {
                removeThread(thread);
            }
        }

        public function removeThread(value:IRunnable):IRunnable
        {
            var index:int = threads.indexOf(value);
            if (index == -1)
                return null;

            threads.splice(index, 1);
            return value;
        }
    }
}
