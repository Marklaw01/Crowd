
<div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li> <?php
                    echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                <li> <?php
                    echo $this->Html->link('Messaging', array('controller'=>'Messages','action'=>'index'), array('escape'=>false));
                ?></li>
                <li> <?php
                    echo $this->Html->link('Networking options', array('controller'=>'NetworkingOptions','action'=>'index'), array('escape'=>false));
                ?></li>
                <li class="active">Manage Groups</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-8 col-md-8 col-sm-12 '>
             <div class="page_heading">
               <h1>Manage Groups</h1> 
              </div>
            </div>
            <div class="col-lg-4 col-md-4 col-sm-12">
              <button class="add_form_field pull-right">Add New Group &nbsp; <span style="font-size:16px; font-weight:bold;">+ </span></button>
            </div>
            
          </div>
          <!-- header ends --> 
          <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">
              <div role="tabpanel" class="campaigns-section">
                <!-- Nav tabs -->
                
                <!-- Tab panes -->
                <div class="tab-content">
                 <!-- 1Tab-->
                  <div role="tabpanel" class="tab-pane active whiteBg" id="current">
                    <?= $this->Form->create($businessUserConnection,['id'=>'FormField','enctype' => 'multipart/form-data']) ?>
                    <div class="row">

                      <div class="col-lg-8 col-md-8 col-sm-12 container1">
                        

                        <?php 
                        $total = count($businessConnection);
                        $i=0; foreach ($businessConnection as $businessConn) { 
                          $i++;
                          //pr($businessConn['name']); die; ?>
                          <div class="group_details">
                            <?php if($i > 1 ) { ?>
                              <a href="#" class="delete pull-right"><i class="fa fa-trash-o fa-2x" aria-hidden="true"></i></a>
                             <?php } ?> 
                            <div class="form-group">
                            <label>Group Details</label>
                                 
                               <?php
                                    echo $this->Form->input('id[]', ['type' => 'hidden','value'=>$i]);

                                    echo $this->Form->input('name[]', ARRAY('label' => false, 'div' => false,'error' => false, 'class' => 'form-control', 'maxlength' => '50000','placeholder'=>'Name','value'=>$businessConn['name']));
                                 ?>
                               <?php 
                                    echo $this->Form->error('name', null, array('class' => 'error-message'));
                                ?>
                            </div>        
                            <div class="form-group">
                                <?php        
                                    echo $this->Form->input('description[]', ARRAY('label' => false,'error' => false, 'div' => false, 'class' => 'form-control', 'id' => '', 'maxlength' => '500000','placeholder'=>'Description', 'type'=>'textarea','value'=>$businessConn['description']));

                                    echo $this->Form->error('description', null, array('class' => 'error-message'));
                              ?>
                            </div>
                            
                          </div>  
                        <?php } ?> 
                      </div>
                      <div class="col-lg-8 col-md-8 col-sm-12" >   
                        <div class="form-group">
                            <?= $this->Form->button('Save',['class'=> 'customBtn blueBtn']) ?>
                        </div>
                      </div>
                    </div>
		                <?= $this->Form->end() ?>      
                  </div>

                   <!--  2Tab -->
                  <div role="tabpanel" class="tab-pane whiteBg" id="completed">    
                  </div>

                   <!--  3Tab -->
                  <div role="tabpanel" class="tab-pane whiteBg" id="search">
                  </div>

                </div>
              </div>
            </div>
          </div>
        </div>
        <!-- /#page-content-wrapper --> 

<script>
$(document).ready(function() {
    var max_fields      = 10;
    var wrapper         = $(".container1"); 
    var add_button      = $(".add_form_field"); 
    
    var x = 1; 
    var xxx = <?php echo $total;?>;
    $(add_button).click(function(e){ 
        e.preventDefault();
        if(x < max_fields){ 
            x++; 
            xxx++;
            $(wrapper).append('<div class="group_details"><a href="#" class="delete pull-right"><i class="fa fa-trash-o fa-2x" aria-hidden="true"></i></a><div class="form-group"><label>Group Details</label><input name="id[]" id="id" value="'+xxx+'" type="hidden"><div class="input text"><input name="name[]" class="form-control" maxlength="5000000" placeholder="Name" id="name" type="text"></div></div><div class="form-group"><div class="input textarea"><textarea name="description[]" class="form-control" id="" maxlength="50000" placeholder="Description" rows="5"></textarea></div>                          </div></div>'); //add input box
        }
    else
    {
    alert('You Reached the limits')
    }
    });
    
    $(wrapper).on("click",".delete", function(e){ 
        e.preventDefault(); $(this).parent('div').remove(); x--;
    })
});
</script>