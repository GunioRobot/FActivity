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

package com.jessefreeman.factivity.utils
{
    import flash.utils.getTimer;

    public class TimeMethodExecutionUtil
    {
        public static var t:int;
        public static var threshold:int = 10;

        /**
         * This method allows you to trace out the execution time of any method.
         *
         * @param label - name used to display when tracing out.
         * @param target - function to call.
         * @param arguments - arguments to be supplied to function.
         * @return returns any value from the target function.
         */
        public static function execute(label:String, target:Function, ...arguments):*
        {
            t = getTimer();
            var value:* = target.apply(target, arguments);
            t = (getTimer() - t);
            if (t > threshold)
                trace("Method '" + label + "' executed in " + t + " ms\n");
            return value;
        }
    }
}
