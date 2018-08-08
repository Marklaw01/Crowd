<?php
namespace App\Controller\Component;

use Cake\Controller\Component;
use Cake\Controller\ComponentRegistry;
use Cake\Network\Exception\InternalErrorException;
use Cake\Utility\Text;
use Cake\ORM\TableRegistry;

class ContractorComponent extends Component
{
	
	/*it returns the profile image of a particular user*/
	
		public function contractorImage($user_id=null){
			$keywords = TableRegistry::get('contractor_basics');
		  
			$keywordsValue = $keywords->find('all',['conditions'=>['user_id'=>$user_id]])
										->select(['image'])
										->first();
										
			if(!empty($keywordsValue)){
				$keywordsValue = $keywordsValue->toArray();
			}
										
			
			if(!empty($keywordsValue) && ($keywordsValue['image']!='') && (file_exists(WWW_ROOT.'img/profile_pic/'.$keywordsValue['image']))):
				$profile_image = '/img/profile_pic/'.$keywordsValue['image'];
			else:
				$profile_image = '/img/default/userdummy.png';
			endif;
					
			return $profile_image;
		}
	
	/*getting the rating of a contractor*/
		
		public function contractorRating($user_id=null){
			$keywords = TableRegistry::get('WorkorderRatings');
			
			$query = $keywords->find();
			$keywordsValue = $query->select(['rating' => $query->func()->avg('rating_star')])
									->where(['given_to'=>$user_id])
									->first()
									->toArray();
			
			return $keywordsValue;
			
		}

	/*getting the rating of a contractor*/
		
		public function entrepreneurRating($user_id=null){
			$keywords = TableRegistry::get('EntrepreneurRatings');
			
			$query = $keywords->find();
			$keywordsValue = $query->select(['rating' => $query->func()->avg('rating_star')])
									->where(['given_to'=>$user_id])
									->first()
									->toArray();
			
			return $keywordsValue;
			
		}	
	
	/*it returns the Keywords of a particular user*/
	
		public function contractorKeywords($keyword_ids=null){
			$keywords = TableRegistry::get('keywords');
		
			$keywordsValue = [];
			
			$keywordsArray = explode(',',$keyword_ids);
			 
			$keywordsValue = $keywords->find('list',['conditions'=>['id IN'=>$keywordsArray]])
										->toArray();
			 
			return $keywordsValue;
		}


		public function campaignTargetKeywords($keyword_ids=null){
			$keywords = TableRegistry::get('CampaignTargetKeywords');
		
			$keywordsValue = [];
			
			$keywordsArray = explode(',',$keyword_ids);
			 
			$keywordsValue = $keywords->find('list',['conditions'=>['id IN'=>$keywordsArray]])
										->toArray();
			 
			return $keywordsValue;
		}

		public function companyKeywords($keyword_ids=null){
			$JobPostingKeywords = TableRegistry::get('JobPostingKeywords');
		
			$keywordsValue = [];
			
			$keywordsArray = explode(',',$keyword_ids);
			 
			$keywordsValue = $JobPostingKeywords->find('list',['conditions'=>['id IN'=>$keywordsArray]])
										->toArray();
			if(!empty($keywordsValue)):
										
				foreach($keywordsValue as $key=>$value){
					$key1=[];
					$key1['id'] = ($key!='')?$key:' ';
					$key1['name'] = ($value!=' ')?$value:' ';
							 
					$keys[] = $key1;			 
				}	 
				
			else :
				$keys=[];
			endif;	
									
			return $keys;
		}

		public function campaignKeywords($keyword_ids=null){
			$keywords = TableRegistry::get('KeywordCampaigns');
		
			$keywordsValue = [];
			
			$keywordsArray = explode(',',$keyword_ids);
			 
			$keywordsValue = $keywords->find('list',['conditions'=>['id IN'=>$keywordsArray]])
										->toArray();
			 
			return $keywordsValue;
		}

		/*it returns the Keywords of a particular user*/
	
