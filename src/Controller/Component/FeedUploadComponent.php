<?php
namespace App\Controller\Component;

use Cake\Controller\Component;
use Cake\Controller\ComponentRegistry;
use Cake\Network\Exception\InternalErrorException;
use Cake\Utility\Text;
use Cake\ORM\TableRegistry;

class FeedUploadComponent extends Component
{

	/****
	*
    *  uploadFeedFile
    *
    *
    *
    ****/
   
    public function uploadFile($files = null) 
    {
	
	    if(!empty($files)){
            //$valid_formats = array('doc','pdf','docx','srs','ppt','DOC','PDF','DOCX','SRS','PPT');
            $valid_formats = array('png','gif','jpg','jpeg','PNG','GIF','JPG','JPEG','mp3', 'mp4', 'mpg', 'wmv' ,'txt', 'doc','pdf','docx','srs','ppt','DOC','PDF','DOCX','SRS','PPT');
            //$max_file_size = 1024*100; //100 kb
            //$max_file_size = 5*1024*1024; //5MB
            //$max_file_size = 2097152; //2MB
            $max_file_size = 20971520; //20MB
            $path = WWW_ROOT . "img/feed/"; // Upload directory
            $imgCamp='';
            $errors='';

            if ($files['error'] == 0) {              
                    if ($files['size'] > $max_file_size) {
                        $errors = $files['name']." is too large! Max allowed size is 20MB.";
                        //continue; // Skip large files
                       
                    }
                    elseif(!in_array(pathinfo($files['name'], PATHINFO_EXTENSION), $valid_formats) ){
                        $errors = $files['name']." is not a valid format, Allowed format are PNG,GIF,JPEG,JPG, PDF, DOCX, SRS, PPT, MP3,  MP4, MPG, WMV.";
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