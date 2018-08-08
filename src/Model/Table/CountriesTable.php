<?php
namespace App\Model\Table;

use App\Model\Entity\Country;
use Cake\ORM\Query;
use Cake\ORM\Table;
use Cake\Validation\Validator;

class CountriesTable extends Table
{
     public function initialize(array $config)
    {
    	 parent::initialize($config);
        $this->addBehavior('Timestamp');
    }

}




?>