<div class="container-fluid">
  <div class="row">
    <div class="col-lg-12 ">
      <ol class="breadcrumb">
        <li> <?php
            echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
        ?></li>
        <li> <?php
            echo $this->Html->link('Opportunities', array('controller'=>'BetaTesters','action'=>'index'), array('escape'=>false));
        ?></li>
        <li class="active">Consulting</li>
      </ol>
    </div>
  </div>
  <!-- header ends --> 

  <!-- breadcrumb ends --> 
  <div class='row'>
    <div class='col-lg-6 col-md-6 col-sm-6 '>
     <div class="page_heading">
       <h1>Find Consulting</h1> 
      </div>
    </div>
    <div class='col-lg-6 col-md-6 col-sm-6'>
      <div class="profileName">
          <?php
              $entrepre = '<i><img src="'.$this->request->webroot.'img/icons/Funds.png" alt=""></i>';
              echo $this->Html->link( $entrepre .'FIND CONSULTING', array('controller'=>'Consultings','action'=>'index'), array('escape'=>false,'class'=>'navbar-brand'));
          ?>
          <?php
              $entrepre = '<i><img src="'.$this->request->webroot.'img/icons/Funds.png" alt=""></i>';
              echo $this->Html->link( $entrepre .'ADD PROJECT', array('controller'=>'Consultings','action'=>'myConsulting'), array('escape'=>false,'class'=>'active'));
          ?>
      </div>
    </div>
  </div>
       
  <div class='row'>
    <div class='col-lg-11 col-md-12 col-sm-12 '>
      <div class="form-group">
        <div class="row">
          <?= $this->Form->create('Search',['id'=>'FormField','type'=>'get']) ?>
              <div class="col-lg-9 col-md-9 col-sm-12 ">
              <input type="search" placeholder="Search" name="search" class="form-control">
              </div>
              <div class="col-lg-3 col-md-3 col-sm-12 no_paddingleftcol ">
              <button class="searchBtn" type="submit">Search</button>
              </div>
          <?= $this->Form->end() ?>
        </div>
      </div>

      <div class="table-responsive">
        <table class="table table-striped startup-list">
          <thead>
            <tr>
              <th width="17%">Image</th>
              <th width="25%">Title</th>
              <th width="20%">Created By</th>
              <th width="20%">Status</th>
              <th width="18%">Step</th>
            </tr>                 
          </thead>
            <tbody>
              <?php if(!empty($myFundsLists)){?>
                <?php $ss=0; foreach($myFundsLists AS $myFundsList){ $ss++; ?>
                    <tr>
                      <td>
                        <?php 
                        $id = base64_encode($myFundsList['user_id']);
                        $fundId= base64_encode($myFundsList['id']);
                        if(!empty($myFundsList['image'])){

                          echo $this->Html->link('<img src="'.$this->request->webroot.'img/consulting/'.$myFundsList['image'].'" width="50" height="50">',['controller'=>'Consultings','action'=>'view',$fundId],['escape'=>false,'title'=>'Click Here View']);

                        }else{
                          echo $this->Html->link('<i class="icon"><img src="'.$this->request->webroot.'images/campaign.png"></i>',['controller'=>'Consultings','action'=>'view',$fundId],['escape'=>false,'title'=>'Click Here View']);
                        }
                        ?>
                      </td>
                      <td>
                        
                        <?php 
                        echo $this->Html->link($myFundsList['title'],['controller'=>'Consultings','action'=>'view',$fundId],['escape'=>false,'title'=>'Click Here View']);
                        ?>
                      </td>

                      <td>
                        <?php 
                          echo $myFundsList['user']['first_name'].' '.$myFundsList['user']['last_name'];
                        ?>
                      </td>

                      <td>
                          <?php  
                            if(empty($myFundsList['award_status'])){
                                echo "Open";
                            }else{
                                echo "Close";
                            }    
                          ?>

                      </td>
                      
                      <td>
                        
                        <?php 
                        $startId= base64_encode($myFundsList['id']);
                        echo $this->Html->link('View',['controller'=>'Consultings','action'=>'view',$fundId],['class'=>'fa fa-angle-double-right']);
                        ?>
                      </td>
                      
                    </tr>
                  <?php }?>
              <?php }?>                
            </tbody>
         </table>
      </div> 
      <?php 
        if(!empty($ss)){?>
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
              <li>No Consulting Projects Available.</li>
            </ul>
          </nav>  
       <?php }?>
    </div>
  </div>
</div>
<!-- /#page-content-wrapper --> 

