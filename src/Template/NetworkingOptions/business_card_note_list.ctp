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

                <li class="active">Business Cards Notes List</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-6 col-md-6 col-sm-6 '>
             <div class="page_heading">
               <h1>Business Card Notes List</h1> 
              </div>
            </div>
            <div class='col-lg-6 col-md-6 col-sm-6'>
              <div class="profileName">
                  <?php
                     
                      echo $this->Html->link('Search Connection', array('controller'=>'NetworkingOptions','action'=>'contacts'), array('escape'=>false,'class'=>' greenBtn'));
                  ?>
              </div>
            </div>
          </div>
          <!-- header ends --> 
       
         <div class='row'>
          <div class='col-lg-11 col-md-12 col-sm-12 '>

             <div class="table-responsive">
                 <table class="table table-striped startup-list">
                    <thead>
                      <tr>
                        <th width="33.3%">S.No.</th>
                        <th width="33.3%">Note</th>
                        <th width="33.3%">Action</th>
                      </tr>
                                      
                    </thead>
                    <tbody>
                      <?php  
                      if(!empty($businessCardNotes)){?>
                        <?php $ss=0; foreach($businessCardNotes AS $businessCardNote){ $ss++; ?>
                            <tr <?php //echo $businessCardNote['status'] == 1?'class="success"':''; ?> >

                              <td >
                                
                              <?php 
                                echo $ss;
                              ?>
                              </td>

                              <td>
                                <?php 

                                  echo $businessCardNote['description'];
                                
                                ?>
                              </td>
                              
                              <td>
                                
                                <?php 
                                  $noteId= base64_encode($businessCardNote['id']);
                                  echo $this->Html->link('',['controller'=>'NetworkingOptions','action'=>'businessCardNoteEdit',$noteId],['class'=>'fa fa-pencil-square-o fa-2x']);
                                
                                ?>
                              </td>
                              
                            </tr>
                          <?php }?>
                      <?php }?>  
                                     
                    </tbody>

                 </table>
              </div> 
                      
        </div>
        </div>
        </div>
        <!-- /#page-content-wrapper --> 

