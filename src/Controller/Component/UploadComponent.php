<?php
namespace App\Controller\Component;

use Cake\Controller\Component;
use Cake\Controller\ComponentRegistry;
use Cake\Network\Exception\InternalErrorException;
use Cake\Utility\Text;

class UploadComponent extends Component
{
    public function Upload($data = null)
    {
    	
    if(!empty($data)){
    	   
       if ($data['error']==0){
                
       	        $file = $data;
                $filename = $data['name']; //put the data into a var for easy use
            
                $ext = pathinfo($filename, PATHINFO_EXTENSION); //get the extension
                $ext = strtolower($ext);
                $arr_ext = array('doc','pdf','docx','srs'); //set allowed extensions
                $image_ext = array('jpg', 'jpeg', 'gif','png');//set allowed image extension
				$audio_ext = array('mp3');//set allowed audio extension
				$video_ext = array('mp4');//set allowed audio extension
				$docs_ext = array('ppt','docx','doc','pdf');//set allowed video extension
                $setNewFileName = time() . "_" . rand(000000, 999999);
                
                //only process if the extension is valid
               // if (in_array($ext, $arr_ext) && (!empty($data['module_type'])=='startup')) {
                 if (in_array($ext, $arr_ext) && ($data['module_type']=='startup')) {
                    //do the actual uploading of the file. First arg is the tmp name, second arg is 
                    //where we are putting it
                   if(move_uploaded_file($file['tmp_name'], WWW_ROOT . 'img/doc/' . $setNewFileName . '.' . $ext)){
                      
                      $new_file_name = $setNewFileName . '.' . $ext;
                       //giving the permission to the newly uploaded file
                      chmod('img/doc/'.$new_file_name, 0777);
                       //prepare the filename for database entry 
                        $data  = $new_file_name;
                      
                       // pr($data);die;
                      return $data;
                    }
                    else{

                             return 0;
                             //throw new InternalErrorException("Please Upload a valid doc");
                               //return $this->redirect(['controller'=>'Startups','action'=>'StartupDocs');
                        }
                }
                elseif (in_array($ext, $image_ext) && ($data['module_type']=='profile_pic')) {
                    //do the actual uploading of the file. First arg is the tmp name, second arg is 
                    //where we are putting it
                    if(move_uploaded_file($file['tmp_name'], WWW_ROOT . 'img/profile_pic/' . $setNewFileName . '.' . $ext)){
                      
                      $new_file_name = $setNewFileName . '.' . $ext;
                       //giving the permission to the newly uploaded file
                      chmod('img/profile_pic/' . $new_file_name, 0777);
                       //prepare the filename for database entry 
                        $data  = $new_file_name;
                    
                        //pr($data);die;
                      return $data;
                     
                    }
                    else{
                             return 0;
                             //throw new InternalErrorException("Please Upload a valid Image", 1);
                               //return $this->redirect(['controller'=>'Startups','action'=>'StartupDocs');
                        }
						
                }
				elseif ( in_array($ext, $image_ext) && ($data['module_type']=='sliderimages') ){
                    
				    //do the actual uploading of the file. First arg is the tmp name, second arg is 
                    //where we are putting it
					
						if(move_uploaded_file($file['tmp_name'], WWW_ROOT . 'img/sliderimages/' . $setNewFileName . '.' . $ext)){
						  
						  $new_file_name = $setNewFileName . '.' . $ext;
						   //giving the permission to the newly uploaded file
						  chmod('img/sliderimages/' . $new_file_name, 0777);
						   //prepare the filename for database entry 
							$data  = $new_file_name;
						
							//pr($data);die;
						  return $data;
						 
						}
						else{
								 return 0;
								 //throw new InternalErrorException("Please Upload a valid Image", 1);
								   //return $this->redirect(['controller'=>'Startups','action'=>'StartupDocs');
							}
                }
				elseif ( in_array($ext, $audio_ext) && ($data['module_type']=='subadmin_audio') ){
                     
				    //do the actual uploading of the file. First arg is the tmp name, second arg is 
                    //where we are putting it
						
						if(move_uploaded_file($file['tmp_name'], WWW_ROOT . 'img/subadmin_audio/' . $setNewFileName . '.' . $ext)){
						  
						  $new_file_name = $setNewFileName . '.' . $ext;
						   //giving the permission to the newly uploaded file
						  chmod('img/subadmin_audio/' . $new_file_name, 0777);
						   //prepare the filename for database entry 
							$data  = $new_file_name;
						
							//pr($data);die;
						  return $data;
						 
						}
						else{
								 return 0;
								 //throw new InternalErrorException("Please Upload a valid Image", 1);
								   //return $this->redirect(['controller'=>'Startups','action'=>'StartupDocs');
							}
                }
				elseif ( in_array($ext, $video_ext) && ($data['module_type']=='subadmin_video') ){
                    
				    //do the actual uploading of the file. First arg is the tmp name, second arg is 
                    //where we are putting it
					
						if(move_uploaded_file($file['tmp_name'], WWW_ROOT . 'img/subadmin_video/' . $setNewFileName . '.' . $ext)){
						  
						  $new_file_name = $setNewFileName . '.' . $ext;
						   //giving the permission to the newly uploaded file
						  chmod('img/subadmin_video/' . $new_file_name, 0777);
						   //prepare the filename for database entry 
							$data  = $new_file_name;
						
							//pr($data);die;
						  return $data;
						 
						}
						else{
								 return 0;
								 //throw new InternalErrorException("Please Upload a valid Image", 1);
								   //return $this->redirect(['controller'=>'Startups','action'=>'StartupDocs');
							}
                }
				elseif ( in_array($ext, $docs_ext) && ($data['module_type']=='subadmin_docs') ){
                    
				    //do the actual uploading of the file. First arg is the tmp name, second arg is 
                    //where we are putting it
					
						if(move_uploaded_file($file['tmp_name'], WWW_ROOT . 'img/subadmin_docs/' . $setNewFileName . '.' . $ext)){
						  
						  $new_file_name = $setNewFileName . '.' . $ext;
						   //giving the permission to the newly uploaded file
						  chmod('img/subadmin_docs/' . $new_file_name, 0777);
						   //prepare the filename for database entry 
							$data  = $new_file_name;
						
							//pr($data);die;
						  return $data;
						 
						}
						else{
								 return 0;
								 //throw new InternalErrorException("Please Upload a valid Image", 1);
								   //return $this->redirect(['controller'=>'Startups','action'=>'StartupDocs');
							}
                }
				elseif ( in_array($ext, $image_ext) && ($data['module_type']=='subadmin_profile_image') ){
                    
				    //do the actual uploading of the file. First arg is the tmp name, second arg is 
                    //where we are putting it
					
						if(move_uploaded_file($file['tmp_name'], WWW_ROOT . 'img/subadmin_profile_image/' . $setNewFileName . '.' . $ext)){
						  
						  $new_file_name = $setNewFileName . '.' . $ext;
						   //giving the permission to the newly uploaded file
						  chmod('img/subadmin_profile_image/' . $new_file_name, 0777);
						   //prepare the filename for database entry 
							$data  = $new_file_name;
						
							//pr($data);die;
						  return $data;
						 
						}
						else{
								 return 0;
								 //throw new InternalErrorException("Please Upload a valid Image", 1);
								   //return $this->redirect(['controller'=>'Startups','action'=>'StartupDocs');
							}
                }
                else{
                          return 0;
                          //throw new InternalErrorException("Error processing Request", 1);
                    }
                
                }
                
    }
	}
       /*
	    *
	    *upload a file thorugh Api
	    *
	    */
	   
