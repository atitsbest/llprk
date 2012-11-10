/**
 * @class Resizer.Nil
 *
 * Bilder gar nicht "resizen".
 */
module.exports = function() {
  /**
   * Bild im Speicher resizen.
   */
  var _resizeInMemory = function(data, width, height, fn) {
    fn([]);
  };

  return {
    resizeInMemory: _resizeInMemory,
  };
}();
