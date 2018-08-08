<?php
namespace App\Model\Table;

use App\Model\Entity\StartupQuestion;
use Cake\ORM\Query;
use Cake\ORM\Table;
use Cake\Validation\Validator;

class StartupQuestionsTable extends Table
{
     public function initialize(array $config)
    {
    	 parent::initialize($config);
        $this->addBehavior('Timestamp');

        $this->belongsTo('Startups', [
            'foreignKey' => 'startup_id'
        ]);
    }

}




?>