/**
 * @class Storage.Nil
 *
 * Dateien im Nichts speichern.
 */
module.exports = function() {

  /**
   * Datei im Storage speichern.
   */
  var _putFile = function(fname, data, fn) {
    fn();
  };

  /**
   * Datei aus dem Storage entfernen. 
   */
  var _removeFile = function(fname, fn) {
    fn();
  };

  return {
    baseUrl: '',
    putFile: _putFile,
    removeFile: _removeFile
  };
}();

