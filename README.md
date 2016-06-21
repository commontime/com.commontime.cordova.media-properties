# Media-Properties Plugin

## Calls

The following are methods on the `plugins.mediaproperties` plugin.

### getProperties

Gets the properties of a video or audio file. The object return in the success callback has a `duration` member, which is a number specifying the duration of the media file in seconds, a `contentType` field, which is the MIME type of the media file.

```javascript
function success(properties) {
  var duration = properties.duration; // duration of the media file, in seconds
  var contentType = properties.contentType; // content (MIME) type of the media file

  // etc
}

function error(message) {
  // handle error with the given message
}

plugins.mediaproperties.getProperties(success, error, path);
```