		public function starupKeywordsList($keyword_ids=null){
			$keywords = TableRegistry::get('KeywordStartups');
		
			$keywordsValue = [];
			
			$keywordsArray = explode(',',$keyword_ids);
			 
			$keywordsValue = $keywords->find('list',['conditions'=>['id IN'=>$keywordsArray]])
										->toArray();
			 
			return $keywordsValue;
		}

		/*it returns the Keywords of a particular user*/
	
		public function contractorPreferKeywords($keyword_ids=null){
			$keywords = TableRegistry::get('prefferStartups');
		
			$keywordsValue = [];
			
			$keywordsArray = explode(',',$keyword_ids);
			 
			$keywordsValue = $keywords->find('list',['conditions'=>['id IN'=>$keywordsArray]])
										->toArray();
			 
			return $keywordsValue;
		}
		
		/*it returns the  ,qualifications  of a particular user*/
	
		public function contractorQualifications($keyword_ids=null){
			$keywords = TableRegistry::get('qualifications');
		
			$keywordsValue = [];
			
			$keywordsArray = explode(',',$keyword_ids);
			
			$keywordsValue = $keywords->find('list',['conditions'=>['id IN'=>$keywordsArray]])
										->toArray();
			
			return $keywordsValue;
		}
		
		/*it returns the certifications,  of a particular user*/
	
		public function contractorCertifications($keyword_ids=null){
			$keywords = TableRegistry::get('certifications');
		
			$keywordsValue = [];
			
			$keywordsArray = explode(',',$keyword_ids);
			
			$keywordsValue = $keywords->find('list',['conditions'=>['id IN'=>$keywordsArray]])
										->toArray();
			
			return $keywordsValue;
		}
		
		/*it returns the   ,skills of a particular user*/
	
		public function contractorSkills($keyword_ids=null){
			$keywords = TableRegistry::get('skills');
		
			$keywordsValue = [];
			
			$keywordsArray = explode(',',$keyword_ids);
			
			$keywordsValue = $keywords->find('list',['conditions'=>['id IN'=>$keywordsArray]])
										->toArray();
			
			return $keywordsValue;
		}


		public function JobDutyList($keyword_ids=null){
			$keywords = TableRegistry::get('job_duties');
		
			$keywordsValue = [];
			
			$keywordsArray = explode(',',$keyword_ids);
			
			$keywordsValue = $keywords->find('list',['conditions'=>['id IN'=>$keywordsArray]])
										->toArray();
			
			if(!empty($keywordsValue)):
										
				foreach($keywordsValue as $key=>$value){
					$key1=[];
					$key1['id'] = ($key!='')?$key:' ';
					$key1['name'] = ($value!=' ')?$value:' ';
							 
					$keys[] = $key1;			 
				}	 
				
			else :
				$keys=[];
			endif;	
									
			return $keys;
		}

		public function JobRoleList($keyword_ids=null){
			$keywords = TableRegistry::get('job_roles');
		
			$keywordsValue = [];
			
			$keywordsArray = explode(',',$keyword_ids);
			
			$keywordsValue = $keywords->find('list',['conditions'=>['id IN'=>$keywordsArray]])
										->toArray();
			
			if(!empty($keywordsValue)):
										
				foreach($keywordsValue as $key=>$value){
					$key1=[];
					$key1['id'] = ($key!='')?$key:' ';
					$key1['name'] = ($value!=' ')?$value:' ';
							 
					$keys[] = $key1;			 
				}	 
				
			else :
				$keys=[];
			endif;	
									
			return $keys;
		}

		public function JobAchievementList($keyword_ids=null){
			$keywords = TableRegistry::get('job_achievements');
		
			$keywordsValue = [];
			
			$keywordsArray = explode(',',$keyword_ids);
			
			$keywordsValue = $keywords->find('list',['conditions'=>['id IN'=>$keywordsArray]])
										->toArray();
			
			if(!empty($keywordsValue)):
										
				foreach($keywordsValue as $key=>$value){
					$key1=[];
					$key1['id'] = ($key!='')?$key:' ';
					$key1['name'] = ($value!=' ')?$value:' ';
							 
					$keys[] = $key1;			 
				}	 
				
			else :
				$keys=[];
			endif;	
									
			return $keys;
		}

