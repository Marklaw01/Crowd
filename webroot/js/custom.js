
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

$('#tabbing').tabCollapse();


 /* $(document).ready(function() {
    var bodyheight=$('body').height();
     $('#scrollEvent').slimScroll({

          height: '600',

          alwaysVisible: true,
          railVisible: true
      });
  });*/
  $('#browseBtn').click(function(e) { 
    e.preventDefault(); 
    $('#file').click(); 
  });

$('#file').change(function() {
    $('#filename').text($(this).val() || 'no file');                        
});
});

/* select events */

$(document).ready(function(){
    /* deselect*/
    $('#selectAll').on('click',function(){
        if(this.checked){
            $('.checkinput').each(function(){
                this.checked = true;
            });
        }else{
             $('.checkinput').each(function(){
                this.checked = false;
            });
        }
    });
    
    $('.checkinput').on('click',function(){ 
        if($('.checkinput:checked').length == $('.checkinput').length){
            $('#selectAll').prop('checked',true);
        }else{
            $('#selectAll').prop('checked',false);
            $('#deselectAll').prop('checked',false);
        }
    });
    /* deselect*/
     $('#deselectAll').on('click',function(){ //alert('j');
        if(this.checked){
            $('.checkinput').each(function(){
                this.checked = false;
            });
        }else{
             $('.checkinput').each(function(){
                this.checked = true;
            });
        }
    });
    
    $('.checkinput').on('click',function(){ //alert('vj');
        if($('.checkinput:checked').length == $('.checkinput').length){
            $('#deselectAll').prop('checked',false);
        }else{
            //$('#deselectAll').prop('checked',true);
        }
    }); 
    $(".circle-icon").click(function(){
      $(".notify-droppdown").slideToggle('slow');
    });
  });






 
  

  
  