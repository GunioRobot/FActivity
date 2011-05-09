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
    import flash.display.Stage;
    import flash.system.Capabilities;

    public class DeviceUtil
    {
        public static const ANDROID:String = "AND";
        public static const IOS:String = "IOS";
        public static const PLAYBOOK:String = "QNX";

        private static var mobileDeviceIDs:Array = [ANDROID, IOS, PLAYBOOK];

        /**
         * Returns the current os the application is running on. This is a 3 character value:
         * OSX, WIN, AND, IOS, QNX
         */
        public static function get os():String
        {
            return Capabilities.version.substr(0, 3);
        }

        /**
         * This returns the screen width based on the device your application is running on. If it is on mobile you
         * will get the full screen width. If you are on desktop you will get the stage width.
         *
         * @param stage - requires a reference to the stage in order to get the correct size.
         * @return
         */
        public static function getScreenWidth(stage:Stage):int
        {
            return isMobile() ? stage.fullScreenWidth : stage.stageWidth;
        }

        /**
         * This returns the screen height based on the device your application is running on. If it is on mobile you
         * will get the full screen height. If you are on desktop you will get the stage height.
         *
         * @param stage
         * @return
         */
        public static function getScreenHeight(stage:Stage):int
        {
            return isMobile() ? stage.fullScreenHeight : stage.stageHeight;
        }

        /**
         * Returns if the application is running on a mobile device.
         *
         * @return
         */
        public static function isMobile():Boolean
        {
            return (mobileDeviceIDs.indexOf(os) != -1);
        }


    }
}