		public function jobPostKeword($keyword_ids=null){
			$keywords = TableRegistry::get('job_posting_keywords');
		
			$keywordsValue = [];
			
			$keywordsArray = explode(',',$keyword_ids);
			
			$keywordsValue = $keywords->find('list',['conditions'=>['id IN'=>$keywordsArray]])
										->toArray();
			
			return $keywordsValue;
		}

		public function jobIndustryIdname($keyword_ids=null){
			$keywords = TableRegistry::get('job_industries');
		
			$keywordsValue = [];
			
			$keywordsArray = explode(',',$keyword_ids);
			
			$keywordsValue = $keywords->find('list',['conditions'=>['id IN'=>$keywordsArray]])
										->toArray();
			
			return $keywordsValue;
		}
		
		public function entrepreneurImage($user_id=null){
			$keywords = TableRegistry::get('entrepreneur_basics');
			
			$keywordsValue = $keywords->find('all',['conditions'=>['user_id'=>$user_id]])
										->select(['image'])
										->first();
										
			if(!empty($keywordsValue)){
				$keywordsValue = $keywordsValue->toArray();
			}
										
			
			if(!empty($keywordsValue) && ($keywordsValue['image']!='') && (file_exists(WWW_ROOT.'img/profile_pic/'.$keywordsValue['image']))):
				$profile_image = '/img/profile_pic/'.$keywordsValue['image'];
			else:
				$profile_image = '/img/default/userdummy.png';
			endif;
					
			return $profile_image;
		}
		
