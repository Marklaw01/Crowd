<?php
namespace App\Controller\Component;

use Cake\Controller\Component;
use Cake\Controller\ComponentRegistry;
use Cake\Network\Exception\InternalErrorException;
use Cake\Utility\Text;
use Cake\ORM\TableRegistry;

class FundsUploadComponent extends Component
{

		
		/*
	     *  fundsManagerLists method for unfollowJob job
	     *
	     *
	     *
	     *
	     ***/
	    public function fundsManagerLists($id=null)
	    {

	    		$UserId=$id;
	    		$Users = TableRegistry::get('Users');
	    		//$Usrlists = $Users->find('all',['conditions'=>['id != '=>$UserId]]);
	    		$Usrlists = $Users->find('all');
	    		
	    		$TotalItems= $Usrlists->count();

	    		if(!empty($TotalItems)){
	    			
	    			foreach ($Usrlists as $key => $value) {

	                    //$keys['id']= $value->id;
						//$keys['name']= $value->first_name.' '.$value->last_name;

						$finalConnections[$value->id] = $value->first_name.' '.$value->last_name;
					}
	    		}else{
	            	$finalConnections=[];
	            }

	            return $finalConnections;
	    }

		/* * * *
		*
		*
		*  Get Funds Manger Name and Id
		*
		*
		*
		* * * */
		public function fundManagers($keyword_ids=null)
		{

			$JobPostingKeywords = TableRegistry::get('Users');
		
			$keywordsValue = [];
			
			$keywordsArray = explode(',',$keyword_ids);
			 
			$keywordsValue = $JobPostingKeywords->find('all',['conditions'=>['id IN'=>$keywordsArray]])->toArray();
							
			if(!empty($keywordsValue)):
										
				foreach($keywordsValue as $key=>$value){
					$key1=[];
					$key1['id'] = $value->id;
					$key1['name'] = $value->first_name.' '.$value->last_name;
							 
					$keys[] = $key1;			 
				}	 
				
			else :
				$keys=[];
			endif;	
									
			return $keys;
		}


		/*
	     *  fundPortfolioList method for unfollowJob job
	     *
	     *
	     *
	     *
	     ***/
	    public function fundPortfolioList($id=null)
	    {
	            $UserId=$id;
	    		$Startups = TableRegistry::get('Startups');
	    		$fundss = TableRegistry::get('Funds');

        		//$PortfolioLists = $Startups->find('all',['conditions'=>['user_id != '=>$UserId]]);
        		$PortfolioLists = $Startups->find('all');

        		$TotalItems= $PortfolioLists->count();

        		if(!empty($TotalItems)){

        			foreach ($PortfolioLists as $key => $value) {

		                    $keys['startup_id']= $value->id;
							$keys['startup_name']= $value->name;

							$finalConnections[$value->id] = $value->name;
					}

        		}else{
	            	$finalConnections=[];
	            }

	            return $finalConnections;
	    }


	    /*
	     *  fundPortfolioList method for unfollowJob job
	     *
	     *
	     *
	     *
	     ***/
	    public function fundAddPortfolioList($id=null)
	    {
	            $UserId=$id;
	    		$Startups = TableRegistry::get('Startups');
	    		$fundss = TableRegistry::get('Funds');

        		//$PortfolioLists = $Startups->find('all',['conditions'=>['user_id != '=>$UserId]]);
        		$PortfolioLists = $Startups->find('all',['conditions'=>['status'=>1]]);

        		$TotalItems= $PortfolioLists->count();

        		if(!empty($TotalItems)){
        			$customCount=0;
        			foreach ($PortfolioLists as $key => $value) {

        				$isFunded= $fundss->find('all',['conditions'=>["FIND_IN_SET($value->id,Funds.portfolios_id)"]])->first();
        				if(empty($isFunded)){
        					$customCount++;
		                    $keys['startup_id']= $value->id;
							$keys['startup_name']= $value->name;

							$finalConnections[$value->id] = $value->name;
						}
					}

					if(empty($customCount)){
						$finalConnections=[];
					}

        		}else{
	            	$finalConnections=[];
	            }

	            return $finalConnections;
	    }


	    /*
	     *  fundEditPortfolioList method for unfollowJob job
	     *
	     *
	     *
	     *
	     ***/
	    public function fundEditPortfolioList($id=null,$portfolio_id=null)
	    {
	            $UserId=$id;
	    		$Startups = TableRegistry::get('Startups');
	    		$fundss = TableRegistry::get('Funds');

	    		$portfolio_idArray= explode(',', $portfolio_id);

        		//$PortfolioLists = $Startups->find('all',['conditions'=>['user_id != '=>$UserId]]);
        		$PortfolioLists = $Startups->find('all',['conditions'=>['status'=>1]]);

        		$TotalItems= $PortfolioLists->count();

        		if(!empty($TotalItems)){
        			$customCount=0;
        			foreach ($PortfolioLists as $key => $value) {

        				if (!in_array($value->id, $portfolio_idArray)) {
						    $isFunded= $fundss->find('all',['conditions'=>["FIND_IN_SET($value->id,Funds.portfolios_id)"]])->first();
						}else{
							$isFunded='';
						}
        				
        				if(empty($isFunded)){
        					$customCount++;
		                    $keys['startup_id']= $value->id;
							$keys['startup_name']= $value->name;

							$finalConnections[$value->id] = $value->name;
						}
					}

					if(empty($customCount)){
						$finalConnections=[];
					}
					
        		}else{
	            	$finalConnections=[];
	            }

	            return $finalConnections;
	    }

