package org.evilbinary.food;

import android.content.ComponentName;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.IBinder;
import android.util.Log;

import net.posprinter.posprinterface.IMyBinder;
import net.posprinter.service.PosprinterService;

import io.flutter.app.FlutterApplication;
import io.flutter.plugins.GeneratedPluginRegistrant;

/**
 * 作者:evilbinary on 2020/11/14.
 * 邮箱:rootdebug@163.com
 */
public class FoodApplication extends FlutterApplication {

    public static IMyBinder myBinder;

    ServiceConnection mSerconnection= new ServiceConnection() {
        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {
            myBinder= (IMyBinder) service;
            Log.e("myBinder","connect");
        }

        @Override
        public void onServiceDisconnected(ComponentName name) {
            Log.e("myBinder","disconnect");
        }
    };

    public int portType=0;//0是网络，1是蓝牙，2是USB
    public static boolean ISCONNECT=false;
    private static FoodApplication instance;

    @Override
    public void onCreate() {
        super.onCreate();
        instance = this;
        //bind service，get imyBinder
        Intent intent =new Intent(this, PosprinterService.class);
        bindService(intent,mSerconnection,BIND_AUTO_CREATE);
    }

    public static FoodApplication getMyApplication() {
        return instance;
    }
}
