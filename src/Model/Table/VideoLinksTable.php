<?php
namespace App\Model\Table;

//use App\Model\Entity\VideoLink;
use Cake\ORM\Query;
use Cake\ORM\RulesChecker;
use Cake\ORM\Table;
use Cake\Validation\Validator;
use Cake\Auth\DefaultPasswordHasher;

class VideoLinksTable extends Table
{
    public function initialize(array $config)
    {
        parent::initialize($config);
        $this->addBehavior('Timestamp');
        $this->table('video_links');
        $this->displayField('id');
        $this->primaryKey('id');
         
    }
    /**
     * Default validation rules.
     *
     * @param \Cake\Validation\Validator $validator Validator instance.
     * @return \Cake\Validation\Validator
     */
    public function validationDefault(Validator $validator)
    {
        
        $validator
            ->requirePresence('link')
            ->notEmpty('link');
			
        return $validator;
    }
    /**
    *       Password Validations
    **/
  
}
?>
