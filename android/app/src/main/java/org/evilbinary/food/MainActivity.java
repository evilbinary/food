package org.evilbinary.food;

import android.content.ComponentName;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Bundle;
import android.os.IBinder;
import android.util.Log;
import android.widget.Toast;

import net.posprinter.posprinterface.IMyBinder;
import net.posprinter.posprinterface.ProcessData;
import net.posprinter.posprinterface.TaskCallback;
import net.posprinter.service.PosprinterService;
import net.posprinter.utils.DataForSendToPrinterPos58;
import net.posprinter.utils.StringUtils;
import net.printer.print.PrintActivity;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

import androidx.annotation.Nullable;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StringCodec;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL_NATIVE = "org.evilbinary.flutter/native";
    private static final String CHANNEL_MESSAGE = "org.evilbinary.flutter/message";
    private FlutterEngine flutterEngine;

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


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        flutterEngine = this.getFlutterEngine();
        GeneratedPluginRegistrant.registerWith(this.getFlutterEngine());
        MethodChannel nativeChannel = new MethodChannel(flutterEngine.getDartExecutor()
                .getBinaryMessenger(), CHANNEL_NATIVE);
        nativeChannel.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                switch (methodCall.method) {
                    case "startActivity":   // 跳转原生页面
                        Intent intent = new Intent();
                        intent.setClassName(MainActivity.this, methodCall.arguments.toString());
                        startActivity(intent);
                        result.success("Activity -> Flutter 接收回调的返回值成功");
                        break;
                    default:
                        result.notImplemented();
                        break;
                }
            }
        });

        final BasicMessageChannel channel = new BasicMessageChannel<String>(flutterEngine.getDartExecutor()
                .getBinaryMessenger(), CHANNEL_MESSAGE, StringCodec.INSTANCE);
        channel.setMessageHandler(new BasicMessageChannel.MessageHandler() {
            @Override
            public void onMessage(Object o, BasicMessageChannel.Reply reply) {
                try {
                   printSample(o.toString(),reply);
                } catch (Exception e) {
                    e.printStackTrace();
                    reply.reply("打印失败,"+e.getMessage());
                }


            }
        });

        //bind service，get imyBinder
        Intent intent =new Intent(this, PosprinterService.class);
        bindService(intent,mSerconnection,BIND_AUTO_CREATE);

    }

    private int printSample(String data,BasicMessageChannel.Reply reply) {
        if (PrintActivity.ISCONNECT) {
            MainActivity.myBinder.WriteSendData(new TaskCallback() {
                @Override
                public void OnSucceed() {
                    //Toast.makeText(getApplicationContext(), getString(R.string.con_success), Toast.LENGTH_SHORT).show();
                    reply.reply("打印成功");
                }

                @Override
                public void OnFailed() {
                    //Toast.makeText(getApplicationContext(), getString(R.string.con_failed), Toast.LENGTH_SHORT).show();
                    reply.reply("打印失败");
                }
            }, new ProcessData() {
                @Override
                public List<byte[]> processDataBeforeSend() {
                    List<byte[]> list = new ArrayList<>();
                    try {
                        JSONObject jsonObject = new JSONObject(data);
                        String shopName=jsonObject.getString("shopName");
                        int total=jsonObject.getInt("total");//总价格
                        int count=jsonObject.getInt("count");//数量
                        JSONArray goods=jsonObject.getJSONArray("goods");

                        list.add(DataForSendToPrinterPos58.initializePrinter());
                        list.add(DataForSendToPrinterPos58.printAndFeedLine());
                        list.add(DataForSendToPrinterPos58.setAbsolutePrintPosition(50, 00));//设置初始位置
                        list.add(DataForSendToPrinterPos58.selectCharacterSize(17));//字体放大一倍
                        list.add(StringUtils.strTobytes(shopName));
                        list.add(DataForSendToPrinterPos58.printAndFeedLine());

                        Date date = new Date();
                        SimpleDateFormat ft = new SimpleDateFormat ("yyyy-MM-dd hh:mm:ss");
                        list.add(DataForSendToPrinterPos58.initializePrinter());
                        list.add(DataForSendToPrinterPos58.setAbsolutePrintPosition(0, 00));
                        list.add(StringUtils.strTobytes("订单时间："+ft.format(date)));
                        list.add(DataForSendToPrinterPos58.printAndFeedLine());

                        list.add(DataForSendToPrinterPos58.initializePrinter());
                        list.add(DataForSendToPrinterPos58.setAbsolutePrintPosition(0, 00));
                        list.add(StringUtils.strTobytes("--------------------------------"));
                        list.add(DataForSendToPrinterPos58.printAndFeedLine());

                        list.add(DataForSendToPrinterPos58.initializePrinter());
                        for(int i=0;i<goods.length();i++){
                            JSONObject good= goods.getJSONObject(i);
                            list.add(DataForSendToPrinterPos58.initializePrinter());
                            list.add(DataForSendToPrinterPos58.selectCharacterSize(1));
                            list.add(DataForSendToPrinterPos58.setAbsolutePrintPosition(0, 00));
                            list.add(StringUtils.strTobytes(good.getString("title")));
                            list.add(DataForSendToPrinterPos58.setAbsolutePrintPosition(180, 00));
                            list.add(StringUtils.strTobytes(" "+good.getInt("count")+"份"));
                            list.add(DataForSendToPrinterPos58.setAbsolutePrintPosition(240, 00));
                            list.add(StringUtils.strTobytes(" "+(good.getDouble("price")*good.getInt("count"))+"元"));
                            list.add(DataForSendToPrinterPos58.printAndFeedLine());
                        }
                        list.add(DataForSendToPrinterPos58.initializePrinter());
                        list.add(StringUtils.strTobytes("--------------------------------"));
                        list.add(DataForSendToPrinterPos58.printAndFeedLine());

                        list.add(DataForSendToPrinterPos58.initializePrinter());
                        list.add(DataForSendToPrinterPos58.selectCharacterSize(17));
                        list.add(DataForSendToPrinterPos58.setAbsolutePrintPosition(0, 00));
                        list.add(StringUtils.strTobytes(""+count+"份"));
                        list.add(DataForSendToPrinterPos58.setAbsolutePrintPosition(240, 00));
                        list.add(StringUtils.strTobytes(" "+total+"元"));
                        list.add(DataForSendToPrinterPos58.printAndFeedLine());
                        list.add(DataForSendToPrinterPos58.printAndFeedLine());
                        list.add(DataForSendToPrinterPos58.printAndFeedLine());
                        list.add(DataForSendToPrinterPos58.printAndFeedLine());

                    } catch (JSONException e) {
                        e.printStackTrace();
                        reply.reply("打印异常,"+e.getMessage());
                    }
                    return list;
                }
            });
        } else {
            Toast.makeText(getApplicationContext(), getString(R.string.connect_first), Toast.LENGTH_SHORT).show();
        }
        return -1;
    }
}
