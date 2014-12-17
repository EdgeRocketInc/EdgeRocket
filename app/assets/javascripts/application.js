// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs

//--- Bootswatch themes
//--  
// require flatly/loader
// require flatly/bootswatch
//-- Active --
//= require yeti/loader
//= require yeti/bootswatch

//= require analytics
//= require dashboards-charts

//= require angular
//= require angular-sanitize
//= require angular-resource
//= require ui-bootstrap-tpls-0.11.0.min
//= require ng-grid-2.0.11.min
//= require ngActivityIndicator.min


var _MS_PER_DAY = 1000 * 60 * 60 * 24 // ms in a day
var _DAYS_OLD = 7

$(document).ready(function () {

  !function (a, b) {
    if (void 0 === b[a]) {
      b["_" + a] = {}, b[a] = function (c) {
        b["_" + a].clients = b["_" + a].clients || {}, b["_" + a].clients[c.projectId] = this, this._config = c
      }, b[a].ready = function (c) {
        b["_" + a].ready = b["_" + a].ready || [], b["_" + a].ready.push(c)
      };
      for (var c = ["addEvent", "setGlobalProperties", "trackExternalLink", "on"], d = 0; d < c.length; d++) {
        var e = c[d], f = function (a) {
          return function () {
            return this["_" + a] = this["_" + a] || [], this["_" + a].push(arguments), this
          }
        };
        b[a].prototype[e] = f(e)
      }
      var g = document.createElement("script");
      g.type = "text/javascript", g.async = !0, g.src = "https://d26b395fwzu5fz.cloudfront.net/3.0.9/keen.min.js";
      var h = document.getElementsByTagName("script")[0];
      h.parentNode.insertBefore(g, h)
    }
  }("Keen", this);
});


