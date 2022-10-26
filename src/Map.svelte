<script>
import directory from './data/directory.json';
import { onMount } from 'svelte';
import * as jq from 'jquery';
import * as d3 from 'd3';
import * as mapboxgl from 'mapbox-gl';
import * as MapboxGeocoder from '@mapbox/mapbox-gl-geocoder';
import '@mapbox/mapbox-gl-geocoder/dist/mapbox-gl-geocoder.css';
import * as turf from '@turf/turf';

mapboxgl.accessToken = 'pk.eyJ1Ijoic3RhcnRyaWJ1bmUiLCJhIjoiY2sxYjRnNjdqMGtjOTNjcGY1cHJmZDBoMiJ9.St9lE8qlWR5jIjkPYd3Wqw';

let raceData = directory.races;

function makeMap(zoom, center, interactive, shading, opacity, dataSource, overSource, filter, district, overlaid, office) {

/********** MAP CONFIG VARIABLES **********/
let condition = 'mousemove';
var mclick = false;
let statecenter = [-94.351646, 46.607469];
let metrocenter = [-93.218950, 44.935852];
let metrozoom = 9;
let statezoom = 5.5;

/********** INITIALIZE MAP **********/
const map = new mapboxgl.Map({
  container: 'map',
  style: 'mapbox://styles/startribune/ck1b7427307bv1dsaq4f8aa5h',
  center: center,
  zoom: zoom,
  minZoom: 5.2,
  maxZoom: 14,
  //maxBounds: [-107.2,40.88,-78.92,51.62],
  scrollZoom: false,
  interactive: interactive
});


/********** SPECIAL STATE AND METRO RESET BUTTONS **********/
class HomeReset {
  onAdd(map){
    this.map = map;
    this.container = document.createElement('div');
    this.container.className = 'mapboxgl-ctrl my-custom-control mapboxgl-ctrl-group statereset';
    const button = this._createButton('mapboxgl-ctrl-icon StateFace monitor_button')
    this.container.appendChild(button);
    return this.container;
  }
  onRemove(){
    this.container.parentNode.removeChild(this.container);
    this.map = undefined;
  }
  _createButton(className) {
    const el = window.document.createElement('button')
    el.className = className;
    el.innerHTML = '<img width="15" src="https://static.startribune.com/news/projects/all/20220215-redistrict/build/img/mn.png" alt="mn" />';
    el.addEventListener('click',(e)=>{
     // e.style.display = 'none'
     // e.stopPropagation()
    },false )
    return el;
  }
}
const toggleControl = new HomeReset();

class MetroReset {
  onAdd(map){
    this.map = map;
    this.container = document.createElement('div');
    this.container.className = 'mapboxgl-ctrl my-custom-control mapboxgl-ctrl-group metroreset';

    const button = this._createButton('mapboxgl-ctrl-icon StateFace monitor_button')
    this.container.appendChild(button);
    return this.container;
  }
  onRemove(){
    this.container.parentNode.removeChild(this.container);
    this.map = undefined;
  }
  _createButton(className) {
    const el = window.document.createElement('button')
    el.className = className;
    el.innerHTML = '<img width="15" src="https://static.startribune.com/news/projects/all/20220215-redistrict/build/img/metro.png" alt="metro" />';
    el.addEventListener('click',(e)=>{
     // e.style.display = 'none'
     // e.stopPropagation()
    },false )
    return el;
  }
}
const toggleControlM = new MetroReset();

/********** SETUP BASIC MAP CONTROLS FOR DESKTOP AND MOBILE **********/
var scale = new mapboxgl.ScaleControl({
  maxWidth: 80,
  unit: 'imperial'
  });

if (interactive == 1) {
    if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
      //map.dragPan.disable();
      map.keyboard.disable();
      map.dragRotate.disable();
      map.touchZoomRotate.disableRotation();
      map.scrollZoom.disable();
      map.addControl(new mapboxgl.NavigationControl({ showCompass: false }),'bottom-left');
      map.addControl(toggleControl,'bottom-left');
      map.addControl(toggleControlM,'bottom-left');
      condition = 'click';
      mclick = true;
    } else {
      map.addControl(scale);
      map.getCanvas().style.cursor = 'pointer';
      map.addControl(new mapboxgl.NavigationControl({ showCompass: false }),'bottom-left');
      map.addControl(toggleControl,'bottom-left');
      map.addControl(toggleControlM,'bottom-left');
    }

    jq('#map .statereset').on('click', function(){
      if ((jq("#map").width() < 520)) { 
        zoom = zoom - 1;
      } else { zoom = zoom; }
      map.jumpTo({
        center: statecenter,
        zoom: statezoom,
      });
    });

    jq('#map .metroreset').on('click', function(){
      map.jumpTo({
        center: metrocenter,
        zoom: metrozoom,
      });
    });
} else {
  jq("#map").css('pointer-events','none');
}

