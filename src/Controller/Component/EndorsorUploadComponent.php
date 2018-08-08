<?php
namespace App\Controller\Component;

use Cake\Controller\Component;
use Cake\Controller\ComponentRegistry;
use Cake\Network\Exception\InternalErrorException;
use Cake\Utility\Text;
use Cake\ORM\TableRegistry;

class EndorsorUploadComponent extends Component
{

		/* * * * * 
		*
		*
		*  Get interestKeywordList Name and Id
		*
		*
		*
		* * * * */
		public function interestKeywordList($keyword_ids=null)
		{
			$JobPostingKeywords = TableRegistry::get('EndorsorInterestKeywords');
		
			$keywordsValue = [];
			
			$keywordsArray = explode(',',$keyword_ids);
			 
			$keywordsValue = $JobPostingKeywords->find('all',['conditions'=>['id IN'=>$keywordsArray]])
										->toArray();
			if(!empty($keywordsValue)):
										
				foreach($keywordsValue as $key=>$value){
					$key1=[];
					$key1['id'] = $value->id;
					$key1['name'] = $value->name;
							 
					$keys[] = $key1;			 
				}	 
				
			else :
				$keys=[];
			endif;	
									
			return $keys;
		}



		/* * * * * 
		*
		*
		*  Get keywordList Name and Id
		*
		*
		*
		* * * * */
		public function keywordList($keyword_ids=null)
		{
			$JobPostingKeywords = TableRegistry::get('EndorsorKeywords');
		
			$keywordsValue = [];
			
			$keywordsArray = explode(',',$keyword_ids);
			 
			$keywordsValue = $JobPostingKeywords->find('all',['conditions'=>['id IN'=>$keywordsArray]])
										->toArray();
			if(!empty($keywordsValue)):
										
				foreach($keywordsValue as $key=>$value){
					$key1=[];
					$key1['id'] = $value->id;
					$key1['name'] = $value->name;
							 
					$keys[] = $key1;			 
				}	 
				
			else :
				$keys=[];
			endif;	
									
			return $keys;
		}

		/* * * * * 
		*
		*
		*  Get targetMarketList Name and Id
		*
		*
		*
		* * * * */
		public function targetMarketList($keyword_ids=null)
		{
			$JobPostingKeywords = TableRegistry::get('EndorsorTargetMarkets');
		
			$keywordsValue = [];
			
			$keywordsArray = explode(',',$keyword_ids);
			 
			$keywordsValue = $JobPostingKeywords->find('all',['conditions'=>['id IN'=>$keywordsArray]])
										->toArray();
			if(!empty($keywordsValue)):
										
				foreach($keywordsValue as $key=>$value){
					$key1=[];
					$key1['id'] = $value->id;
					$key1['name'] = $value->name;
							 
					$keys[] = $key1;			 
				}	 
				
			else :
				$keys=[];
			endif;	
									
			return $keys;
		}

		/* * * * * 
		*
		*
		*  Get getLikeCount Name and Id
		*
		*
		*
		* * * * */
		public function getLikeCount($fundId=null)
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
		*  Get getDislikeCount Name and Id
		*
		*
		*
		* * * * */
		public function getDislikeCount($fundId=null)
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
		*  Get isLikedbyUser Name and Id
		*
		*
		*
		* * * * */
		public function isLikedbyUser($fundId=null,$userId=null)
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
		*  Get isDislikedbyUser Name and Id
		*
		*
		*
		* * * * */
		public function isDislikedbyUser($fundId=null,$userId=null)
		{

			$FundFollowers = TableRegistry::get('EndorsorDislikes');
			$FundFollower= $FundFollowers->find('all',['conditions'=>['endorsor_id' => $fundId,'dislike_by' => $userId]])->first();

	        $TotalItems=0;
	        if(!empty($FundFollower)){
	        	$TotalItems=1;
	        }

	        return $TotalItems;
		}

		/* * * * * 
		*
		*
		*  Get isFollowedbyUser Name and Id
		*
		*
		*
		* * * * */
		public function isFollowedbyUser($fundId=null,$userId=null)
		{

			$FundFollowers = TableRegistry::get('EndorsorFollowers');
			$FundFollower= $FundFollowers->find('all',['conditions'=>['endorsor_id' => $fundId,'user_id' => $userId]])->first();

	        $TotalItems=0;
	        if(!empty($FundFollower)){
	        	$TotalItems=1;
	        }

	        return $TotalItems;
		}

		/* * * * * 
		*
		*
		*  Get isCommitedbyUser Name and Id
		*
		*
		*
		* * * * */
		public function isCommitedbyUser($fundId=null,$userId=null)
		{

			$FundFollowers = TableRegistry::get('EndorsorCommitments');
			$FundFollower= $FundFollowers->find('all',['conditions'=>['endorsor_id' => $fundId,'user_id' => $userId]])->first();

	        $TotalItems=0;
	        if(!empty($FundFollower)){
	        	$TotalItems=1;
	        }

	        return $TotalItems;
		}


