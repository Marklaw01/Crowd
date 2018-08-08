<?php
namespace App\Model\Table;

use App\Model\Entity\RoadmapDynamic;
use Cake\ORM\Query;
use Cake\ORM\RulesChecker;
use Cake\ORM\Table;
use Cake\Validation\Validator;

/**
 * Campaigns Model
 *
 * @property \Cake\ORM\Association\BelongsTo $Users
 * @property \Cake\ORM\Association\BelongsTo $Startups
 * @property \Cake\ORM\Association\HasMany $CampaignDonations
 * @property \Cake\ORM\Association\HasMany $CampaignFollowers
 * @property \Cake\ORM\Association\HasMany $CampaignRecommendations
 */
class RoadmapDynamicsTable extends Table
{

    /**
     * Initialize method
     *
     * @param array $config The configuration for the Table.
     * @return void
     */
    public function initialize(array $config)
    {
        parent::initialize($config);

        $this->table('roadmap_dynamics');
        $this->displayField('id');
        $this->primaryKey('id');

        $this->addBehavior('Timestamp');
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
            ->add('id', 'valid', ['rule' => 'numeric'])
            ->allowEmpty('id', 'create');

        $validator
            ->requirePresence('title', 'create')
            ->notEmpty('title','Title can not be left blank.')
            ->add('title','custom',[
                'rule' => function($value){ //pr($value);die;
                            if ($value) {
                                if (!preg_match("/^[a-zA-Z0-9!@#$%^&*().+=_\/-:,;?\-<>\'\" ]+$/i", $value)) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Title has invalid characters!',
            ]);

        $validator
            ->requirePresence('description', 'create')
            ->allowEmpty('description','Description can not be left blank.');
            /*->add('summary','custom',[
                'rule' => function($value){ //pr($value);die;
                            if ($value) {
                                if (!preg_match("/^[\r\na-zA-Z0-9!@#$%^&*().+=_\/-:,;?\-<>\'\" ]+$/", $value)) {
                                    return false;
                                }
                            }
                    return true;
                },
                'message'=>'Summary has invalid characters!',
            ]);*/

       /*  $validator
            ->requirePresence('files', 'create')
            ->notEmpty('files');

       $validator
            ->add('status', 'valid', ['rule' => 'numeric'])
            ->requirePresence('status', 'create')
            ->notEmpty('status');

        $validator
            ->add('hold', 'valid', ['rule' => 'numeric'])
            ->requirePresence('hold', 'create')
            ->notEmpty('hold');*/

        return $validator;
    }

    /**
     * Returns a rules checker object that will be used for validating
     * application integrity.
     *
     * @param \Cake\ORM\RulesChecker $rules The rules object to be modified.
     * @return \Cake\ORM\RulesChecker
     */

}
