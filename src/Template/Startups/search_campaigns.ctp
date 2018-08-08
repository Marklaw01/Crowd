<div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li><?php
                    echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                <li><?php
                    echo $this->Html->link('Startups', array('controller'=>'Startups','action'=>'currentStartup'), array('escape'=>false));
                ?></li>
                <li class="active">Search Campaign</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <div class="page_heading">
               <h1>Search Campaign</h1> 
              </div>
            </div>
            
          </div>
          <!-- header ends --> 
       
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
                                <th width="33.3%">Campaign Name</th>
                                <th width="33.3%">Enterpreneur Name</th>
                                <th width="33.3%">Step</th>
                              </tr>
                                              
                            </thead>
                            <tbody>
                              <?php if(!empty($startup_detail)){?>
                                <?php $ss=0; foreach($startup_detail AS $startup){ $ss++; ?>
                                    <tr>

                                      <td>
                                        
                                      <?php 
                                      $id = base64_encode($startup['user_id']);
                                      $startId= base64_encode($startup['id']);
                                      echo $this->Html->link($startup['campaigns_name'],['controller'=>'Campaigns','action'=>'view',$startId],['escape'=>false,'title'=>'Click Here View']);
                                      ?>
                                      </td>

                                      <td>
                                        <?php if(!empty($startup['user']['entrepreneur_basic']['first_name'])){
                        
                                          echo $startup['user']['entrepreneur_basic']['first_name'].' '.$startup['user']['entrepreneur_basic']['last_name'];
                         
                                        }else{

                                          echo $startup['user']['first_name'].' '.$startup['user']['last_name'];
                                        } ?>
                                      </td>
                                      
                                      <td>
                                        
                                        <?php 
                                        $startId= base64_encode($startup['id']);
                                        echo $this->Html->link('Next Step',['controller'=>'Campaigns','action'=>'view',$startId],['class'=>'fa fa-angle-double-right']);
                                        ?>
                                      </td>
                                      
                                    </tr>
                                  <?php }?>
                              <?php }?>  
                                             
                            </tbody>
     
                         </table>
                      </div> 
                      <?php 

                        $cc= count($startup_detail);
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
                                      <li>No Campaigns Available.</li>
                                    </ul>
                                  </nav>  
                       <?php }?>

        </div>
        </div>
        </div>
        <!-- /#page-content-wrapper --> 

