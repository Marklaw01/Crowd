 <div class="container-fluid">
          <div class="row">
            <div class="col-lg-12 ">
              <ol class="breadcrumb">
                <li><?php
                    echo $this->Html->link('Home', array('controller'=>'Contractors','action'=>'dashboard'), array('escape'=>false));
                ?></li>
                 <li><?php
                    echo $this->Html->link('My Profile', array('controller'=>'Contractors','action'=>'myProfile'), array('escape'=>false));
                ?></li>
                <li class="active">Suggest Keywords</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-6 col-md-6 col-sm-6 '>
             <div class="page_heading">
               <h1>Suggest Keywords</h1> 
              </div>
            </div>
          </div>
          <!-- header ends --> 
          <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">

              

              <div role="tabpanel" class="about-section">
                
                <!-- Tab panes -->
                <div class="tab-content">
                 <!-- 1Tab-->                 
                 <?php //pr($user);?>
                  
                  <div role="tabpanel" class="tab-pane active" id="connections">

                      <div class="form-group"></div>
                        <div class="row">
                          <?= $this->Form->create($suggested,['id'=>'FormField']) ?>
                          
                              <div class="col-lg-4 col-md-4 col-sm-4 no_paddingleftcol ">
                                <input type="search" placeholder="Keyword name" name="name" class="form-control">
                                <?php 
                                  echo $this->Form->error('name', null, array('class' => 'error-message'));
                                ?>
                              </div>

                              <div class="col-lg-4 col-md-4 col-sm-4 no_paddingleftcol ">
                               
                                <?php
                                  echo $this->Form->input('keyword_type', ARRAY('label' => false, 'div' => false,'error' => false, 'class' => 'selectpicker form-control show-tick', 'id' => 'keyword_type','type'=>'select','title'=>'Select Keyword Type', 'data-size'=>'5', 'options'=>$KeywordTypes));
                                ?>
                                <?php 
                                  echo $this->Form->error('keyword_type', null, array('class' => 'error-message'));
                                ?>
                              </div>

                              <div class="col-lg-3 col-md-3 col-sm-3 no_paddingleftcol ">
                                  <button class="searchBtn" type="submit">Add</button>
                              </div>

                          <?= $this->Form->end() ?>
                        </div>
                      

                      <div class='row'>
                        <div class='col-lg-11 col-md-12 col-sm-12 '>
                          <div class="table-responsive mver20 ">
                            <table class="table table-striped startup-list">
                              <tr>
                                  <th>S.NO.</th>
                                  <th>Name</th>
                                  <th>Type</th>
                                  <th>Status</th>
                                  <th>Action</th>
                              </tr>
                              <?php $i=0; foreach ($KeywordSuggestedLists as $key => $value) { $i++; ?>
                                  <tr>
                                    <td><?php echo $i; ?></td>
                                    <td><?php echo $value->name;?></td>
                                    <td><?php echo $value->keyword_type->name;?></td>
                                    <td><?php if(empty($value->status)){ echo '<span style="color:red;">Pending</span>';}else if($value->status==2) {echo '<span style="color:red;">Rejected</span>';}else{echo '<span style="color:green;">Accepted</span>';}?></td>
                                    <td>
                                      <?php
                                          echo $this->Html->link('Delete', array('controller'=>'Contractors','action'=>'deleteSuggestKeywords',base64_encode($value->id)), array('escape'=>false));
                                      ?>
                                    </td>
                                  </tr>
                              <?php } ?>
                            </table>
                          </div>  
                        </div>
                      </div>
                  </div>
                  
                </div>
              </div>
            </div>
          </div>
 </div>
 <!-- /#page-content-wrapper --> 
<script type="text/javascript">

</script>