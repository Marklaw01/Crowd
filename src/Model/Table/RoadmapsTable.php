<?php
namespace App\Model\Table;

use App\Model\Entity\Roadmap;
use Cake\ORM\Query;
use Cake\ORM\RulesChecker;
use Cake\ORM\Table;
use Cake\Validation\Validator;

class RoadmapsTable extends Table
{
    public function initialize(array $config)
    {
    	 parent::initialize($config);
         $this->addBehavior('Timestamp');
         $this->table('roadmaps');
         $this->primaryKey('id');

        $this->belongsTo('Users', [
            'foreignKey' => 'user_id'
        ]);
        
        

    }
}

?>