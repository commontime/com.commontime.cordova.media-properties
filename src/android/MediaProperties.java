package com.commontime.plugin;

import android.media.MediaPlayer;
import android.net.Uri;
import android.webkit.MimeTypeMap;

import org.apache.cordova.*;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class MediaProperties extends CordovaPlugin {

    @Override
    public boolean execute(String action, final JSONArray data, final CallbackContext callbackContext) throws JSONException
    {
        cordova.getThreadPool().execute(new Runnable()
        {
            @Override
            public void run()
            {
                try
                {
                    JSONObject mediaInfo = getMediaInfo(data.getString(0));
                    if(mediaInfo != null)
                        callbackContext.success(mediaInfo);
                    else
                        callbackContext.error("Error getting media info");
                }
                catch(Exception e)
                {
                    callbackContext.error("Error getting media info");
                }
            }
        });

        return true;
    }

    private JSONObject getMediaInfo(String path)
    {
        MediaPlayer mPlayer = null;

        try
        {
            if (path.contains("cdvfile://"))
            {
                CordovaResourceApi resourceApi = webView.getResourceApi();
                Uri fileURL = resourceApi.remapUri(Uri.parse(path));
                path = fileURL.getPath();
            }
            else
            {
                path = path.replace("file://", "");
            }

            mPlayer = new MediaPlayer();
            mPlayer.setDataSource(path);
            mPlayer.prepare();
            long duration = mPlayer.getDuration();
            mPlayer.release();

            JSONObject mediaInfo = new JSONObject();

            long seconds = duration / 1000;
            String mimeType = getMimeType(path);

            mediaInfo.put("duration", seconds);
            if(mimeType != null)
                mediaInfo.put("contentType", mimeType);

            return mediaInfo;
        }
        catch (Exception e)
        {
            if(mPlayer != null)
                mPlayer.release();
            return null;
        }
    }

    public static String getMimeType(String path)
    {
        try
        {
            String type = null;
            String extension = null;
            int i = path.lastIndexOf('.');
            if (i > 0)
                extension = path.substring(i+1);
            if (extension != null)
                type = MimeTypeMap.getSingleton().getMimeTypeFromExtension(extension);
            return type;
        }
        catch(Exception e)
        {
            return null;
        }
    }
}