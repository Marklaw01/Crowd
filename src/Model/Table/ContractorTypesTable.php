<?php
namespace App\Model\Table;

use App\Model\Entity\ContractorType;
use Cake\ORM\Query;
use Cake\ORM\Table;
use Cake\Validation\Validator;

class ContractorTypesTable extends Table
{
     public function initialize(array $config)
    {
    	 parent::initialize($config);
        $this->addBehavior('Timestamp');
    }

}




?>