		public function contractorProfileCompleteness($user_id=null){
			
			$contractor_basics = TableRegistry::get('contractor_basics');
			$contractor_professionals = TableRegistry::get('contractor_professionals');
			
			$contractor_basicsinfo = $contractor_basics->find('all',['conditions'=>['user_id'=>$user_id]])
									->first();
			
			$contractor_professionalsinfo = $contractor_professionals->find('all',['conditions'=>['user_id'=>$user_id]])
										->first();
			
			$totalFields = 19;	
			$completed = 0;

			 if(!empty($contractor_basicsinfo)){
				
				$contractor_basics_info = $contractor_basicsinfo->toArray();
				 
				if($contractor_basics_info['price']!='' && $contractor_basics_info['price']!=0):
					$completed++;
				endif;
				
				if($contractor_basics_info['bio']!=''):
					$completed++;
				endif;
				
				if($contractor_basics_info['first_name']!=''):
					$completed++;
				endif;
				
				if($contractor_basics_info['last_name']!=''):
					$completed++;
				endif;
				
				if($contractor_basics_info['email']!=''):
					$completed++;
				endif;
				
				if($contractor_basics_info['date_of_birth']!=''):
					$completed++;
				endif;
				
				if($contractor_basics_info['phoneno']!=''):
					$completed++;
				endif;
				
				if($contractor_basics_info['country_id']!=''):
					$completed++;
				endif;
				
				if($contractor_basics_info['state_id']!=''):
					$completed++;
				endif;
				
				if($contractor_basics_info['image']!=''):
					$completed++;
				endif;
				
			 }
			
			 if(!empty($contractor_professionalsinfo)){
				
				$contractor_professionals_info = $contractor_professionalsinfo->toArray();
				
				if($contractor_professionals_info['experience_id']!=''):
					$completed++;
				endif;
				
				if($contractor_professionals_info['keywords']!=''):
					$completed++;
				endif;
				
				if($contractor_professionals_info['qualifications']!=''):
					$completed++;
				endif;
				
				if($contractor_professionals_info['certifications']!=''):
					$completed++;
				endif;
				
				if($contractor_professionals_info['skills']!=''):
					$completed++;
				endif;
				
				if($contractor_professionals_info['industry_focus']!=''):
					$completed++;
				endif;
				
				if($contractor_professionals_info['startup_stage']!=''):
					$completed++;
				endif;
				
				if($contractor_professionals_info['contributor_type']!=''):
					$completed++;
				endif;
				
				if($contractor_professionals_info['accredited_investor']!=''):
					$completed++;
				endif;
				
			 }
			 
			$percntile = round(($completed*100)/$totalFields);
			
			return $percntile;
		}


		
		public function entrepreneurProfileCompleteness($user_id=null){
		
			$entrepreneur_basics = TableRegistry::get('entrepreneur_basics');
			$entrepreneur_professionals = TableRegistry::get('entrepreneur_professionals');
			
			$entrepreneur_basicsinfo = $entrepreneur_basics->find('all',['conditions'=>['user_id'=>$user_id]])
									->first();
			
			$entrepreneur_professionalsinfo = $entrepreneur_professionals->find('all',['conditions'=>['user_id'=>$user_id]])
										->first();
			
			$totalFields = 17;	
			$completed = 0;
			 
			 if(!empty($entrepreneur_basicsinfo)){
				
				$entrepreneur_basics_info = $entrepreneur_basicsinfo->toArray();
				
				if($entrepreneur_basics_info['image']!=''):
					$completed++;
				endif;
				
				if($entrepreneur_basics_info['bio']!=''):
					$completed++;
				endif;
				
				if($entrepreneur_basics_info['first_name']!=''):
					$completed++;
				endif;
				
				if($entrepreneur_basics_info['last_name']!=''):
					$completed++;
				endif;
				
				if($entrepreneur_basics_info['email']!=''):
					$completed++;
				endif;
				
				if($entrepreneur_basics_info['date_of_birth']!=''):
					$completed++;
				endif;
				
				if($entrepreneur_basics_info['phoneno']!=''):
					$completed++;
				endif;
				
				if($entrepreneur_basics_info['country_id']!=''):
					$completed++;
				endif;
				
				if($entrepreneur_basics_info['state_id']!=''):
					$completed++;
				endif;
				 
				if($entrepreneur_basics_info['my_interests']!=''):
					$completed++;
				endif;
				
			 }
			
			 if(!empty($entrepreneur_professionalsinfo)){
				
				$entrepreneur_professionals_info = $entrepreneur_professionalsinfo->toArray();
				
				if($entrepreneur_professionals_info['company_name']!=''):
					$completed++;
				endif;
				
				if($entrepreneur_professionals_info['website_link']!=''):
					$completed++;
				endif;
				
				if($entrepreneur_professionals_info['description']!=''):
					$completed++;
				endif;
				
				if($entrepreneur_professionals_info['keywords']!=''):
					$completed++;
				endif;
				
				if($entrepreneur_professionals_info['qualifications']!=''):
					$completed++;
				endif;
				
				if($entrepreneur_professionals_info['skills']!=''):
					$completed++;
				endif;
				
				if($entrepreneur_professionals_info['industry_focus']!=''):
					$completed++;
				endif;
				
			 }
			  
			$percntile = round(($completed*100)/$totalFields);
			
			return $percntile;
		}
		
		/*it returns the user is foollowing the campaign or not*/
		
		public function isFollowing($user_id=null,$campaign_id){
			$keywords = TableRegistry::get('campaign_followers');
			
			$keywordsValue = $keywords->find('all',['conditions'=>['user_id'=>$user_id,'campaign_id'=>$campaign_id]])
										->first();
							
			if(!empty($keywordsValue)){
				return '1';
			}else{
				return '0';						
			}
			
		}
		
		public function isUserFollowing($following_id=null,$followed_id){
			
			$keywords = TableRegistry::get('user_followers');
			
			$keywordsValue = $keywords->find('all',['conditions'=>['followed_by'=>$following_id,'user_id'=>$followed_id]])
										->first();
			
			if(!empty($keywordsValue)){
				return '1';
			}else{
				return '0';						
			}
			
		}
		 
		/*it returns the user is foollowing the campaign or not*/
		
		public function isCommit($user_id=null,$campaign_id){
			$keywords = TableRegistry::get('campaign_donations');
			
			$keywordsValue = $keywords->find('all',['conditions'=>['user_id'=>$user_id,'campaign_id'=>$campaign_id]])
										->first();
							
			if(!empty($keywordsValue)){
				return '1';
			}else{
				return '0';						
			}
			
		}
		
