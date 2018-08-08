<?php
namespace App\View\Helper;

use Cake\View\Helper;

use Cake\ORM\TableRegistry;

class CustomHelper extends Helper {
    //public $helpers = array('Html');
 
    /*public function show($name) {
        $link = $this->Html->link($name, "##");
	return '<div>' . $link . '</div>';
    }*/

     /**
    *   Get Startups Detail by Id
    *   @params id
    *   @return Startups Detail
    */
    public function getStartupsDetailByID($ID = null){
        
    	$startups = TableRegistry::get('Startups');
       	$startup = $startups->find('all',['conditions'=> ['id'=> $ID]])->toArray();
		return $startup;
    }//EOF
    public function getUserImageByID($ID = null){
        
    	$UserImage = TableRegistry::get('ContractorBasics');
       	$UserImage = $UserImage->find('all',['conditions'=> ['user_id'=> $ID]])->toArray();
		return $UserImage;
    }

    // Get Campaign Commited amount by id
    public function getCampaignTotalDonatedAmountByID($ID = null){
        
        $DonatedAmount = TableRegistry::get('CampaignDonations');

        $DonatedAmount = $DonatedAmount->find('all',['conditions' => ['campaign_id' => $ID]]);
        $DonatedAmount= $DonatedAmount->sumOf('amount');


        return $DonatedAmount;
    }
    //Get contractor image by id
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
                $profile_image = '';
            endif;
                    