		/* * * * * 
		*
		*
		*  Get getCommitCount Name and Id
		*
		*
		*
		* * * * */
		public function getCommitCount($fundId=null)
		{

			$FundDislikes = TableRegistry::get('EndorsorCommitments');
			$likelists= $FundDislikes->find('all',['conditions'=>['endorsor_id' => $fundId]]);

	        $TotalItems= $likelists->count();
	        if(empty($TotalItems)){
	        	$TotalItems=0;
	        }

	        return $TotalItems;
		}


		/****
		*
	    *  uploadFundImage
	    *
	    *
	    *
	    ****/
	   
	    public function uploadImage($files = null) 
	    {
    	
		    if(!empty($files)){
                //$valid_formats = array('doc','pdf','docx','srs','ppt','DOC','PDF','DOCX','SRS','PPT');
                $valid_formats = array('png','gif','jpg','jpeg','PNG','GIF','JPG','JPEG');
                //$max_file_size = 1024*100; //100 kb
                //$max_file_size = 5*1024*1024; //5MB
                $max_file_size = 2097152; //2MB
                $path = WWW_ROOT . "img/endorsor/"; // Upload directory
                $imgCamp='';
                $errors='';

                if ($files['error'] == 0) {              
                        if ($files['size'] > $max_file_size) {
                            $errors = $files['name']." is too large! Max allowed size is 2MB.";
                            //continue; // Skip large files
                           
                        }
                        elseif(!in_array(pathinfo($files['name'], PATHINFO_EXTENSION), $valid_formats) ){
                            $errors = $files['name']." is not a valid format, Allowed format are PNG,GIF,JPEG,JPG.";
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


		/****
		*
	    *  uploadFundDoc
	    *
	    *
	    *
	    ****/
	   
	    public function uploadDoc($files = null) 
	    {
    	
		    if(!empty($files)){
                //$valid_formats = array('doc','pdf','docx','srs','ppt','DOC','PDF','DOCX','SRS','PPT');
                $valid_formats = array('png','gif','jpg','jpeg','PNG','GIF','JPG','JPEG');
                //$max_file_size = 1024*100; //100 kb
                $max_file_size = 5*1024*1024; //5MB
                //$max_file_size = 2097152; //2MB
                $max_file_size = 20971520; //20MB
                $path = WWW_ROOT . "img/endorsor/"; // Upload directory
                $imgCamp='';
                $errors='';

                if ($files['error'] == 0) {              
                        if ($files['size'] > $max_file_size) {
                            //$errors = $files['name']." is too large! Max allowed size is 2MB.";
                            $errors = 'You can only upload the following file types .mp3, mp4 and .pdf. The maximum size for each file is 20 MB.';
                            //continue; // Skip large files
                           
                        }
                        elseif(in_array(pathinfo($files['name'], PATHINFO_EXTENSION), $valid_formats) ){
                            $errors = $files['name']." is not a valid format, Allowed format are DOC,PDF,DOCX,SRS,XLS,VISIO.";
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

		/****
		*
	    *  uploadFundDoc
	    *
	    *
	    *
	    ****/
	   
	    public function uploadAudio($files = null) 
	    {
    	
		    if(!empty($files)){
                //$valid_formats = array('doc','pdf','docx','srs','ppt','DOC','PDF','DOCX','SRS','PPT');
                $valid_formats = array('mp3');
                //$max_file_size = 1024*100; //100 kb
                $max_file_size = 5*1024*1024; //5MB
                //$max_file_size = 2097152; //2MB
                $max_file_size = 20971520; //20MB
                $path = WWW_ROOT . "img/endorsor/"; // Upload directory
                $imgCamp='';
                $errors='';

                if ($files['error'] == 0) {              
                        if ($files['size'] > $max_file_size) {
                            //$errors = $files['name']." is too large! Max allowed size is 5MB.";
                            $errors = 'You can only upload the following file types .mp3, mp4 and .pdf. The maximum size for each file is 20 MB.';
                            //continue; // Skip large files
                           
                        }
                        elseif(!in_array(pathinfo($files['name'], PATHINFO_EXTENSION), $valid_formats) ){
                            $errors = $files['name']." is not a valid format, Allowed format are MP3.";
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

		/****
		*
	    *  uploadFundDoc
	    *
	    *
	    *
	    ****/
	   
	    public function uploadVideo($files = null) 
	    {
    	
		    if(!empty($files)){
                //$valid_formats = array('doc','pdf','docx','srs','ppt','DOC','PDF','DOCX','SRS','PPT');
                $valid_formats = array('mp4');
                //$max_file_size = 1024*100; //100 kb
                $max_file_size = 5*1024*1024; //5MB
                //$max_file_size = 2097152; //2MB
                $max_file_size = 20971520; //20MB
                $path = WWW_ROOT . "img/endorsor/"; // Upload directory
                $imgCamp='';
                $errors='';

                if ($files['error'] == 0) {              
                        if ($files['size'] > $max_file_size) {
                            //$errors = $files['name']." is too large! Max allowed size is 5MB.";
                            $errors = 'You can only upload the following file types .mp3, mp4 and .pdf. The maximum size for each file is 20 MB.';
                            //continue; // Skip large files
                           
                        }
                        elseif(!in_array(pathinfo($files['name'], PATHINFO_EXTENSION), $valid_formats) ){
                            $errors = $files['name']." is not a valid format, Allowed format are MP4.";
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