	       public function UploadApi($data = null) {
    	
    if(!empty($data)){
    	   
       if ($data['error']==0){
                
       	        $file = $data;
                $filename = $data['name']; //put the data into a var for easy use
            
             $ext = pathinfo($filename, PATHINFO_EXTENSION);//get the extension
                
                $arr_ext = array('doc','pdf','docx','srs'); //set allowed extensions
                $image_ext = array('jpg', 'jpeg', 'gif','png');//set allowed image extension
                $setNewFileName = time() . "_" . rand(000000, 999999);
                              
                //only process if the extension is valid
                if (in_array($ext, $arr_ext) && (!empty($data['module_type'])=='startup')) {
                 
                    //do the actual uploading of the file. First arg is the tmp name, second arg is 
                    //where we are putting it
                   if(move_uploaded_file($file['tmp_name'], WWW_ROOT . 'img/doc/' . $setNewFileName . '.' . $ext)){
                      
                      $new_file_name = $setNewFileName . '.' . $ext;
                       //giving the permission to the newly uploaded file
                      chmod('img/doc/'.$new_file_name, 0777);
                       //prepare the filename for database entry 
                        $data  = $new_file_name;
                     
                       // pr($data);die;
                      return $data;
                    }
                    else{

                             throw new InternalErrorException("Please Upload a valid doc");
                               //return $this->redirect(['controller'=>'Startups','action'=>'StartupDocs');
                        }
                }
                elseif (in_array($ext, $image_ext) && (!empty($data['module_type'])=='profile_pic')) {
                    //do the actual uploading of the file. First arg is the tmp name, second arg is 
                    //where we are putting it
                    if(move_uploaded_file($file['tmp_name'], WWW_ROOT . 'img/profile_pic/' . $setNewFileName . '.' . $ext)){
                      
                      $new_file_name = $setNewFileName . '.' . $ext;
                       //giving the permission to the newly uploaded file
                      chmod('img/profile_pic/' . $new_file_name, 0777);
                       //prepare the filename for database entry 
                        $data  = $new_file_name;
                    
                        //pr($data);die;
                      return $data;
                     
                    }
                    else{
                            return 0;
                        }
                }
                else{
                          return 0;
                    }
                
                }
                
    }
}

