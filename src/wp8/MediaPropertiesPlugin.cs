using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Windows.Storage;
using Windows.Storage.FileProperties;

using System.Diagnostics;

using Newtonsoft.Json.Linq;

namespace WPCordovaClassLib.Cordova.Commands
{
  public sealed class MediaPropertiesPlugin : BaseCommand
  {
    public MediaPropertiesPlugin()
      : base()
    {
    }

    public void getProperties(string args)
    {
      string callbackId = "";
      string path = "";

      try
      {
        JArray parameters = JArray.Parse(args);

        path = (string) parameters[0];
        callbackId = (string) parameters[1];

        if (path.StartsWith("./") || path.StartsWith(".\\"))
        {
          path = path.Remove(0, 2);
        }

        GetProperties(path, callbackId);
      }
      catch (Exception e)
      {
        Debug.WriteLine("Cannot get properties for {0}: {1}", path, e.Message);

        DispatchCommandResult(new PluginResult(PluginResult.Status.ERROR, e.Message), callbackId);
      }
    }

    private async void GetProperties(string path, string callbackId)
    {
      try
      {
        StorageFolder rootFolder = Windows.Storage.ApplicationData.Current.LocalFolder;
        StorageFile file = await rootFolder.GetFileAsync(path);
        JObject result = new JObject();

        result["contentType"] = file.ContentType;

        if (file.ContentType.StartsWith("audio"))
        {
          MusicProperties properties = await file.Properties.GetMusicPropertiesAsync();

          result["duration"] = properties.Duration.TotalSeconds;
        }
        else if (file.ContentType.StartsWith("video"))
        {
          VideoProperties properties = await file.Properties.GetVideoPropertiesAsync();

          result["duration"] = properties.Duration.TotalSeconds;
        }

        DispatchCommandResult(new PluginResult(PluginResult.Status.OK, result.ToString()), callbackId);
      }
      catch (Exception e)
      {
        Debug.WriteLine("Cannot get properties for {0}: {1}", path, e.Message);

        DispatchCommandResult(new PluginResult(PluginResult.Status.ERROR, e.Message), callbackId);
      }
    }
  }
}
