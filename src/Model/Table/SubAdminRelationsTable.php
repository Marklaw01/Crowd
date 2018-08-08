<?php
namespace App\Model\Table;

//use App\Model\Entity\SubAdminDetail;
use Cake\ORM\Query;
use Cake\ORM\RulesChecker;
use Cake\ORM\Table;
use Cake\Validation\Validator;
use Cake\Auth\DefaultPasswordHasher;


class SubAdminRelationsTable extends Table
{
    public function initialize(array $config)
    { 
        parent::initialize($config);
        $this->addBehavior('Timestamp');
        $this->table('sub_admin_relations');
        $this->displayField('id');
        $this->primaryKey('id');
        
        $this->belongsTo('SubAdminDetails', [
            'foreignKey' => 'sub_admin_details_id'
        ]);
		
		/*$this->belongsTo('Industries', [
            'foreignKey' => 'industry'
        ]); 
		
		$this->belongsTo('JobTypes', [
            'foreignKey' => 'job_type'
        ]);*/
		
    }
    
}
?>