		/*
	    *
	    *UploadSampelDoc a file thorugh Api
	    *
	    */
	   
	    public function UploadSampelDoc($files = null) 
	    {
    	
		    if(!empty($files)){
                //$valid_formats = array('doc','pdf','docx','srs','ppt','DOC','PDF','DOCX','SRS','PPT');
                $valid_formats = array('png','gif','jpg','jpeg','PNG','GIF','JPG','JPEG');
                //$max_file_size = 1024*100; //100 kb
                //$max_file_size = 5*1024*1024; //5MB
                //$max_file_size = 2097152; //2MB
                $max_file_size = 20971520; //20MB
                $path = WWW_ROOT . "img/sampledoc/"; // Upload directory
                $imgCamp='';
                $errors='';

                if ($files['error'] == 0) {              
                        if ($files['size'] > $max_file_size) {
                            $errors = $files['name']." is too large! Max allowed size is 20MB.";
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

 /*
	    *
	    *upload a file thorugh Api
	    *
	    */
	
	public function uploadForumImage($data = null){
	
    if(!empty($data)){
    	   
       if ($data['error']==0){
            
			 $file = $data;
			 $filename = $data['name']; //put the data into a var for easy use
             
             $ext = pathinfo($filename, PATHINFO_EXTENSION);//get the extension
                
				$image_ext = array('jpg', 'jpeg', 'gif','png');//set allowed image extension
                $setNewFileName = time() . "_" . rand(000000, 999999);
                
				if (in_array($ext, $image_ext)) {
						
						if(move_uploaded_file($file['tmp_name'], WWW_ROOT . 'img/forums/' . $setNewFileName . '.' . $ext)){
						  
						  $new_file_name = $setNewFileName . '.' . $ext;
						   
						  chmod('img/forums/' . $new_file_name, 0777);
						   
							$data  = $new_file_name;
						
							return $data;
						 
						}
						else{
								return 0;
							}
                }
					else{
							  return 0;
						}
                
                }
                
		}
	}
	
	/*
	 *
	 *attach file to the mnail
	 *
	 */
	
	public function uploadEmailAttachment($data = null){
	
    if(!empty($data)){
    	   
       if ($data['error']==0){
            
			 $file = $data;
			 $filename = $data['name']; //put the data into a var for easy use
             
             $ext = pathinfo($filename, PATHINFO_EXTENSION); //get the extension
                 
                $setNewFileName = time() . "_" . rand(000000, 999999);
                 
						if(move_uploaded_file($file['tmp_name'], WWW_ROOT . 'mail_attachments/' . $setNewFileName . '.' . $ext)){
						
						  $new_file_name = $setNewFileName . '.' . $ext;
						
						  chmod('mail_attachments/' . $new_file_name, 0777);
						   
							$data  = $new_file_name;
						
							return $data;
						 
						}else{
								return 0;
							}
                
                }
		}
	}
}
?>