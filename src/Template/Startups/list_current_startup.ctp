<?php if(!empty($startupdata)){?>
<table>
    <tr>
        <th>Startup</th>
        <th>Enterpreneur Name</th>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <th>Step</th>
    </tr>
   <?php// pr($startupdata);die;?>
<?php foreach($startupdata as $startup){?>
    <!-- Here is where we iterate through our $articles query object, printing out article info -->
      
<tr>
        <td><?= $startup['name'] ?></td>
        <td><?= $startup['user']['first_name'].'  '.$startup['user']['last_name'] ?></td>
        <td><?= $startup['next_step'] ?></td>
        <td>
            <?php echo $this->Html->link('Edit',Array('action'=>'EditStartup',$startup['id']));?>   
        </td>
</tr>
<?php } ?>
</table>
<?php }else{
            echo $this->Html->link("Add Detail",ARRAY('controller'=>'startups','action'=>'AddStartup'),ARRAY('class'=>""));
          }
?>