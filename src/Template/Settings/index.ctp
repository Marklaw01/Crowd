<?= $this->Html->css('demo.css') ?>
<?=$this->Html->script('jquery'); ?>
<?=$this->Html->script('jquery.collapse'); ?>
<?= $this->fetch('css') ?>
<?= $this->fetch('script') ?>

<style>
    h3{font-weight: bold !important;}
    .url{font-size: 20px;}
    .input-param{font-style: italic;font-size: 18px;}
</style>
 
<div id="accordion-example" data-collapse="accordion">
  
<?php $i=1;
        foreach($ApiList as $single_item){
            echo $i.'  '.$single_item;
            $i++;
        }
?>

</div>
 
 
     