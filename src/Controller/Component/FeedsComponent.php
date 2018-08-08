<?php
namespace App\Controller\Component;

use Cake\Controller\Component;
use Cake\Controller\ComponentRegistry;
use Cake\Network\Exception\InternalErrorException;
use Cake\Utility\Text;
use Cake\Routing\Router;
use Cake\ORM\TableRegistry;

class FeedsComponent extends Component
{

	/****
	*
	* Check user enabled feeds settings
	*
	******/
	public function getFeedsSetting($senderId=null,$type=null)
    {
    		$BetaSignups = TableRegistry::get('BetaSignups');
    		$BetaSignups= $BetaSignups->find('all',['conditions'=>['user_id'=>$senderId,'type'=>$type]]);

    		$TotalItems= $BetaSignups->count();
	        if(empty($TotalItems)){
	        	$TotalItems=0;
	        }
	        return $TotalItems;

    }

	/****
	*
	* Get User Connections Id List
	*
	******/
	public function getConnectionLists($senderId=null)
    {
            $this->paginate = ['limit' => 10];
            $UserConnections = TableRegistry::get('UserConnections');
			

			$connectionLists = $UserConnections->find('all',
                                                      ['conditions'=>
                                                        ['UserConnections.status'=>1,
                                                        'OR'=>[
                                                                ['UserConnections.connection_by'=>$senderId],
                                                                ['UserConnections.connection_to'=>$senderId]
                                                              ]  
                                                        ]
                                                      ])->toArray();

            return $connectionLists;
    }

