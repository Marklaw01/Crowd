<div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li><?php
                    echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                <li><?php
                    echo $this->Html->link('Campaigns', array('controller'=>'campaigns','action'=>'myCampaign'), array('escape'=>false));
                ?></li>
                <li class="active">Edit Block</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12'>
             <div class="page_heading">
               <h1><?php  echo $Blocks->title;?></h1> 
              </div>
            </div>
          </div>
          <!-- header ends -->
          <?php $cId= base64_encode($Blocks->id);?>
          <?= $this->Form->create($Blocks,['enctype' => 'multipart/form-data']) ?>
          <div class="row">
            <div class="col-lg-6 col-md-6 col-sm-12">
                    <div class="form-group">
                    <label>Block Description</label>
                        <?php
                          echo $this->Form->input('description', ARRAY('type'=>'textarea','label' => false,'value'=>$Blocks->description
                           , 'div' => false, 'error' => false, 'id' => '','placeholder'=>'Campaign Name','class' => 'form-control'));
                        ?>
                        <?php 
                              echo $this->Form->error('decription', null, array('class' => 'error-message'));
                        ?>
                    </div>
              </div>
              <div class="col-lg-12 col-md-12 col-sm-12 ">
                <div class="form-group  pull-right">
                  <?= $this->Form->button('Update Block',['class'=> 'customBtn blueBtn']) ?>
                </div>
             </div>
          </div>
         <?= $this->Form->end() ?>
        </div> 



