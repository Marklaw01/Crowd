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
                <li class="active">My Business Cards</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-6 col-md-6 col-sm-6 '>
             <div class="page_heading">
               <h1>My Business Cards</h1> 
              </div>
            </div>
            <div class='col-lg-6 col-md-6 col-sm-6'>
              <div class="profileName">
                  <?php
                      $entrepre = '<i class="fa fa-credit-card"></i>';
                      echo $this->Html->link( $entrepre .'Add Business Card', array('controller'=>'NetworkingOptions','action'=>'addBusinessCard'), array('escape'=>false,'class'=>'active'));
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
                        <th width="33.3%">Card Bio</th>
                        <th width="33.3%">Action</th>
                      </tr>
                                      
                    </thead>
                    <tbody>
                      <?php if(!empty($businessCardResults)){?>
                        <?php $ss=0; foreach($businessCardResults AS $businessCard){ $ss++; ?>
                            <tr <?php echo $businessCard['status'] == 1?'class="success"':''; ?> >

                              <td >
                                
                              <?php 
                                echo $ss;
                              ?>
                              </td>

                              <td>
                                <?php 

                                   echo $string2 = substr($businessCard['user_bio'], 0, 70);
                                  //echo $businessCard['user_bio'];
                                
                                ?>
                              </td>
                              
                              <td>
                                
                                <?php 
                                $cardId= base64_encode($businessCard['id']);
                                echo $this->Html->link('',['controller'=>'NetworkingOptions','action'=>'editBusinessCard',$cardId],['class'=>'fa fa-pencil-square-o fa-2x']);

                                echo "&nbsp;&nbsp;&nbsp;".$this->Html->link('',['controller'=>'NetworkingOptions','action'=>'deleteBusinessCard',$cardId],['class'=>'fa fa-trash fa-2x']);

                                if($businessCard['status'] == 1){
                                echo "&nbsp;&nbsp;&nbsp;".$this->Html->link('',['controller'=>'NetworkingOptions','action'=>'activeBusinessCard',$cardId],['class'=>'fa fa-toggle-on fa-2x']);
                                }else{
                                  echo "&nbsp;&nbsp;&nbsp;".$this->Html->link('',['controller'=>'NetworkingOptions','action'=>'activeBusinessCard',$cardId],['class'=>'fa fa-toggle-off fa-2x']);
                                } 

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

