<?php
namespace App\Model\Table;

use App\Model\Entity\ContractorRole;
use Cake\ORM\Query;
use Cake\ORM\RulesChecker;
use Cake\ORM\Table;
use Cake\Validation\Validator;

class ContractorRolesTable extends Table
{
    public function initialize(array $config)
    {
    	 parent::initialize($config);
         $this->addBehavior('Timestamp');
          $this->table('contractor_roles');
          $this->displayField('id');
         $this->primaryKey('id');

       
    }
}

?>