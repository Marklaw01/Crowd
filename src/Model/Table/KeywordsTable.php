<?php
namespace App\Model\Table;

use App\Model\Entity\Keyword;
use Cake\ORM\Query;
use Cake\ORM\Table;
use Cake\Validation\Validator;

class KeywordsTable extends Table
{
     public function initialize(array $config)
    {
    	 parent::initialize($config);
        $this->addBehavior('Timestamp');
    }

}




?>