package org.evilbinary.food;

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.text.format.DateFormat;
import android.widget.Toast;

import net.posprinter.posprinterface.ProcessData;
import net.posprinter.posprinterface.TaskCallback;
import net.posprinter.utils.DataForSendToPrinterPos58;
import net.posprinter.utils.StringUtils;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Date;
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
    private FoodApplication app= (FoodApplication) getApplication();
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
                    if(!app.ISCONNECT) {
                        TaskCallback callback = new TaskCallback() {
                            @Override
                            public void OnSucceed() {
                                app.ISCONNECT = true;
                                printSample(o.toString(), reply);
                                Toast.makeText(getApplicationContext(), getString(R.string.con_success), Toast.LENGTH_SHORT).show();
                            }

                            @Override
                            public void OnFailed() {
                                app.ISCONNECT = false;
                                Toast.makeText(getApplicationContext(), getString(R.string.con_failed), Toast.LENGTH_SHORT).show();
                            }
                        };
                        connectType(callback);
                    }else {
                        printSample(o.toString(), reply);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    reply.reply("打印失败,"+e.getMessage());
                }


            }
        });
    }

    @Override
    protected void onResume() {
        super.onResume();
        TaskCallback callback = new TaskCallback() {
            @Override
            public void OnSucceed() {
                app.ISCONNECT = true;
                Toast.makeText(getApplicationContext(), getString(R.string.con_success), Toast.LENGTH_SHORT).show();
            }

            @Override
            public void OnFailed() {
                app.ISCONNECT = false;
                Toast.makeText(getApplicationContext(), getString(R.string.con_failed), Toast.LENGTH_SHORT).show();
            }
        };
        connectType(callback);
    }

    private void connectType(TaskCallback callback) {
        if(!app.ISCONNECT) {
            SharedPreferences pref = getSharedPreferences("device", MODE_PRIVATE);
            String deviceAddress = pref.getString("address", "");
            int portType = pref.getInt("portType", -1);
            if (deviceAddress != null) {
                if (portType == 0) {
                    app.myBinder.ConnectNetPort(deviceAddress, 9100, callback);
                } else if (portType == 1) {
                    app.myBinder.ConnectBtPort(deviceAddress, callback);
                } else if (portType == 2) {
                    app.myBinder.ConnectUsbPort(getApplicationContext(), deviceAddress, callback);
                } else {
                    Toast.makeText(getApplicationContext(), "网络类型不对", Toast.LENGTH_SHORT).show();
                }
            }
        }
    }

    private int printSample(String data, BasicMessageChannel.Reply reply) {
        if (app.ISCONNECT) {
            app.myBinder.WriteSendData(new TaskCallback() {
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
                        String mark=jsonObject.getString("mark");
                        String no=jsonObject.getString("no");
                        int total=jsonObject.getInt("total");//总价格
                        int count=jsonObject.getInt("count");//数量
                        JSONArray goods=jsonObject.getJSONArray("goods");

                        list.add(DataForSendToPrinterPos58.initializePrinter());
                        list.add(DataForSendToPrinterPos58.printAndFeedLine());
                        list.add(DataForSendToPrinterPos58.setAbsolutePrintPosition(50, 00));//设置初始位置
                        list.add(DataForSendToPrinterPos58.selectCharacterSize(17));//字体放大一倍
                        list.add(StringUtils.strTobytes(shopName));
                        list.add(DataForSendToPrinterPos58.printAndFeedLine());

                        list.add(DataForSendToPrinterPos58.setAbsolutePrintPosition(0, 00));
                        list.add(StringUtils.strTobytes("取餐号："));
                        list.add(DataForSendToPrinterPos58.setAbsolutePrintPosition(240, 00));
                        list.add(StringUtils.strTobytes("#"+no));
                        list.add(DataForSendToPrinterPos58.printAndFeedLine());

                        Date date = new Date();
                        DateFormat ft = new DateFormat ();
                        list.add(DataForSendToPrinterPos58.initializePrinter());
                        list.add(DataForSendToPrinterPos58.setAbsolutePrintPosition(0, 00));

                        list.add(StringUtils.strTobytes("订单时间："+ft.format("yyyy-MM-dd hh:mm:ss",date)));
                        list.add(DataForSendToPrinterPos58.printAndFeedLine());

                        list.add(DataForSendToPrinterPos58.initializePrinter());
                        list.add(DataForSendToPrinterPos58.setAbsolutePrintPosition(0, 00));
                        list.add(StringUtils.strTobytes("--------------------------------"));
                        list.add(DataForSendToPrinterPos58.printAndFeedLine());

                        list.add(DataForSendToPrinterPos58.initializePrinter());
                        list.add(DataForSendToPrinterPos58.setAbsolutePrintPosition(0, 00));
                        list.add(DataForSendToPrinterPos58.selectCharacterSize(1));
                        list.add(StringUtils.strTobytes("备注："+mark));
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