		/*it returns the entrepreneur name from entrprnr or user table*/
		
		public function entrepreneurName($user_id=null){
			$users = TableRegistry::get('users');
			
			$userValue = $users->find('all',['conditions'=>['users.id'=>$user_id]])
										->contain(['EntrepreneurBasics'])
										->first();
			
			if(!empty($userValue['entrepreneur_basic'])&& isset($userValue['entrepreneur_basic'])){
				
				$first_name = ($userValue['entrepreneur_basic']->first_name!='')?$userValue['entrepreneur_basic']->first_name:' ';
				$last_name = ($userValue['entrepreneur_basic']->last_name!='')?$userValue['entrepreneur_basic']->last_name:' ';
				
				return $first_name.' '.$last_name;
				
			}elseif(!empty($userValue)){
				
				$first_name = ($userValue->first_name!='')?$userValue->first_name:' ';
				$last_name = ($userValue->last_name!='')?$userValue->last_name:' ';
				
				return $first_name.' '.$last_name;					
			}else{
				return '';	
			}
			
		}
	  
	  /*it returns the contractor name from contractor or user table*/
	  
		public function contractorName($user_id=null){
			$users = TableRegistry::get('users');
			
			$userValue = $users->find('all',['conditions'=>['users.id'=>$user_id]])
										->contain(['ContractorBasics'])
										->first();
			
			if(!empty($userValue['contractor_basic'])&& isset($userValue['contractor_basic'])){
				
				$first_name = ($userValue['contractor_basic']->first_name!='')?$userValue['contractor_basic']->first_name:' ';
				$last_name = ($userValue['contractor_basic']->last_name!='')?$userValue['contractor_basic']->last_name:' ';
				
				$fullname = $first_name.' '.$last_name;
				return 	trim($fullname)	;
				
			}elseif(!empty($userValue)){
				
				$first_name = ($userValue->first_name!='')?$userValue->first_name:' ';
				$last_name = ($userValue->last_name!='')?$userValue->last_name:' ';
				$fullname = $first_name.' '.$last_name;
				return 	trim($fullname)	;			
			}else{
				return '';	
			}
			
		}
		
		 /*it returns the contractor name from contractor or user table*/
	  
		public function contractorEmail($user_id=null){
			$users = TableRegistry::get('users');
			
			$userValue = $users->find('all',['conditions'=>['users.id'=>$user_id]])
										->contain(['ContractorBasics'])
										->first();
			
			if(!empty($userValue['contractor_basic'])&& isset($userValue['contractor_basic'])){
				
				$first_name = ($userValue['contractor_basic']->email!='')?$userValue['contractor_basic']->email:' '; 
				
				return $first_name;
				
			}elseif(!empty($userValue)){
				
				$first_name = ($userValue->email!='')?$userValue->email:' ';
				
				return $first_name;					
			}else{
				return '';	
			}
			
		}
		
		/*it returns the deliverable roadmaps of a particular user*/
		
		public function startupRoadmaps(){
			$keywords = TableRegistry::get('Roadmaps');
			
			$startupRoadmaps = $keywords->find('all')
										->toArray();
			if(!empty($startupRoadmaps)):
				foreach($startupRoadmaps as $singleroadmap):
					$rdmap[$singleroadmap->id] = $singleroadmap->name;
				endforeach;
				return $rdmap;
			else:
				return [];
			endif;
			
		}
		
		/*it returns the EntrepreneurBasic profile of a particular user*/
		
		public function userEntrepreneurBasic($user_id=null){
			$Users = TableRegistry::get('Users');
			
			$Users = $Users->find('all',['conditions'=>['Users.id'=>$user_id]])
										->contain(['EntrepreneurBasics'])
										->first()
										->toArray();
			if(!empty($Users)):
				return $Users;
			else:
				return [];
			endif;
			
		}
		
		/*it returns the EntrepreneurBasic profile of a particular user*/
		