/********** ADD MAP LAYERS **********/
map.on('load', function() {

  map.setPaintProperty(
    'water',
    'fill-color','#ededed' 
  );

      map.addSource('precincts', {
        type: 'geojson',
        data: './data/' + dataSource,
        generateId: true
      });

      map.addLayer({
            'id': 'precincts',
            'interactive': true,
            'source': 'precincts',
            'layout': {},
            'type': 'fill',
            'paint': {
              'fill-color': shading,
              'fill-opacity': opacity
            },
        }, "settlement-subdivision-label");


      map.addLayer({
            'id': 'precincts-l',
            'interactive': true,
            'source': 'precincts',
            'layout': {},
            'type': 'fill',
            'paint': {
              'fill-color': '#efefef',
              'fill-opacity': ['case', ['boolean', ['feature-state', 'hover'], false], 0, 0.05],
              'fill-outline-color': '#ffffff'
            },
        }, "settlement-subdivision-label");


    if (overlaid == 1) {

      //BOUNDARY OVERLAY
      map.addSource('overlay', {
        type: 'geojson',
        data: './data/' + overSource,
        generateId: true
      });

      map.addLayer({
            'id': 'overlay',
            'interactive': true,
            'source': 'overlay',
            'layout': {},
            'type': 'fill',
            'paint': {
              'fill-color': '#efefef',
              'fill-opacity': ['case', ['boolean', ['feature-state', 'hover'], false], 1, 0],
              'fill-outline-color': ['case', ['boolean', ['feature-state', 'hover'], false],'#000000','#ffffff']
            }
        }, "settlement-subdivision-label");

      map.addLayer({
            'id': 'overlay-l',
            'interactive': true,
            'source': 'overlay',
            'layout': {},
            'type': 'line',
            'paint': {
              'line-color': '#333333'
            }
        }, "settlement-subdivision-label");
    }

      if (filter == 2) {

          map.addSource('overlay-f', {
            type: 'geojson',
            data: './data/' + overSource,
            generateId: true
          });


          map.addLayer({
            'id': 'overlay-f',
            'interactive': true,
            'source': 'overlay-f',
            'layout': {},
            'type': 'line',
            'paint': {
              'line-color': '#333333'
            },
            filter: ['==', 'DISTRICT', district]
        }, "settlement-subdivision-label");


        map.setFilter('overlay', ['!=', 'DISTRICT', district]);
        map.setPaintProperty('overlay', 'fill-opacity', 1);

        map.on('sourcedata', function (e) {
          if (e.sourceId == 'overlay-f' && e.isSourceLoaded) {
          var f = map.queryRenderedFeatures({layers:['overlay-f']});
          if (f.length === 0) return
          var bbox = turf.bbox({
            type: 'FeatureCollection',
            features: f
          });
          map.fitBounds(bbox, {padding: 20}); 
          }   
        })
      }
  
     
      //map.setPaintProperty('precincts-l', 'line-width', ['interpolate',['exponential', 0.5], ['zoom'],5,0.5,13,1.5]);

/********** TOOLTIP AND HOVER EFFECTS **********/
    let hoveredStateId = null;

    function tooltips(layer) {
          const popup = new mapboxgl.Popup({
          closeButton: mclick,
          closeOnClick: mclick
          });
          
          map.on(condition, layer, function(e) {
                map.getCanvas().style.cursor = 'default';
                var feature = e.features[0];

                if (e.features.length > 0) {
                    if (hoveredStateId !== null) {
                      map.setFeatureState({ source: layer, id: hoveredStateId },{ hover: false });
                    }
                    hoveredStateId = feature.id;
                      map.setFeatureState({ source: layer, id: hoveredStateId },{ hover: true });
                }


                var obj = jq.parseJSON(feature.properties.votes_obj);

                var geo = feature.properties.county + ' County';
                if (office > 3 && office < 12) { geo = 'Congressional District ' + feature.properties.congdist; }
                else if (office > 11 && office < 79) { geo = 'Senate District ' + feature.properties.mnsendist; }
                else if (office > 78) { geo = 'House District ' + feature.properties.mnlegdist; }

                popup.setLngLat(e.lngLat)
                    .setHTML('<span class="precinct-name">' + feature.properties.precinct + '</span><span class="county-name">' + geo + '</span>' + tipinfo(obj, office) + '<p class="precinct-note">Precinct’s top 3 candidates shown</p>')
                    .addTo(map);
            });

            map.on('mouseleave', layer, function() {
                map.getCanvas().style.cursor = '';
                popup.remove();
                if (hoveredStateId !== null) {
                  map.setFeatureState({ source: layer, id: hoveredStateId },{ hover: false });
                }
                hoveredStateId = null;
            });
    }

    function tipinfo(obj, office) {
      var tipstring = '<table class="tableResults"><thead><tr><th></th><th class="cand">Candidate</th><th class="votes">Votes</th><th class="pct">Pct.</th></tr></thead><tbody>';

      for (var i=0; i < 3; i++) {
        tipstring = tipstring + '<tr><td class="' + obj[i].party + '"><span class="dot ' + obj[i].party + '"></span></td><td class="cand">' + obj[i].name + ' <span>' + obj[i].party + '</span></td><td class="votes">' + obj[i].votes + '</td><td class="pct">' + obj[i].votes_pct + '%</td></tr>';
      }

      tipstring = tipstring + '</tbody></table>'

      return tipstring;
    }

    tooltips('precincts');
});




