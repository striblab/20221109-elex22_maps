var district;
var boundaries;
var isolate;
var interactive;
var shading;
var height;
var hed;
var chatter;
var showtext;

$("#form_id").submit(function( event ) {
  event.preventDefault();

  district = $(this).find('[name=eOffice]').val();
  boundaries = $(this).find('[name=eDistricts]:checked').val();
  isolate = $(this).find('[name=eIsolate]:checked').val();
  interactive = $(this).find('[name=eInteract]:checked').val();
  shading = $(this).find('[name=eShading]:checked').val();
  hed = $(this).find('[name=eHed]').val();
  chatter = $(this).find('[name=eChatter]').val();
  height = $(this).find('[name=eHeight]').val();
  showtext = $(this).find('[name=eText]:checked').val();

  window.open('https://static.startribune.com/news/projects/all/elex22maps/build/?office=' + district + "&overlay=" + boundaries + "&filter=" + isolate +"&interactive=" + interactive + "&shading=" + shading + "&height=" + height+ "&text=" + showtext + "&title=" + hed + "&chatter=" + chatter, '_blank');
  
});