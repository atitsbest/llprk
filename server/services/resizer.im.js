/**
 * @class Resizer.IM
 *
 * Bilder mit Hilfe von ImageMagick "resizen".
 */
module.exports = function() {
  var _im = require('imagemagick');

  /**
   * Bild im Speicher resizen.
   */
  var _resizeInMemory = function(data, width, height, fn) {
    _im.resize({
      srcData:  data,
      width:    width,
      height:   height
      // TODO: Sharpening
    },
    function(err, stdout, stderr) {
      if (err) throw err;
      fn(stdout); // Resiztes Bild.
    });
  };

  return {
    resizeInMemory: _resizeInMemory,
    im: _im
  };
}();
