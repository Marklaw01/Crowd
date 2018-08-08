<div class="container-fluid">
  <div class="row">
    <div class="col-lg-12 ">
      <ol class="breadcrumb">
        <li><?php
            echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
        ?></li>
        <li> <?php
            echo $this->Html->link('Opportunities', array('controller'=>'BetaTesters','action'=>'index'), array('escape'=>false));
        ?></li>
        <li class="active">Consulting</li>
      </ol>
    </div>
  </div>
  <!-- breadcrumb ends --> 
  <div class='row'>
    <div class='col-lg-12 col-md-12 col-sm-12 '>
     <div class="page_heading">
       <h1>Apply</h1> 
      </div>
    </div>
    
  </div>
  <!-- header ends --> 
  <?= $this->Form->create($commit,['enctype' => 'multipart/form-data']) ?>
    <div class="row">
      <div class="col-lg-6 col-md-6 col-sm-12 ">
      
        <div class="form-group">
            <label>Consulting Project Title</label>
            <span class="form-control"><?php echo $ConsultingDetails->title;?> </span>
        </div>

        <div class="form-group">
            <label>Consulting Project Overview</label>
            <span class="form-control textArea"><?php echo $ConsultingDetails->overview;?> </span>
            
        </div>

        <div class="form-group ">
         <div class="upload_frame " id="uploadMedia">
          <div class="halfDivisionleft"> 
              <select class="form-control" name="file_type[]">
                    <option value="doc">DOC</option>
               </select>
          </div>
          <div class="halfDivisionright">
          <button type="button" id="doc_browse" class="uploadBtn">Upload File</button> 
          <span id="filename_doc"></span>
               <?php
                  echo $this->Form->input('document', ARRAY('label' => false, 'div' => false,'type' => 'file', 'style'=>'display:none;', 'id'=>'doc_name'));
               ?>    
          </div> 
         </div>
        </div>

        <div class="form-group">
          <span style="color: red;">Please select file, you can only upload the following file types DOC, PDF, DOCX, SRS, XLS, VISIO. The maximum size for each file is 20 MB.</span>
        </div>

        <div class="form-group  pull-right">
           <?= $this->Form->button('Submit',['name'=>'submit','class'=> 'customBtn blueBtn']) ?>
        </div>

        
      </div>
    </div>
 <?= $this->Form->end() ?>            
</div>

<script>
    $(document).ready(function () {

        $('#target_amount').priceFormat({
              prefix: '$'
        });

     });

    $('#doc_browse').click(function(){ $('#doc_name').trigger('click'); });
    $("#doc_name").change(function(){
      var filename = $('#doc_name').val();
      $('#filename_doc').html(filename);
    }); 



</script>