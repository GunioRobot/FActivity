/*
 *
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
 * /
 */

/**
 * Created by IntelliJ IDEA.
 * User: Jesse Freeman
 * Date: 2/25/11
 * Time: 7:43 PM
 * To change this template use File | Settings | File Templates.
 */
package com.jessefreeman.factivity.threads
{
    import com.jessefreeman.factivity.activities.IUpdate;

    import com.jessefreeman.factivity.threads.IRunnable;

    import flash.utils.Dictionary;

    public class ThreadManager implements IUpdate
    {
        private var maxActive:int;
        private var threads:Array = [];
        private var instances:Dictionary = new Dictionary(true);

        public function ThreadManager(maxActive:int = 4)
        {
            this.maxActive = maxActive;
        }

        public function addThread(value:IRunnable):int
        {

            if(!instances[value])
            {
                var index:int = threads.length < maxActive ? (threads.push(value)-1) : -1;
                instances[value] = index;
            }

            value.start();

            return instances[value];
        }

        public function update(elapsed:Number = 0):void
        {
            var total:int = threads.length;

            if(total == 0)
                return;

            var i:int;
            var thread:IRunnable;
            var finishedThreads:Array = [];

            for (i = 0; i < total; i++)
            {

                thread = threads[i];

                thread.run(elapsed);
                if(!thread.isRunning())
                    finishedThreads.push(thread);
            }

            removeThreads.apply(this, finishedThreads)
        }

        private function removeThreads(...threads):void
        {
            var thread:IRunnable;
            for each(thread in threads)
            {
                removeThread(thread);
            }
        }

        public function removeThread(value:IRunnable):IRunnable
        {
            var index:int = instances[value];
            threads.splice(index,1);
            delete instances[value];
            return value;
        }
    }
}
