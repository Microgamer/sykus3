(function () {
  if (navigator.userAgent.match(/MSIE (6|7|8)/)) {
    window.alert(
      'Sie benutzen einen stark veralteten Webbrowser.\n\n' +
        'Die Seite kann daher nicht korrekt dargestellt werden.\n\n' + 
        'Bitte benutzen Sie mindestens Internet Explorer 9 ' +
        'oder einen alternativen Webbrowser, ' +
        'wie z.B. Mozilla Firefox oder Google Chrome.'
    );
  }
})();