		public function userContractorBasic($user_id=null){
			$Users = TableRegistry::get('Users');
			
			$Users = $Users->find('all',['conditions'=>['Users.id'=>$user_id]])
										->contain(['ContractorBasics'])
										->first();
										
			if(!empty($Users)){
				$Users = $Users->toArray();
				
				if(!empty($Users)):
					return $Users;
				else:
					return [];
				endif;
				
			}else{
				return [];
			}
			
		}
		
		/*it returns the Road map  details*/
		
		public function RoadmapDetails($roadmap_id=null){
			$RoadMaps = TableRegistry::get('Roadmaps');
			
			$RoadMaps = $RoadMaps->find('all',['conditions'=>['Roadmaps.id'=>$roadmap_id]])
										->first();
			
			if(!empty($RoadMaps)&&($RoadMaps->name!='')):
				return $RoadMaps->name;
			else:
				return '';
			endif;
			
		}
		
		/*it returns the role of a member in team*/
		
		public function teamMemberName($startup_id=null,$user_id=null){
			$StartupTeams = TableRegistry::get('StartupTeams');
			
			$role = $StartupTeams->find('all',['conditions'=>['StartupTeams.startup_id'=>$startup_id,
																	  'StartupTeams.user_id'=>$user_id]])
										->select(['contractor_role_id'])
										->first();
			
			if(!empty($role)&&($role->contractor_role_id!='')):
				return $role->contractor_role_id;
			else:
				return '';
			endif;
			
		}
		
		/*it returns the role of a member in team*/
		
		public function teamMemberRoleName($role_id=null){
			$ContractorRoles = TableRegistry::get('ContractorRoles');
			
			$role = $ContractorRoles->find('all',['conditions'=>['ContractorRoles.id'=>$role_id]])
										->select(['name'])
										->first();
			
			if(!empty($role)&&($role->name!='')):
				return $role->name;
			else:
				return '';
			endif;
			
		}
		
		/*getting the consumed hours by a team member*/
		
		public function memberConsumedHours($startup_id=null,$user_id=null,$StartupTeamId=null){
			$startupWorkOrders = TableRegistry::get('startup_work_orders');
			
			$query = $startupWorkOrders->find();
			$keywordsValue = $query->select(['consumed_hours' => $query->func()->sum('work_units')])
									->where(['user_id'=>$user_id,
											 'startup_id'=>$startup_id,
											 'startup_team_id'=>$StartupTeamId,
											 'status'=>'1'])
									->first()
									->toArray();
		
			if(!empty($keywordsValue)&&($keywordsValue['consumed_hours']!='')):
				return $keywordsValue['consumed_hours'];
			else:
				return '0';
			endif;
			
		}
		
		/*getting the consumed hours by a team member*/
		
		public function campaignName($campaign_id=null){
			$camapigns = TableRegistry::get('campaigns');
			
			$query = $camapigns->find();
			$keywordsValue = $query->select(['campaigns_name'])
									->where(['id'=>$campaign_id])
									->first();
			 
			if(!empty($keywordsValue)):
				if(!empty($keywordsValue)&&($keywordsValue['campaigns_name']!='')):
					return $keywordsValue['campaigns_name'];
				else:
					return '0';
				endif;
				
			else:
				return '0';
			endif;
			
			
			
		}
		
		
		/*getting the consumed hours by a team member*/
		
