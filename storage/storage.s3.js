/**
 * @class Storage.S3
 *
 * Dateien auf AWS S3 speichern.
 */
module.exports = function() {
  var bucketName = 'llprktest',
      awssum = require('awssum'),
      amazon = awssum.load('amazon/amazon'),
      S3 = awssum.load('amazon/S3').S3,
      s3 = new S3({
        accessKeyId: 'AKIAJRH4APHXIF7LQMRA',
        secretAccessKey: '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',
        region: amazon.EU_WEST_1
      });

  /**
   * Datei im Storage speichern.
   */
  var _putFile = function(fname, data, fn) {
    var options = {
      BucketName    : bucketName,
      ObjectName    : fname,
      ContentLength : data.length,
      Body          : data,
      Acl           : 'public-read'
    };

    s3.PutObject(options, function(err, data) {
      if (err) throw err;
      fn(data);
    });
  };

  /**
   * Datei aus dem Storage entfernen. 
   */
  var _removeFile = function(fname, fn) {
    var options = {
      BucketName    : bucketName,
      ObjectName    : fname
    };

    s3.DeleteObject(options, function(err, data) {
      if (err) throw err;
      fn(data);
    });
  };

  return {
    baseUrl: 'https://s3-eu-west-1.amazonaws.com/' + bucketName + '/',
    putFile: _putFile,
    removeFile: _removeFile
  };
}();