/********** MOBILE ZOOM ADJUSTMENTS **********/
jq(document).ready(function() {
  map.resize();
  var cachedWidth = jq(window).width();
  if ((jq("#map").width() < 520)) {
      map.zoom(mzoom);
  }
  jq(window).resize(function() {
    var newWidth = jq(window).width();
    if(newWidth !== cachedWidth){
      cachedWidth = newWidth;
      if ((jq("#map").width() < 520)){
        map.zoom(mzoom);
      } else {
        map.zoom(zoom);
      }
    }
  });
});
}

    onMount(() => {

      /********** GRAB URL PARAMETERS **********/
      jq.urlParam = function(name) {
        var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
        if (results != null) {
            return results[1] || 0;
        } else {
            return null;
        }
      }

      /********** DYNAMIC DATA SETTINGS **********/
      var office = jq.urlParam('office') ?? 0; //string
      var format = jq.urlParam('format') ?? 0; //string
      var overlay = jq.urlParam('overlay') ?? 0; //boolean
      var filter = jq.urlParam('filter') ?? 0; //boolean
      var boundaries = false;

      if (overlay != 0) { boundaries = true; }

      var dataSource;

      if (format == 0) { dataSource = raceData[office].precincts; }
      else if (format == 1) { dataSource = raceData[office].counties; }
      else if (format == 2) { dataSource = raceData[office].congress; }
      else if (format == 3) { dataSource = raceData[office].house; }
      else if (format == 4) { dataSource = raceData[office].senate; }

      var overSource = raceData[office].overlay;
      var district = raceData[office].district;

      /********** MAP SHADING OPTIONS **********/
      var shading = jq.urlParam('shading') ?? 0; //density, strength, win

      var shades = [];

      shades[0] = ['case', ['==', ['get', 'wmargin'], null], "#e0e0e0", [
                  'interpolate',
                  ['linear'],
                  ['get', 'wmargin'],
                    -80,
                    '#750000',
                    -60,
                    '#750000',
                    -40,
                    '#AE191C',
                    -20,
                    '#AE191C',
                    -6,
                    '#DA9190',
                    -0,
                    '#ccc900',
                     6,
                    '#8FAECE',
                     20,
                    '#115E9B',
                     40,
                    '#115E9B',
                     60,
                    '#003168',
                     80,
                    '#003168'
                ]];
      shades[1] = ['case', ['==', ['get', 'wmargin'], null], "#e0e0e0", [
                  'interpolate',
                  ['linear'],
                  ['get', 'wmargin'],
                    -80,
                    '#750000',
                    -60,
                    '#750000',
                    -40,
                    '#AE191C',
                    -20,
                    '#AE191C',
                    -6,
                    '#DA9190',
                    -0,
                    '#ccc900',
                     6,
                    '#8FAECE',
                     20,
                    '#115E9B',
                     40,
                    '#115E9B',
                     60,
                    '#003168',
                     80,
                    '#003168'
                ]];
      shades[2] = ['case', ['==', ['get', 'wmargin'], null], "#e0e0e0", [
                  'interpolate',
                  ['linear'],
                  ['get', 'wmargin'],
                    -1,
                    '#AE191C',
                    0,
                    '#cfcdda',
                    1,
                    '#115E9B'
                  ]];

      var opacities = [];

          opacities[0] = [
                  'interpolate',
                  ['linear'],
                  ['get', 'votes_sqmi'],
                      0,
                      0.10,
                      20,
                      0.20,
                      30,
                      0.30,
                      40,
                      0.40,
                      50,
                      0.50,
                      60,
                      0.60,
                      70,
                      0.70,
                      80,
                      0.80
                  ];
          opacities[1] = 0.8;
          opacities[2] = 1;

          jq("#legend"+shading).show();

      /********** MAP CONFIGURATION SETTINGS **********/
      var interactive = jq.urlParam('interactive') ?? 1;
      var height = jq.urlParam('height') ?? 600;

      var centers = [];
      centers[0] = [-94.351646, 46.607469]; //default desktop centerpoint
      centers[1] = [-93.218950, 44.935852]; //default metro area centerpoint
      centers[2] = [-93.907810, 45.940497]; //default mobile centerpoint
      centers[3] = [-94.351646, 46.607469]; //default desktop centerpoint

      var zooms = [];
      zooms[0] = 5.5;
      zooms[1] = 9; //default metro area zoom level
      zooms[2] = 5.5;
      zooms[3] = 6;

      jq("#map").css("height",height+"px");


      /********** CHATTER CONFIGURATION **********/
      var text = jq.urlParam('text') ?? 1;
      var title = jq.urlParam('title') ?? 'title test';
      var chatter = jq.urlParam('chatter') ?? 'chatter test';

      if (text == 0) { jq("#text").hide(); }

      jq(".chartTitle").html(decodeURI(title));
      jq(".chatter").html(decodeURI(chatter));
      

    /********** RENDER **********/
        makeMap(zooms[filter], centers[filter], interactive, shades[shading], opacities[shading], dataSource, overSource, filter, district, overlay, office);
    });
