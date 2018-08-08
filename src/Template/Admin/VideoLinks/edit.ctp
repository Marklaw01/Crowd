<div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb"> 
                <li><?php
                    echo $this->Html->link('List', array('controller'=>'videoLinks','action'=>'index'), array('escape'=>false));
                ?></li>
                <li class="active">Edit VideoLink</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12'>
             <div class="page_heading">
               <h1><?php  echo $VideoLinks->title;?></h1> 
              </div>
            </div>
          </div>
          <!-- header ends -->
          <?php $cId= base64_encode($VideoLinks->id);?>
          <?= $this->Form->create($VideoLinks,['enctype' => 'multipart/form-data']) ?>
          <div class="row">
            <div class="col-lg-6 col-md-6 col-sm-12">
                    <div class="form-group">
                    <label>VideoLink</label>
                        <?php
                          echo $this->Form->input('link', ARRAY('type'=>'text','label' => false,'value'=>$VideoLinks->link
                           , 'div' => false, 'error' => false, 'id' => '','placeholder'=>'video link','class' => 'form-control'));
                        ?>
                        <?php 
                              echo $this->Form->error('link', null, array('class' => 'error-message'));
                        ?>
                    </div>
              </div>
              <div class="col-lg-12 col-md-12 col-sm-12 ">
                <div class="form-group  pull-right">
                  <?= $this->Form->button('Update VideoLink',['class'=> 'customBtn blueBtn']) ?>
                </div>
             </div>
          </div>
         <?= $this->Form->end() ?>
        </div> 



