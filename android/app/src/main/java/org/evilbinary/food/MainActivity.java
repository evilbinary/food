package org.evilbinary.food;

import android.content.Intent;
import android.os.Bundle;
import android.widget.Toast;

import net.posprinter.posprinterface.ProcessData;
import net.posprinter.posprinterface.TaskCallback;
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
                    printSample(o.toString());
                    reply.reply("打印成功");
                } catch (Exception e) {
                    e.printStackTrace();
                }


            }
        });
    }

    private void printSample(String data) {
        if (PrintActivity.ISCONNECT) {
            PrintActivity.myBinder.WriteSendData(new TaskCallback() {
                @Override
                public void OnSucceed() {
                    Toast.makeText(getApplicationContext(), getString(R.string.con_success), Toast.LENGTH_SHORT).show();

                }

                @Override
                public void OnFailed() {
                    Toast.makeText(getApplicationContext(), getString(R.string.con_failed), Toast.LENGTH_SHORT).show();
                }
            }, new ProcessData() {
                @Override
                public List<byte[]> processDataBeforeSend() {
                    List<byte[]> list = new ArrayList<>();
                    try {
                        JSONObject jsonObject = new JSONObject(data);
                        int total=jsonObject.getInt("total");//总价格
                        int count=jsonObject.getInt("count");//数量
                        JSONArray goods=jsonObject.getJSONArray("goods");
                        for(int i=0;i<goods.length();i++){
                            
                        }
                        list.add(DataForSendToPrinterPos58.initializePrinter());
                        list.add(DataForSendToPrinterPos58.setAbsolutePrintPosition(50, 00));//设置初始位置
                        list.add(DataForSendToPrinterPos58.selectCharacterSize(17));//字体放大一倍
                        list.add(StringUtils.strTobytes("商品"));
                        list.add(DataForSendToPrinterPos58.setAbsolutePrintPosition(250, 00));
                        list.add(StringUtils.strTobytes("价格"));
                        list.add(DataForSendToPrinterPos58.printAndFeedLine());
                        list.add(DataForSendToPrinterPos58.printAndFeedLine());

                        list.add(DataForSendToPrinterPos58.initializePrinter());
                        list.add(DataForSendToPrinterPos58.setAbsolutePrintPosition(30, 00));
                        list.add(StringUtils.strTobytes("黄焖鸡"));
                        list.add(DataForSendToPrinterPos58.setAbsolutePrintPosition(220, 00));
                        list.add(StringUtils.strTobytes("5元"));
                        list.add(DataForSendToPrinterPos58.printAndFeedLine());

                        list.add(DataForSendToPrinterPos58.initializePrinter());
                        list.add(DataForSendToPrinterPos58.setAbsolutePrintPosition(30, 00));
                        list.add(StringUtils.strTobytes("黄焖鸡呀"));
                        list.add(DataForSendToPrinterPos58.setAbsolutePrintPosition(220, 00));
                        list.add(StringUtils.strTobytes("6元"));
                        list.add(DataForSendToPrinterPos58.printAndFeedLine());

                        list.add(DataForSendToPrinterPos58.initializePrinter());
                        list.add(DataForSendToPrinterPos58.setAbsolutePrintPosition(30, 00));
                        list.add(StringUtils.strTobytes("黄焖鸡"));
                        list.add(DataForSendToPrinterPos58.setAbsolutePrintPosition(220, 00));
                        list.add(StringUtils.strTobytes("7元"));
                        list.add(DataForSendToPrinterPos58.printAndFeedLine());

                        list.add(DataForSendToPrinterPos58.initializePrinter());
                        list.add(DataForSendToPrinterPos58.setAbsolutePrintPosition(30, 00));
                        list.add(StringUtils.strTobytes("黄焖鸡"));
                        list.add(DataForSendToPrinterPos58.setAbsolutePrintPosition(220, 00));
                        list.add(StringUtils.strTobytes("8元"));
                        list.add(DataForSendToPrinterPos58.printAndFeedLine());

                        list.add(DataForSendToPrinterPos58.initializePrinter());
                        list.add(DataForSendToPrinterPos58.setAbsolutePrintPosition(30, 00));
                        list.add(StringUtils.strTobytes("黄焖鸡"));
                        list.add(DataForSendToPrinterPos58.setAbsolutePrintPosition(220, 00));
                        list.add(StringUtils.strTobytes("9元"));
                        list.add(DataForSendToPrinterPos58.printAndFeedLine());

                        list.add(DataForSendToPrinterPos58.initializePrinter());
                        list.add(DataForSendToPrinterPos58.setAbsolutePrintPosition(30, 00));
                        list.add(StringUtils.strTobytes("黄焖鸡"));
                        list.add(DataForSendToPrinterPos58.setAbsolutePrintPosition(220, 00));
                        list.add(StringUtils.strTobytes("10元"));
                        list.add(DataForSendToPrinterPos58.printAndFeedLine());

                    } catch (JSONException e) {
                        e.printStackTrace();
                    }


                    return list;
                }
            });
        } else {
            Toast.makeText(getApplicationContext(), getString(R.string.connect_first), Toast.LENGTH_SHORT).show();
        }
    }
}
