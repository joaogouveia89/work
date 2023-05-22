// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

import * as bootstrap from'bootstrap'
import Chart from 'chart.js/auto';

import "@fortawesome/fontawesome-free/css/all"
import "../stylesheets/application"

global.$ = jQuery;

global.BS = bootstrap;

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

function generateDashboardCharts(idsList){
    var numOfIds = idsList.length;

    const chartType = "pie";
    const chartsLabels = ["Bad", "Medium", "Good"];
    const backgroundsColors = [
        'rgb(220, 53, 69)',
        'rgb(255, 193, 7)',
        'rgb(25, 135, 84)'
        ];

    var htmlElementLastMonth = {}
    var htmlElementCurrentMonth = {}
    var chartLastMonth = {}
    var chartCurrentMonth = {}

    for (var i = 0; i < numOfIds; i++) {
        htmlElementLastMonth = document.getElementById("chart_" + idsList[i] + "_lm").getContext('2d');
        htmlElementCurrentMonth = document.getElementById("chart_" + idsList[i] + "_cm").getContext('2d')
        
        chartLastMonth = new Chart(htmlElementLastMonth, {
            type: chartType,
            data: {
                labels: chartsLabels,
                datasets: [{
                    data: JSON.parse(htmlElementLastMonth.canvas.dataset.set),
                    backgroundColor: backgroundsColors,
                }],
            },
        });

        chartCurrentMonth = new Chart(htmlElementCurrentMonth, {
            type: chartType,
            data: {
                labels: chartsLabels,
                datasets: [{
                    data: JSON.parse(htmlElementCurrentMonth.canvas.dataset.set),
                    backgroundColor: backgroundsColors,
                }],
            },
        });
    }
}

document.addEventListener('turbolinks:load', () => {
    if(window.location.pathname === "/"){
        generateDashboardCharts(
            [
                "meetings",
                "currenttask",
                "teaminteraction",
                "humor"
            ]
        );
    }
  })