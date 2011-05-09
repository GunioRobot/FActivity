/**
 * Created by IntelliJ IDEA.
 * User: jessefreeman
 * Date: 5/9/11
 * Time: 11:38 AM
 * To change this template use File | Settings | File Templates.
 */
package com.jessefreeman.factivity.sounds
{
    import com.jessefreeman.factivity.sounds.FActivitySound;

    public interface ISoundManager
    {
        /**
         * Set up and play a looping background soundtrack.
         *
         * @param    Music        The sound file you want to loop in the background.
         * @param    Volume        How loud the sound should be, from 0 to 1.
         */
        function playMusic(Music:Class, Volume:Number = 1.0):void;

        /**
         * Creates a new sound object from an embedded <code>Class</code> object.
         *
         * @param    EmbeddedSound    The sound you want to play.
         * @param    Volume            How loud to play it (0 to 1).
         * @param    Looped            Whether or not to loop this sound.
         *
         * @return    A <code>FlxSound</code> object.
         */
        function play(EmbeddedSound:Class, Volume:Number = 1.0, Looped:Boolean = false):FActivitySound;

        /**
         * Set <code>mute</code> to true to turn off the sound.
         *
         * @default false
         */
        function get mute():Boolean;

        /**
         * @private
         */
        function set mute(Mute:Boolean):void;

        /**
         * Get a number that represents the mute state that we can multiply into a sound transform.
         *
         * @return        An unsigned integer - 0 if muted, 1 if not muted.
         */
        function getMuteValue():uint;

        /**
         * Set <code>volume</code> to a number between 0 and 1 to change the global volume.
         *
         * @default 0.5
         */
        function get volume():Number;

        /**
         * @private
         */
        function set volume(Volume:Number):void;

        /**
         * Called by FlxGame on state changes to stop and destroy sounds.
         *
         * @param    ForceDestroy        Kill sounds even if they're flagged <code>survive</code>.
         */
        function destroySounds(ForceDestroy:Boolean = false):void;

        /**
         * An internal function that adjust the volume levels and the music channel after a change.
         */
        function changeSounds():void;

        /**
         * Internal helper, pauses all game sounds.
         */
        function pauseSounds():void;

        /**
         * Internal helper, pauses all game sounds.
         */
        function playSounds():void;
    }
}