    /****
	*
	* Save User Profile Feeds
	*
	******/
	public function saveProfileFeeds($senderId=null,$type=null)
    {	
    	//Ger user connections List
    	$connectionLists= $this->getConnectionLists($senderId);

    	if(!empty($connectionLists)){
    		foreach ($connectionLists as $key => $value) {

    			//Check if seeting enabled
    			$isSettingEnabbled='';
    			if($value->connection_by == $senderId){
    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_to,$type);
    			}else{
    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_by,$type);
    			}
    			//Check if seeting enabled
    			if(!empty($isSettingEnabbled)){

					$UserFeeds = TableRegistry::get('UserFeeds');
					$title =" has an updated Profile.";
	    			$feeds = $UserFeeds->newEntity();
	    			$values = [];

	    			if($value->connection_by == $senderId){

	    				$link= Router::url(['controller' => 'Contractors', 'action' => 'myProfile',base64_encode($value->connection_by)]);
	    				$values = ['sender_id'=>$value->connection_by,'record_id'=>'','team_id'=>''];

	    				$feeds->sender_id = $value->connection_by;
	    				$feeds->receiver_id = $value->connection_to;

	    			}else{

	    				$link= Router::url(['controller' => 'Contractors', 'action' => 'myProfile',base64_encode($value->connection_to)]);
	    				$values = ['sender_id'=>$value->connection_to,'record_id'=>'','team_id'=>''];

	    				$feeds->sender_id = $value->connection_to;
	    				$feeds->receiver_id =$value->connection_by;

	    			}
	    			$feeds->type =$type;
	    			$feeds->title =$title;
	    			$feeds->link =$link;
	    			$feeds->record_name	 ='profile';
	    			$feeds->data =json_encode($values);

    				//Save user feeds.
    				$result = $UserFeeds->save($feeds);
    				//return $isSettingEnabbled;
    			}
    		}
    	}
    	//return
    }

    /**********************************************************
    *
    * Get startup name
    *
    *
    ****/
    public function startupName($startup_id=null)
    {
		$camapigns = TableRegistry::get('startups');
		 
		$query = $camapigns->find();
		$keywordsValue = $query->select(['name'])
								->where(['id'=>$startup_id])
								->first(); 
	  
		if(!empty($keywordsValue)&&($keywordsValue['name']!='')):
			return $keywordsValue['name'];
		else:
			return '0';
		endif;
		
	}

	/**
    *
    * Get startup team
    *
    *
    ****/
	public function startupTeamList($startup_id=null)
	{
			$resultList = TableRegistry::get('StartupTeams');
			 
			$resultLists = $resultList->find('all',['conditions'=>['startup_id'=>$startup_id,'approved'=>1]])->contain('Users')->toArray();
		  
			return $resultLists;
			
	}	

    /****
	*
	* Save User Startup Feeds
	*
	******/
	public function saveStartupFeeds($senderId=null,$type=null,$record_id=null)
    {	
    	if($type == 'feeds_startup_added'){ 
	    	//Ger user connections List
	    	$connectionLists= $this->getConnectionLists($senderId);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {
	    			//Check if seeting enabled
	    			$isSettingEnabbled='';
	    			if($value->connection_by == $senderId){
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_to,'feeds_startup');
	    			}else{
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_by,'feeds_startup');
	    			}
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){

	    				$recordName = $this->startupName($record_id);
						$title =' added "'.$recordName.'" startup.';
	    			
						$UserFeeds = TableRegistry::get('UserFeeds');
		    			$feeds = $UserFeeds->newEntity();
		    			$values = [];

		    			if($value->connection_by == $senderId){

		    				$link= Router::url(['controller' => 'Startups', 'action' => 'viewStartup',base64_encode($record_id)]);
		    				$values = ['sender_id'=>$value->connection_by,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_by;
		    				$feeds->receiver_id = $value->connection_to;

		    			}else{

		    				$link= Router::url(['controller' => 'Startups', 'action' => 'viewStartup',base64_encode($record_id)]);
		    				$values = ['sender_id'=>$value->connection_to,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_to;
		    				$feeds->receiver_id =$value->connection_by;

		    			}
		    			$feeds->type =$type;
		    			$feeds->title =$title;
		    			$feeds->link =$link;
		    			$feeds->record_name	=$record_id;

		    			$feeds->data =json_encode($values);

	    				//Save user feeds.
	    				$result = $UserFeeds->save($feeds);
	    				//return $isSettingEnabbled;
	    			}
	    		}
	    	}

	    }else{
	    	//Ger user connections List
	    	$connectionLists= $this->startupTeamList($record_id);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {

	    			//Check if seeting enabled
	    			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->user->id,'feeds_startup');
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){
	    				if($senderId != $value->user->id){

		    				$recordName = $this->startupName($record_id);

							if($type == 'feeds_startup_updated'){
								$title =' updated "'.$recordName.'" startup.';
							}else if($type == 'feeds_startup_member_added'){
								$title =' is now a team member of "'.$recordName.'" startup.';
							}else if($type == 'feeds_startup_completed_assignment'){
								$title =' completed an assignment for "'.$recordName.'" startup.';
							}else{
								$title ="Startup";
							}

		    				
							$UserFeeds = TableRegistry::get('UserFeeds');
			    			$feeds = $UserFeeds->newEntity();
			    			$values = [];

		    				$link= Router::url(['controller' => 'Startups', 'action' => 'viewStartup',base64_encode($record_id)]);
		    				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>$value->id];

		    				$feeds->sender_id = $senderId;
		    				$feeds->receiver_id = $value->user->id;

			    			$feeds->type =$type;
			    			$feeds->title =$title;
			    			$feeds->link =$link;
			    			$feeds->record_name	=$record_id;

			    			$feeds->data =json_encode($values);

		    				//Save user feeds.
		    				$result = $UserFeeds->save($feeds);
		    				//return $isSettingEnabbled;
		    			}	
	    			}
	    		}
	    	}	

	    	//Send feed to startup Owner
	    	if($type == 'feeds_startup_member_added'){
	    		$strtDetail = TableRegistry::get('startups');

	    		$strtDetails= $strtDetail->find('all',['conditions'=>['id'=>$record_id]])->first();

	    		$StartupTeams = TableRegistry::get('StartupTeams');
	    		$StartupTeam= $StartupTeams->find('all',['conditions'=>['startup_id'=>$record_id,'user_id'=>$senderId,'	approved'=>1]])->first();
				$teamId= $StartupTeam->id;

	    		//Check if seeting enabled
	    			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($strtDetails->user_id,'feeds_startup');
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){

	    				$recordName = $this->startupName($record_id);

						$title =' is now a team member of "'.$recordName.'" startup.';

						$UserFeeds = TableRegistry::get('UserFeeds');
		    			$feeds = $UserFeeds->newEntity();
		    			$values = [];

	    				$link= Router::url(['controller' => 'Startups', 'action' => 'viewStartup',base64_encode($record_id)]);
	    				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>$teamId];

	    				$feeds->sender_id = $senderId;
	    				$feeds->receiver_id = $strtDetails->user_id;

		    			$feeds->type =$type;
		    			$feeds->title =$title;
		    			$feeds->link =$link;
		    			$feeds->record_name	=$record_id;

		    			$feeds->data =json_encode($values);

	    				//Save user feeds.
	    				$result = $UserFeeds->save($feeds);
					}	
	    	}
	    }	
    }

    /**
    *
    * Get fund followers
    *
    *
    ****/
	public function fundFollowerList($record_id=null)
	{
			$resultList = TableRegistry::get('FundFollowers');
			 
			$resultLists = $resultList->find('all',['conditions'=>['fund_id'=>$record_id]])->toArray();
		  
			return $resultLists;
			
	}

    /****
	*
	* Save User Fund Feeds
	*
	******/
	public function saveFundsFeeds($senderId=null,$type=null,$record_id=null)
    {	
    	$recordDetails = TableRegistry::get('Funds');
	    $recordDetail= $recordDetails->find('all',['conditions'=>['id'=>$record_id]])->first();

    	if($type == 'feeds_fund_added'){ 
	    	//Ger user connections List
	    	$connectionLists= $this->getConnectionLists($senderId);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {
	    			//Check if seeting enabled
	    			$isSettingEnabbled='';
	    			if($value->connection_by == $senderId){
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_to,'feeds_fund');
	    			}else{
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_by,'feeds_fund');
	    			}
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){

	    				$recordName = $recordDetail->title;

						$title =' added "'.$recordName.'" Fund.';
	    			
						$UserFeeds = TableRegistry::get('UserFeeds');
		    			$feeds = $UserFeeds->newEntity();
		    			$values = [];

		    			if($value->connection_by == $senderId){

		    				$link= Router::url(['controller' => 'Funds', 'action' => 'view',base64_encode($record_id)]);
		    				$values = ['sender_id'=>$value->connection_by,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_by;
		    				$feeds->receiver_id = $value->connection_to;

		    			}else{

		    				$link= Router::url(['controller' => 'Funds', 'action' => 'view',base64_encode($record_id)]);
		    				$values = ['sender_id'=>$value->connection_to,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_to;
		    				$feeds->receiver_id =$value->connection_by;

		    			}
		    			$feeds->type =$type;
		    			$feeds->title =$title;
		    			$feeds->link =$link;
		    			$feeds->record_name	=$record_id;

		    			$feeds->data =json_encode($values);

	    				//Save user feeds.
	    				$result = $UserFeeds->save($feeds);
	    				//return $isSettingEnabbled;
	    			}
	    		}
	    	}

	    }else{

	    	//Ger user connections List
	    	$connectionLists= $this->fundFollowerList($record_id);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {

	    			//Check if seeting enabled
	    			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->user_id,'feeds_fund');
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){
	    				if($senderId != $value->user_id){

		    				$recordName = $recordDetail->title;

							$title =' is following "'.$recordName.'" fund.';
							
							$UserFeeds = TableRegistry::get('UserFeeds');
			    			$feeds = $UserFeeds->newEntity();
			    			$values = [];

		    				$link= Router::url(['controller' => 'Funds', 'action' => 'view',base64_encode($record_id)]);
		    				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $senderId;
		    				$feeds->receiver_id = $value->user_id;

			    			$feeds->type =$type;
			    			$feeds->title =$title;
			    			$feeds->link =$link;
			    			$feeds->record_name	=$record_id;

			    			$feeds->data =json_encode($values);

		    				//Save user feeds.
		    				$result = $UserFeeds->save($feeds);
		    				//return $isSettingEnabbled;
		    			}	
	    			}
	    		}
	    	}

	    	//Send feeds to Fund Owner
			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($recordDetail->user_id,'feeds_fund');
			//Check if seeting enabled
			if(!empty($isSettingEnabbled)){
				$recordName = $recordDetail->title;
				$title =' is following "'.$recordName.'" startup.';
				$UserFeeds = TableRegistry::get('UserFeeds');
    			$feeds = $UserFeeds->newEntity();
    			$values = [];
				$link= Router::url(['controller' => 'Funds', 'action' => 'view',base64_encode($record_id)]);
				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

				$feeds->sender_id = $senderId;
				$feeds->receiver_id = $recordDetail->user_id;

    			$feeds->type =$type;
    			$feeds->title =$title;
    			$feeds->link =$link;
    			$feeds->record_name	=$record_id;

    			$feeds->data =json_encode($values);

				//Save user feeds.
				$result = $UserFeeds->save($feeds);
			}

	    }    	
    }



    /************************************************************************
    *
    * Get campaign followers
    *
    *
    ****/
	public function campaignFollowerList($record_id=null)
	{
			$resultList = TableRegistry::get('CampaignFollowers');
			 
			$resultLists = $resultList->find('all',['conditions'=>['campaign_id'=>$record_id]])->toArray();
		  
			return $resultLists;
			
	}

    /****
	*
	* Save User Campaign Feeds
	*
	******/
	public function saveCampaignFeeds($senderId=null,$type=null,$record_id=null)
    {	
    	$recordDetails = TableRegistry::get('Campaigns');
	    $recordDetail= $recordDetails->find('all',['conditions'=>['id'=>$record_id]])->first();

    	if($type == 'feeds_campaign_added'){ 
	    	//Ger user connections List
	    	$connectionLists= $this->getConnectionLists($senderId);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {
	    			//Check if seeting enabled
	    			$isSettingEnabbled='';
	    			if($value->connection_by == $senderId){
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_to,'feeds_campaign');
	    			}else{
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_by,'feeds_campaign');
	    			}
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){

	    				$recordName = $recordDetail->campaigns_name;

						$title =' added "'.$recordName.'" Campaign.';
	    			
						$UserFeeds = TableRegistry::get('UserFeeds');
		    			$feeds = $UserFeeds->newEntity();
		    			$values = [];

		    			if($value->connection_by == $senderId){

		    				$link= Router::url(['controller' => 'Campaigns', 'action' => 'view',base64_encode($record_id)]);
		    				$values = ['sender_id'=>$value->connection_by,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_by;
		    				$feeds->receiver_id = $value->connection_to;

		    			}else{

		    				$link= Router::url(['controller' => 'Campaigns', 'action' => 'view',base64_encode($record_id)]);
		    				$values = ['sender_id'=>$value->connection_to,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_to;
		    				$feeds->receiver_id =$value->connection_by;

		    			}
		    			$feeds->type =$type;
		    			$feeds->title =$title;
		    			$feeds->link =$link;
		    			$feeds->record_name	=$record_id;

		    			$feeds->data =json_encode($values);

	    				//Save user feeds.
	    				$result = $UserFeeds->save($feeds);
	    				//return $isSettingEnabbled;
	    			}
	    		}
	    	}

	    }else{

	    	//Ger user connections List
	    	$connectionLists= $this->campaignFollowerList($record_id);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {

	    			//Check if seeting enabled
	    			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->user_id,'feeds_campaign');
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){
	    				if($senderId != $value->user_id){

		    				$recordName = $recordDetail->campaigns_name;

		    				if($type == 'feeds_campaign_commited'){

		    					$title =' made a commitment to "'.$recordName.'" Campaign.';

		    				}else{

								$title =' is following "'.$recordName.'" Campaign.';

							}

							$UserFeeds = TableRegistry::get('UserFeeds');
			    			$feeds = $UserFeeds->newEntity();
			    			$values = [];

		    				$link= Router::url(['controller' => 'Campaigns', 'action' => 'view',base64_encode($record_id)]);
		    				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $senderId;
		    				$feeds->receiver_id = $value->user_id;

			    			$feeds->type =$type;
			    			$feeds->title =$title;
			    			$feeds->link =$link;
			    			$feeds->record_name	=$record_id;

			    			$feeds->data =json_encode($values);

		    				//Save user feeds.
		    				$result = $UserFeeds->save($feeds);
		    				//return $isSettingEnabbled;
		    			}	
	    			}
	    		}
	    	}

	    	//Send feeds to Fund Owner
			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($recordDetail->user_id,'feeds_campaign');
			//Check if seeting enabled
			if(!empty($isSettingEnabbled)){
				$recordName = $recordDetail->campaigns_name;

				if($type == "feeds_campaign_commited"){

					$title =' made a commitment to "'.$recordName.'" Campaign.';
					
				}else{

					$title =' is following "'.$recordName.'" Campaign....';
					
					
				}

				$UserFeeds = TableRegistry::get('UserFeeds');
    			$feeds = $UserFeeds->newEntity();
    			$values = [];
				$link= Router::url(['controller' => 'Campaigns', 'action' => 'view',base64_encode($record_id)]);
				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

				$feeds->sender_id = $senderId;
				$feeds->receiver_id = $recordDetail->user_id;

    			$feeds->type =$type;
    			$feeds->title =$title;
    			$feeds->link =$link;
    			$feeds->record_name	=$record_id;

    			$feeds->data =json_encode($values);

				//Save user feeds.
				$result = $UserFeeds->save($feeds);
			}

	    }    	
    }


    /**************************************************************************
    *
    * Get improvement followers
    *
    *
    ****/
	public function improvementFollowerList($record_id=null)
	{
			$resultList = TableRegistry::get('SelfFollowers');
			 
			$resultLists = $resultList->find('all',['conditions'=>['self_id'=>$record_id]])->toArray();
		  
			return $resultLists;
			
	}

    /****
	*
	* Save User improvement Feeds
	*
	******/
	public function saveImprovementFeeds($senderId=null,$type=null,$record_id=null)
    {	
    	$recordDetails = TableRegistry::get('SelfImprovements');
	    $recordDetail= $recordDetails->find('all',['conditions'=>['id'=>$record_id]])->first();
	    $recordName = $recordDetail->title;

    	if($type == 'feeds_improvement_added'){ 
	    	//Ger user connections List
	    	$connectionLists= $this->getConnectionLists($senderId);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {
	    			//Check if seeting enabled
	    			$isSettingEnabbled='';
	    			if($value->connection_by == $senderId){
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_to,'feeds_improvement');
	    			}else{
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_by,'feeds_improvement');
	    			}
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){

						$title =' added "'.$recordName.'" self improvement tool.';
	    			
						$UserFeeds = TableRegistry::get('UserFeeds');
		    			$feeds = $UserFeeds->newEntity();
		    			$values = [];

		    			if($value->connection_by == $senderId){

		    				$link= Router::url(['controller' => 'SelfImprovements', 'action' => 'view',base64_encode($record_id)]);
		    				$values = ['sender_id'=>$value->connection_by,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_by;
		    				$feeds->receiver_id = $value->connection_to;

		    			}else{

		    				$link= Router::url(['controller' => 'SelfImprovements', 'action' => 'view',base64_encode($record_id)]);
		    				$values = ['sender_id'=>$value->connection_to,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_to;
		    				$feeds->receiver_id =$value->connection_by;

		    			}
		    			$feeds->type =$type;
		    			$feeds->title =$title;
		    			$feeds->link =$link;
		    			$feeds->record_name	=$record_id;

		    			$feeds->data =json_encode($values);

	    				//Save user feeds.
	    				$result = $UserFeeds->save($feeds);
	    				//return $isSettingEnabbled;
	    			}
	    		}
	    	}

	    }else{

	    	//Ger user connections List
	    	$connectionLists= $this->improvementFollowerList($record_id);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {

	    			//Check if seeting enabled
	    			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->user_id,'feeds_campaign');
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){
	    				if($senderId != $value->user_id){

							$title =' is following "'.$recordName.'" self improvement tool.';

							$UserFeeds = TableRegistry::get('UserFeeds');
			    			$feeds = $UserFeeds->newEntity();
			    			$values = [];

		    				$link= Router::url(['controller' => 'SelfImprovements', 'action' => 'view',base64_encode($record_id)]);
		    				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $senderId;
		    				$feeds->receiver_id = $value->user_id;

			    			$feeds->type =$type;
			    			$feeds->title =$title;
			    			$feeds->link =$link;
			    			$feeds->record_name	=$record_id;

			    			$feeds->data =json_encode($values);

		    				//Save user feeds.
		    				$result = $UserFeeds->save($feeds);
		    				//return $isSettingEnabbled;
		    			}	
	    			}
	    		}
	    	}

	    	//Send feeds to Fund Owner
			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($recordDetail->user_id,'feeds_campaign');
			//Check if seeting enabled
			if(!empty($isSettingEnabbled)){


				$title =' is following "'.$recordName.'" self improvement tool.';


				$UserFeeds = TableRegistry::get('UserFeeds');
    			$feeds = $UserFeeds->newEntity();
    			$values = [];
				$link= Router::url(['controller' => 'SelfImprovements', 'action' => 'view',base64_encode($record_id)]);
				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

				$feeds->sender_id = $senderId;
				$feeds->receiver_id = $recordDetail->user_id;

    			$feeds->type =$type;
    			$feeds->title =$title;
    			$feeds->link =$link;
    			$feeds->record_name	=$record_id;

    			$feeds->data =json_encode($values);

				//Save user feeds.
				$result = $UserFeeds->save($feeds);
			}

	    }    	
    }



    /**************************************************************************
    *
    * Get career followers
    *
    *
    ****/
	public function careerFollowerList($record_id=null)
	{
			$resultList = TableRegistry::get('CareerFollowers');
			 
			$resultLists = $resultList->find('all',['conditions'=>['career_id'=>$record_id]])->toArray();
		  
			return $resultLists;
			
	}

    /****
	*
	* Save User career Feeds
	*
	******/
	public function saveCareerFeeds($senderId=null,$type=null,$record_id=null)
    {	
    	$recordDetails = TableRegistry::get('CareerAdvancements');
	    $recordDetail= $recordDetails->find('all',['conditions'=>['id'=>$record_id]])->first();
	    $recordName = $recordDetail->title;

    	if($type == 'feeds_career_added'){ 
	    	//Ger user connections List
	    	$connectionLists= $this->getConnectionLists($senderId);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {
	    			//Check if seeting enabled
	    			$isSettingEnabbled='';
	    			if($value->connection_by == $senderId){
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_to,'feeds_career');
	    			}else{
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_by,'feeds_career');
	    			}
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){

						$title =' added "'.$recordName.'" career help tool.';
	    			
						$UserFeeds = TableRegistry::get('UserFeeds');
		    			$feeds = $UserFeeds->newEntity();
		    			$values = [];

		    			if($value->connection_by == $senderId){

		    				$link= Router::url(['controller' => 'CareerAdvancements', 'action' => 'view',base64_encode($record_id)]);
		    				$values = ['sender_id'=>$value->connection_by,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_by;
		    				$feeds->receiver_id = $value->connection_to;

		    			}else{

		    				$link= Router::url(['controller' => 'CareerAdvancements', 'action' => 'view',base64_encode($record_id)]);
		    				$values = ['sender_id'=>$value->connection_to,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_to;
		    				$feeds->receiver_id =$value->connection_by;

		    			}
		    			$feeds->type =$type;
		    			$feeds->title =$title;
		    			$feeds->link =$link;
		    			$feeds->record_name	=$record_id;

		    			$feeds->data =json_encode($values);

	    				//Save user feeds.
	    				$result = $UserFeeds->save($feeds);
	    				//return $isSettingEnabbled;
	    			}
	    		}
	    	}

	    }else{

	    	//Ger user connections List
	    	$connectionLists= $this->careerFollowerList($record_id);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {

	    			//Check if seeting enabled
	    			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->user_id,'feeds_career');
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){
	    				if($senderId != $value->user_id){

							$title =' is following "'.$recordName.'" career help tool.';

							$UserFeeds = TableRegistry::get('UserFeeds');
			    			$feeds = $UserFeeds->newEntity();
			    			$values = [];

		    				$link= Router::url(['controller' => 'CareerAdvancements', 'action' => 'view',base64_encode($record_id)]);
		    				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $senderId;
		    				$feeds->receiver_id = $value->user_id;

			    			$feeds->type =$type;
			    			$feeds->title =$title;
			    			$feeds->link =$link;
			    			$feeds->record_name	=$record_id;

			    			$feeds->data =json_encode($values);

		    				//Save user feeds.
		    				$result = $UserFeeds->save($feeds);
		    				//return $isSettingEnabbled;
		    			}	
	    			}
	    		}
	    	}

	    	//Send feeds to Fund Owner
			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($recordDetail->user_id,'feeds_career');
			//Check if seeting enabled
			if(!empty($isSettingEnabbled)){


				$title =' is following "'.$recordName.'" career help tool.';


				$UserFeeds = TableRegistry::get('UserFeeds');
    			$feeds = $UserFeeds->newEntity();
    			$values = [];
				$link= Router::url(['controller' => 'CareerAdvancements', 'action' => 'view',base64_encode($record_id)]);
				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

				$feeds->sender_id = $senderId;
				$feeds->receiver_id = $recordDetail->user_id;

    			$feeds->type =$type;
    			$feeds->title =$title;
    			$feeds->link =$link;
    			$feeds->record_name	=$record_id;

    			$feeds->data =json_encode($values);

				//Save user feeds.
				$result = $UserFeeds->save($feeds);
			}

	    }    	
    }



    /**************************************************************************
    *
    * Get forum followers
    *
    *
    ****/
	public function forumFollowerList($record_id=null)
	{
			$resultList = TableRegistry::get('ForumFollowers');
			 
			$resultLists = $resultList->find('all',['conditions'=>['forum_id'=>$record_id]])->toArray();
		  
			return $resultLists;
			
	}

    /****
	*
	* Save User career Feeds
	*
	******/
	public function saveForumFeeds($senderId=null,$type=null,$record_id=null)
    {	
    	$recordDetails = TableRegistry::get('Forums');
	    $recordDetail= $recordDetails->find('all',['conditions'=>['id'=>$record_id]])->first();
	    $recordName = $recordDetail->title;

    	if($type == 'feeds_forum_added'){ 
	    	//Ger user connections List
	    	$connectionLists= $this->getConnectionLists($senderId);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {
	    			//Check if seeting enabled
	    			$isSettingEnabbled='';
	    			if($value->connection_by == $senderId){
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_to,'feeds_forum');
	    			}else{
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_by,'feeds_forum');
	    			}
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){

						$title =' created forum "'.$recordName.'".';
	    			
						$UserFeeds = TableRegistry::get('UserFeeds');
		    			$feeds = $UserFeeds->newEntity();
		    			$values = [];

		    			if($value->connection_by == $senderId){

		    				$link= Router::url(['controller' => 'Forums', 'action' => 'viewForum',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$value->connection_by,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_by;
		    				$feeds->receiver_id = $value->connection_to;

		    			}else{

		    				$link= Router::url(['controller' => 'Forums', 'action' => 'viewForum',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$value->connection_to,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_to;
		    				$feeds->receiver_id =$value->connection_by;

		    			}
		    			$feeds->type =$type;
		    			$feeds->title =$title;
		    			$feeds->link =$link;
		    			$feeds->record_name	=$record_id;

		    			$feeds->data =json_encode($values);

	    				//Save user feeds.
	    				$result = $UserFeeds->save($feeds);
	    				//return $isSettingEnabbled;
	    			}
	    		}
	    	}

	    }else{

	    	//Ger user connections List
	    	$connectionLists= $this->forumFollowerList($record_id);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {

	    			//Check if seeting enabled
	    			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->user_id,'feeds_forum');
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){
	    				if($senderId != $value->user_id){

							$title =' added message on forum "'.$recordName.'".';

							$UserFeeds = TableRegistry::get('UserFeeds');
			    			$feeds = $UserFeeds->newEntity();
			    			$values = [];

		    				$link= Router::url(['controller' => 'Forums', 'action' => 'viewForum',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $senderId;
		    				$feeds->receiver_id = $value->user_id;

			    			$feeds->type =$type;
			    			$feeds->title =$title;
			    			$feeds->link =$link;
			    			$feeds->record_name	=$record_id;

			    			$feeds->data =json_encode($values);

		    				//Save user feeds.
		    				$result = $UserFeeds->save($feeds);
		    				//return $isSettingEnabbled;
		    			}	
	    			}
	    		}
	    	}

	    	//Send feeds to Fund Owner
			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($recordDetail->user_id,'feeds_forum');
			//Check if seeting enabled
			if(!empty($isSettingEnabbled)){


				$title =' added message on forum "'.$recordName.'".';


				$UserFeeds = TableRegistry::get('UserFeeds');
    			$feeds = $UserFeeds->newEntity();
    			$values = [];
				$link= Router::url(['controller' => 'Forums', 'action' => 'viewForum',base64_encode($record_id)]);

				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

				$feeds->sender_id = $senderId;
				$feeds->receiver_id = $recordDetail->user_id;

    			$feeds->type =$type;
    			$feeds->title =$title;
    			$feeds->link =$link;
    			$feeds->record_name	=$record_id;

    			$feeds->data =json_encode($values);

				//Save user feeds.
				$result = $UserFeeds->save($feeds);
			}

	    }    	
    }


    /**************************************************************************
    *
    * Get group followers
    *
    *
    ****/
	public function groupFollowerList($record_id=null)
	{
			$resultList = TableRegistry::get('GroupFollowers');
			 
			$resultLists = $resultList->find('all',['conditions'=>['group_id'=>$record_id]])->toArray();
		  
			return $resultLists;
			
	}

    /****
	*
	* Save group Feeds
	*
	******/
	public function saveGroupFeeds($senderId=null,$type=null,$record_id=null)
    {	
    	$recordDetails = TableRegistry::get('Groups');
	    $recordDetail= $recordDetails->find('all',['conditions'=>['id'=>$record_id]])->first();
	    $recordName = $recordDetail->title;

    	if($type == 'feeds_group_added'){ 
	    	//Ger user connections List
	    	$connectionLists= $this->getConnectionLists($senderId);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {
	    			//Check if seeting enabled
	    			$isSettingEnabbled='';
	    			if($value->connection_by == $senderId){
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_to,'feeds_group');
	    			}else{
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_by,'feeds_group');
	    			}
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){

						$title =' created "'.$recordName.'" group.';
	    			
						$UserFeeds = TableRegistry::get('UserFeeds');
		    			$feeds = $UserFeeds->newEntity();
		    			$values = [];

		    			if($value->connection_by == $senderId){

		    				$link= Router::url(['controller' => 'Groups', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$value->connection_by,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_by;
		    				$feeds->receiver_id = $value->connection_to;

		    			}else{

		    				$link= Router::url(['controller' => 'Groups', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$value->connection_to,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_to;
		    				$feeds->receiver_id =$value->connection_by;

		    			}
		    			$feeds->type =$type;
		    			$feeds->title =$title;
		    			$feeds->link =$link;
		    			$feeds->record_name	=$record_id;

		    			$feeds->data =json_encode($values);

	    				//Save user feeds.
	    				$result = $UserFeeds->save($feeds);
	    				//return $isSettingEnabbled;
	    			}
	    		}
	    	}

	    }else{

	    	//Ger user connections List
	    	$connectionLists= $this->groupFollowerList($record_id);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {

	    			//Check if seeting enabled
	    			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->user_id,'feeds_group');
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){
	    				if($senderId != $value->user_id){

							$title =' is following "'.$recordName.'" group.';

							$UserFeeds = TableRegistry::get('UserFeeds');
			    			$feeds = $UserFeeds->newEntity();
			    			$values = [];

		    				$link= Router::url(['controller' => 'Groups', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $senderId;
		    				$feeds->receiver_id = $value->user_id;

			    			$feeds->type =$type;
			    			$feeds->title =$title;
			    			$feeds->link =$link;
			    			$feeds->record_name	=$record_id;

			    			$feeds->data =json_encode($values);

		    				//Save user feeds.
		    				$result = $UserFeeds->save($feeds);
		    				//return $isSettingEnabbled;
		    			}	
	    			}
	    		}
	    	}

	    	//Send feeds to Fund Owner
			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($recordDetail->user_id,'feeds_group');
			//Check if seeting enabled
			if(!empty($isSettingEnabbled)){


				$title =' is following "'.$recordName.'" group.';


				$UserFeeds = TableRegistry::get('UserFeeds');
    			$feeds = $UserFeeds->newEntity();
    			$values = [];
				$link= Router::url(['controller' => 'Groups', 'action' => 'view',base64_encode($record_id)]);
				
				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

				$feeds->sender_id = $senderId;
				$feeds->receiver_id = $recordDetail->user_id;

    			$feeds->type =$type;
    			$feeds->title =$title;
    			$feeds->link =$link;
    			$feeds->record_name	=$record_id;

    			$feeds->data =json_encode($values);

				//Save user feeds.
				$result = $UserFeeds->save($feeds);
			}

	    }    	
    }


    /**************************************************************************
    *
    * Get hardware followers
    *
    *
    ****/
	public function hardwareFollowerList($record_id=null)
	{
			$resultList = TableRegistry::get('HardwareFollowers');
			 
			$resultLists = $resultList->find('all',['conditions'=>['hardware_id'=>$record_id]])->toArray();
		  
			return $resultLists;
			
	}

    /****
	*
	* Save hardware Feeds
	*
	******/
	public function saveHardwareFeeds($senderId=null,$type=null,$record_id=null)
    {	
    	$recordDetails = TableRegistry::get('Hardwares');
	    $recordDetail= $recordDetails->find('all',['conditions'=>['id'=>$record_id]])->first();
	    $recordName = $recordDetail->title;

    	if($type == 'feeds_hardware_added'){ 
	    	//Ger user connections List
	    	$connectionLists= $this->getConnectionLists($senderId);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {
	    			//Check if seeting enabled
	    			$isSettingEnabbled='';
	    			if($value->connection_by == $senderId){
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_to,'feeds_hardware');
	    			}else{
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_by,'feeds_hardware');
	    			}
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){

						$title =' added "'.$recordName.'" hardware.';
	    			
						$UserFeeds = TableRegistry::get('UserFeeds');
		    			$feeds = $UserFeeds->newEntity();
		    			$values = [];

		    			if($value->connection_by == $senderId){

		    				$link= Router::url(['controller' => 'Hardwares', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$value->connection_by,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_by;
		    				$feeds->receiver_id = $value->connection_to;

		    			}else{

		    				$link= Router::url(['controller' => 'Hardwares', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$value->connection_to,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_to;
		    				$feeds->receiver_id =$value->connection_by;

		    			}
		    			$feeds->type =$type;
		    			$feeds->title =$title;
		    			$feeds->link =$link;
		    			$feeds->record_name	=$record_id;

		    			$feeds->data =json_encode($values);

	    				//Save user feeds.
	    				$result = $UserFeeds->save($feeds);
	    				//return $isSettingEnabbled;
	    			}
	    		}
	    	}

	    }else{

	    	//Ger user connections List
	    	$connectionLists= $this->hardwareFollowerList($record_id);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {

	    			//Check if seeting enabled
	    			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->user_id,'feeds_hardware');
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){
	    				if($senderId != $value->user_id){

							$title =' is following "'.$recordName.'" hardware.';

							$UserFeeds = TableRegistry::get('UserFeeds');
			    			$feeds = $UserFeeds->newEntity();
			    			$values = [];

		    				$link= Router::url(['controller' => 'Hardwares', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $senderId;
		    				$feeds->receiver_id = $value->user_id;

			    			$feeds->type =$type;
			    			$feeds->title =$title;
			    			$feeds->link =$link;
			    			$feeds->record_name	=$record_id;

			    			$feeds->data =json_encode($values);

		    				//Save user feeds.
		    				$result = $UserFeeds->save($feeds);
		    				//return $isSettingEnabbled;
		    			}	
	    			}
	    		}
	    	}

	    	//Send feeds to Fund Owner
			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($recordDetail->user_id,'feeds_hardware');
			//Check if seeting enabled
			if(!empty($isSettingEnabbled)){


				$title =' is following "'.$recordName.'" hardware.';


				$UserFeeds = TableRegistry::get('UserFeeds');
    			$feeds = $UserFeeds->newEntity();
    			$values = [];
				$link= Router::url(['controller' => 'Hardwares', 'action' => 'view',base64_encode($record_id)]);
				
				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

				$feeds->sender_id = $senderId;
				$feeds->receiver_id = $recordDetail->user_id;

    			$feeds->type =$type;
    			$feeds->title =$title;
    			$feeds->link =$link;
    			$feeds->record_name	=$record_id;

    			$feeds->data =json_encode($values);

				//Save user feeds.
				$result = $UserFeeds->save($feeds);
			}

	    }    	
    }

    /**************************************************************************
    *
    * Get software followers
    *
    *
    ****/
	public function softwareFollowerList($record_id=null)
	{
			$resultList = TableRegistry::get('SoftwareFollowers');
			 
			$resultLists = $resultList->find('all',['conditions'=>['software_id'=>$record_id]])->toArray();
		  
			return $resultLists;
			
	}

    /****
	*
	* Save software Feeds
	*
	******/
	public function saveSoftwareFeeds($senderId=null,$type=null,$record_id=null)
    {	
    	$recordDetails = TableRegistry::get('Softwares');
	    $recordDetail= $recordDetails->find('all',['conditions'=>['id'=>$record_id]])->first();
	    $recordName = $recordDetail->title;

    	if($type == 'feeds_software_added'){ 
	    	//Ger user connections List
	    	$connectionLists= $this->getConnectionLists($senderId);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {
	    			//Check if seeting enabled
	    			$isSettingEnabbled='';
	    			if($value->connection_by == $senderId){
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_to,'feeds_software');
	    			}else{
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_by,'feeds_software');
	    			}
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){

						$title =' added "'.$recordName.'" software.';
	    			
						$UserFeeds = TableRegistry::get('UserFeeds');
		    			$feeds = $UserFeeds->newEntity();
		    			$values = [];

		    			if($value->connection_by == $senderId){

		    				$link= Router::url(['controller' => 'Softwares', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$value->connection_by,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_by;
		    				$feeds->receiver_id = $value->connection_to;

		    			}else{

		    				$link= Router::url(['controller' => 'Softwares', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$value->connection_to,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_to;
		    				$feeds->receiver_id =$value->connection_by;

		    			}
		    			$feeds->type =$type;
		    			$feeds->title =$title;
		    			$feeds->link =$link;
		    			$feeds->record_name	=$record_id;

		    			$feeds->data =json_encode($values);

	    				//Save user feeds.
	    				$result = $UserFeeds->save($feeds);
	    				//return $isSettingEnabbled;
	    			}
	    		}
	    	}

	    }else{

	    	//Ger user connections List
	    	$connectionLists= $this->softwareFollowerList($record_id);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {

	    			//Check if seeting enabled
	    			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->user_id,'feeds_software');
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){
	    				if($senderId != $value->user_id){

							$title =' is following "'.$recordName.'" software.';

							$UserFeeds = TableRegistry::get('UserFeeds');
			    			$feeds = $UserFeeds->newEntity();
			    			$values = [];

		    				$link= Router::url(['controller' => 'Softwares', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $senderId;
		    				$feeds->receiver_id = $value->user_id;

			    			$feeds->type =$type;
			    			$feeds->title =$title;
			    			$feeds->link =$link;
			    			$feeds->record_name	=$record_id;

			    			$feeds->data =json_encode($values);

		    				//Save user feeds.
		    				$result = $UserFeeds->save($feeds);
		    				//return $isSettingEnabbled;
		    			}	
	    			}
	    		}
	    	}

	    	//Send feeds to Fund Owner
			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($recordDetail->user_id,'feeds_software');
			//Check if seeting enabled
			if(!empty($isSettingEnabbled)){


				$title =' is following "'.$recordName.'" software.';


				$UserFeeds = TableRegistry::get('UserFeeds');
    			$feeds = $UserFeeds->newEntity();
    			$values = [];
				$link= Router::url(['controller' => 'Softwares', 'action' => 'view',base64_encode($record_id)]);
				
				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

				$feeds->sender_id = $senderId;
				$feeds->receiver_id = $recordDetail->user_id;

    			$feeds->type =$type;
    			$feeds->title =$title;
    			$feeds->link =$link;
    			$feeds->record_name	=$record_id;

    			$feeds->data =json_encode($values);

				//Save user feeds.
				$result = $UserFeeds->save($feeds);
			}

	    }    	
    }


    /**************************************************************************
    *
    * Get services followers
    *
    *
    ****/
	public function serviceFollowerList($record_id=null)
	{
			$resultList = TableRegistry::get('ServiceFollowers');
			 
			$resultLists = $resultList->find('all',['conditions'=>['service_id'=>$record_id]])->toArray();
		  
			return $resultLists;
			
	}

    /****
	*
	* Save service Feeds
	*
	******/
	public function saveServiceFeeds($senderId=null,$type=null,$record_id=null)
    {	
    	$recordDetails = TableRegistry::get('Services');
	    $recordDetail= $recordDetails->find('all',['conditions'=>['id'=>$record_id]])->first();
	    $recordName = $recordDetail->title;

    	if($type == 'feeds_service_added'){ 
	    	//Ger user connections List
	    	$connectionLists= $this->getConnectionLists($senderId);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {
	    			//Check if seeting enabled
	    			$isSettingEnabbled='';
	    			if($value->connection_by == $senderId){
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_to,'feeds_service');
	    			}else{
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_by,'feeds_service');
	    			}
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){

						$title =' added "'.$recordName.'" services.';
	    			
						$UserFeeds = TableRegistry::get('UserFeeds');
		    			$feeds = $UserFeeds->newEntity();
		    			$values = [];

		    			if($value->connection_by == $senderId){

		    				$link= Router::url(['controller' => 'Services', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$value->connection_by,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_by;
		    				$feeds->receiver_id = $value->connection_to;

		    			}else{

		    				$link= Router::url(['controller' => 'Services', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$value->connection_to,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_to;
		    				$feeds->receiver_id =$value->connection_by;

		    			}
		    			$feeds->type =$type;
		    			$feeds->title =$title;
		    			$feeds->link =$link;
		    			$feeds->record_name	=$record_id;

		    			$feeds->data =json_encode($values);

	    				//Save user feeds.
	    				$result = $UserFeeds->save($feeds);
	    				//return $isSettingEnabbled;
	    			}
	    		}
	    	}

	    }else{

	    	//Ger user connections List
	    	$connectionLists= $this->serviceFollowerList($record_id);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {

	    			//Check if seeting enabled
	    			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->user_id,'feeds_service');
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){
	    				if($senderId != $value->user_id){

							$title =' is following "'.$recordName.'" services.';

							$UserFeeds = TableRegistry::get('UserFeeds');
			    			$feeds = $UserFeeds->newEntity();
			    			$values = [];

		    				$link= Router::url(['controller' => 'Services', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $senderId;
		    				$feeds->receiver_id = $value->user_id;

			    			$feeds->type =$type;
			    			$feeds->title =$title;
			    			$feeds->link =$link;
			    			$feeds->record_name	=$record_id;

			    			$feeds->data =json_encode($values);

		    				//Save user feeds.
		    				$result = $UserFeeds->save($feeds);
		    				//return $isSettingEnabbled;
		    			}	
	    			}
	    		}
	    	}

	    	//Send feeds to Fund Owner
			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($recordDetail->user_id,'feeds_service');
			//Check if seeting enabled
			if(!empty($isSettingEnabbled)){


				$title =' is following "'.$recordName.'" services.';


				$UserFeeds = TableRegistry::get('UserFeeds');
    			$feeds = $UserFeeds->newEntity();
    			$values = [];
				$link= Router::url(['controller' => 'Services', 'action' => 'view',base64_encode($record_id)]);
				
				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

				$feeds->sender_id = $senderId;
				$feeds->receiver_id = $recordDetail->user_id;

    			$feeds->type =$type;
    			$feeds->title =$title;
    			$feeds->link =$link;
    			$feeds->record_name	=$record_id;

    			$feeds->data =json_encode($values);

				//Save user feeds.
				$result = $UserFeeds->save($feeds);
			}

	    }    	
    }

    /**************************************************************************
    *
    * Get audio followers
    *
    *
    ****/
	public function audioFollowerList($record_id=null)
	{
			$resultList = TableRegistry::get('AudioFollowers');
			 
			$resultLists = $resultList->find('all',['conditions'=>['audio_id'=>$record_id]])->toArray();
		  
			return $resultLists;
			
	}

    /****
	*
	* Save audio videos Feeds
	*
	******/
	public function saveAudioFeeds($senderId=null,$type=null,$record_id=null)
    {	
    	$recordDetails = TableRegistry::get('AudioVideos');
	    $recordDetail= $recordDetails->find('all',['conditions'=>['id'=>$record_id]])->first();
	    $recordName = $recordDetail->title;

    	if($type == 'feeds_audio_added'){ 
	    	//Ger user connections List
	    	$connectionLists= $this->getConnectionLists($senderId);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {
	    			//Check if seeting enabled
	    			$isSettingEnabbled='';
	    			if($value->connection_by == $senderId){
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_to,'feeds_audio');
	    			}else{
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_by,'feeds_audio');
	    			}
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){

						$title =' added "'.$recordName.'" audio/video.';
	    			
						$UserFeeds = TableRegistry::get('UserFeeds');
		    			$feeds = $UserFeeds->newEntity();
		    			$values = [];

		    			if($value->connection_by == $senderId){

		    				$link= Router::url(['controller' => 'AudioVideos', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$value->connection_by,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_by;
		    				$feeds->receiver_id = $value->connection_to;

		    			}else{

		    				$link= Router::url(['controller' => 'AudioVideos', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$value->connection_to,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_to;
		    				$feeds->receiver_id =$value->connection_by;

		    			}
		    			$feeds->type =$type;
		    			$feeds->title =$title;
		    			$feeds->link =$link;
		    			$feeds->record_name	=$record_id;

		    			$feeds->data =json_encode($values);

	    				//Save user feeds.
	    				$result = $UserFeeds->save($feeds);
	    				//return $isSettingEnabbled;
	    			}
	    		}
	    	}

	    }else{

	    	//Ger user connections List
	    	$connectionLists= $this->audioFollowerList($record_id);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {

	    			//Check if seeting enabled
	    			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->user_id,'feeds_audio');
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){
	    				if($senderId != $value->user_id){

							$title =' is following "'.$recordName.'" audio/video.';

							$UserFeeds = TableRegistry::get('UserFeeds');
			    			$feeds = $UserFeeds->newEntity();
			    			$values = [];

		    				$link= Router::url(['controller' => 'AudioVideos', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $senderId;
		    				$feeds->receiver_id = $value->user_id;

			    			$feeds->type =$type;
			    			$feeds->title =$title;
			    			$feeds->link =$link;
			    			$feeds->record_name	=$record_id;

			    			$feeds->data =json_encode($values);

		    				//Save user feeds.
		    				$result = $UserFeeds->save($feeds);
		    				//return $isSettingEnabbled;
		    			}	
	    			}
	    		}
	    	}

	    	//Send feeds to Fund Owner
			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($recordDetail->user_id,'feeds_audio');
			//Check if seeting enabled
			if(!empty($isSettingEnabbled)){


				$title =' is following "'.$recordName.'" audio/video.';


				$UserFeeds = TableRegistry::get('UserFeeds');
    			$feeds = $UserFeeds->newEntity();
    			$values = [];
				$link= Router::url(['controller' => 'AudioVideos', 'action' => 'view',base64_encode($record_id)]);
				
				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

				$feeds->sender_id = $senderId;
				$feeds->receiver_id = $recordDetail->user_id;

    			$feeds->type =$type;
    			$feeds->title =$title;
    			$feeds->link =$link;
    			$feeds->record_name	=$record_id;

    			$feeds->data =json_encode($values);

				//Save user feeds.
				$result = $UserFeeds->save($feeds);
			}

	    }    	
    }


    /**************************************************************************
    *
    * Get information followers
    *
    *
    ****/
	public function informationFollowerList($record_id=null)
	{
			$resultList = TableRegistry::get('InformationFollowers');
			 
			$resultLists = $resultList->find('all',['conditions'=>['information_id'=>$record_id]])->toArray();
		  
			return $resultLists;
			
	}

    /****
	*
	* Save information Feeds
	*
	******/
	public function saveInformationFeeds($senderId=null,$type=null,$record_id=null)
    {	
    	$recordDetails = TableRegistry::get('Informations');
	    $recordDetail= $recordDetails->find('all',['conditions'=>['id'=>$record_id]])->first();
	    $recordName = $recordDetail->title;

    	if($type == 'feeds_information_added'){ 
	    	//Ger user connections List
	    	$connectionLists= $this->getConnectionLists($senderId);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {
	    			//Check if seeting enabled
	    			$isSettingEnabbled='';
	    			if($value->connection_by == $senderId){
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_to,'feeds_information');
	    			}else{
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_by,'feeds_information');
	    			}
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){

						$title =' added "'.$recordName.'" information.';
	    			
						$UserFeeds = TableRegistry::get('UserFeeds');
		    			$feeds = $UserFeeds->newEntity();
		    			$values = [];

		    			if($value->connection_by == $senderId){

		    				$link= Router::url(['controller' => 'Informations', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$value->connection_by,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_by;
		    				$feeds->receiver_id = $value->connection_to;

		    			}else{

		    				$link= Router::url(['controller' => 'Informations', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$value->connection_to,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_to;
		    				$feeds->receiver_id =$value->connection_by;

		    			}
		    			$feeds->type =$type;
		    			$feeds->title =$title;
		    			$feeds->link =$link;
		    			$feeds->record_name	=$record_id;

		    			$feeds->data =json_encode($values);

	    				//Save user feeds.
	    				$result = $UserFeeds->save($feeds);
	    				//return $isSettingEnabbled;
	    			}
	    		}
	    	}

	    }else{

	    	//Ger user connections List
	    	$connectionLists= $this->informationFollowerList($record_id);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {

	    			//Check if seeting enabled
	    			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->user_id,'feeds_information');
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){
	    				if($senderId != $value->user_id){

							$title =' is following "'.$recordName.'" information.';

							$UserFeeds = TableRegistry::get('UserFeeds');
			    			$feeds = $UserFeeds->newEntity();
			    			$values = [];

		    				$link= Router::url(['controller' => 'Informations', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $senderId;
		    				$feeds->receiver_id = $value->user_id;

			    			$feeds->type =$type;
			    			$feeds->title =$title;
			    			$feeds->link =$link;
			    			$feeds->record_name	=$record_id;

			    			$feeds->data =json_encode($values);

		    				//Save user feeds.
		    				$result = $UserFeeds->save($feeds);
		    				//return $isSettingEnabbled;
		    			}	
	    			}
	    		}
	    	}

	    	//Send feeds to Fund Owner
			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($recordDetail->user_id,'feeds_information');
			//Check if seeting enabled
			if(!empty($isSettingEnabbled)){


				$title =' is following "'.$recordName.'" information.';


				$UserFeeds = TableRegistry::get('UserFeeds');
    			$feeds = $UserFeeds->newEntity();
    			$values = [];
				$link= Router::url(['controller' => 'Informations', 'action' => 'view',base64_encode($record_id)]);
				
				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

				$feeds->sender_id = $senderId;
				$feeds->receiver_id = $recordDetail->user_id;

    			$feeds->type =$type;
    			$feeds->title =$title;
    			$feeds->link =$link;
    			$feeds->record_name	=$record_id;

    			$feeds->data =json_encode($values);

				//Save user feeds.
				$result = $UserFeeds->save($feeds);
			}

	    }    	
    }


    /**************************************************************************
    *
    * Get productivity followers
    *
    *
    ****/
	public function productivityFollowerList($record_id=null)
	{
			$resultList = TableRegistry::get('ProductivityFollowers');
			 
			$resultLists = $resultList->find('all',['conditions'=>['productivity_id'=>$record_id]])->toArray();
		  
			return $resultLists;
			
	}

    /****
	*
	* Save productivity Feeds
	*
	******/
	public function saveProductivityFeeds($senderId=null,$type=null,$record_id=null)
    {	
    	$recordDetails = TableRegistry::get('Productivities');
	    $recordDetail= $recordDetails->find('all',['conditions'=>['id'=>$record_id]])->first();
	    $recordName = $recordDetail->title;

    	if($type == 'feeds_productivity_added'){ 
	    	//Ger user connections List
	    	$connectionLists= $this->getConnectionLists($senderId);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {
	    			//Check if seeting enabled
	    			$isSettingEnabbled='';
	    			if($value->connection_by == $senderId){
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_to,'feeds_productivity');
	    			}else{
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_by,'feeds_productivity');
	    			}
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){

						$title =' added "'.$recordName.'" productivity tool.';
	    			
						$UserFeeds = TableRegistry::get('UserFeeds');
		    			$feeds = $UserFeeds->newEntity();
		    			$values = [];

		    			if($value->connection_by == $senderId){

		    				$link= Router::url(['controller' => 'Productivities', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$value->connection_by,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_by;
		    				$feeds->receiver_id = $value->connection_to;

		    			}else{

		    				$link= Router::url(['controller' => 'Productivities', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$value->connection_to,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_to;
		    				$feeds->receiver_id =$value->connection_by;

		    			}
		    			$feeds->type =$type;
		    			$feeds->title =$title;
		    			$feeds->link =$link;
		    			$feeds->record_name	=$record_id;

		    			$feeds->data =json_encode($values);

	    				//Save user feeds.
	    				$result = $UserFeeds->save($feeds);
	    				//return $isSettingEnabbled;
	    			}
	    		}
	    	}

	    }else{

	    	//Ger user connections List
	    	$connectionLists= $this->productivityFollowerList($record_id);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {

	    			//Check if seeting enabled
	    			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->user_id,'feeds_productivity');
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){
	    				if($senderId != $value->user_id){

							$title =' is following "'.$recordName.'" productivity tool.';

							$UserFeeds = TableRegistry::get('UserFeeds');
			    			$feeds = $UserFeeds->newEntity();
			    			$values = [];

		    				$link= Router::url(['controller' => 'Productivities', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $senderId;
		    				$feeds->receiver_id = $value->user_id;

			    			$feeds->type =$type;
			    			$feeds->title =$title;
			    			$feeds->link =$link;
			    			$feeds->record_name	=$record_id;

			    			$feeds->data =json_encode($values);

		    				//Save user feeds.
		    				$result = $UserFeeds->save($feeds);
		    				//return $isSettingEnabbled;
		    			}	
	    			}
	    		}
	    	}

	    	//Send feeds to Fund Owner
			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($recordDetail->user_id,'feeds_productivity');
			//Check if seeting enabled
			if(!empty($isSettingEnabbled)){


				$title =' is following "'.$recordName.'" productivity tool.';


				$UserFeeds = TableRegistry::get('UserFeeds');
    			$feeds = $UserFeeds->newEntity();
    			$values = [];
				$link= Router::url(['controller' => 'Productivities', 'action' => 'view',base64_encode($record_id)]);
				
				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

				$feeds->sender_id = $senderId;
				$feeds->receiver_id = $recordDetail->user_id;

    			$feeds->type =$type;
    			$feeds->title =$title;
    			$feeds->link =$link;
    			$feeds->record_name	=$record_id;

    			$feeds->data =json_encode($values);

				//Save user feeds.
				$result = $UserFeeds->save($feeds);
			}

	    }    	
    }


	/**************************************************************************
    *
    * Get conferences followers
    *
    *
    ****/
	public function conferenceFollowerList($record_id=null)
	{
			$resultList = TableRegistry::get('ConferenceFollowers');
			 
			$resultLists = $resultList->find('all',['conditions'=>['conference_id'=>$record_id]])->toArray();
		  
			return $resultLists;
			
	}

    /****
	*
	* Save conferences Feeds
	*
	******/
	public function saveConferenceFeeds($senderId=null,$type=null,$record_id=null)
    {	
    	$recordDetails = TableRegistry::get('Conferences');
	    $recordDetail= $recordDetails->find('all',['conditions'=>['id'=>$record_id]])->first();
	    $recordName = $recordDetail->title;

    	if($type == 'feeds_conference_added'){ 
	    	//Ger user connections List
	    	$connectionLists= $this->getConnectionLists($senderId);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {
	    			//Check if seeting enabled
	    			$isSettingEnabbled='';
	    			if($value->connection_by == $senderId){
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_to,'feeds_conference');
	    			}else{
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_by,'feeds_conference');
	    			}
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){

						$title =' added "'.$recordName.'" conference.';
	    			
						$UserFeeds = TableRegistry::get('UserFeeds');
		    			$feeds = $UserFeeds->newEntity();
		    			$values = [];

		    			if($value->connection_by == $senderId){

		    				$link= Router::url(['controller' => 'Conferences', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$value->connection_by,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_by;
		    				$feeds->receiver_id = $value->connection_to;

		    			}else{

		    				$link= Router::url(['controller' => 'Conferences', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$value->connection_to,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_to;
		    				$feeds->receiver_id =$value->connection_by;

		    			}
		    			$feeds->type =$type;
		    			$feeds->title =$title;
		    			$feeds->link =$link;
		    			$feeds->record_name	=$record_id;

		    			$feeds->data =json_encode($values);

	    				//Save user feeds.
	    				$result = $UserFeeds->save($feeds);
	    				//return $isSettingEnabbled;
	    			}
	    		}
	    	}

	    }else{

	    	//Ger user connections List
	    	$connectionLists= $this->conferenceFollowerList($record_id);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {

	    			//Check if seeting enabled
	    			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->user_id,'feeds_conference');
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){
	    				if($senderId != $value->user_id){

							$title =' is following "'.$recordName.'" conference.';

							$UserFeeds = TableRegistry::get('UserFeeds');
			    			$feeds = $UserFeeds->newEntity();
			    			$values = [];

		    				$link= Router::url(['controller' => 'Conferences', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $senderId;
		    				$feeds->receiver_id = $value->user_id;

			    			$feeds->type =$type;
			    			$feeds->title =$title;
			    			$feeds->link =$link;
			    			$feeds->record_name	=$record_id;

			    			$feeds->data =json_encode($values);

		    				//Save user feeds.
		    				$result = $UserFeeds->save($feeds);
		    				//return $isSettingEnabbled;
		    			}	
	    			}
	    		}
	    	}

	    	//Send feeds to Fund Owner
			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($recordDetail->user_id,'feeds_conference');
			//Check if seeting enabled
			if(!empty($isSettingEnabbled)){


				$title =' is following "'.$recordName.'" conference.';


				$UserFeeds = TableRegistry::get('UserFeeds');
    			$feeds = $UserFeeds->newEntity();
    			$values = [];
				$link= Router::url(['controller' => 'Conferences', 'action' => 'view',base64_encode($record_id)]);
				
				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

				$feeds->sender_id = $senderId;
				$feeds->receiver_id = $recordDetail->user_id;

    			$feeds->type =$type;
    			$feeds->title =$title;
    			$feeds->link =$link;
    			$feeds->record_name	=$record_id;

    			$feeds->data =json_encode($values);

				//Save user feeds.
				$result = $UserFeeds->save($feeds);
			}

	    }    	
    }



    /**************************************************************************
    *
    * Get demoday followers
    *
    *
    ****/
	public function demodayFollowerList($record_id=null)
	{
			$resultList = TableRegistry::get('DemodayFollowers');
			 
			$resultLists = $resultList->find('all',['conditions'=>['demoday_id'=>$record_id]])->toArray();
		  
			return $resultLists;
			
	}

    /****
	*
	* Save demoday Feeds
	*
	******/
	public function saveDemodayFeeds($senderId=null,$type=null,$record_id=null)
    {	
    	$recordDetails = TableRegistry::get('Demodays');
	    $recordDetail= $recordDetails->find('all',['conditions'=>['id'=>$record_id]])->first();
	    $recordName = $recordDetail->title;

    	if($type == 'feeds_demoday_added'){ 
	    	//Ger user connections List
	    	$connectionLists= $this->getConnectionLists($senderId);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {
	    			//Check if seeting enabled
	    			$isSettingEnabbled='';
	    			if($value->connection_by == $senderId){
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_to,'feeds_demoday');
	    			}else{
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_by,'feeds_demoday');
	    			}
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){

						$title =' added "'.$recordName.'" demo day.';
	    			
						$UserFeeds = TableRegistry::get('UserFeeds');
		    			$feeds = $UserFeeds->newEntity();
		    			$values = [];

		    			if($value->connection_by == $senderId){

		    				$link= Router::url(['controller' => 'Demodays', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$value->connection_by,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_by;
		    				$feeds->receiver_id = $value->connection_to;

		    			}else{

		    				$link= Router::url(['controller' => 'Demodays', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$value->connection_to,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_to;
		    				$feeds->receiver_id =$value->connection_by;

		    			}
		    			$feeds->type =$type;
		    			$feeds->title =$title;
		    			$feeds->link =$link;
		    			$feeds->record_name	=$record_id;

		    			$feeds->data =json_encode($values);

	    				//Save user feeds.
	    				$result = $UserFeeds->save($feeds);
	    				//return $isSettingEnabbled;
	    			}
	    		}
	    	}

	    }else{

	    	//Ger user connections List
	    	$connectionLists= $this->demodayFollowerList($record_id);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {

	    			//Check if seeting enabled
	    			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->user_id,'feeds_demoday');
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){
	    				if($senderId != $value->user_id){

							$title =' is following "'.$recordName.'" demo day.';

							$UserFeeds = TableRegistry::get('UserFeeds');
			    			$feeds = $UserFeeds->newEntity();
			    			$values = [];

		    				$link= Router::url(['controller' => 'Demodays', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $senderId;
		    				$feeds->receiver_id = $value->user_id;

			    			$feeds->type =$type;
			    			$feeds->title =$title;
			    			$feeds->link =$link;
			    			$feeds->record_name	=$record_id;

			    			$feeds->data =json_encode($values);

		    				//Save user feeds.
		    				$result = $UserFeeds->save($feeds);
		    				//return $isSettingEnabbled;
		    			}	
	    			}
	    		}
	    	}

	    	//Send feeds to Fund Owner
			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($recordDetail->user_id,'feeds_demoday');
			//Check if seeting enabled
			if(!empty($isSettingEnabbled)){


				$title =' is following "'.$recordName.'" demo day.';


				$UserFeeds = TableRegistry::get('UserFeeds');
    			$feeds = $UserFeeds->newEntity();
    			$values = [];
				$link= Router::url(['controller' => 'Demodays', 'action' => 'view',base64_encode($record_id)]);
				
				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

				$feeds->sender_id = $senderId;
				$feeds->receiver_id = $recordDetail->user_id;

    			$feeds->type =$type;
    			$feeds->title =$title;
    			$feeds->link =$link;
    			$feeds->record_name	=$record_id;

    			$feeds->data =json_encode($values);

				//Save user feeds.
				$result = $UserFeeds->save($feeds);
			}

	    }    	
    }

	/**************************************************************************
    *
    * Get meetup followers
    *
    *
    ****/
	public function meetupFollowerList($record_id=null)
	{
			$resultList = TableRegistry::get('MeetupFollowers');
			 
			$resultLists = $resultList->find('all',['conditions'=>['meetup_id'=>$record_id]])->toArray();
		  
			return $resultLists;
			
	}

    /****
	*
	* Save meetup Feeds
	*
	******/
	public function saveMeetupFeeds($senderId=null,$type=null,$record_id=null)
    {	
    	$recordDetails = TableRegistry::get('Meetups');
	    $recordDetail= $recordDetails->find('all',['conditions'=>['id'=>$record_id]])->first();
	    $recordName = $recordDetail->title;

    	if($type == 'feeds_meetup_added'){ 
	    	//Ger user connections List
	    	$connectionLists= $this->getConnectionLists($senderId);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {
	    			//Check if seeting enabled
	    			$isSettingEnabbled='';
	    			if($value->connection_by == $senderId){
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_to,'feeds_meetup');
	    			}else{
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_by,'feeds_meetup');
	    			}
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){

						$title =' added "'.$recordName.'" meetup.';
	    			
						$UserFeeds = TableRegistry::get('UserFeeds');
		    			$feeds = $UserFeeds->newEntity();
		    			$values = [];

		    			if($value->connection_by == $senderId){

		    				$link= Router::url(['controller' => 'Meetups', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$value->connection_by,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_by;
		    				$feeds->receiver_id = $value->connection_to;

		    			}else{

		    				$link= Router::url(['controller' => 'Meetups', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$value->connection_to,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_to;
		    				$feeds->receiver_id =$value->connection_by;

		    			}
		    			$feeds->type =$type;
		    			$feeds->title =$title;
		    			$feeds->link =$link;
		    			$feeds->record_name	=$record_id;

		    			$feeds->data =json_encode($values);

	    				//Save user feeds.
	    				$result = $UserFeeds->save($feeds);
	    				//return $isSettingEnabbled;
	    			}
	    		}
	    	}

	    }else{

	    	//Ger user connections List
	    	$connectionLists= $this->meetupFollowerList($record_id);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {

	    			//Check if seeting enabled
	    			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->user_id,'feeds_meetup');
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){
	    				if($senderId != $value->user_id){

							$title =' is following "'.$recordName.'" meetup.';

							$UserFeeds = TableRegistry::get('UserFeeds');
			    			$feeds = $UserFeeds->newEntity();
			    			$values = [];

		    				$link= Router::url(['controller' => 'Meetups', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $senderId;
		    				$feeds->receiver_id = $value->user_id;

			    			$feeds->type =$type;
			    			$feeds->title =$title;
			    			$feeds->link =$link;
			    			$feeds->record_name	=$record_id;

			    			$feeds->data =json_encode($values);

		    				//Save user feeds.
		    				$result = $UserFeeds->save($feeds);
		    				//return $isSettingEnabbled;
		    			}	
	    			}
	    		}
	    	}

	    	//Send feeds to Fund Owner
			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($recordDetail->user_id,'feeds_meetup');
			//Check if seeting enabled
			if(!empty($isSettingEnabbled)){


				$title =' is following "'.$recordName.'" meetup.';


				$UserFeeds = TableRegistry::get('UserFeeds');
    			$feeds = $UserFeeds->newEntity();
    			$values = [];
				$link= Router::url(['controller' => 'Meetups', 'action' => 'view',base64_encode($record_id)]);
				
				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

				$feeds->sender_id = $senderId;
				$feeds->receiver_id = $recordDetail->user_id;

    			$feeds->type =$type;
    			$feeds->title =$title;
    			$feeds->link =$link;
    			$feeds->record_name	=$record_id;

    			$feeds->data =json_encode($values);

				//Save user feeds.
				$result = $UserFeeds->save($feeds);
			}

	    }    	
    }


    /**************************************************************************
    *
    * Get Webinar followers
    *
    *
    ****/
	public function webinarFollowerList($record_id=null)
	{
			$resultList = TableRegistry::get('webinarFollowers');
			 
			$resultLists = $resultList->find('all',['conditions'=>['webinar_id'=>$record_id]])->toArray();
		  
			return $resultLists;
			
	}

    /****
	*
	* Save Webinar Feeds
	*
	******/
	public function saveWebinarFeeds($senderId=null,$type=null,$record_id=null)
    {	
    	$recordDetails = TableRegistry::get('Webinars');
	    $recordDetail= $recordDetails->find('all',['conditions'=>['id'=>$record_id]])->first();
	    $recordName = $recordDetail->title;

    	if($type == 'feeds_webinar_added'){ 
	    	//Ger user connections List
	    	$connectionLists= $this->getConnectionLists($senderId);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {
	    			//Check if seeting enabled
	    			$isSettingEnabbled='';
	    			if($value->connection_by == $senderId){
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_to,'feeds_webinar');
	    			}else{
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_by,'feeds_webinar');
	    			}
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){

						$title =' added "'.$recordName.'" webinar.';
	    			
						$UserFeeds = TableRegistry::get('UserFeeds');
		    			$feeds = $UserFeeds->newEntity();
		    			$values = [];

		    			if($value->connection_by == $senderId){

		    				$link= Router::url(['controller' => 'Webinars', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$value->connection_by,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_by;
		    				$feeds->receiver_id = $value->connection_to;

		    			}else{

		    				$link= Router::url(['controller' => 'Webinars', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$value->connection_to,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_to;
		    				$feeds->receiver_id =$value->connection_by;

		    			}
		    			$feeds->type =$type;
		    			$feeds->title =$title;
		    			$feeds->link =$link;
		    			$feeds->record_name	=$record_id;

		    			$feeds->data =json_encode($values);

	    				//Save user feeds.
	    				$result = $UserFeeds->save($feeds);
	    				//return $isSettingEnabbled;
	    			}
	    		}
	    	}

	    }else{

	    	//Ger user connections List
	    	$connectionLists= $this->webinarFollowerList($record_id);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {

	    			//Check if seeting enabled
	    			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->user_id,'feeds_webinar');
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){
	    				if($senderId != $value->user_id){

							$title =' is following "'.$recordName.'" webinar.';

							$UserFeeds = TableRegistry::get('UserFeeds');
			    			$feeds = $UserFeeds->newEntity();
			    			$values = [];

		    				$link= Router::url(['controller' => 'Webinars', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $senderId;
		    				$feeds->receiver_id = $value->user_id;

			    			$feeds->type =$type;
			    			$feeds->title =$title;
			    			$feeds->link =$link;
			    			$feeds->record_name	=$record_id;

			    			$feeds->data =json_encode($values);

		    				//Save user feeds.
		    				$result = $UserFeeds->save($feeds);
		    				//return $isSettingEnabbled;
		    			}	
	    			}
	    		}
	    	}

	    	//Send feeds to Fund Owner
			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($recordDetail->user_id,'feeds_webinar');
			//Check if seeting enabled
			if(!empty($isSettingEnabbled)){


				$title =' is following "'.$recordName.'" webinar.';


				$UserFeeds = TableRegistry::get('UserFeeds');
    			$feeds = $UserFeeds->newEntity();
    			$values = [];
				$link= Router::url(['controller' => 'Webinars', 'action' => 'view',base64_encode($record_id)]);
				
				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

				$feeds->sender_id = $senderId;
				$feeds->receiver_id = $recordDetail->user_id;

    			$feeds->type =$type;
    			$feeds->title =$title;
    			$feeds->link =$link;
    			$feeds->record_name	=$record_id;

    			$feeds->data =json_encode($values);

				//Save user feeds.
				$result = $UserFeeds->save($feeds);
			}

	    }    	
    }

    /**************************************************************************
    *
    * Get boardMember followers
    *
    *
    ****/
	public function boardMemberFollowerList($record_id=null)
	{
			$resultList = TableRegistry::get('BoardMemberFollowers');
			 
			$resultLists = $resultList->find('all',['conditions'=>['board_member_id'=>$record_id]])->toArray();
		  
			return $resultLists;
			
	}

    /****
	*
	* Save boardMember Feeds
	*
	******/
	public function saveBoardMemberFeeds($senderId=null,$type=null,$record_id=null)
    {	
    	$recordDetails = TableRegistry::get('BoardMembers');
	    $recordDetail= $recordDetails->find('all',['conditions'=>['id'=>$record_id]])->first();
	    $recordName = $recordDetail->title;

    	if($type == 'feeds_boardmember_added'){ 
	    	//Ger user connections List
	    	$connectionLists= $this->getConnectionLists($senderId);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {
	    			//Check if seeting enabled
	    			$isSettingEnabbled='';
	    			if($value->connection_by == $senderId){
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_to,'feeds_boardmember');
	    			}else{
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_by,'feeds_boardmember');
	    			}
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){

						$title =' added "'.$recordName.'" board member opportunity.';
	    			
						$UserFeeds = TableRegistry::get('UserFeeds');
		    			$feeds = $UserFeeds->newEntity();
		    			$values = [];

		    			if($value->connection_by == $senderId){

		    				$link= Router::url(['controller' => 'BoardMembers', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$value->connection_by,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_by;
		    				$feeds->receiver_id = $value->connection_to;

		    			}else{

		    				$link= Router::url(['controller' => 'BoardMembers', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$value->connection_to,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_to;
		    				$feeds->receiver_id =$value->connection_by;

		    			}
		    			$feeds->type =$type;
		    			$feeds->title =$title;
		    			$feeds->link =$link;
		    			$feeds->record_name	=$record_id;

		    			$feeds->data =json_encode($values);

	    				//Save user feeds.
	    				$result = $UserFeeds->save($feeds);
	    				//return $isSettingEnabbled;
	    			}
	    		}
	    	}

	    }else{

	    	//Ger user connections List
	    	$connectionLists= $this->boardMemberFollowerList($record_id);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {

	    			//Check if seeting enabled
	    			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->user_id,'feeds_boardmember');
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){
	    				if($senderId != $value->user_id){

							$title =' is following "'.$recordName.'" board member opportunity.';

							$UserFeeds = TableRegistry::get('UserFeeds');
			    			$feeds = $UserFeeds->newEntity();
			    			$values = [];

		    				$link= Router::url(['controller' => 'BoardMembers', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $senderId;
		    				$feeds->receiver_id = $value->user_id;

			    			$feeds->type =$type;
			    			$feeds->title =$title;
			    			$feeds->link =$link;
			    			$feeds->record_name	=$record_id;

			    			$feeds->data =json_encode($values);

		    				//Save user feeds.
		    				$result = $UserFeeds->save($feeds);
		    				//return $isSettingEnabbled;
		    			}	
	    			}
	    		}
	    	}

	    	//Send feeds to Fund Owner
			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($recordDetail->user_id,'feeds_boardmember');
			//Check if seeting enabled
			if(!empty($isSettingEnabbled)){


				$title =' is following "'.$recordName.'" board member opportunity.';


				$UserFeeds = TableRegistry::get('UserFeeds');
    			$feeds = $UserFeeds->newEntity();
    			$values = [];
				$link= Router::url(['controller' => 'BoardMembers', 'action' => 'view',base64_encode($record_id)]);
				
				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

				$feeds->sender_id = $senderId;
				$feeds->receiver_id = $recordDetail->user_id;

    			$feeds->type =$type;
    			$feeds->title =$title;
    			$feeds->link =$link;
    			$feeds->record_name	=$record_id;

    			$feeds->data =json_encode($values);

				//Save user feeds.
				$result = $UserFeeds->save($feeds);
			}

	    }    	
    }


    /**************************************************************************
    *
    * Get communalAsset followers
    *
    *
    ****/
	public function communalAssetFollowerList($record_id=null)
	{
			$resultList = TableRegistry::get('CommunalAssetFollowers');
			 
			$resultLists = $resultList->find('all',['conditions'=>['communalasset_id'=>$record_id]])->toArray();
		  
			return $resultLists;
			
	}

    /****
	*
	* Save communalAsset Feeds
	*
	******/
	public function saveCommunalAssetFeeds($senderId=null,$type=null,$record_id=null)
    {	
    	$recordDetails = TableRegistry::get('CommunalAssets');
	    $recordDetail= $recordDetails->find('all',['conditions'=>['id'=>$record_id]])->first();
	    $recordName = $recordDetail->title;

    	if($type == 'feeds_communal_added'){ 
	    	//Ger user connections List
	    	$connectionLists= $this->getConnectionLists($senderId);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {
	    			//Check if seeting enabled
	    			$isSettingEnabbled='';
	    			if($value->connection_by == $senderId){
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_to,'feeds_communal');
	    			}else{
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_by,'feeds_communal');
	    			}
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){

						$title =' added "'.$recordName.'" communal asset.';
	    			
						$UserFeeds = TableRegistry::get('UserFeeds');
		    			$feeds = $UserFeeds->newEntity();
		    			$values = [];

		    			if($value->connection_by == $senderId){

		    				$link= Router::url(['controller' => 'CommunalAssets', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$value->connection_by,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_by;
		    				$feeds->receiver_id = $value->connection_to;

		    			}else{

		    				$link= Router::url(['controller' => 'CommunalAssets', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$value->connection_to,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_to;
		    				$feeds->receiver_id =$value->connection_by;

		    			}
		    			$feeds->type =$type;
		    			$feeds->title =$title;
		    			$feeds->link =$link;
		    			$feeds->record_name	=$record_id;

		    			$feeds->data =json_encode($values);

	    				//Save user feeds.
	    				$result = $UserFeeds->save($feeds);
	    				//return $isSettingEnabbled;
	    			}
	    		}
	    	}

	    }else{

	    	//Ger user connections List
	    	$connectionLists= $this->communalAssetFollowerList($record_id);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {

	    			//Check if seeting enabled
	    			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->user_id,'feeds_communal');
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){
	    				if($senderId != $value->user_id){

							$title =' is following "'.$recordName.'" communal asset.';

							$UserFeeds = TableRegistry::get('UserFeeds');
			    			$feeds = $UserFeeds->newEntity();
			    			$values = [];

		    				$link= Router::url(['controller' => 'CommunalAssets', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $senderId;
		    				$feeds->receiver_id = $value->user_id;

			    			$feeds->type =$type;
			    			$feeds->title =$title;
			    			$feeds->link =$link;
			    			$feeds->record_name	=$record_id;

			    			$feeds->data =json_encode($values);

		    				//Save user feeds.
		    				$result = $UserFeeds->save($feeds);
		    				//return $isSettingEnabbled;
		    			}	
	    			}
	    		}
	    	}

	    	//Send feeds to Fund Owner
			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($recordDetail->user_id,'feeds_communal');
			//Check if seeting enabled
			if(!empty($isSettingEnabbled)){


				$title =' is following "'.$recordName.'" communal asset.';


				$UserFeeds = TableRegistry::get('UserFeeds');
    			$feeds = $UserFeeds->newEntity();
    			$values = [];
				$link= Router::url(['controller' => 'CommunalAssets', 'action' => 'view',base64_encode($record_id)]);
				
				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

				$feeds->sender_id = $senderId;
				$feeds->receiver_id = $recordDetail->user_id;

    			$feeds->type =$type;
    			$feeds->title =$title;
    			$feeds->link =$link;
    			$feeds->record_name	=$record_id;

    			$feeds->data =json_encode($values);

				//Save user feeds.
				$result = $UserFeeds->save($feeds);
			}

	    }    	
    }



    /**************************************************************************
    *
    * Get consulting followers
    *
    *
    ****/
	public function consultingFollowerList($record_id=null)
	{
			$resultList = TableRegistry::get('ConsultingFollowers');
			 
			$resultLists = $resultList->find('all',['conditions'=>['consulting_id'=>$record_id]])->toArray();
		  
			return $resultLists;
			
	}

    /****
	*
	* Save consulting Feeds
	*
	******/
	public function saveConsultingFeeds($senderId=null,$type=null,$record_id=null)
    {	
    	$recordDetails = TableRegistry::get('Consultings');
	    $recordDetail= $recordDetails->find('all',['conditions'=>['id'=>$record_id]])->first();
	    $recordName = $recordDetail->title;

    	if($type == 'feeds_consulting_added'){ 
	    	//Ger user connections List
	    	$connectionLists= $this->getConnectionLists($senderId);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {
	    			//Check if seeting enabled
	    			$isSettingEnabbled='';
	    			if($value->connection_by == $senderId){
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_to,'feeds_consulting');
	    			}else{
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_by,'feeds_consulting');
	    			}
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){

						$title =' added "'.$recordName.'" consulting opportunity.';
	    			
						$UserFeeds = TableRegistry::get('UserFeeds');
		    			$feeds = $UserFeeds->newEntity();
		    			$values = [];

		    			if($value->connection_by == $senderId){

		    				$link= Router::url(['controller' => 'Consultings', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$value->connection_by,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_by;
		    				$feeds->receiver_id = $value->connection_to;

		    			}else{

		    				$link= Router::url(['controller' => 'Consultings', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$value->connection_to,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_to;
		    				$feeds->receiver_id =$value->connection_by;

		    			}
		    			$feeds->type =$type;
		    			$feeds->title =$title;
		    			$feeds->link =$link;
		    			$feeds->record_name	=$record_id;

		    			$feeds->data =json_encode($values);

	    				//Save user feeds.
	    				$result = $UserFeeds->save($feeds);
	    				//return $isSettingEnabbled;
	    			}
	    		}
	    	}

	    }else{

	    	//Ger user connections List
	    	$connectionLists= $this->consultingFollowerList($record_id);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {

	    			//Check if seeting enabled
	    			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->user_id,'feeds_consulting');
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){
	    				if($senderId != $value->user_id){

							$title =' is following "'.$recordName.'" consulting opportunity.';

							$UserFeeds = TableRegistry::get('UserFeeds');
			    			$feeds = $UserFeeds->newEntity();
			    			$values = [];

		    				$link= Router::url(['controller' => 'Consultings', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $senderId;
		    				$feeds->receiver_id = $value->user_id;

			    			$feeds->type =$type;
			    			$feeds->title =$title;
			    			$feeds->link =$link;
			    			$feeds->record_name	=$record_id;

			    			$feeds->data =json_encode($values);

		    				//Save user feeds.
		    				$result = $UserFeeds->save($feeds);
		    				//return $isSettingEnabbled;
		    			}	
	    			}
	    		}
	    	}

	    	//Send feeds to Fund Owner
			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($recordDetail->user_id,'feeds_consulting');
			//Check if seeting enabled
			if(!empty($isSettingEnabbled)){


				$title =' is following "'.$recordName.'" consulting opportunity.';


				$UserFeeds = TableRegistry::get('UserFeeds');
    			$feeds = $UserFeeds->newEntity();
    			$values = [];
				$link= Router::url(['controller' => 'Consultings', 'action' => 'view',base64_encode($record_id)]);
				
				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

				$feeds->sender_id = $senderId;
				$feeds->receiver_id = $recordDetail->user_id;

    			$feeds->type =$type;
    			$feeds->title =$title;
    			$feeds->link =$link;
    			$feeds->record_name	=$record_id;

    			$feeds->data =json_encode($values);

				//Save user feeds.
				$result = $UserFeeds->save($feeds);
			}

	    }    	
    }


    /**************************************************************************
    *
    * Get earlyAdopter followers
    *
    *
    ****/
	public function earlyAdopterFollowerList($record_id=null)
	{
			$resultList = TableRegistry::get('EarlyAdopterFollowers');
			 
			$resultLists = $resultList->find('all',['conditions'=>['early_adopter_id'=>$record_id]])->toArray();
		  
			return $resultLists;
			
	}

    /****
	*
	* Save earlyAdopter Feeds
	*
	******/
	public function saveEarlyAdopterFeeds($senderId=null,$type=null,$record_id=null)
    {	
    	$recordDetails = TableRegistry::get('EarlyAdopters');
	    $recordDetail= $recordDetails->find('all',['conditions'=>['id'=>$record_id]])->first();
	    $recordName = $recordDetail->title;

    	if($type == 'feeds_earlyadopter_added'){ 
	    	//Ger user connections List
	    	$connectionLists= $this->getConnectionLists($senderId);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {
	    			//Check if seeting enabled
	    			$isSettingEnabbled='';
	    			if($value->connection_by == $senderId){
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_to,'feeds_earlyadopter');
	    			}else{
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_by,'feeds_earlyadopter');
	    			}
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){

						$title =' added "'.$recordName.'" early adopter opportunity.';
	    			
						$UserFeeds = TableRegistry::get('UserFeeds');
		    			$feeds = $UserFeeds->newEntity();
		    			$values = [];

		    			if($value->connection_by == $senderId){

		    				$link= Router::url(['controller' => 'EarlyAdopters', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$value->connection_by,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_by;
		    				$feeds->receiver_id = $value->connection_to;

		    			}else{

		    				$link= Router::url(['controller' => 'EarlyAdopters', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$value->connection_to,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_to;
		    				$feeds->receiver_id =$value->connection_by;

		    			}
		    			$feeds->type =$type;
		    			$feeds->title =$title;
		    			$feeds->link =$link;
		    			$feeds->record_name	=$record_id;

		    			$feeds->data =json_encode($values);

	    				//Save user feeds.
	    				$result = $UserFeeds->save($feeds);
	    				//return $isSettingEnabbled;
	    			}
	    		}
	    	}

	    }else{

	    	//Ger user connections List
	    	$connectionLists= $this->earlyAdopterFollowerList($record_id);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {

	    			//Check if seeting enabled
	    			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->user_id,'feeds_earlyadopter');
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){
	    				if($senderId != $value->user_id){

							$title =' is following "'.$recordName.'" early adopter opportunity.';

							$UserFeeds = TableRegistry::get('UserFeeds');
			    			$feeds = $UserFeeds->newEntity();
			    			$values = [];

		    				$link= Router::url(['controller' => 'EarlyAdopters', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $senderId;
		    				$feeds->receiver_id = $value->user_id;

			    			$feeds->type =$type;
			    			$feeds->title =$title;
			    			$feeds->link =$link;
			    			$feeds->record_name	=$record_id;

			    			$feeds->data =json_encode($values);

		    				//Save user feeds.
		    				$result = $UserFeeds->save($feeds);
		    				//return $isSettingEnabbled;
		    			}	
	    			}
	    		}
	    	}

	    	//Send feeds to Fund Owner
			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($recordDetail->user_id,'feeds_earlyadopter');
			//Check if seeting enabled
			if(!empty($isSettingEnabbled)){


				$title =' is following "'.$recordName.'" early adopter opportunity.';


				$UserFeeds = TableRegistry::get('UserFeeds');
    			$feeds = $UserFeeds->newEntity();
    			$values = [];
				$link= Router::url(['controller' => 'EarlyAdopters', 'action' => 'view',base64_encode($record_id)]);
				
				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

				$feeds->sender_id = $senderId;
				$feeds->receiver_id = $recordDetail->user_id;

    			$feeds->type =$type;
    			$feeds->title =$title;
    			$feeds->link =$link;
    			$feeds->record_name	=$record_id;

    			$feeds->data =json_encode($values);

				//Save user feeds.
				$result = $UserFeeds->save($feeds);
			}

	    }    	
    }


    /**************************************************************************
    *
    * Get endorsors followers
    *
    *
    ****/
	public function endorsorsFollowerList($record_id=null)
	{
			$resultList = TableRegistry::get('EndorsorFollowers');
			 
			$resultLists = $resultList->find('all',['conditions'=>['endorsor_id'=>$record_id]])->toArray();
		  
			return $resultLists;
			
	}

    /****
	*
	* Save endorsor Feeds
	*
	******/
	public function saveEndorsorFeeds($senderId=null,$type=null,$record_id=null)
    {	
    	$recordDetails = TableRegistry::get('Endorsors');
	    $recordDetail= $recordDetails->find('all',['conditions'=>['id'=>$record_id]])->first();
	    $recordName = $recordDetail->title;

    	if($type == 'feeds_endorser_added'){ 
	    	//Ger user connections List
	    	$connectionLists= $this->getConnectionLists($senderId);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {
	    			//Check if seeting enabled
	    			$isSettingEnabbled='';
	    			if($value->connection_by == $senderId){
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_to,'feeds_endorser');
	    			}else{
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_by,'feeds_endorser');
	    			}
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){

						$title =' added "'.$recordName.'" endorser opportunity.';
	    			
						$UserFeeds = TableRegistry::get('UserFeeds');
		    			$feeds = $UserFeeds->newEntity();
		    			$values = [];

		    			if($value->connection_by == $senderId){

		    				$link= Router::url(['controller' => 'Endorsers', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$value->connection_by,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_by;
		    				$feeds->receiver_id = $value->connection_to;

		    			}else{

		    				$link= Router::url(['controller' => 'Endorsers', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$value->connection_to,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_to;
		    				$feeds->receiver_id =$value->connection_by;

		    			}
		    			$feeds->type =$type;
		    			$feeds->title =$title;
		    			$feeds->link =$link;
		    			$feeds->record_name	=$record_id;

		    			$feeds->data =json_encode($values);

	    				//Save user feeds.
	    				$result = $UserFeeds->save($feeds);
	    				//return $isSettingEnabbled;
	    			}
	    		}
	    	}

	    }else{

	    	//Ger user connections List
	    	$connectionLists= $this->endorsorsFollowerList($record_id);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {

	    			//Check if seeting enabled
	    			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->user_id,'feeds_endorser');
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){
	    				if($senderId != $value->user_id){

							$title =' is following "'.$recordName.'" endorser opportunity.';

							$UserFeeds = TableRegistry::get('UserFeeds');
			    			$feeds = $UserFeeds->newEntity();
			    			$values = [];

		    				$link= Router::url(['controller' => 'Endorsers', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $senderId;
		    				$feeds->receiver_id = $value->user_id;

			    			$feeds->type =$type;
			    			$feeds->title =$title;
			    			$feeds->link =$link;
			    			$feeds->record_name	=$record_id;

			    			$feeds->data =json_encode($values);

		    				//Save user feeds.
		    				$result = $UserFeeds->save($feeds);
		    				//return $isSettingEnabbled;
		    			}	
	    			}
	    		}
	    	}

	    	//Send feeds to Fund Owner
			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($recordDetail->user_id,'feeds_endorser');
			//Check if seeting enabled
			if(!empty($isSettingEnabbled)){


				$title =' is following "'.$recordName.'" endorser opportunity.';


				$UserFeeds = TableRegistry::get('UserFeeds');
    			$feeds = $UserFeeds->newEntity();
    			$values = [];
				$link= Router::url(['controller' => 'Endorsers', 'action' => 'view',base64_encode($record_id)]);
				
				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

				$feeds->sender_id = $senderId;
				$feeds->receiver_id = $recordDetail->user_id;

    			$feeds->type =$type;
    			$feeds->title =$title;
    			$feeds->link =$link;
    			$feeds->record_name	=$record_id;

    			$feeds->data =json_encode($values);

				//Save user feeds.
				$result = $UserFeeds->save($feeds);
			}

	    }    	
    }


    /**************************************************************************
    *
    * Get FocusGroup followers
    *
    *
    ****/
	public function focusGroupFollowerList($record_id=null)
	{
			$resultList = TableRegistry::get('FocusGroupFollowers');
			 
			$resultLists = $resultList->find('all',['conditions'=>['focus_group_id'=>$record_id]])->toArray();
		  
			return $resultLists;
			
	}

    /****
	*
	* Save FocusGroup Feeds
	*
	******/
	public function saveFocusGroupFeeds($senderId=null,$type=null,$record_id=null)
    {	
    	$recordDetails = TableRegistry::get('FocusGroups');
	    $recordDetail= $recordDetails->find('all',['conditions'=>['id'=>$record_id]])->first();
	    $recordName = $recordDetail->title;

    	if($type == 'feeds_focusgroup_added'){ 
	    	//Ger user connections List
	    	$connectionLists= $this->getConnectionLists($senderId);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {
	    			//Check if seeting enabled
	    			$isSettingEnabbled='';
	    			if($value->connection_by == $senderId){
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_to,'feeds_focusgroup');
	    			}else{
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_by,'feeds_focusgroup');
	    			}
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){

						$title =' added "'.$recordName.'" focus group opportunity.';
	    			
						$UserFeeds = TableRegistry::get('UserFeeds');
		    			$feeds = $UserFeeds->newEntity();
		    			$values = [];

		    			if($value->connection_by == $senderId){

		    				$link= Router::url(['controller' => 'FocusGroups', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$value->connection_by,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_by;
		    				$feeds->receiver_id = $value->connection_to;

		    			}else{

		    				$link= Router::url(['controller' => 'FocusGroups', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$value->connection_to,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_to;
		    				$feeds->receiver_id =$value->connection_by;

		    			}
		    			$feeds->type =$type;
		    			$feeds->title =$title;
		    			$feeds->link =$link;
		    			$feeds->record_name	=$record_id;

		    			$feeds->data =json_encode($values);

	    				//Save user feeds.
	    				$result = $UserFeeds->save($feeds);
	    				//return $isSettingEnabbled;
	    			}
	    		}
	    	}

	    }else{

	    	//Ger user connections List
	    	$connectionLists= $this->focusGroupFollowerList($record_id);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {

	    			//Check if seeting enabled
	    			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->user_id,'feeds_focusgroup');
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){
	    				if($senderId != $value->user_id){

							$title =' is following "'.$recordName.'" focus group opportunity.';

							$UserFeeds = TableRegistry::get('UserFeeds');
			    			$feeds = $UserFeeds->newEntity();
			    			$values = [];

		    				$link= Router::url(['controller' => 'FocusGroups', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $senderId;
		    				$feeds->receiver_id = $value->user_id;

			    			$feeds->type =$type;
			    			$feeds->title =$title;
			    			$feeds->link =$link;
			    			$feeds->record_name	=$record_id;

			    			$feeds->data =json_encode($values);

		    				//Save user feeds.
		    				$result = $UserFeeds->save($feeds);
		    				//return $isSettingEnabbled;
		    			}	
	    			}
	    		}
	    	}

	    	//Send feeds to Fund Owner
			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($recordDetail->user_id,'feeds_focusgroup');
			//Check if seeting enabled
			if(!empty($isSettingEnabbled)){


				$title =' is following "'.$recordName.'" focus group opportunity.';


				$UserFeeds = TableRegistry::get('UserFeeds');
    			$feeds = $UserFeeds->newEntity();
    			$values = [];
				$link= Router::url(['controller' => 'FocusGroups', 'action' => 'view',base64_encode($record_id)]);
				
				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

				$feeds->sender_id = $senderId;
				$feeds->receiver_id = $recordDetail->user_id;

    			$feeds->type =$type;
    			$feeds->title =$title;
    			$feeds->link =$link;
    			$feeds->record_name	=$record_id;

    			$feeds->data =json_encode($values);

				//Save user feeds.
				$result = $UserFeeds->save($feeds);
			}

	    }    	
    }


    /**************************************************************************
    *
    * Get Job followers
    *
    *
    ****/
	public function jobFollowerList($record_id=null)
	{
			$resultList = TableRegistry::get('JobFollowers');
			 
			$resultLists = $resultList->find('all',['conditions'=>['job_id'=>$record_id]])->toArray();
		  
			return $resultLists;
			
	}

    /****
	*
	* Save Job Feeds
	*
	******/
	public function saveJobFeeds($senderId=null,$type=null,$record_id=null)
    {	
    	$recordDetails = TableRegistry::get('Jobs');
	    $recordDetail= $recordDetails->find('all',['conditions'=>['id'=>$record_id]])->first();
	    $recordName = $recordDetail->job_title;

    	if($type == 'feeds_job_added'){ 
	    	//Ger user connections List
	    	$connectionLists= $this->getConnectionLists($senderId);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {
	    			//Check if seeting enabled
	    			$isSettingEnabbled='';
	    			if($value->connection_by == $senderId){
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_to,'feeds_job');
	    			}else{
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_by,'feeds_job');
	    			}
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){

						$title =' added "'.$recordName.'" job opportunity.';
	    			
						$UserFeeds = TableRegistry::get('UserFeeds');
		    			$feeds = $UserFeeds->newEntity();
		    			$values = [];

		    			if($value->connection_by == $senderId){

		    				$link= Router::url(['controller' => 'Opportunities', 'action' => 'viewJob',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$value->connection_by,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_by;
		    				$feeds->receiver_id = $value->connection_to;

		    			}else{

		    				$link= Router::url(['controller' => 'Opportunities', 'action' => 'viewJob',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$value->connection_to,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_to;
		    				$feeds->receiver_id =$value->connection_by;

		    			}
		    			$feeds->type =$type;
		    			$feeds->title =$title;
		    			$feeds->link =$link;
		    			$feeds->record_name	=$record_id;

		    			$feeds->data =json_encode($values);

	    				//Save user feeds.
	    				$result = $UserFeeds->save($feeds);
	    				//return $isSettingEnabbled;
	    			}
	    		}
	    	}

	    }else{

	    	//Ger user connections List
	    	$connectionLists= $this->jobFollowerList($record_id);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {

	    			//Check if seeting enabled
	    			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->user_id,'feeds_job');
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){
	    				if($senderId != $value->user_id){

							$title =' is following "'.$recordName.'" job opportunity.';

							$UserFeeds = TableRegistry::get('UserFeeds');
			    			$feeds = $UserFeeds->newEntity();
			    			$values = [];

		    				$link= Router::url(['controller' => 'Opportunities', 'action' => 'viewJob',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $senderId;
		    				$feeds->receiver_id = $value->user_id;

			    			$feeds->type =$type;
			    			$feeds->title =$title;
			    			$feeds->link =$link;
			    			$feeds->record_name	=$record_id;

			    			$feeds->data =json_encode($values);

		    				//Save user feeds.
		    				$result = $UserFeeds->save($feeds);
		    				//return $isSettingEnabbled;
		    			}	
	    			}
	    		}
	    	}

	    	//Send feeds to Fund Owner
			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($recordDetail->user_id,'feeds_job');
			//Check if seeting enabled
			if(!empty($isSettingEnabbled)){


				$title =' is following "'.$recordName.'" job opportunity.';


				$UserFeeds = TableRegistry::get('UserFeeds');
    			$feeds = $UserFeeds->newEntity();
    			$values = [];
				$link= Router::url(['controller' => 'Opportunities', 'action' => 'viewJob',base64_encode($record_id)]);
				
				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

				$feeds->sender_id = $senderId;
				$feeds->receiver_id = $recordDetail->user_id;

    			$feeds->type =$type;
    			$feeds->title =$title;
    			$feeds->link =$link;
    			$feeds->record_name	=$record_id;

    			$feeds->data =json_encode($values);

				//Save user feeds.
				$result = $UserFeeds->save($feeds);
			}

	    }    	
    }


    /**************************************************************************
    *
    * Get launchDeal followers
    *
    *
    ****/
	public function launchDealFollowerList($record_id=null)
	{
			$resultList = TableRegistry::get('LaunchDealFollowers');
			 
			$resultLists = $resultList->find('all',['conditions'=>['launchdeal_id'=>$record_id]])->toArray();
		  
			return $resultLists;
			
	}

    /****
	*
	* Save LaunchDeal Feeds
	*
	******/
	public function saveLaunchDealFeeds($senderId=null,$type=null,$record_id=null)
    {	
    	$recordDetails = TableRegistry::get('LaunchDeals');
	    $recordDetail= $recordDetails->find('all',['conditions'=>['id'=>$record_id]])->first();
	    $recordName = $recordDetail->title;

    	if($type == 'feeds_launchdeal_added'){ 
	    	//Ger user connections List
	    	$connectionLists= $this->getConnectionLists($senderId);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {
	    			//Check if seeting enabled
	    			$isSettingEnabbled='';
	    			if($value->connection_by == $senderId){
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_to,'feeds_launchdeal');
	    			}else{
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_by,'feeds_launchdeal');
	    			}
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){

						$title =' added "'.$recordName.'" launch deal.';
	    			
						$UserFeeds = TableRegistry::get('UserFeeds');
		    			$feeds = $UserFeeds->newEntity();
		    			$values = [];

		    			if($value->connection_by == $senderId){

		    				$link= Router::url(['controller' => 'LaunchDeals', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$value->connection_by,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_by;
		    				$feeds->receiver_id = $value->connection_to;

		    			}else{

		    				$link= Router::url(['controller' => 'LaunchDeals', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$value->connection_to,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_to;
		    				$feeds->receiver_id =$value->connection_by;

		    			}
		    			$feeds->type =$type;
		    			$feeds->title =$title;
		    			$feeds->link =$link;
		    			$feeds->record_name	=$record_id;

		    			$feeds->data =json_encode($values);

	    				//Save user feeds.
	    				$result = $UserFeeds->save($feeds);
	    				//return $isSettingEnabbled;
	    			}
	    		}
	    	}

	    }else{

	    	//Ger user connections List
	    	$connectionLists= $this->launchDealFollowerList($record_id);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {

	    			//Check if seeting enabled
	    			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->user_id,'feeds_launchdeal');
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){
	    				if($senderId != $value->user_id){

							$title =' is following "'.$recordName.'" launch deal.';

							$UserFeeds = TableRegistry::get('UserFeeds');
			    			$feeds = $UserFeeds->newEntity();
			    			$values = [];

		    				$link= Router::url(['controller' => 'LaunchDeals', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $senderId;
		    				$feeds->receiver_id = $value->user_id;

			    			$feeds->type =$type;
			    			$feeds->title =$title;
			    			$feeds->link =$link;
			    			$feeds->record_name	=$record_id;

			    			$feeds->data =json_encode($values);

		    				//Save user feeds.
		    				$result = $UserFeeds->save($feeds);
		    				//return $isSettingEnabbled;
		    			}	
	    			}
	    		}
	    	}

	    	//Send feeds to Fund Owner
			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($recordDetail->user_id,'feeds_launchdeal');
			//Check if seeting enabled
			if(!empty($isSettingEnabbled)){


				$title =' is following "'.$recordName.'" launch deal.';


				$UserFeeds = TableRegistry::get('UserFeeds');
    			$feeds = $UserFeeds->newEntity();
    			$values = [];
				$link= Router::url(['controller' => 'LaunchDeals', 'action' => 'view',base64_encode($record_id)]);
				
				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

				$feeds->sender_id = $senderId;
				$feeds->receiver_id = $recordDetail->user_id;

    			$feeds->type =$type;
    			$feeds->title =$title;
    			$feeds->link =$link;
    			$feeds->record_name	=$record_id;

    			$feeds->data =json_encode($values);

				//Save user feeds.
				$result = $UserFeeds->save($feeds);
			}

	    }    	
    }


    /**************************************************************************
    *
    * Get groupBuying followers
    *
    *
    ****/
	public function groupBuyingFollowerList($record_id=null)
	{
			$resultList = TableRegistry::get('GroupBuyingFollowers');
			 
			$resultLists = $resultList->find('all',['conditions'=>['groupbuying_id'=>$record_id]])->toArray();
		  
			return $resultLists;
			
	}

    /****
	*
	* Save groupBuying Feeds
	*
	******/
	public function saveGroupBuyingFeeds($senderId=null,$type=null,$record_id=null)
    {	
    	$recordDetails = TableRegistry::get('GroupBuyings');
	    $recordDetail= $recordDetails->find('all',['conditions'=>['id'=>$record_id]])->first();
	    $recordName = $recordDetail->title;

    	if($type == 'feeds_purchaseorder_added'){ 
	    	//Ger user connections List
	    	$connectionLists= $this->getConnectionLists($senderId);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {
	    			//Check if seeting enabled
	    			$isSettingEnabbled='';
	    			if($value->connection_by == $senderId){
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_to,'feeds_purchaseorder');
	    			}else{
	    				$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->connection_by,'feeds_purchaseorder');
	    			}
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){

						$title =' added "'.$recordName.'" purchase order.';
	    			
						$UserFeeds = TableRegistry::get('UserFeeds');
		    			$feeds = $UserFeeds->newEntity();
		    			$values = [];

		    			if($value->connection_by == $senderId){

		    				$link= Router::url(['controller' => 'GroupBuyings', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$value->connection_by,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_by;
		    				$feeds->receiver_id = $value->connection_to;

		    			}else{

		    				$link= Router::url(['controller' => 'GroupBuyings', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$value->connection_to,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $value->connection_to;
		    				$feeds->receiver_id =$value->connection_by;

		    			}
		    			$feeds->type =$type;
		    			$feeds->title =$title;
		    			$feeds->link =$link;
		    			$feeds->record_name	=$record_id;

		    			$feeds->data =json_encode($values);

	    				//Save user feeds.
	    				$result = $UserFeeds->save($feeds);
	    				//return $isSettingEnabbled;
	    			}
	    		}
	    	}

	    }else{

	    	//Ger user connections List
	    	$connectionLists= $this->groupBuyingFollowerList($record_id);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {

	    			//Check if seeting enabled
	    			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->user_id,'feeds_purchaseorder');
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){
	    				if($senderId != $value->user_id){

							$title =' is following "'.$recordName.'" purchase order.';

							$UserFeeds = TableRegistry::get('UserFeeds');
			    			$feeds = $UserFeeds->newEntity();
			    			$values = [];

		    				$link= Router::url(['controller' => 'GroupBuyings', 'action' => 'view',base64_encode($record_id)]);

		    				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $senderId;
		    				$feeds->receiver_id = $value->user_id;

			    			$feeds->type =$type;
			    			$feeds->title =$title;
			    			$feeds->link =$link;
			    			$feeds->record_name	=$record_id;

			    			$feeds->data =json_encode($values);

		    				//Save user feeds.
		    				$result = $UserFeeds->save($feeds);
		    				//return $isSettingEnabbled;
		    			}	
	    			}
	    		}
	    	}

	    	//Send feeds to Fund Owner
			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($recordDetail->user_id,'feeds_purchaseorder');
			//Check if seeting enabled
			if(!empty($isSettingEnabbled)){


				$title =' is following "'.$recordName.'" purchase order.';


				$UserFeeds = TableRegistry::get('UserFeeds');
    			$feeds = $UserFeeds->newEntity();
    			$values = [];
				$link= Router::url(['controller' => 'GroupBuyings', 'action' => 'view',base64_encode($record_id)]);
				
				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

				$feeds->sender_id = $senderId;
				$feeds->receiver_id = $recordDetail->user_id;

    			$feeds->type =$type;
    			$feeds->title =$title;
    			$feeds->link =$link;
    			$feeds->record_name	=$record_id;

    			$feeds->data =json_encode($values);

				//Save user feeds.
				$result = $UserFeeds->save($feeds);
			}

	    }    	
    }


    /**************************************************************************
    *
    * Get organization followers
    *
    *
    ****/
	public function organizationHiredList($record_id=null)
	{
			$resultList = TableRegistry::get('SubAdminRelations');
			 
			$resultLists = $resultList->find('all',['conditions'=>['sub_admin_details_id'=>$record_id]])->toArray();
		  
			return $resultLists;
			
	}

	/****
	*
	* Get Users List
	*
	******/
	public function getUsersLists($senderId=null)
    {
            $UserConnections = TableRegistry::get('Users');
			

			$connectionLists = $UserConnections->find('all',['conditions'=>['id !='=> $senderId,'role_id'=>2]])->toArray();

            return $connectionLists;
    }

    /****
	*
	* Save organization Feeds
	*
	******/
	public function saveOrganizationFeeds($senderId=null,$type=null,$record_id=null)
    {	
    	$recordDetails = TableRegistry::get('SubAdminDetails');
	    $recordDetail= $recordDetails->find('all',['conditions'=>['id'=>$record_id]])->first();
	    $recordName = $recordDetail->company_name;

    	if($type == 'feeds_organization_added'){ 
	    	//Ger user connections List
	    	$connectionLists= $this->getUsersLists($senderId);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {
	    			//Check if seeting enabled
	    			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->id,'feeds_organization');

	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){

						$title =' added "'.$recordName.'" organization.';
	    			
						$UserFeeds = TableRegistry::get('UserFeeds');
		    			$feeds = $UserFeeds->newEntity();
		    			$values = [];

	    				//$link= Router::url(['controller' => 'Companies', 'action' => 'view',base64_encode($record_id)]);
	    				$link= '/companies/view/'.base64_encode($record_id);
	    				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

	    				$feeds->sender_id = $senderId;
	    				$feeds->receiver_id =$value->id;

		    			$feeds->type =$type;
		    			$feeds->title =$title;
		    			$feeds->link =$link;
		    			$feeds->record_name	=$record_id;

		    			$feeds->data =json_encode($values);

	    				//Save user feeds.
	    				$result = $UserFeeds->save($feeds);
	    				//return $isSettingEnabbled;
	    			}
	    		}
	    	}

	    }else{

	    	//Ger user connections List
	    	$connectionLists= $this->organizationHiredList($record_id);
	    	if(!empty($connectionLists)){
	    		foreach ($connectionLists as $key => $value) {

	    			//Check if seeting enabled
	    			$isSettingEnabbled= $connectionLists= $this->getFeedsSetting($value->contractor_id,'feeds_organization');
	    			//Check if seeting enabled
	    			if(!empty($isSettingEnabbled)){

							$title =' updated "'.$recordName.'" organization.';

							$UserFeeds = TableRegistry::get('UserFeeds');
			    			$feeds = $UserFeeds->newEntity();
			    			$values = [];

		    				//$link= Router::url(['controller' => 'Companies', 'action' => 'view',base64_encode($record_id)]);
		    				$link= '/companies/view/'.base64_encode($record_id);
		    				$values = ['sender_id'=>$senderId,'record_id'=>$record_id,'team_id'=>''];

		    				$feeds->sender_id = $senderId;
		    				$feeds->receiver_id = $value->contractor_id;

			    			$feeds->type =$type;
			    			$feeds->title =$title;
			    			$feeds->link =$link;
			    			$feeds->record_name	=$record_id;

			    			$feeds->data =json_encode($values);

		    				//Save user feeds.
		    				$result = $UserFeeds->save($feeds);
		    				//return $isSettingEnabbled;
	    			}
	    		}
	    	}
	    }    	
    }





}
?>