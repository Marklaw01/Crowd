
$( window ).load(function() {
   var headerHeight = $('.top-Bar').height();
    $(window).resize(function(){
    var headerHeight = $('.top-Bar').height();
    $("body").css("padding-top",headerHeight);
    $("#sidebar-wrapper").css("margin-top",headerHeight);
     $(".sidebar-nav").css("padding-bottom",headerHeight+10);
   });

    $("body").css("padding-top",headerHeight);
    $("#sidebar-wrapper").css("margin-top",headerHeight);
     $(".sidebar-nav").css("padding-bottom",headerHeight+10);
   
   });

$(document).ready(function() {
  $('[data-toggle="offcanvas"]').click(function () {
        $('#wrapper').toggleClass('toggled');
  }); 

$('#aboutTab').tabCollapse();
     $('#scrollEvent').slimScroll({
          alwaysVisible: true,
          railVisible: true
      });
  
});

/* tabing*/

 
  

  
  