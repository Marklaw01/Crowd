<div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li><?php
                    echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                <li><?php
                    echo $this->Html->link('BottomSliders', array('controller'=>'campaigns','action'=>'myCampaign'), array('escape'=>false));
                ?></li>
                <li class="active">Edit BottomSlider</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12'>
             <div class="page_heading">
               <h1><?php  echo $BottomSliders->title;?></h1> 
              </div>
            </div>
          </div>
          <!-- header ends -->
          <?php $cId= base64_encode($BottomSliders->id);?>
          <?= $this->Form->create($BottomSliders,['enctype' => 'multipart/form-data']) ?>
          <div class="row">
            <div class="col-lg-6 col-md-6 col-sm-12">
                    <div class="form-group">
                    <label>Title</label>
                        <?php
                          echo $this->Form->input('title', ARRAY('type'=>'text','label' => false,'value'=>$BottomSliders->title
                           , 'div' => false, 'error' => false, 'id' => '','placeholder'=>'title','class' => 'form-control'));
                        ?>
                        <?php 
                              echo $this->Form->error('title', null, array('class' => 'error-message'));
                        ?>
                    </div>
                    <div class="form-group">
                    <label>Image</label>
                    <?php echo $this->Html->image('sliderimages/'.$BottomSliders->image, ['alt' => 'slider image','width'=>'200','height'=>'200']);?> 
                        <?php
                          echo $this->Form->input('image', ARRAY('type'=>'file','label' => false
                           , 'div' => false, 'error' => false, 'id' => '' ));
                        ?>
                        <?php 
                              echo $this->Form->error('image', null, array('class' => 'error-message'));
                        ?>
                    </div>
                    <div class="form-group">
                    <label>BottomSlider Description</label>
                        <?php
                          echo $this->Form->input('description', ARRAY('type'=>'textarea','label' => false,'value'=>$BottomSliders->description
                           , 'div' => false, 'error' => false, 'id' => '','placeholder'=>'Campaign Name','class' => 'form-control'));
                        ?>
                        <?php 
                              echo $this->Form->error('decription', null, array('class' => 'error-message'));
                        ?>
                    </div>
              </div>
              <div class="col-lg-12 col-md-12 col-sm-12 ">
                <div class="form-group  pull-right">
                  <?= $this->Form->button('Update BottomSlider',['class'=> 'customBtn blueBtn']) ?>
                </div>
             </div>
          </div>
         <?= $this->Form->end() ?>
</div>