<div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li><?php
                    echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                <li class="active">Search Organization</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <div class="page_heading">
               <h1>Search Organization</h1> 
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
                            <input type="search" placeholder="Search by organization name" name="search" class="form-control">
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
                                <th width="33.3%">Organization Name</th>
                                <th width="33.3%">Owner Name</th>
                                <th width="33.3%">Step</th>
                              </tr>
                                              
                            </thead>
                            <tbody>
                              <?php if(!empty($companyLists)){?>
                                <?php $ss=0; foreach($companyLists AS $companyList){ $ss++; ?>
                                    <tr>

                                      <td>
                                        
                                      <?php 
                                        $compId= base64_encode($companyList['id']);
                                        
                                        echo $this->Html->link($companyList['company_name'],['controller'=>'Companies','action'=>'view',$compId],['escape'=>false,'title'=>'Click Here View']);
                                      ?>
                                      </td>

                                      <td>
                                        <?php 

                                          echo $companyList['user']['first_name'].' '.$companyList['user']['last_name'];
                                        
                                        ?>
                                      </td>
                                      
                                      <td>
                                        
                                        <?php 
                                        $compId= base64_encode($companyList['id']);
                                        echo $this->Html->link('View',['controller'=>'Companies','action'=>'view',$compId],['class'=>'fa fa-angle-double-right']);
                                        ?>
                                      </td>
                                      
                                    </tr>
                                  <?php }?>
                              <?php }?>  
                                             
                            </tbody>
     
                         </table>
                      </div> 
                      <?php 

                        $cc= count($companyLists);
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
                                      <li>No Companies Available.</li>
                                    </ul>
                                  </nav>  
                       <?php }?>

        </div>
        </div>
        </div>
        <!-- /#page-content-wrapper --> 

