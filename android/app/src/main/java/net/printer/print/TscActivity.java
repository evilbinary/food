package net.printer.print;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

import net.posprinter.posprinterface.ProcessData;
import net.posprinter.posprinterface.TaskCallback;
import net.posprinter.utils.BitmapProcess;
import net.posprinter.utils.BitmapToByteData;
import net.posprinter.utils.DataForSendToPrinterTSC;

import org.evilbinary.food.MainActivity;
import org.evilbinary.food.R;

import java.util.ArrayList;
import java.util.List;

import androidx.appcompat.app.AppCompatActivity;

public class TscActivity extends AppCompatActivity implements View.OnClickListener{

    private Button content,text,barcode,qrcode,bitmap;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_tsc);
        initView();
    }

    private void initView(){
        content = findViewById(R.id.bt_tsp);
        text = findViewById(R.id.bt_text);
        barcode =findViewById(R.id.bt_barcode);
        qrcode = findViewById(R.id.bt_qr);
        bitmap = findViewById(R.id.bt_bitmap);

        content.setOnClickListener(this);
        text.setOnClickListener(this);
        barcode.setOnClickListener(this);
        qrcode.setOnClickListener(this);
        bitmap.setOnClickListener(this);


    }

    @Override
    public void onClick(View view) {

        switch (view.getId()){
            case R.id.bt_tsp:
                printContent();
                break;
            case R.id.bt_text:
                printText();
                break;
            case   R.id.bt_barcode:
                printBarcode();
                break;
            case R.id.bt_qr:
                printQR();
                break;
            case R.id.bt_bitmap:
                printbitmap();
                break;
        }

    }


    //打印文本
    private void printContent(){
        if (PrintActivity.ISCONNECT){

            MainActivity.myBinder.WriteSendData(new TaskCallback() {
                @Override
                public void OnSucceed() {
                    Toast.makeText(getApplicationContext(),getString(R.string.send_success), Toast.LENGTH_SHORT).show();
                }

                @Override
                public void OnFailed() {
                    Toast.makeText(getApplicationContext(),getString(R.string.send_failed), Toast.LENGTH_SHORT).show();

                }
            }, new ProcessData() {
                @Override
                public List<byte[]> processDataBeforeSend() {
                    List<byte[]> list = new ArrayList<>();
                    //设置标签纸大小
                    list.add(DataForSendToPrinterTSC.sizeBymm(50,30));
                    //设置间隙
                    list.add(DataForSendToPrinterTSC.gapBymm(2,0));
                    //清除缓存
                    list.add(DataForSendToPrinterTSC.cls());
                    //设置方向
                    list.add(DataForSendToPrinterTSC.direction(0));
                    //线条
                    list.add(DataForSendToPrinterTSC.bar(10,10,200,3));
                    //条码
                    list.add(DataForSendToPrinterTSC.barCode(10,45,"128",100,1,0,2,2,"abcdef12345"));
                    //文本,简体中文是TSS24.BF2,可参考编程手册中字体的代号
                    list.add(DataForSendToPrinterTSC.text(220,10,"TSS24.BF2",0,1,1,"这是测试文本"));
                    //打印
                    list.add(DataForSendToPrinterTSC.print(1));

                    return list;
                }
            });

        }else {
            Toast.makeText(getApplicationContext(),getString(R.string.connect_first), Toast.LENGTH_SHORT).show();
        }
    }

    //打印文本
    private void printText(){

        if (PrintActivity.ISCONNECT){

            MainActivity.myBinder.WriteSendData(new TaskCallback() {
                @Override
                public void OnSucceed() {
                    Toast.makeText(getApplicationContext(),getString(R.string.send_success), Toast.LENGTH_SHORT).show();
                }

                @Override
                public void OnFailed() {
                    Toast.makeText(getApplicationContext(),getString(R.string.send_failed), Toast.LENGTH_SHORT).show();

                }
            }, new ProcessData() {
                @Override
                public List<byte[]> processDataBeforeSend() {
                    List<byte[]> list = new ArrayList<>();
                    //设置标签纸大小
                    list.add(DataForSendToPrinterTSC.sizeBymm(50,30));
                    //设置间隙
                    list.add(DataForSendToPrinterTSC.gapBymm(2,0));
                    //清除缓存
                    list.add(DataForSendToPrinterTSC.cls());
                    //设置方向
                    list.add(DataForSendToPrinterTSC.direction(0));
                    //线条
//                    list.add(DataForSendToPrinterTSC.bar(10,10,200,3));
                    //条码
//                    list.add(DataForSendToPrinterTSC.barCode(10,15,"128",100,1,0,2,2,"abcdef12345"));
                    //文本
                    list.add(DataForSendToPrinterTSC.text(10,30,"TSS24.BF2",0,1,1,"abcasdjknf"));
                    //打印
                    list.add(DataForSendToPrinterTSC.print(1));

                    return list;
                }
            });

        }else {
            Toast.makeText(getApplicationContext(),getString(R.string.connect_first), Toast.LENGTH_SHORT).show();
        }

    }

    private void printBarcode(){
        if (PrintActivity.ISCONNECT){

            MainActivity.myBinder.WriteSendData(new TaskCallback() {
                @Override
                public void OnSucceed() {
                    Toast.makeText(getApplicationContext(),getString(R.string.send_success), Toast.LENGTH_SHORT).show();
                }

                @Override
                public void OnFailed() {
                    Toast.makeText(getApplicationContext(),getString(R.string.send_failed), Toast.LENGTH_SHORT).show();

                }
            }, new ProcessData() {
                @Override
                public List<byte[]> processDataBeforeSend() {
                    List<byte[]> list = new ArrayList<>();
                    //设置标签纸大小
                    list.add(DataForSendToPrinterTSC.sizeBymm(50,30));
                    //设置间隙
                    list.add(DataForSendToPrinterTSC.gapBymm(2,0));
                    //清除缓存
                    list.add(DataForSendToPrinterTSC.cls());
                    //设置方向
                    list.add(DataForSendToPrinterTSC.direction(0));
                    //线条
//                    list.add(DataForSendToPrinterTSC.bar(10,10,200,3));
                    //条码
                    list.add(DataForSendToPrinterTSC.barCode(10,15,"128",100,1,0,2,2,"abcdef12345"));
                    //文本
//                    list.add(DataForSendToPrinterTSC.text(10,30,"1",0,1,1,"abcasdjknf"));
                    //打印
                    list.add(DataForSendToPrinterTSC.print(1));

                    return list;
                }
            });

        }else {
            Toast.makeText(getApplicationContext(),getString(R.string.connect_first), Toast.LENGTH_SHORT).show();
        }
    }

    private void printQR(){
        if (PrintActivity.ISCONNECT){

            MainActivity.myBinder.WriteSendData(new TaskCallback() {
                @Override
                public void OnSucceed() {
                    Toast.makeText(getApplicationContext(),getString(R.string.send_success), Toast.LENGTH_SHORT).show();
                }

                @Override
                public void OnFailed() {
                    Toast.makeText(getApplicationContext(),getString(R.string.send_failed), Toast.LENGTH_SHORT).show();

                }
            }, new ProcessData() {
                @Override
                public List<byte[]> processDataBeforeSend() {
                    List<byte[]> list = new ArrayList<>();
                    //设置标签纸大小
                    list.add(DataForSendToPrinterTSC.sizeBymm(50,30));
                    //设置间隙
                    list.add(DataForSendToPrinterTSC.gapBymm(2,0));
                    //清除缓存
                    list.add(DataForSendToPrinterTSC.cls());
                    //设置方向
                    list.add(DataForSendToPrinterTSC.direction(0));
                    //具体参数值请参看编程手册
                    list.add(DataForSendToPrinterTSC.qrCode(10,20,"M",3,"A",0,"M1","S3","123456789"));
                    //打印
                    list.add(DataForSendToPrinterTSC.print(1));

                    return list;
                }
            });

        }else {
            Toast.makeText(getApplicationContext(),getString(R.string.connect_first), Toast.LENGTH_SHORT).show();
        }
    }

    private void printbitmap(){
        final Bitmap bitmap1 =  BitmapProcess.compressBmpByYourWidth
                (BitmapFactory.decodeResource(getResources(), R.drawable.test),150);
        MainActivity.myBinder.WriteSendData(new TaskCallback() {
            @Override
            public void OnSucceed() {
                Toast.makeText(getApplicationContext(),getString(R.string.send_success), Toast.LENGTH_SHORT).show();

            }

            @Override
            public void OnFailed() {
                Toast.makeText(getApplicationContext(),getString(R.string.send_failed), Toast.LENGTH_SHORT).show();

            }
        }, new ProcessData() {
            @Override
            public List<byte[]> processDataBeforeSend() {

                List<byte[]> list = new ArrayList<>();
                //设置标签纸大小
                list.add(DataForSendToPrinterTSC.sizeBymm(50,30));
                //设置间隙
                list.add(DataForSendToPrinterTSC.gapBymm(2,0));
                //清除缓存
                list.add(DataForSendToPrinterTSC.cls());
                list.add(DataForSendToPrinterTSC.bitmap(10,10,0,bitmap1, BitmapToByteData.BmpType.Threshold));
                list.add(DataForSendToPrinterTSC.print(1));

                return list;
            }
        });
    }

}
