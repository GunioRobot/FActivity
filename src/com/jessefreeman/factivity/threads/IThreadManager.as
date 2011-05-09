/**
 * Created by IntelliJ IDEA.
 * User: jessefreeman
 * Date: 5/9/11
 * Time: 10:40 AM
 * To change this template use File | Settings | File Templates.
 */
package com.jessefreeman.factivity.threads
{
    import com.jessefreeman.factivity.activities.IUpdate;

    public interface IThreadManager extends IUpdate
    {
        function addThread(value:IRunnable):int;

        function removeThreads(...threads):void;

        function removeThread(value:IRunnable):IRunnable;
    }
}