            return $profile_image;
        }

        public function contractorName($user_id=null){
            $keywords = TableRegistry::get('contractor_basics');
            

            $keywordsValue = $keywords->find('all',['conditions'=>['user_id'=>$user_id]])
                                        ->select(['first_name','last_name'])
                                        ->first();
                                        
            if(!empty($keywordsValue)){
                $keywordsValue = $keywordsValue->toArray();
            }else{
                $keywords = TableRegistry::get('Users');
                $keywordsValue = $keywords->find('all',['conditions'=>['id'=>$user_id]])
                                        ->select(['first_name','last_name'])
                                        ->first();
            }
                                        
            
            if(!empty($keywordsValue) && ($keywordsValue['first_name']!='')):
                $profile_name = $keywordsValue['first_name'].' '.$keywordsValue['last_name'];
            else:
                $profile_name = '';
            endif;
                    
            return $profile_name;
        }  

        public function getContractorUserNameById($user_id=null)
        {
            $keywords = TableRegistry::get('contractor_basics');
            

            $keywordsValue = $keywords->find('all',['conditions'=>['user_id'=>$user_id]])
                                        ->select(['first_name','last_name'])
                                        ->first();
                                        
            if(!empty($keywordsValue)){
                $keywordsValue = $keywordsValue->toArray();
            }else{
                $keywords = TableRegistry::get('Users');
                $keywordsValue = $keywords->find('all',['conditions'=>['id'=>$user_id]])
                                        ->select(['first_name','last_name'])
                                        ->first();
            }
                                        
            
            if(!empty($keywordsValue) && ($keywordsValue['first_name']!='')):
                $profile_name = $keywordsValue['first_name'].' '.$keywordsValue['last_name'];
            else:
                $profile_name = '';
            endif;
                    
            return $profile_name;

        }  

        public function getUserQuickbloxId($user_id=null)
        {
              $users = TableRegistry::get('users'); 
              $userValue = $users->find('all',['conditions'=>['users.id'=>$user_id]])
                            ->select(['quickbloxid'])
                            ->first();
              $userQuickbloxId = $userValue->quickbloxid;   
              
              return  $userQuickbloxId;       
        }

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

        public function getUserKeywords($user_id=null)
        {
              $users = TableRegistry::get('contractorProfessionals'); 
              $userValue = $users->find('all',['conditions'=>['contractorProfessionals.user_id'=>$user_id]])
                            ->select(['keywords'])
                            ->first();
              $userQuickbloxId='';              
              if(!empty($userValue->keywords)){              
              $userQuickbloxId = $userValue->keywords;   
              }
              return  $userQuickbloxId;       
        }
        /********************* Fund *********************/
        /* * * * * 
        *
        *
        *  Get getFundLikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getFundLikeCount($fundId=null)
        {

            $FundLikes = TableRegistry::get('FundLikes');
            $likelists= $FundLikes->find('all',['conditions'=>['fund_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }
            return $TotalItems;
        }

        /* * * * * 
        *
        *
        *  Get getFundDislikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getFundDislikeCount($fundId=null)
        {

            $FundDislikes = TableRegistry::get('FundDislikes');
            $likelists= $FundDislikes->find('all',['conditions'=>['fund_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get getFundFollowedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isFundLikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('FundLikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['fund_id' => $fundId,'like_by' => $userId]])->first();
            
            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get getFundFollowedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isFundDislikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('FundDislikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['fund_id' => $fundId,'dislike_by' => $userId]])->first();

            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;
        }

        /********************* Beta Test *********************/

        /* * * * * 
        *
        *
        *  Get getBetaLikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getBetaLikeCount($fundId=null)
        {

            $FundLikes = TableRegistry::get('BetaTestLikes');
            $likelists= $FundLikes->find('all',['conditions'=>['beta_test_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }
            return $TotalItems;
        }

        /* * * * * 
        *
        *
        *  Get getBetaDislikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getBetaDislikeCount($fundId=null)
        {

            $FundDislikes = TableRegistry::get('BetaTestDislikes');
            $likelists= $FundDislikes->find('all',['conditions'=>['beta_test_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get isBetaLikedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isBetaLikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('BetaTestLikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['beta_test_id' => $fundId,'like_by' => $userId]])->first();
            
            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get isBetaDislikedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isBetaDislikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('BetaTestDislikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['beta_test_id' => $fundId,'dislike_by' => $userId]])->first();

            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;
        }


        /********************* Board Member *********************/

        /* * * * * 
        *
        *
        *  Get getBetaLikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getBoardLikeCount($fundId=null)
        {

            $FundLikes = TableRegistry::get('BoardMemberLikes');
            $likelists= $FundLikes->find('all',['conditions'=>['board_member_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }
            return $TotalItems;
        }

        /* * * * * 
        *
        *
        *  Get getBetaDislikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getBoardDislikeCount($fundId=null)
        {

            $FundDislikes = TableRegistry::get('BoardMemberDislikes');
            $likelists= $FundDislikes->find('all',['conditions'=>['board_member_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get isBetaLikedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isBoardLikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('BoardMemberLikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['board_member_id' => $fundId,'like_by' => $userId]])->first();
            
            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get isBetaDislikedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isBoardDislikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('BoardMemberDislikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['board_member_id' => $fundId,'dislike_by' => $userId]])->first();

            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;
        }


        /********************* Early Adopter *********************/

        /* * * * * 
        *
        *
        *  Get getBetaLikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getEarlyLikeCount($fundId=null)
        {

            $FundLikes = TableRegistry::get('EarlyAdopterLikes');
            $likelists= $FundLikes->find('all',['conditions'=>['early_adopter_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }
            return $TotalItems;
        }

        /* * * * * 
        *
        *
        *  Get getBetaDislikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getEarlyDislikeCount($fundId=null)
        {

            $FundDislikes = TableRegistry::get('EarlyAdopterDislikes');
            $likelists= $FundDislikes->find('all',['conditions'=>['early_adopter_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get isBetaLikedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isEarlyLikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('EarlyAdopterLikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['early_adopter_id' => $fundId,'like_by' => $userId]])->first();
            
            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get isBetaDislikedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isEarlyDislikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('EarlyAdopterDislikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['early_adopter_id' => $fundId,'dislike_by' => $userId]])->first();

            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;
        }

        /********************* Endorsers *********************/

        /* * * * * 
        *
        *
        *  Get getBetaLikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getEndorserLikeCount($fundId=null)
        {

            $FundLikes = TableRegistry::get('EndorsorLikes');
            $likelists= $FundLikes->find('all',['conditions'=>['endorsor_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }
            return $TotalItems;
        }

        /* * * * * 
        *
        *
        *  Get getBetaDislikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getEndorserDislikeCount($fundId=null)
        {

            $FundDislikes = TableRegistry::get('EndorsorDislikes');
            $likelists= $FundDislikes->find('all',['conditions'=>['endorsor_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get isBetaLikedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isEndorserLikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('EndorsorLikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['endorsor_id' => $fundId,'like_by' => $userId]])->first();
            
            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get isBetaDislikedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isEndorserDislikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('EndorsorDislikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['endorsor_id' => $fundId,'dislike_by' => $userId]])->first();

            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;
        }



        /********************* Focus Groups *********************/

        /* * * * * 
        *
        *
        *  Get getBetaLikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getFocusLikeCount($fundId=null)
        {

            $FundLikes = TableRegistry::get('FocusGroupLikes');
            $likelists= $FundLikes->find('all',['conditions'=>['focus_group_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }
            return $TotalItems;
        }

        /* * * * * 
        *
        *
        *  Get getBetaDislikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getFocusDislikeCount($fundId=null)
        {

            $FundDislikes = TableRegistry::get('FocusGroupDislikes');
            $likelists= $FundDislikes->find('all',['conditions'=>['focus_group_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get isBetaLikedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isFocusLikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('FocusGroupLikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['focus_group_id' => $fundId,'like_by' => $userId]])->first();
            
            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get isBetaDislikedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isFocusDislikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('FocusGroupDislikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['focus_group_id' => $fundId,'dislike_by' => $userId]])->first();

            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;
        }

        /********************* Audio & Video *********************/
        /* * * * * 
        *
        *
        *  Get getFundLikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getAudioLikeCount($fundId=null)
        {

            $FundLikes = TableRegistry::get('AudioLikes');
            $likelists= $FundLikes->find('all',['conditions'=>['audio_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }
            return $TotalItems;
        }

        /* * * * * 
        *
        *
        *  Get getFundDislikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getAudioDislikeCount($fundId=null)
        {

            $FundDislikes = TableRegistry::get('AudioDislikes');
            $likelists= $FundDislikes->find('all',['conditions'=>['audio_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get getFundFollowedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isAudioLikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('AudioLikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['audio_id' => $fundId,'like_by' => $userId]])->first();
            
            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get getFundFollowedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isAudioDislikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('AudioDislikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['audio_id' => $fundId,'dislike_by' => $userId]])->first();

            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;
        }


        /********************* Softwares *********************/
        /* * * * * 
        *
        *
        *  Get getFundLikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getSoftwareLikeCount($fundId=null)
        {

            $FundLikes = TableRegistry::get('SoftwareLikes');
            $likelists= $FundLikes->find('all',['conditions'=>['software_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }
            return $TotalItems;
        }

        /* * * * * 
        *
        *
        *  Get getFundDislikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getSoftwareDislikeCount($fundId=null)
        {

            $FundDislikes = TableRegistry::get('SoftwareDislikes');
            $likelists= $FundDislikes->find('all',['conditions'=>['software_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get getFundFollowedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isSoftwareLikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('SoftwareLikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['software_id' => $fundId,'like_by' => $userId]])->first();
            
            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get getFundFollowedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isSoftwareDislikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('SoftwareDislikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['software_id' => $fundId,'dislike_by' => $userId]])->first();

            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;
        }


        /********************* Services *********************/
        /* * * * * 
        *
        *
        *  Get getFundLikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getServiceLikeCount($fundId=null)
        {

            $FundLikes = TableRegistry::get('ServiceLikes');
            $likelists= $FundLikes->find('all',['conditions'=>['service_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }
            return $TotalItems;
        }

        /* * * * * 
        *
        *
        *  Get getFundDislikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getServiceDislikeCount($fundId=null)
        {

            $FundDislikes = TableRegistry::get('ServiceDislikes');
            $likelists= $FundDislikes->find('all',['conditions'=>['service_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get getFundFollowedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isServiceLikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('ServiceLikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['service_id' => $fundId,'like_by' => $userId]])->first();
            
            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get getFundFollowedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isServiceDislikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('ServiceDislikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['service_id' => $fundId,'dislike_by' => $userId]])->first();

            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;
        }


        /********************* Information *********************/
        /* * * * * 
        *
        *
        *  Get getFundLikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getInformationLikeCount($fundId=null)
        {

            $FundLikes = TableRegistry::get('InformationLikes');
            $likelists= $FundLikes->find('all',['conditions'=>['information_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }
            return $TotalItems;
        }

        /* * * * * 
        *
        *
        *  Get getFundDislikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getInformationDislikeCount($fundId=null)
        {

            $FundDislikes = TableRegistry::get('InformationDislikes');
            $likelists= $FundDislikes->find('all',['conditions'=>['information_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get getFundFollowedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isInformationLikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('InformationLikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['information_id' => $fundId,'like_by' => $userId]])->first();
            
            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get getFundFollowedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isInformationDislikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('InformationDislikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['information_id' => $fundId,'dislike_by' => $userId]])->first();

            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;
        }



        /********************* Productivity *********************/
        /* * * * * 
        *
        *
        *  Get getFundLikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getProductivityLikeCount($fundId=null)
        {

            $FundLikes = TableRegistry::get('ProductivityLikes');
            $likelists= $FundLikes->find('all',['conditions'=>['productivity_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }
            return $TotalItems;
        }

        /* * * * * 
        *
        *
        *  Get getFundDislikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getProductivityDislikeCount($fundId=null)
        {

            $FundDislikes = TableRegistry::get('ProductivityDislikes');
            $likelists= $FundDislikes->find('all',['conditions'=>['productivity_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get getFundFollowedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isProductivityLikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('ProductivityLikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['productivity_id' => $fundId,'like_by' => $userId]])->first();
            
            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get getFundFollowedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isProductivityDislikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('ProductivityDislikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['productivity_id' => $fundId,'dislike_by' => $userId]])->first();

            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;

        }


        /********************* Hardware *********************/
        /* * * * * 
        *
        *
        *  Get getFundLikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getHardwareLikeCount($fundId=null)
        {

            $FundLikes = TableRegistry::get('HardwareLikes');
            $likelists= $FundLikes->find('all',['conditions'=>['hardware_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }
            return $TotalItems;
        }

        /* * * * * 
        *
        *
        *  Get getFundDislikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getHardwareDislikeCount($fundId=null)
        {

            $FundDislikes = TableRegistry::get('HardwareDislikes');
            $likelists= $FundDislikes->find('all',['conditions'=>['hardware_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get getFundFollowedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isHardwareLikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('HardwareLikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['hardware_id' => $fundId,'like_by' => $userId]])->first();
            
            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get getFundFollowedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isHardwareDislikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('HardwareDislikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['hardware_id' => $fundId,'dislike_by' => $userId]])->first();

            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;

        }


        /********************* Groups *********************/
        /* * * * * 
        *
        *
        *  Get getFundLikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getGroupLikeCount($fundId=null)
        {

            $FundLikes = TableRegistry::get('GroupLikes');
            $likelists= $FundLikes->find('all',['conditions'=>['group_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }
            return $TotalItems;
        }

        /* * * * * 
        *
        *
        *  Get getFundDislikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getGroupDislikeCount($fundId=null)
        {

            $FundDislikes = TableRegistry::get('GroupDislikes');
            $likelists= $FundDislikes->find('all',['conditions'=>['group_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get getFundFollowedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isGroupLikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('GroupLikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['group_id' => $fundId,'like_by' => $userId]])->first();
            
            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get getFundFollowedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isGroupDislikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('GroupDislikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['group_id' => $fundId,'dislike_by' => $userId]])->first();

            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;

        }



        /********************* Conferences *********************/
        /* * * * * 
        *
        *
        *  Get getFundLikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getConferenceLikeCount($fundId=null)
        {

            $FundLikes = TableRegistry::get('ConferenceLikes');
            $likelists= $FundLikes->find('all',['conditions'=>['conference_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }
            return $TotalItems;
        }

        /* * * * * 
        *
        *
        *  Get getFundDislikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getConferenceDislikeCount($fundId=null)
        {

            $FundDislikes = TableRegistry::get('ConferenceDislikes');
            $likelists= $FundDislikes->find('all',['conditions'=>['conference_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get getFundFollowedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isConferenceLikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('ConferenceLikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['conference_id' => $fundId,'like_by' => $userId]])->first();
            
            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get getFundFollowedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isConferenceDislikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('ConferenceDislikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['conference_id' => $fundId,'dislike_by' => $userId]])->first();

            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;

        }


        /********************* Demoday *********************/
        /* * * * * 
        *
        *
        *  Get getFundLikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getDemodayLikeCount($fundId=null)
        {

            $FundLikes = TableRegistry::get('DemodayLikes');
            $likelists= $FundLikes->find('all',['conditions'=>['demoday_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }
            return $TotalItems;
        }

        /* * * * * 
        *
        *
        *  Get getFundDislikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getDemodayDislikeCount($fundId=null)
        {

            $FundDislikes = TableRegistry::get('DemodayDislikes');
            $likelists= $FundDislikes->find('all',['conditions'=>['demoday_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get getFundFollowedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isDemodayLikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('DemodayLikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['demoday_id' => $fundId,'like_by' => $userId]])->first();
            
            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get getFundFollowedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isDemodayDislikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('DemodayDislikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['demoday_id' => $fundId,'dislike_by' => $userId]])->first();

            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;

        }

        /********************* Meetup *********************/
        /* * * * * 
        *
        *
        *  Get getFundLikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getMeetupLikeCount($fundId=null)
        {

            $FundLikes = TableRegistry::get('MeetupLikes');
            $likelists= $FundLikes->find('all',['conditions'=>['meetup_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }
            return $TotalItems;
        }

        /* * * * * 
        *
        *
        *  Get getFundDislikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getMeetupDislikeCount($fundId=null)
        {

            $FundDislikes = TableRegistry::get('MeetupDislikes');
            $likelists= $FundDislikes->find('all',['conditions'=>['meetup_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get getFundFollowedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isMeetupLikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('MeetupLikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['meetup_id' => $fundId,'like_by' => $userId]])->first();
            
            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get getFundFollowedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isMeetupDislikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('MeetupDislikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['meetup_id' => $fundId,'dislike_by' => $userId]])->first();

            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;

        }



        /********************* Webinar *********************/
        /* * * * * 
        *
        *
        *  Get getFundLikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getWebinarLikeCount($fundId=null)
        {

            $FundLikes = TableRegistry::get('WebinarLikes');
            $likelists= $FundLikes->find('all',['conditions'=>['webinar_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }
            return $TotalItems;
        }

        /* * * * * 
        *
        *
        *  Get getFundDislikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getWebinarDislikeCount($fundId=null)
        {

            $FundDislikes = TableRegistry::get('WebinarDislikes');
            $likelists= $FundDislikes->find('all',['conditions'=>['webinar_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get getFundFollowedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isWebinarLikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('WebinarLikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['webinar_id' => $fundId,'like_by' => $userId]])->first();
            
            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get getFundFollowedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isWebinarDislikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('WebinarDislikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['webinar_id' => $fundId,'dislike_by' => $userId]])->first();

            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;

        }


        /********************* Career *********************/
        /* * * * * 
        *
        *
        *  Get getFundLikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getCareerLikeCount($fundId=null)
        {

            $FundLikes = TableRegistry::get('CareerLikes');
            $likelists= $FundLikes->find('all',['conditions'=>['career_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }
            return $TotalItems;
        }

        /* * * * * 
        *
        *
        *  Get getFundDislikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getCareerDislikeCount($fundId=null)
        {

            $FundDislikes = TableRegistry::get('CareerDislikes');
            $likelists= $FundDislikes->find('all',['conditions'=>['career_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get getFundFollowedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isCareerLikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('CareerLikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['career_id' => $fundId,'like_by' => $userId]])->first();
            
            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get getFundFollowedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isCareerDislikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('CareerDislikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['career_id' => $fundId,'dislike_by' => $userId]])->first();

            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;

        }

        /********************* Self *********************/
        /* * * * * 
        *
        *
        *  Get getFundLikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getSelfLikeCount($fundId=null)
        {

            $FundLikes = TableRegistry::get('SelfLikes');
            $likelists= $FundLikes->find('all',['conditions'=>['self_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }
            return $TotalItems;
        }

        /* * * * * 
        *
        *
        *  Get getFundDislikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getSelfDislikeCount($fundId=null)
        {

            $FundDislikes = TableRegistry::get('SelfDislikes');
            $likelists= $FundDislikes->find('all',['conditions'=>['self_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get getFundFollowedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isSelfLikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('SelfLikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['self_id' => $fundId,'like_by' => $userId]])->first();
            
            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get getFundFollowedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isSelfDislikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('SelfDislikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['self_id' => $fundId,'dislike_by' => $userId]])->first();

            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;

        }

        /********************* GroupBuying *********************/
        /* * * * * 
        *
        *
        *  Get getFundLikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getGroupBuyingLikeCount($fundId=null)
        {

            $FundLikes = TableRegistry::get('GroupBuyingLikes');
            $likelists= $FundLikes->find('all',['conditions'=>['groupbuying_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }
            return $TotalItems;
        }

        /* * * * * 
        *
        *
        *  Get getFundDislikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getGroupBuyingDislikeCount($fundId=null)
        {

            $FundDislikes = TableRegistry::get('GroupBuyingDislikes');
            $likelists= $FundDislikes->find('all',['conditions'=>['groupbuying_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get getFundFollowedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isGroupBuyingLikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('GroupBuyingLikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['groupbuying_id' => $fundId,'like_by' => $userId]])->first();
            
            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get getFundFollowedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isGroupBuyingDislikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('GroupBuyingDislikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['groupbuying_id' => $fundId,'dislike_by' => $userId]])->first();

            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;

        }


        /********************* LaunchDeal *********************/
        /* * * * * 
        *
        *
        *  Get getFundLikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getLaunchDealLikeCount($fundId=null)
        {

            $FundLikes = TableRegistry::get('LaunchDealLikes');
            $likelists= $FundLikes->find('all',['conditions'=>['launchdeal_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }
            return $TotalItems;
        }

        /* * * * * 
        *
        *
        *  Get getFundDislikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getLaunchDealDislikeCount($fundId=null)
        {

            $FundDislikes = TableRegistry::get('LaunchDealDislikes');
            $likelists= $FundDislikes->find('all',['conditions'=>['launchdeal_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get getFundFollowedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isLaunchDealLikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('LaunchDealLikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['launchdeal_id' => $fundId,'like_by' => $userId]])->first();
            
            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get getFundFollowedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isLaunchDealDislikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('LaunchDealDislikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['launchdeal_id' => $fundId,'dislike_by' => $userId]])->first();

            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;

        }



         /********************* CommunalAsset *********************/
        /* * * * * 
        *
        *
        *  Get getFundLikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getCommunalAssetLikeCount($fundId=null)
        {

            $FundLikes = TableRegistry::get('CommunalAssetLikes');
            $likelists= $FundLikes->find('all',['conditions'=>['communalasset_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }
            return $TotalItems;
        }

        /* * * * * 
        *
        *
        *  Get getFundDislikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getCommunalAssetDislikeCount($fundId=null)
        {

            $FundDislikes = TableRegistry::get('CommunalAssetDislikes');
            $likelists= $FundDislikes->find('all',['conditions'=>['communalasset_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get getFundFollowedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isCommunalAssetLikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('CommunalAssetLikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['communalasset_id' => $fundId,'like_by' => $userId]])->first();
            
            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get getFundFollowedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isCommunalAssetDislikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('CommunalAssetDislikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['communalasset_id' => $fundId,'dislike_by' => $userId]])->first();

            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;

        }


         /********************* Consulting *********************/
        /* * * * * 
        *
        *
        *  Get getFundLikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getConsultingLikeCount($fundId=null)
        {

            $FundLikes = TableRegistry::get('ConsultingLikes');
            $likelists= $FundLikes->find('all',['conditions'=>['consulting_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }
            return $TotalItems;
        }

        /* * * * * 
        *
        *
        *  Get getFundDislikeCount Name and Id
        *
        *
        *
        * * * * */
        public function getConsultingDislikeCount($fundId=null)
        {

            $FundDislikes = TableRegistry::get('ConsultingDislikes');
            $likelists= $FundDislikes->find('all',['conditions'=>['consulting_id' => $fundId]]);

            $TotalItems= $likelists->count();
            if(empty($TotalItems)){
                $TotalItems=0;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get getFundFollowedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isConsultingLikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('ConsultingLikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['consulting_id' => $fundId,'like_by' => $userId]])->first();
            
            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get getFundFollowedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isConsultingDislikedbyUser($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('ConsultingDislikes');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['consulting_id' => $fundId,'dislike_by' => $userId]])->first();

            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;

        }

         /* * * * * 
        *
        *
        *  Get getFundFollowedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function isGetConustingWinningBidder($consulting_id=null)
        {

            $FundFollowers = TableRegistry::get('ConsultingAwards');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['consulting_id' => $consulting_id]])->first();

            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=$FundFollower->contractor_id;
            }

            return $TotalItems;

        }

         /* * * * * 
        *
        *
        *  Get getFundFollowedbyUser Name and Id
        *
        *
        *
        * * * * */
        public function checkInvitationSent($consulting_id=null,$sent_by=null,$sent_to=null)
        {

            $FundFollowers = TableRegistry::get('ConsultingInvitations');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['sent_by' =>$sent_by,'sent_to' =>$sent_to,'consulting_id' => $consulting_id]])->first();

            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;

        }






        /* * * * * 
        *
        *
        *  Get is user blocked for forum
        *
        *
        *
        * * * * */
        public function isUserBlockedForForum($fundId=null,$userId=null)
        {

            $FundFollowers = TableRegistry::get('ForumUserBlocklists');
            $FundFollower= $FundFollowers->find('all',['conditions'=>['forum_id' => $fundId,'user_id' => $userId]])->first();

            $TotalItems=0;
            if(!empty($FundFollower)){
                $TotalItems=1;
            }

            return $TotalItems;
        }


        /* * * * * 
        *
        *
        *  Get User Network detail
        *
        *
        *
        * * * * */

        public function businessNetwork($connectedTo=null,$userId=null)
        {
            $BusinessUserNetworks = TableRegistry::get('BusinessUserNetworks');
            $BusinessUserNetworkData= $BusinessUserNetworks->find('all',['conditions'=>['connected_to' => $connectedTo,'user_id'=>$userId]])->first();

            //
            $data=0;
            if(!empty($BusinessUserNetworkData)){
                $data=$BusinessUserNetworkData;

            }
            return $data;
        }

        public function businessCardData($connectedTo=null)
        {
            $BusinessUserNetworks = TableRegistry::get('BusinessCards');

            $BusinessCardsData = $BusinessUserNetworks->find('all',['conditions'=>['user_id'=>$connectedTo , 'status'=>1]])->toArray();

            //$BusinessUserNetworkData= $BusinessUserNetworks->find('all',['conditions'=>['connected_to' => $connectedTo,'user_id'=>$userId]])->first();

            //
            $data=0;

            if(!empty($BusinessCardsData)){
                $data=$BusinessCardsData;

            }

            return $data;
        }

        /* * * * * 
        *
        *
        *  Get Contractor Profile 
        *
        *
        *
        * * * * */

        public function getContractorImage($userId=null)
        {   
            //$userId="288";
            $ContractorBasics = TableRegistry::get('ContractorBasics');
            $ContractorBasicsData= $ContractorBasics->find('all',['conditions'=>['user_id' =>$userId]])->first();;

            //
            $data=0;

            if(!empty($ContractorBasicsData)){
                $data=$ContractorBasicsData;

            }
            return $data;
        }

        public function checkUserandMeetupGroup($userId=null,$connectedId = null)
        {   
            //$userId="288";
            $ContractorBasics = TableRegistry::get('BusinessUserNetworks');
            $userConnData= $ContractorBasics->find('all',['conditions'=>
                                    [ 'OR'=>[    
                                                ['user_id'=>$connectedId,
                                                 'connected_to' =>$userId
                                                ],
                                                ['user_id'=>$userId,
                                                 'connected_to'=>$connectedId
                                                ]
                                            ]
                                    ]
                                ])->first();

            //
            $data=0;

            if(!empty($userConnData)){
                $data=$userConnData;

            }
            return $data;
        }


        public function checkUserandMeetupConnection($userId=null,$connectedId = null)
        {   
            //$userId="288";
            $ContractorBasics = TableRegistry::get('UserConnections');
            $userConnections= $ContractorBasics->find('all',['conditions'=>
                                                ['status'=>1,
                                                    'OR'=>[  
                                                                ['connection_to'=>$connectedId,
                                                                 'connection_by' =>$userId
                                                                ],
                                                                ['connection_to'=>$userId,
                                                                 'connection_by'=>$connectedId
                                                                ]
                                                            ]   
                                                ]
                                        ])->first();

            //
            $data=0;

            if(!empty($userConnections)){
                $data=$userConnections;

            }
            return $data;
        }


    function getConnectionTypeById($user_id,$typeId)
    {
        $businessUserConnTable = TableRegistry::get('BusinessUserConnectionTypes');
        $businessConnectionData = $businessUserConnTable->find('all',['conditions'=>['user_id'=>$user_id]])->toArray();

        
        if(!empty($businessConnectionData)){

            $result = json_decode($businessConnectionData[0]->data);
            
            foreach ($result as $conn) {
                 $finalArray[$conn->id] = $conn->name;
            }
            
        }else{ 

            $businessConnectionTable = TableRegistry::get('BusinessConnectionTypes');
            $finalArray = $businessConnectionTable->find('list')->toArray();
        }

        if(!empty($typeId)){
            return $finalArray[$typeId];
        }else{
            return '';
        }
    }


    function getStartupProfile($id)
    {
        $StartupProfilesTable = TableRegistry::get('StartupProfiles');
        $StartupProfilesTableData = $StartupProfilesTable->find('all',['conditions'=>['startup_id'=>$id]])->first();
        if(!empty($StartupProfilesTableData)){
            $filepath = $StartupProfilesTableData->file_path;
        }else{
            $filepath ='';
        }

        return $filepath;
    }

}//EOC

?>
