// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

import 'bootstrap'
import "@fortawesome/fontawesome-free/css/all"
import "../stylesheets/application"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

window.copyToClipboard = function copyToClipboard(value, iconId, defaultIconClass){
    navigator.clipboard.writeText(value);
    const iconEl = $( "#" + iconId);
    iconEl.fadeOut( "slow", function() {
        iconEl.removeClass(defaultIconClass);
        iconEl.addClass("fa-circle-check");
        iconEl.fadeIn( "slow", function() {
            iconEl.delay(800);
            iconEl.fadeOut( "slow", function() {
                iconEl.removeClass("fa-circle-check");
                iconEl.addClass(defaultIconClass);
                iconEl.fadeIn( "slow");
            });
        });
    });
}