</script>

<div id="text">
  <div class="chartTitle">TITLE HERE</div>
  <div class="chatter">chatter here</div>
</div>
<div class="map" id="map">

      <div class="legend" id="legend0">
        <div><span>&nbsp;</span><span style="text-align:right;">&larr;</span><span style="text-align:right;">D</span><span>&nbsp;</span><span>R</span><span>&rarr;</span><span>&nbsp;</span></div>
        <div class="strong "><span style="background-color: #003168"></span><span style="background-color: #115E9B"></span><span style="background-color: #003168"></span><span style="background-color: #cfcdda"></span><span style="background-color: #da9190"></span><span style="background-color: #ae19ac"></span><span style="background-color: #750000"></span> &darr; votes</div>
        <div class="middle"><span style="background-color: #003168"></span><span style="background-color: #115E9B"></span><span style="background-color: #003168"></span><span style="background-color: #cfcdda"></span><span style="background-color: #da9190"></span><span style="background-color: #ae19ac"></span><span style="background-color: #750000"></span></div>
        <div class="weak"><span style="background-color: #003168"></span><span style="background-color: #115E9B"></span><span style="background-color: #003168"></span><span style="background-color: #cfcdda"></span><span style="background-color: #da9190"></span><span style="background-color: #ae19ac"></span><span style="background-color: #750000"></span></div>
      </div>

      <div class="legend" id="legend1">
        <div><span>&nbsp;</span><span style="text-align:right;">&larr;</span><span style="text-align:right;">D</span><span>&nbsp;</span><span>R</span><span>&rarr;</span><span>&nbsp;</span></div>
        <div class="strong "><span style="background-color: #003168"></span><span style="background-color: #115E9B"></span><span style="background-color: #003168"></span><span style="background-color: #cfcdda"></span><span style="background-color: #da9190"></span><span style="background-color: #ae19ac"></span><span style="background-color: #750000"></span></div>
      </div>

      <div class="legend" id="legend2">
        <div><span style="text-align:right;">D</span><span>&nbsp;</span><span>R</span></div>
        <div class="strong "><span style="background-color: #115E9B"></span><span style="background-color: #cfcdda"></span><span style="background-color: #ae19ac"></span></div>
      </div>
</div>
      <div class="dataline">Map: Jeff Hargarten, Star Tribune • Source: Minnesota Secretary of State</div>