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
 * This code was taken from FlxGame (https://github.com/AdamAtomic/flixel/blob/master/org/flixel/FlxGame.as) and
 * modified for this game.
 * Original Author Adam 'Atomic' Saltsman
 *
 */

package com.jessefreeman.factivity.sounds
{
    import com.jessefreeman.factivity.managers.*;
    import com.jessefreeman.factivity.sounds.FActivitySound;
    import com.jessefreeman.factivity.utils.ClassUtil;

    public class SoundManager implements ISoundManager
    {

        private var sounds:Array = [];
        private var music:FActivitySound;
        private var _mute:Boolean = false;
        private var _volume:Number = 1;
        private var activeMusic:String;

        public function SoundManager()
        {
        }

        public function playMusic(Music:Class, Volume:Number = 1.0):void
        {
            var soundClassName:String = ClassUtil.classToString(Music);

            if (activeMusic == soundClassName)
                return;

            if (music == null)
                music = new FActivitySound(this);
            else if (music.active)
                music.stop();
            music.loadEmbedded(Music, true);
            music.volume = Volume;
            music.survive = true;
            music.play();
            activeMusic = soundClassName;
        }

        public function play(EmbeddedSound:Class, Volume:Number = 1.0, Looped:Boolean = false):FActivitySound
        {
            var sl:uint = sounds.length;
            for (var i:uint = 0; i < sl; i++)
                if (!(sounds[i] as FActivitySound).active)
                    break;
            if (sounds[i] == null)
                sounds[i] = new FActivitySound(this);
            var s:FActivitySound = sounds[i];
            s.loadEmbedded(EmbeddedSound, Looped);
            s.volume = Volume;
            s.play();
            return s;
        }

        public function get mute():Boolean
        {
            return _mute;
        }

        public function set mute(Mute:Boolean):void
        {
            _mute = Mute;
            changeSounds();
        }

        public function getMuteValue():uint
        {
            if (_mute)
                return 0;
            else
                return 1;
        }

        public function get volume():Number
        {
            return _volume;
        }

        public function set volume(Volume:Number):void
        {
            _volume = Volume;
            if (_volume < 0)
                _volume = 0;
            else if (_volume > 1)
                _volume = 1;
            changeSounds();
        }

        public function destroySounds(ForceDestroy:Boolean = false):void
        {
            if (sounds == null)
                return;
            if ((music != null) && (ForceDestroy || !music.survive))
                music.destroy();
            var s:FActivitySound;
            var sl:uint = sounds.length;
            for (var i:uint = 0; i < sl; i++)
            {
                s = sounds[i] as FActivitySound;
                if ((s != null) && (ForceDestroy || !s.survive))
                    s.destroy();
            }

            activeMusic = null;
        }

        public function changeSounds():void
        {
            if ((music != null) && music.active)
                music.updateTransform();
            var s:FActivitySound;
            var sl:uint = sounds.length;
            for (var i:uint = 0; i < sl; i++)
            {
                s = sounds[i] as FActivitySound;
                if ((s != null) && s.active)
                    s.updateTransform();
            }
        }

        public function pauseSounds():void
        {
            if ((music != null) && music.active)
                music.pause();
            var s:FActivitySound;
            var sl:uint = sounds.length;
            for (var i:uint = 0; i < sl; i++)
            {
                s = sounds[i] as FActivitySound;
                if ((s != null) && s.active)
                    s.pause();
            }
        }

        public function playSounds():void
        {
            if ((music != null) && music.active)
                music.play();
            var s:FActivitySound;
            var sl:uint = sounds.length;
            for (var i:uint = 0; i < sl; i++)
            {
                s = sounds[i] as FActivitySound;
                if ((s != null) && s.active)
                    s.play();
            }
        }
    }
}
