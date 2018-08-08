<?php
namespace App\Model\Table;

use App\Model\Entity\Certification;
use Cake\ORM\Query;
use Cake\ORM\Table;
use Cake\Validation\Validator;

class CertificationsTable extends Table
{
     public function initialize(array $config)
    {
    	 parent::initialize($config);
        $this->addBehavior('Timestamp');
    }

}




?>