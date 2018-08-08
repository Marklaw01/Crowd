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
                <li class="active">Notes</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <div class="page_heading">
               <h1>Notes</h1> 
              </div>
            </div>
            
          </div>
          <!-- header ends --> 
       
         <div class='row'>
          <div class='col-lg-11 col-md-12 col-sm-12 user-notes'>
           <ul class="contentListing archivedForums_listing panel-default"> 
                     <?php foreach($notes as $note){?>
                          <div class="panel-heading" role="tab" id="headingTwo">
                            <h4 class="panel-title">
                              <a href="#">
                                <?php echo $note->startup->name; ?>
                              </a>
                            </h4>
                          </div>
                          <li>

                           <div class="listingIcon"><i class="icon">
                           <img alt="" src="<?php echo $this->request->webroot;?>images/forum.png">
                           </i></div>
                           <div class="listingContent">
                             <div class="headingBar">
                               <h2 class="heading">

                               <?php echo $note->title; ?>


                               </h2>
                               <h2 class="date-right date"><?php echo date_format($note->created,"F d, Y").' '.date('h:m A', strtotime($note->created));?></h2>
                             </div>
                             <p><?php echo $note->comment;?>
                             </p>
                            <div class="links alignRight">

                                <?php
                                   echo $this->Html->link('<i class="fa fa-eye"></i>View', array('controller'=>'Notes','action'=>'view',base64_encode($note->id)), array('escape'=>false,'class'=>'smallCurveBtnMsg greenBtn customBtnMsg'));
                                ?>

                                <?php
                                   echo $this->Html->link('<i class="fa fa-pencil"></i>Edit', array('controller'=>'Notes','action'=>'edit',base64_encode($note->id)), array('escape'=>false,'class'=>'smallCurveBtnMsg blueBtn customBtnMsg'));
                                ?>
      
                                 <!-- Delete Button Code -->
                                <?php
                                    echo $this->Form->postLink('Delete',['controller'=>'Notes','action' => 'delete', base64_encode($note->id)],['id'=>'delPost2'.$note->id,'class'=>'smallCurveBtnMsg redBtn customBtnMsg']);
                                ?>
                                <script type="text/javascript">
                                             $(document).ready(function () {
                                                 $('#delPost2<?php echo $note->id;?>').html('<i class="fa fa-trash-o"></i>Delete');
                                              });   
                                </script>

                          

                             </div>
                          </div>
                          </li> 

                      <?php } ?> 
                     
           </ul>
                      <?php
                        $cc= count($notes);
                            if(!empty($notes)){
                      ?>
                              <nav class="pagingNav">
                                    <ul class="pagination pagination-sm">
                                      <li><?= $this->Paginator->prev('< ' . __('Previous')) ?></li>
                                      <li><?= $this->Paginator->numbers() ?></li>
                                      <li><?= $this->Paginator->next(__('Next') . ' >') ?></li>
                                    </ul>
                              </nav>

                      <?php }else {?>
                              <nav class="pagingNav">
                                <ul class="pagination pagination-sm">
                                  <li>No Notes Available.</li>
                                </ul>
                              </nav>  
                      <?php }?>

                    <div class="col-lg-12 col-md-12 col-sm-12 ">
                      <div class="form-group">
                          <?php
                              echo $this->Html->link('Add Notes', array('controller'=>'Notes','action'=>'add'), array('escape'=>false,'class'=>'customBtn blueBtn  pull-right'));
                          ?>
                      </div>
                    </div>
        </div>
        </div>
        </div>
        <!-- /#page-content-wrapper --> 
<style type="text/css">
  .user-notes .panel-title a {
    background: no-repeat;
}
</style>




