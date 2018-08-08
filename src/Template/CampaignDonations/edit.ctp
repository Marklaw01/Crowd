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
                <li class="active">Campaign Donation</li>
              </ol>
            </div>
          </div>
          <!-- breadcrumb ends --> 
          <div class='row'>
            <div class='col-lg-12 col-md-12 col-sm-12 '>
             <div class="page_heading">
               <h1>Edit Campaign Donation</h1> 
              </div>
            </div>
            
          </div>
          <!-- header ends --> 
          <?= $this->Form->create($donations) ?>
          <div class="row">
            <div class="col-lg-8 col-md-8 col-sm-12 ">
              <div class="form-group">
                <span class="form-control">
                   <?php echo $donations->campaign->campaigns_name; ?>
                </span>
                 
              </div>
              <div class="form-group">
                <?php
                  echo $this->Form->input('amount', ARRAY('label' => false,'readonly', 'div' => false,'error' => false, 'id' => 'amount', 'type'=>'text', 'placeholder'=>'Amount','class' => 'form-control', 'value' => $this->Number->precision($donations->amount,2)));
                ?>
                 
                <?php 

                      echo $this->Form->error('amount', null, array('class' => 'error-message','id'=>'amount'));
                ?>
              </div>

              <div class="form-group">

                  <select id="time_period" class="selectpicker form-control show-tick" name="time_period" disabled="true">         
                   <?php foreach ($timeperiods as $timeperiod){ ?>
                      <option <?php if($donations->time_period == $timeperiod->id){ echo 'selected="selected"';}?> value="<?php echo $timeperiod->id; ?>">
                        <?php echo $timeperiod->timeperiod;?> <?php echo $timeperiod->type; ?>
                      </option>
                   <?php }?>
                   </select>  
                <?php 
                      echo $this->Form->error('time_period', null, array('class' => 'error-message'));
                ?>
              </div>
              <div class="form-group">
                    <div class="radio">
                      <span>Make my Contribution: </span>
                          <input type="radio" value="1" <?php if($donations->status == 1){ echo $checkk= 'checked="checked"';} else{ echo $checkk='';}?> name="status" id="private"> <label for="private">Private</label> 
                          <input type="radio" value="0" <?php if($donations->status == 0){ echo $nTcheckk= 'checked="checked"';} else{ echo $nTcheckk='';}?> name="status" id="public"> <label for="public">Public</label> 
                    </div>
              </div>

          </div>
              
              <div class="col-lg-8 col-md-8 col-sm-12 ">

              <?= $this->Html->link(__('Back to Campaign'), ['controller' => 'campaigns','action' => 'view',base64_encode($donations->campaign_id)]) ?>

                <div class="form-group  pull-right">
                   <?= $this->Form->button('Update',['class'=> 'customBtn blueBtn']) ?>
                </div>
             </div>
          </div>
         <?= $this->Form->end() ?>
        </div>
        <!-- /#page-content-wrapper --> 

<script type="text/javascript">
$(document).ready(function () {

     $('#amount').priceFormat({
          prefix: '$'
     });

      /*var amount = '<?php echo $donations->amount;?>';
      var i = parseFloat(amount);
      if(isNaN(i)) { i = 0.00; }
      var minus = '';
      if(i < 0) { minus = '-'; }
      i = Math.abs(i);
      i = parseInt((i + .005) * 100);
      i = i / 100;
      s = new String(i);
      if(s.indexOf('.') < 0) { s += '.00'; }
      if(s.indexOf('.') == (s.length - 2)) { s += '0'; }
      s = minus + s;
      $('#amount').val(s);*/

  });

</script>
