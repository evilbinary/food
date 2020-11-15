package org.evilbinary.food;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;

import androidx.annotation.Nullable;

/**
 * 作者:evilbinary on 2020/11/15.
 * 邮箱:rootdebug@163.com
 */
public class ConnectService  extends Service {
    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
}
