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
 */

package com.jessefreeman.factivity.threads.effects
{
    import com.jessefreeman.factivity.threads.Thread;

    import flash.text.TextField;

    public class CountUpTextEffect extends Thread
    {
        private var target:TextField;
        private var value:Number;
        private var speed:int;
        private var counter:int = 0;
        private var paddedText:String;

        public function CountUpTextEffect(target:TextField, updateCallback:Function = null, finishCallback:Function = null)
        {
            this.target = target;
            super(updateCallback, finishCallback);
        }

        public function resetValues(value:Number, initialValue:int = 0, speed:int = 1, paddedText:String = ""):void
        {
            counter = initialValue;
            this.speed = speed;
            this.paddedText = paddedText;
            this.value = value;
        }


        override public function start():void
        {
            updateText(counter);

            super.start();
        }

        override public function run(elapsed:Number = 0):void
        {
            super.run(elapsed);
            counter += speed;
            if (counter > value)
                counter = value;

            updateText(counter);

            if (counter == value)
                finish();
        }

        protected function updateText(value:int):void
        {
            target.htmlText = pad(paddedText, value.toString());
        }

        private function pad(padding:String, value:String):String
        {
            return padding.slice(0, padding.length - value.toString().length) + value.toString()
        }

        public function forceStop():void
        {
            counter = value;
            updateText(counter);

            if (counter == value)
                finish();
        }

    }
}