		/* * * * * 
		*
		*
		*  Get fundPortfolio Name and Id
		*
		*
		*
		* * * * */
		public function fundPortfolio($keyword_ids=null)
		{
			$JobPostingKeywords = TableRegistry::get('Startups');
		
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



		/*
	     *  sponsorsList method for unfollowJob job
	     *
	     *
	     *
	     *
	     ***/
	    public function sponsorsList($id=null)
	    {
	            $UserId=$id;
	    		$SubAdminDetails = TableRegistry::get('SubAdminDetails');

        		//$Sponsors = $SubAdminDetails->find('all',['conditions'=>['user_id != '=>$UserId]]);
        		$Sponsors = $SubAdminDetails->find('all');
        		$TotalItems= $Sponsors->count();

        		if(!empty($TotalItems)){
        			
        			foreach ($Sponsors as $key => $value) {

	                    //$keys['id']= $value->id;
						//$keys['company_name']= $value->company_name;

						$finalConnections[$value->id] = $value->company_name;
					}

        		}else{

	            	$finalConnections=[];
	            }

	            return $finalConnections;

	    }
		/* * * * * 
		*
		*
		*  Get fundSponsors Name and Id
		*
		*
		*
		* * * * */
		public function fundSponsors($keyword_ids=null)
		{
			$JobPostingKeywords = TableRegistry::get('SubAdminDetails');
		
			$keywordsValue = [];
			
			$keywordsArray = explode(',',$keyword_ids);
			 
			$keywordsValue = $JobPostingKeywords->find('all',['conditions'=>['id IN'=>$keywordsArray]])
										->toArray();
			if(!empty($keywordsValue)):
										
				foreach($keywordsValue as $key=>$value){
					$key1=[];
					$key1['id'] = $value->id;
					$key1['name'] = $value->company_name;
							 
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
		*  Get fundIndustriesList Name and Id
		*
		*
		*
		* * * * */
		public function fundIndustriesList($keyword_ids=null)
		{
			$JobPostingKeywords = TableRegistry::get('FundIndustries');
		
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
		*  Get fundKeywords Name and Id
		*
		*
		*
		* * * * */
		public function fundKeywords($keyword_ids=null)
		{
			$JobPostingKeywords = TableRegistry::get('KeywordFunds');
		
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

		/* * * * * 
		*
		*
		*  Get getFundFollowedbyUser Name and Id
		*
		*
		*
		* * * * */
		public function isFundFollowedbyUser($fundId=null,$userId=null)
		{

			$FundFollowers = TableRegistry::get('FundFollowers');
			$FundFollower= $FundFollowers->find('all',['conditions'=>['fund_id' => $fundId,'user_id' => $userId]])->first();

	        $TotalItems=0;
	        if(!empty($FundFollower)){
	        	$TotalItems=1;
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
	   
	    public function uploadFundImage($files = null) 
	    {
    	
		    if(!empty($files)){
                //$valid_formats = array('doc','pdf','docx','srs','ppt','DOC','PDF','DOCX','SRS','PPT');
                $valid_formats = array('png','gif','jpg','jpeg','PNG','GIF','JPG','JPEG');
                //$max_file_size = 1024*100; //100 kb
                //$max_file_size = 5*1024*1024; //5MB
                $max_file_size = 2097152; //2MB
                $path = WWW_ROOT . "img/funds/"; // Upload directory
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
	   
	    public function uploadFundDoc($files = null) 
	    {
    	
		    if(!empty($files)){
                //$valid_formats = array('doc','pdf','docx','srs','ppt','DOC','PDF','DOCX','SRS','PPT');
                $valid_formats = array('png','gif','jpg','jpeg','PNG','GIF','JPG','JPEG');
                //$max_file_size = 1024*100; //100 kb
                $max_file_size = 5*1024*1024; //5MB
                //$max_file_size = 2097152; //2MB
                $max_file_size = 20971520; //20MB
                $path = WWW_ROOT . "img/funds/"; // Upload directory
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
	   
	    public function uploadFundAudio($files = null) 
	    {
    	
		    if(!empty($files)){
                //$valid_formats = array('doc','pdf','docx','srs','ppt','DOC','PDF','DOCX','SRS','PPT');
                $valid_formats = array('mp3');
                //$max_file_size = 1024*100; //100 kb
                $max_file_size = 5*1024*1024; //5MB
                //$max_file_size = 2097152; //2MB
                $max_file_size = 20971520; //20MB
                $path = WWW_ROOT . "img/funds/"; // Upload directory
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
	   
	    public function uploadFundVideo($files = null) 
	    {
    	
		    if(!empty($files)){
                //$valid_formats = array('doc','pdf','docx','srs','ppt','DOC','PDF','DOCX','SRS','PPT');
                $valid_formats = array('mp4');
                //$max_file_size = 1024*100; //100 kb
                $max_file_size = 5*1024*1024; //5MB
                //$max_file_size = 2097152; //2MB
                $max_file_size = 20971520; //20MB
                $path = WWW_ROOT . "img/funds/"; // Upload directory
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