		public function startupName($startup_id=null){
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
		
		
		/*getting the consumed hours by a team member*/
		
		public function forumName($forum_id=null){
			$camapigns = TableRegistry::get('forums');
			
			$query = $camapigns->find();
			$keywordsValue = $query->select(['title'])
									->where(['id'=>$forum_id])
									->first()
									->toArray();
		
			if(!empty($keywordsValue)&&($keywordsValue['title']!='')):
				return $keywordsValue['title'];
			else:
				return '0';
			endif;
			
		}
		
		/*getting the PROFILE STATUS PRIVATE OR PUBLIC*/
		
		public function ProfileStatus($forum_id=null){
			$settings = TableRegistry::get('settings');
			
			$query = $settings->find();
			$keywordsValue = $query->select(['public_profile'])
									->where(['user_id'=>$forum_id])
									->first();
			 
			if(!empty($keywordsValue)):
				if($keywordsValue['public_profile']=='1'):
					return '1';
				else:
					return '0';
				endif;
			else:
				return '1';
			endif;
			
		}

		/*getting the meetup name*/
		
		public function meetupName($meetup_id=null){
			$meetups = TableRegistry::get('meetups');
			
			$query = $meetups->find();
			$keywordsValue = $query->select(['title'])
									->where(['id'=>$meetup_id])
									->first();
			
			if(!empty($keywordsValue)):
				if(!empty($keywordsValue)&&($keywordsValue['title']!='')):
					return $keywordsValue['title'];
				else:
					return '0';
				endif;
				
			else:
				return '0';
			endif;
			
			
			
		}
		
		public function saveNotification($sender,$receiver,$type,$title,$link,$data)
	{ 
			  //$this->loadModel('userNotifications'); 
			  $userNotifications = TableRegistry::get('userNotifications');
              $notification = $userNotifications->newEntity();
              $notification->sender_id = $sender;
              $notification->receiver_id = $receiver;
              $notification->type = $type;
              $notification->title = $title;
              $notification->link = $link;
			  $notification->data = $data;
				
			 $cc = $userNotifications->save($notification);
                 return $cc['id'];    

	}

	/* * * * * 
	*
	*
	*  Get isLikedbyUser Name and Id
	*
	*
	*
	* * * * */
		public function isBetaTester($userId=null)
		{

			$FundFollowers = TableRegistry::get('BetaSignups');
			$FundFollower= $FundFollowers->find('all',['conditions'=>['user_id' => $userId,'type' => 'beta_tester']])->first();
			
			$TotalItems=false;
	        if(!empty($FundFollower)){
	        	$TotalItems=true;
	        }

	        return $TotalItems;
		}

	/* * * * * 
	*
	*
	*  Get isLikedbyUser Name and Id
	*
	*
	*
	* * * * */
		public function isBoardMember($userId=null)
		{

			$FundFollowers = TableRegistry::get('BetaSignups');
			$FundFollower= $FundFollowers->find('all',['conditions'=>['user_id' => $userId,'type' => 'board_member']])->first();
			
			$TotalItems=false;
	        if(!empty($FundFollower)){
	        	$TotalItems=true;
	        }

	        return $TotalItems;
		}	

	/* * * * * 
	*
	*
	*  Get isLikedbyUser Name and Id
	*
	*
	*
	* * * * */
		public function isEarlyAdopter($userId=null)
		{

			$FundFollowers = TableRegistry::get('BetaSignups');
			$FundFollower= $FundFollowers->find('all',['conditions'=>['user_id' => $userId,'type' => 'early_adopter']])->first();
			
			$TotalItems=false;
	        if(!empty($FundFollower)){
	        	$TotalItems=true;
	        }

	        return $TotalItems;
		}

	/* * * * * 
	*
	*
	*  Get isLikedbyUser Name and Id
	*
	*
	*
	* * * * */
		public function isEndorsor($userId=null)
		{

			$FundFollowers = TableRegistry::get('BetaSignups');
			$FundFollower= $FundFollowers->find('all',['conditions'=>['user_id' => $userId,'type' => 'endorsor']])->first();
			
			$TotalItems=false;
	        if(!empty($FundFollower)){
	        	$TotalItems=true;
	        }

	        return $TotalItems;
		}   
	/* * * * * 
	*
	*
	*  Get isLikedbyUser Name and Id
	*
	*
	*
	* * * * */
		public function isFocusGroup($userId=null)
		{

			$FundFollowers = TableRegistry::get('BetaSignups');
			$FundFollower= $FundFollowers->find('all',['conditions'=>['user_id' => $userId,'type' => 'focus_group']])->first();
			
			$TotalItems=false;
	        if(!empty($FundFollower)){
	        	$TotalItems=true;
	        }

	        return $TotalItems;
		} 
}
?>