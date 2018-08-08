<div class="container-fluid">
  <?= $this->Form->create($Ratings,['id'=>'FormField']) ?>
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li><?php
                    echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                <li class="active"><?php
                    echo $this->Html->link('Contractors', array('controller'=>'Contractors','action'=>'searchContractors'), array('escape'=>false));
                ?></li>
                <li class="active">Rate Contractor</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <div class="page_heading">
               <h1>Rate Contractor</h1> 
              </div>
            </div>
            
          </div>
          <!-- header ends --> 
          <div class="row">
            <div class="col-lg-8 col-md-8 col-sm-12 ">
              <div class="form-group">
                    <span class="form-control">
                        <?php echo $userName= $User->first_name.' '.$User->last_name;?>
                    </span>
              </div>

              <div class="form-group">
                    <span class="form-control">
                        <?php echo  $Startups->startup->name;?>
                    </span>
              </div>
              <div class="form-group">
                    <!--<select class="selectpicker form-control show-tick" name="deliverable[]" multiple="" title='Select Roadmap'>-->
                    <select class="selectpicker form-control show-tick" name="deliverable"  title='Select Roadmap'>
                      <?php 
                        $hiredRoadmap= $Startups->roadmap_id;
                        if(!empty($hiredRoadmap)){  
                            $hiredRoadmapIdArray= explode(",", $hiredRoadmap);
                            foreach($roadmaps as $roadmap){
                                if(in_array($roadmap['id'], $hiredRoadmapIdArray)){
                                  echo '<option value="'.$roadmap['id'].'">'.$roadmap['name'].'</option>';
                                }
                            }
                        }    
                      ?>

                    </select>

                    <?php 
                                  echo $this->Form->error('deliverable', null, array('class' => 'error-message'));
                    ?>
              </div>         

              <div class="form-group">
                  <?php
                    echo $this->Form->input('description', ['label' => false, 'div' => false,'error' => false, 'class' => 'form-control', 'id' => '','type'=>'textarea','placeholder'=>'Description','maxlength' => '50']);
                  ?>
                  <?php 
                                echo $this->Form->error('description', null, array('class' => 'error-message'));
                  ?>
              </div>  
              <div class="form-group">
                  <label>Rating Star :</label>
                  <div id="stars-default">
                  <?php
                    echo $this->Form->input('rating_star', ['label' => false, 'div' => false,'error' => false, 'class' => 'form-control', 'id' => 'rating_star','type'=>'hidden','placeholder'=>'Description','maxlength' => '50']);
                  ?>
                  </div> 
                  <?php 
                                echo $this->Form->error('rating_star', null, array('class' => 'error-message'));
                  ?> 
              </div> 

              <div class="form-group">
                  <?= $this->Form->button('Save',['class'=> 'customBtn blueBtn  pull-right']) ?>
              </div>
            </div>
          </div>
     <?= $this->Form->end() ?>      
</div>

<script>
$(document).ready(function () {
    $('#hourly_price').priceFormat({
          prefix: '$'
    });
});

(function ( $ ) {
 
    $.fn.rating = function( method, options ) {
    method = method || 'create';
        // This is the easiest way to have default options.
        var settings = $.extend({
            // These are the defaults.
      limit: 5,
      value: 0,
      glyph: "glyphicon-star",
            coloroff: "gray",
      coloron: "gold",
      size: "2.0em",
      cursor: "default",
      onClick: function () {},
            endofarray: "idontmatter"
        }, options );
    var style = "";
    style = style + "font-size:" + settings.size + "; ";
    style = style + "color:" + settings.coloroff + "; ";
    style = style + "cursor:" + settings.cursor + "; ";
  

    
    if (method == 'create')
    {
      //this.html('');  //junk whatever was there
      
      //initialize the data-rating property
      this.each(function(){
        attr = $(this).attr('data-rating');
        if (attr === undefined || attr === false) { $(this).attr('data-rating',settings.value); }
      })
      
      //bolt in the glyphs
      for (var i = 0; i < settings.limit; i++)
      {
        this.append('<span data-value="' + (i+1) + '" class="ratingicon glyphicon ' + settings.glyph + '" style="' + style + '" aria-hidden="true"></span>');
      }
      
      //paint
      this.each(function() { paint($(this)); });

    }
    if (method == 'set')
    {
      this.attr('data-rating',options);
      this.each(function() { paint($(this)); });
    }
    if (method == 'get')
    {
      return this.attr('data-rating');
    }
    //register the click events
    this.find("span.ratingicon").click(function() {
      rating = $(this).attr('data-value')
      $(this).parent().attr('data-rating',rating);
      paint($(this).parent());
      settings.onClick.call( $(this).parent() );
    })
    function paint(div)
    {
      rating = parseInt(div.attr('data-rating'));
      div.find("input").val(rating);  //if there is an input in the div lets set it's value
      div.find("span.ratingicon").each(function(){  //now paint the stars
        
        var rating = parseInt($(this).parent().attr('data-rating'));
        var value = parseInt($(this).attr('data-value'));
        if (value > rating) { $(this).css('color',settings.coloroff); }
        else { $(this).css('color',settings.coloron); }
      })
    }

    };
 
}( jQuery ));

$(document).ready(function(){

  $("#stars-default").rating();

});
</script>
