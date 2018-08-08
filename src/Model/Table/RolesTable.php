<?php
namespace App\Model\Table;

use App\Model\Entity\Role;
use Cake\ORM\Query;
use Cake\ORM\RulesChecker;
use Cake\ORM\Table;
use Cake\Validation\Validator;

class RolesTable extends Table
{
    public function initialize(array $config)
    {
    	parent::initialize($config);
        $this->addBehavior('Timestamp');
        
      
       

    }
}





?>