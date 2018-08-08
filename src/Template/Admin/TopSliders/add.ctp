<div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb"> 
                <li class="active">Edit TopSlider</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends-->
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12'>
             <div class="page_heading">
               <h1><?php  echo $TopSliders->title;?></h1> 
              </div>
            </div>
          </div>
          <!-- header ends -->
          <?php $cId= base64_encode($TopSliders->id);?>
          <?= $this->Form->create($TopSliders,['enctype' => 'multipart/form-data']) ?>
          <div class="row">
            <div class="col-lg-6 col-md-6 col-sm-12">
                    <div class="form-group">
                    <label>TopSlider Description</label>
                        <?php
                          echo $this->Form->input('description', ARRAY('type'=>'textarea','label' => false,'value'=>$TopSliders->description
                           , 'div' => false, 'error' => false, 'id' => '','placeholder'=>'Campaign Name','class' => 'form-control'));
                        ?>
                        <?php 
                              echo $this->Form->error('decription', null, array('class' => 'error-message'));
                        ?>
                    </div>
              </div>
              <div class="col-lg-12 col-md-12 col-sm-12 ">
                <div class="form-group  pull-right">
                  <?= $this->Form->button('Update TopSlider',['class'=> 'customBtn blueBtn']) ?>
                </div>
             </div>
          </div>
         <?= $this->Form->end() ?>
        </div> 