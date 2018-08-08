<?php
namespace App\Controller\Component;

use Cake\Controller\Component;
use Cake\Controller\ComponentRegistry;
use Cake\Network\Exception\InternalErrorException;
use Cake\Utility\Text;
use Cake\ORM\TableRegistry;

class UserImageWebComponent extends Component
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
				$profile_image = 'img/profile_pic/'.$keywordsValue['image'];
			else:
				$profile_image = 'images/dummy-man.png';
			endif;
					
			return $profile_image;
		}
	
	/*it returns the profile image of a particular user*/
	
		public function entrepreneurImage($user_id=null){
			$keywords = TableRegistry::get('entrepreneur_basics');
		  
			$keywordsValue = $keywords->find('all',['conditions'=>['user_id'=>$user_id]])
										->select(['image'])
										->first();
										
			if(!empty($keywordsValue)){
				$keywordsValue = $keywordsValue->toArray();
			}
										
			
			if(!empty($keywordsValue) && ($keywordsValue['image']!='') && (file_exists(WWW_ROOT.'img/profile_pic/'.$keywordsValue['image']))):
				$profile_image = 'img/profile_pic/'.$keywordsValue['image'];
			else:
				$profile_image = '';
			endif;
					
			return $profile_image;
		}


		/*it returns the entrepreneur kewords list for reccommended campagn user*/
	
		public function entrepreneurKeywords($user_id=null){
			$keywords = TableRegistry::get('entrepreneur_professionals');
		  
			$keywordsValue = $keywords->find('all',['conditions'=>['user_id'=>$user_id]])
										->select(['keywords'])
										->first();
										
			if(!empty($keywordsValue)){
				$keywordsValue = $keywordsValue->toArray();
			}
										
			
			if(!empty($keywordsValue) && ($keywordsValue['keywords']!='')):
				$selectedKewords = $keywordsValue['keywords'];
			else:
				$selectedKewords = '';
			endif;
					
			return $selectedKewords;
		}

		/*it returns the contractor kewords list for reccommended campagn user*/
	
		public function contractorKeywords($user_id=null){
			$keywords = TableRegistry::get('contractor_professionals');
		  
			$keywordsValue = $keywords->find('all',['conditions'=>['user_id'=>$user_id]])
										->select(['keywords'])
										->first();
										
			if(!empty($keywordsValue)){
				$keywordsValue = $keywordsValue->toArray();
			}
										
			
			if(!empty($keywordsValue) && ($keywordsValue['keywords']!='')):
				$selectedKewords = $keywordsValue['keywords'];
			else:
				$selectedKewords = '';
			endif;
					
			return $selectedKewords;
		}

		/*
		* Get User profile public or private and notification enable or disable
		*
		*
		*/
		public function getUserProfileStatus($user_id=null)
		{
			$settings = TableRegistry::get('settings');
			$settingsValue = $settings->find('all',['conditions'=>['user_id'=>$user_id]])->first();
			if(!empty($settingsValue)){
				$settingsValue = $settingsValue->toArray();
			}

			if(!empty($settingsValue)){
				$profileStatus = $settingsValue['public_profile'];
			}else{
				$profileStatus = 1;
			}	
			return $profileStatus;
		}

		/*
		* it returns the Road map  details
		*
		**/
		
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

		/*getting the consumed hours by a team member*/
		
		public function memberConsumedHours($startup_id=null,$user_id=null,$StartupTeamId=null)
		{
				
			$startupWorkOrders = TableRegistry::get('startup_work_orders');
			
			$query = $startupWorkOrders->find();
			$keywordsValue = $query->select(['consumed_hours' => $query->func()->sum('work_units')])
									->where(['user_id'=>$user_id,
											 'startup_id'=>$startup_id,
											 'startup_team_id'=>$StartupTeamId,
											 'status'=>1])
									->first()
									->toArray();
		
			if(!empty($keywordsValue)&&($keywordsValue['consumed_hours']!='')):
				return $keywordsValue['consumed_hours'];
			else:
				return '0';
			endif;
			
		}

		public function memberunApprovedConsumedHours($startup_id=null,$user_id=null,$StartupTeamId=null)
		{
				
			$startupWorkOrders = TableRegistry::get('startup_work_orders');
			
			$query = $startupWorkOrders->find();
			$keywordsValue = $query->select(['consumed_hours' => $query->func()->sum('work_units')])
									->where(['user_id'=>$user_id,
											 'startup_id'=>$startup_id,
											 'startup_team_id'=>$StartupTeamId,
											 'OR' => [['status' => 0], ['status' => 1]]
											])
									->first()
									->toArray();
		
			if(!empty($keywordsValue)&&($keywordsValue['consumed_hours']!='')):
				return $keywordsValue['consumed_hours'];
			else:
				return '0';
			endif;
			
		}

		/*
	    *upload a file thorugh Api
	    *
	    */
	
		public function forumImageUpload($files = null)
    	{   
            if(!empty($files)){
                $valid_formats = array("jpg", "jpeg", "png","gif","JPG","JPEG","PNG","GIF");
                //$max_file_size = 1024*100; //100 kb
                $max_file_size = 2097152; //2MB
                $path = WWW_ROOT . "img/forums/"; // Upload directory
                $imgCamp='';
                $errors='';

                if ($files['error'] == 0) {              
                        if ($files['size'] > $max_file_size) {
                            $errors = $files['name']." is too large! Max allowed size is 2MB.";
                            //continue; // Skip large files
                           
                        }
                        elseif( ! in_array(pathinfo($files['name'], PATHINFO_EXTENSION), $valid_formats) ){
                            $errors = $files['name']." is not a valid format, Allowed format are jpg,jpeg,png,gif.";
                           // continue; // Skip invalid file formats
                          
                        }
                        else{ // No error found! Move uploaded files 
                            $setNewFileName = time() . "_" . rand(000000, 999999);
                            if(move_uploaded_file($files["tmp_name"], $path.$setNewFileName.$files['name'])) { // Number of successfully uploaded files
                                $imgCamp = $setNewFileName.$files['name'];
                            }
                        }
                    } 
                    $imgCampArray = array(
                                    'imgName' => $imgCamp,
                                    'errors' => $errors,                                 
                            ); 

                    return $imgCampArray;
             }   
    	}

			
		

}
?>