---<select id="state" name="state">
<option value="">Select State</option>
<?php 
foreach($states as $state){ ?>

<option value="<?php echo $state->id;?>" > <?php echo $state->name; ?> </option>

<?php } ?>
</select>---