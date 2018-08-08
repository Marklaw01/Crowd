<?php
namespace App\Model\Table;

use App\Model\Entity\StartupDoc;
use Cake\ORM\Query;
use Cake\ORM\RulesChecker;
use Cake\ORM\Table;
use Cake\Validation\Validator;

class StartupDocsTable extends Table
{
    public function initialize(array $config)
    {
    	 parent::initialize($config);
         $this->addBehavior('Timestamp');
         
         $this->table('startup_docs');
         $this->displayField('id');
         $this->primaryKey('id');

          $this->belongsTo('Users', [
            'foreignKey' => 'user_id'
          ]);

          $this->belongsTo('Roadmaps', [
            'foreignKey' => 'roadmap_id'
          ]);

          $this->belongsTo('Startups', [
            'foreignKey' => 'startup_id'
          ]);
       
    }

     public function validationDefault(Validator $validator){
         //Its empty

          $validator 
            ->requirePresence('roadmap_id') 
            ->notEmpty('roadmap_id','Select roampmap.');

           $validator 
            ->requirePresence('file_path') 
            ->notEmpty('file_path','Please select file or doc.');
  

        $validator 
            ->requirePresence('name') 
            ->notEmpty('name','Name can not be empty.')
            ->add('name', [
                'maxLength' => [
                    'rule' => ['maxLength', 50],
                    'message' => 'Name can not be more then 50 character.',
                ]
            ]);
            /*->add('name','custom',[
                'rule' => function($value){ 
                            if ($value) { 
                                if (!preg_match("/^[a-zA-Z0-9!@#$%^`~&*().+=_:,\-\' ]+$/i", trim($value))) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'File Name has invalid characters!..',
            ]);*/

        return $validator;
    }

    public function validationEditUploadedDocs(Validator $validator){
         //Its empty

          $validator 
            ->requirePresence('roadmap_id') 
            ->notEmpty('roadmap_id','Select roampmap.');

           $validator 
            ->requirePresence('file_path') 
            ->allowEmpty('file_path','Please select file or doc.');
  

        $validator 
            ->requirePresence('name') 
            ->notEmpty('name','Name can not be empty.')
            ->add('name', [
                'maxLength' => [
                    'rule' => ['maxLength', 50],
                    'message' => 'Name can not be more then 50 character.',
                ]
            ]);
            /*->add('name','custom',[
                'rule' => function($value){ 
                            if ($value) { 
                                if (!preg_match("/^[a-zA-Z0-9!@#$%^`~&*().+=_:,\-\' ]+$/i", trim($value))) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'File Name has invalid characters!!!',
            ]);*/

        return $validator;
    }

   

}

?>