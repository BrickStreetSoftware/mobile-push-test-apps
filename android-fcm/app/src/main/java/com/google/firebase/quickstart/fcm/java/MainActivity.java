/**
 * Copyright 2016 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.google.firebase.quickstart.fcm.java;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.RemoteMessage;
import com.google.firebase.quickstart.fcm.R;
import com.google.firebase.quickstart.fcm.databinding.ActivityMainBinding;

import java.util.Date;

public class MainActivity extends AppCompatActivity {

    private static final String TAG = "MainActivity";

    private static MainActivity activity;
    private static String firebaseToken = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ActivityMainBinding binding = ActivityMainBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        activity = this;

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            // Create channel to show notifications.
            String channelId  = getString(R.string.default_notification_channel_id);
            String channelName = getString(R.string.default_notification_channel_name);
            NotificationManager notificationManager =
                    getSystemService(NotificationManager.class);
            notificationManager.createNotificationChannel(new NotificationChannel(channelId,
                    channelName, NotificationManager.IMPORTANCE_LOW));
        }

        // If a notification message is tapped, any data accompanying the notification
        // message is available in the intent extras. In this sample the launcher
        // intent is fired when the notification is tapped, so any accompanying data would
        // be handled here. If you want a different intent fired, set the click_action
        // field of the notification message to the desired intent. The launcher intent
        // is used when no click_action is specified.
        //
        // Handle possible data accompanying notification message.
        // [START handle_data_extras]
        if (getIntent().getExtras() != null) {
            for (String key : getIntent().getExtras().keySet()) {
                Object value = getIntent().getExtras().get(key);
                Log.d(TAG, "Key: " + key + " Value: " + value);
            }
        }
        // [END handle_data_extras]

        /*
        binding.subscribeButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Log.d(TAG, "Subscribing to weather topic");
                // [START subscribe_topics]
                FirebaseMessaging.getInstance().subscribeToTopic("weather")
                        .addOnCompleteListener(new OnCompleteListener<Void>() {
                            @Override
                            public void onComplete(@NonNull Task<Void> task) {
                                String msg = getString(R.string.msg_subscribed);
                                if (!task.isSuccessful()) {
                                    msg = getString(R.string.msg_subscribe_failed);
                                }
                                Log.d(TAG, msg);
                                Toast.makeText(MainActivity.this, msg, Toast.LENGTH_SHORT).show();
                            }
                        });
                // [END subscribe_topics]
            }
        });
        */

        binding.logTokenButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // Get token
                // [START log_reg_token]
                FirebaseMessaging.getInstance().getToken()
                    .addOnCompleteListener(new OnCompleteListener<String>() {
                        @Override
                        public void onComplete(@NonNull Task<String> task) {
                          if (!task.isSuccessful()) {
                            Log.w(TAG, "Fetching FCM registration token failed", task.getException());
                            return;
                          }

                          // Get new FCM registration token
                          String token = task.getResult();
                          MainActivity.setToken(token);

                          activity.runOnUiThread(new Runnable() {
                              public void run() {
                                    TextView textView = (TextView)activity.findViewById(R.id.tokenView);
                                    textView.setText(token);
                                }
                            });

                          // Log and toast
                          String msg = getString(R.string.msg_token_fmt, token);
                          Log.d(TAG, msg);
                          Toast.makeText(MainActivity.this, msg, Toast.LENGTH_SHORT).show();
                          emailToken();
                        }
                    });
                // [END log_reg_token]
            }
        });
    }

    public static void setToken(String token){
        firebaseToken = token;
    }

    public static void displayNotification(RemoteMessage remoteMessage){
        final StringBuffer stringNotif = new StringBuffer();
        stringNotif.append(new Date().toString());
        stringNotif.append("\n\tFrom: " + remoteMessage.getFrom());
        if (remoteMessage.getData().size() > 0) {
            stringNotif.append("\n\tMessage data payload: " + remoteMessage.getData());
        }

        // Check if message contains a notification payload.
        if (remoteMessage.getNotification() != null) {
            stringNotif.append("\n\tMessage Notification Body: " + remoteMessage.getNotification().getBody());
        }

        activity.runOnUiThread(new Runnable() {
            public void run() {
                TextView textView = (TextView)activity.findViewById(R.id.dataView);
                textView.setText(stringNotif);
            }
        });
    }
    public void emailToken(){
        if(firebaseToken == null)
        {
            Log.w(TAG, "EmailToken: no token found.");
            return;
        }

        Intent i = new Intent(Intent.ACTION_SEND);
        i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        i.setType("message/rfc822");
        i.putExtra(Intent.EXTRA_EMAIL  , new String[]{"yourEmailt@example.com"});
        i.putExtra(Intent.EXTRA_SUBJECT, "Firebase Token");
        i.putExtra(Intent.EXTRA_TEXT   , "Token : " + firebaseToken);
        try {
            startActivity(Intent.createChooser(i, "Send mail..."));
        } catch (android.content.ActivityNotFoundException ex) {
            Toast toast = Toast.makeText(this.getApplicationContext(), "There are no email clients installed.", Toast.LENGTH_LONG);
            toast.show();

            toast = Toast.makeText(this.getApplicationContext(), "TOKEN : "+firebaseToken, Toast.LENGTH_LONG);
            toast.show();
        }
    }

}
