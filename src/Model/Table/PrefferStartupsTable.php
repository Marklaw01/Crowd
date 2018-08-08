<?php
namespace App\Model\Table;

use App\Model\Entity\PrefferStartup;
use Cake\ORM\Query;
use Cake\ORM\Table;
use Cake\Validation\Validator;

class PrefferStartupsTable extends Table
{
     public function initialize(array $config)
    {
    	 parent::initialize($config);
        $this->addBehavior('Timestamp');
    }

}




?>