<?php
namespace App\Model\Table;

//use App\Model\Entity\Job;
use Cake\ORM\Query;
use Cake\ORM\RulesChecker;
use Cake\ORM\Table;
use Cake\Validation\Validator;
use Cake\Auth\DefaultPasswordHasher;


class AudioDislikesTable extends Table
{
    public function initialize(array $config)
    { 
        parent::initialize($config);
        $this->addBehavior('Timestamp');
        $this->table('audio_dislikes');
        $this->displayField('id');
        $this->primaryKey('id');


        $this->belongsTo('Users', [
            'foreignKey' => 'dislike_by',
            'joinType' => 'INNER'
        ]);
        
        
		
    }

    
}
?>
