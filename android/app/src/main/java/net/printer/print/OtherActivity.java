package net.printer.print;

import android.app.Activity;
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
import net.posprinter.utils.DataForSendToPrinterPos58;
import net.posprinter.utils.DataForSendToPrinterPos76;
import net.posprinter.utils.StringUtils;

import org.evilbinary.food.R;

import java.util.ArrayList;
import java.util.List;

public class OtherActivity extends Activity implements View.OnClickListener{



    private Button text,pic,sample;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_z76);
        initView();
    }

    private void initView(){
        text =findViewById(R.id.bt_76text);
        pic = findViewById(R.id.bt_76bitmap);
        sample = findViewById(R.id.bt_58iidsample);

        text.setOnClickListener(this);
        pic.setOnClickListener(this);
        sample.setOnClickListener(this);

    }

    @Override
    public void onClick(View view) {
        switch (view.getId()){
            case R.id.bt_76text:
                text();
                break;
            case  R.id.bt_76bitmap:
                printBitmap();
                break;
            case  R.id.bt_58iidsample:
                sample();
                break;
        }

    }

    /**
     * 打印文本
     */
    private void text(){
        if (PrintActivity.ISCONNECT){
            PrintActivity.myBinder.WriteSendData(new TaskCallback() {
                @Override
                public void OnSucceed() {
                    Toast.makeText(getApplicationContext(),getString(R.string.con_success), Toast.LENGTH_SHORT).show();

                }

                @Override
                public void OnFailed() {
                    Toast.makeText(getApplicationContext(),getString(R.string.con_failed), Toast.LENGTH_SHORT).show();
                }
            }, new ProcessData() {
                @Override
                public List<byte[]> processDataBeforeSend() {
                    List<byte[]> list = new ArrayList<>();
//                    list.add(DataForSendToPrinterPos58.initializePrinter());
                    list.add(StringUtils.strTobytes("welcome to use the impact and thermal printer"));
                    list.add(DataForSendToPrinterPos76.printAndFeedLine());
                    return list;
                }
            });
        }else {
            Toast.makeText(getApplicationContext(),getString(R.string.connect_first), Toast.LENGTH_SHORT).show();
        }
    }


    /**
     *
     * 76图片
     */
    private void printBitmap(){
        if (PrintActivity.ISCONNECT){
            final Bitmap bitmap1 =  BitmapProcess.compressBmpByYourWidth
                    (BitmapFactory.decodeResource(getResources(), R.drawable.test),508);
            PrintActivity.myBinder.WriteSendData(new TaskCallback() {
                @Override
                public void OnSucceed() {
                    Toast.makeText(getApplicationContext(),getString(R.string.con_success), Toast.LENGTH_SHORT).show();

                }

                @Override
                public void OnFailed() {
                    Toast.makeText(getApplicationContext(),getString(R.string.con_failed), Toast.LENGTH_SHORT).show();
                }
            }, new ProcessData() {
                @Override
                public List<byte[]> processDataBeforeSend() {
                    List<byte[]> list = new ArrayList<>();
                    list.add(DataForSendToPrinterPos76.initializePrinter());
                    list.add(DataForSendToPrinterPos76.selectBmpModel(0,bitmap1, BitmapToByteData.BmpType.Dithering));
                    list.add(DataForSendToPrinterPos76.printAndFeedLine());
                    return list;
                }
            });
        }else {
            Toast.makeText(getApplicationContext(),getString(R.string.connect_first), Toast.LENGTH_SHORT).show();
        }
    }


    /**
     * 票据标签
     */
    private void sample(){
        if (PrintActivity.ISCONNECT){
            PrintActivity.myBinder.WriteSendData(new TaskCallback() {
                @Override
                public void OnSucceed() {
                    Toast.makeText(getApplicationContext(),getString(R.string.con_success), Toast.LENGTH_SHORT).show();

                }

                @Override
                public void OnFailed() {
                    Toast.makeText(getApplicationContext(),getString(R.string.con_failed), Toast.LENGTH_SHORT).show();
                }
            }, new ProcessData() {
                @Override
                public List<byte[]> processDataBeforeSend() {
                    List<byte[]> list = new ArrayList<>();
                    list.add(DataForSendToPrinterPos58.openOrCloseLableModelInReceip(true));
                    list.add(DataForSendToPrinterPos58.setTheLableWidth(40));
                    list.add(DataForSendToPrinterPos58.initializePrinter());
                    list.add(DataForSendToPrinterPos58.setAbsolutePrintPosition(50,00));//设置初始位置
                    list.add(DataForSendToPrinterPos58.selectCharacterSize(17));//字体放大一倍
                    list.add(StringUtils.strTobytes("商品"));
                    list.add(DataForSendToPrinterPos58.setAbsolutePrintPosition(250,00));
                    list.add(StringUtils.strTobytes("价格"));
                    list.add(DataForSendToPrinterPos58.printAndFeedLine());
                    list.add(DataForSendToPrinterPos58.printAndFeedLine());

                    list.add(DataForSendToPrinterPos58.initializePrinter());
                    list.add(DataForSendToPrinterPos58.setAbsolutePrintPosition(30,00));
                    list.add(StringUtils.strTobytes("黄焖鸡"));
                    list.add(DataForSendToPrinterPos58.setAbsolutePrintPosition(220,00));
                    list.add(StringUtils.strTobytes("5元"));
                    list.add(DataForSendToPrinterPos58.printAndFeedLine());

                    list.add(DataForSendToPrinterPos58.initializePrinter());
                    list.add(DataForSendToPrinterPos58.setAbsolutePrintPosition(30,00));
                    list.add(StringUtils.strTobytes("黄焖鸡呀"));
                    list.add(DataForSendToPrinterPos58.setAbsolutePrintPosition(220,00));
                    list.add(StringUtils.strTobytes("6元"));
                    list.add(DataForSendToPrinterPos58.printAndFeedLine());
                    list.add(DataForSendToPrinterPos58.endOfLable());
                    return list;
                }
            });
        }else {
            Toast.makeText(getApplicationContext(),getString(R.string.connect_first), Toast.LENGTH_SHORT).show();
        }
    }

}
