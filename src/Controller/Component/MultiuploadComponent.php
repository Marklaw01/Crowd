<?php
namespace App\Controller\Component;

use Cake\Controller\Component;
use Cake\Controller\ComponentRegistry;
use Cake\Network\Exception\InternalErrorException;
use Cake\Utility\Text;

class MultiuploadComponent extends Component
{
    public function Multiupload($files = null)
    {
        
        if(!empty($files)){
              //pr($files['file_type'][0]); die;
                //Upload doc
                $valid_formats = array("doc", "mp3", "mp4");
                //$max_file_size = 1024*100; //100 kb
                //$max_file_size = 5*1024*1024; //5MB
                $max_file_size = 20971520; //20MB
                $path = WWW_ROOT . "img/campaign/"; // Upload directory
                $count = 0;
                $filecount=count($files);
                $filecount=$filecount-1;
                $errors= array();
                $imgArray= array();

                for($i=0;$i<$filecount;$i++){

                    if($files['file_type'][$i]=='doc'){
                        $valid_formats = array('doc','pdf','docx','srs','ppt','DOC','PDF','DOCX','SRS','PPT');
                    }else if($files['file_type'][$i]=='mp3') {
                        $valid_formats = array("mp3");
                    }else {
                        $valid_formats = array("mp4");
                    }

                    if ($files[$i]['error'] == 4) {
                         continue; // Skip file if any error found
                        
                    }

                    if ($files[$i]['error'] == 0) {              
                        if ($files[$i]['size'] > $max_file_size) {
                            $errors[] = $files[$i]['name']." is too large! Max allowed size is 20MB.";
                            continue; // Skip large files
                           
                        }
                        elseif( ! in_array(pathinfo($files[$i]['name'], PATHINFO_EXTENSION), $valid_formats) ){
                            $errors[] = $files[$i]['name']." is not a valid format";
                            continue; // Skip invalid file formats
                          
                        }
                        else{ // No error found! Move uploaded files 
                            $setNewFileName = time() . "_" . rand(000000, 999999);
                            if(move_uploaded_file($files[$i]["tmp_name"], $path.$setNewFileName.$files[$i]['name'])) {
                                $count++; // Number of successfully uploaded files
                                $imgArray[] = array(
                                    'name' => $setNewFileName.$files[$i]['name'],
                                    'file_type' => $files['file_type'][$i],

                                );
                            }
                        }
                    }

                } 
                $imgdata = array(
                                    'imgArray' => $imgArray,
                                    'errors' => $errors,                                 
                            );   

                return $imgdata;
                
        }
            
    }
    
    public function MultiuploadApi($files = null)
    {
        
        if(!empty($files)){
                 
                $valid_formats = array("doc", "docx", "pdf" ,"mp3", "mp4");
                //$max_file_size = 1024*100; //100 kb
                //$max_file_size = 5*1024*1024; //5MB
                $max_file_size = 20971520; //20MB
                $path = WWW_ROOT . "img/campaign/"; // Upload directory
                $count = 0;
                $filecount=count($files);
                $filecount=$filecount-1;
                $errors= array();
                $imgArray= array();
                
                for($i=0;$i<=$filecount;$i++){
                    
                    if ($files[$i]['error'] == 0) {              
                       /* if ($files[$i]['size'] > $max_file_size) {
                            $errors[] = $files[$i]['name']." is too large!.";
                            continue; // Skip large files
                           
                        }
                        else(*/if( ! in_array(pathinfo($files[$i]['name'], PATHINFO_EXTENSION), $valid_formats) ){
                            $errors[$files[$i]['name']] = $files[$i]['name']." is not a valid format";
                            continue; // Skip invalid file formats
                          
                        }
                        else{ // No error found! Move uploaded files 
                            $setNewFileName = time() . "_" . rand(000000, 999999);
                            if(move_uploaded_file($files[$i]["tmp_name"], $path.$setNewFileName.$files[$i]['name'])) {
                                
                                chmod($path.$setNewFileName.$files[$i]['name'], 0777);
                                
                                $count++; // Number of successfully uploaded files
                                $imgArray[] = array(
                                    'name' => $setNewFileName.$files[$i]['name']
                                );
                            }
                        }
                    }

                } 
                $imgdata = array(
                                    'imgArray' => $imgArray,
                                    'errors' => $errors,                                 
                            );   

                return $imgdata;
                
        }
            
    }

    public function jobsUploadApi($files = null)
    {
        
        if(!empty($files)){
                 
                $valid_formats = array("doc", "docx", "pdf" ,"mp3", "mp4");
                //$max_file_size = 1024*100; //100 kb
                //$max_file_size = 5*1024*1024; //5MB
                $max_file_size = 20971520; //20MB
                $path = WWW_ROOT . "img/jobs/"; // Upload directory
                $count = 0;
                $filecount=count($files);
                //$filecount=$filecount-1;
                $errors= array();
                $imgArray= array();
                
                for($i=0;$i<$filecount;$i++){
                    
                    if ($files[$i]['error'] == 0) {              
                       /* if ($files[$i]['size'] > $max_file_size) {
                            $errors[] = $files[$i]['name']." is too large!.";
                            continue; // Skip large files
                           
                        }
                        else(*/
                            if( ! in_array(pathinfo($files[$i]['name'], PATHINFO_EXTENSION), $valid_formats) ){
                             
                             $getname1 = $files[$i]['name'];
                             $getType1 = end((explode(".", $getname)));
                                   
                             $errors[$files[$i]['name']] = $files[$i]['name']." is not a valid format";
                             $errors[$files[$i]['file_type']] =$getType1;
                            continue; // Skip invalid file formats
                          
                        }
                        else{ // No error found! Move uploaded files 
                            $setNewFileName = time() . "_" . rand(000000, 999999);
                            if(move_uploaded_file($files[$i]["tmp_name"], $path.$setNewFileName.$files[$i]['name'])) {
                                
                                chmod($path.$setNewFileName.$files[$i]['name'], 0777);
                                
                                $count++; // Number of successfully uploaded files

                                $getname = $setNewFileName.$files[$i]['name'];
                                $getType = end((explode(".", $getname))); # extra () to prevent notice

                                $imgArray[] = array(
                                    'name' => $setNewFileName.$files[$i]['name'],
                                    'file_type' => $getType
                                );
                            }
                        }
                    }

                } 
                $imgdata = array(
                                    'imgArray' => $imgArray,
                                    'errors' => $errors,                                 
                            );   

                return $imgdata;
                
        }
            
    }

    public function campaignImage($files = null)
    {   
            if(!empty($files)){
                $valid_formats = array("jpg", "jpeg", "png","gif","JPG","JPEG","PNG","GIF");
                //$max_file_size = 1024*100; //100 kb
                //$max_file_size = 2097152; //2MB
                $max_file_size = 20971520; //20MB
                $path = WWW_ROOT . "img/campaign/"; // Upload directory
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


    public function jobsUpload($files = null,$type=null)
    {   
            if(!empty($files)){
                //$valid_formats = array("jpg", "jpeg", "png","gif","JPG","JPEG","PNG","GIF");
                if($type=='doc'){

                    $valid_formats = array("doc", "docx", "pdf");

                }else if($type=='mp3'){

                    $valid_formats = array("mp3");

                }else{

                    $valid_formats = array("mp4","mov","ogv","wmv");
                }
                //$max_file_size = 1024*100; //100 kb
                //$max_file_size = 2097152; //2MB
                //$max_file_size = 5*1024*1024; //5MB
                $max_file_size = 20971520; //20MB
                $path = WWW_ROOT . "img/jobs/"; // Upload directory
                $imgCamp='';
                $errors='';

                if ($files['error'] == 0) {              
                        if ($files['size'] > $max_file_size) {
                            $errors = $files['name']." is too large! Max allowed size is 20MB.";
                            //continue; // Skip large files
                           
                        }
                        elseif( ! in_array(pathinfo($files['name'], PATHINFO_EXTENSION), $valid_formats) ){
                                if($type=='doc'){

                                    $errors = $files['name']." is not a valid format, Allowed format are doc,docx,pdf.";

                                }else if($type=='mp3'){

                                    $errors = $files['name']." is not a valid format, Allowed format are mp3.";

                                }else{

                                    $errors = $files['name']." is not a valid format, Allowed format are mp4.";
                                }
                            
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
                                'fileName' => $imgCamp,
                                'errors' => $errors,                                 
                            ); 

                    return $imgCampArray;
             }   
    }

    public function jobsUploadApply($files = null)
    {   
            if(!empty($files)){
   
                //$valid_formats = array("jpg", "jpeg", "png","gif","JPG","JPEG","PNG","GIF");

                $valid_formats = array("doc", "docx", "pdf");

                //$max_file_size = 1024*100; //100 kb
                //$max_file_size = 2097152; //2MB
                //$max_file_size = 5*1024*1024; //5MB
                $max_file_size = 20971520; //20MB
                $path = WWW_ROOT . "img/jobs/apply/"; // Upload directory
                $imgCamp='';
                $errors='';

                if ($files['error'] == 0) {              
                        if ($files['size'] > $max_file_size) {
                            $errors = $files['name']." is too large! Max allowed size is 20MB.";
                            //continue; // Skip large files
                           
                        }
                        elseif( ! in_array(pathinfo($files['name'], PATHINFO_EXTENSION), $valid_formats) ){

                                $errors = $files['name']." is not a valid format, Allowed format are doc,docx,pdf.";
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
                                'fileName' => $imgCamp,
                                'errors' => $errors,                                 
                            ); 

                    return $imgCampArray;
             }   
    }

    public function roadmapGraphicUpload($files = null)
    {   
            if(!empty($files)){
                $valid_formats = array("jpg", "jpeg", "png","gif","JPG","JPEG","PNG","GIF");
                //$max_file_size = 1024*100; //100 kb
                //$max_file_size = 2097152; //2MB
                $max_file_size = 20971520; //20MB
                $path = WWW_ROOT . "img/roadmap/"; // Upload directory
                $imgCamp='';
                $errors='';

                if ($files['error'] == 0) {              
                        if ($files['size'] > $max_file_size) {
                            $errors = $files['name']." is too large! Max allowed size is 20MB.";
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

    public function uploadStratupDocs($files = null)
    {   
            if(!empty($files)){
                $valid_formats = array("doc", "docx", "pdf","PDF","DOCX","DOC");
                //$max_file_size = 1024*100; //100 kb
                //$max_file_size = 2097152; //2MB
                //$max_file_size = 5*1024*1024; //5MB
                $max_file_size = 20971520; //20MB
                $path = WWW_ROOT . "img/roadmap/"; // Upload directory
                $imgCamp='';
                $errors='';

                if ($files['error'] == 0) {              
                        if ($files['size'] > $max_file_size) {
                            $errors = $files['name']." is too large! Max allowed size is 20MB.";
                            //continue; // Skip large files
                           
                        }
                        elseif( ! in_array(pathinfo($files['name'], PATHINFO_EXTENSION), $valid_formats) ){
                            $errors = $files['name']." is not a valid format, Allowed format are doc,docx,PDF.";
                           // continue; // Skip invalid file formats
                          
                        }
                        else{ // No error found! Move uploaded files 
                            $setNewFileName = time() . "_" . rand(000000, 999999);
                            if(move_uploaded_file($files["tmp_name"], $path.$setNewFileName.$files['name'])) { // Number of successfully uploaded files
                                $imgCamp = $setNewFileName.$files['name'];
                                chmod($path.$imgCamp, 0777);
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
    

    public function uploadStratupProfileDocsWeb($files = null)
    {   
            if(!empty($files)){
                $valid_formats = array("doc", "docx", "pdf","PDF","DOCX","DOC");
                //$max_file_size = 1024*100; //100 kb
                //$max_file_size = 2097152; //2MB
                //$max_file_size = 5*1024*1024; //5MB
                $max_file_size = 20971520; //20MB
                $path = WWW_ROOT . "img/startup_profile_docs/"; // Upload directory
                $imgCamp='';
                $errors='';

                if ($files['error'] == 0) {              
                        if ($files['size'] > $max_file_size) {
                            $errors = $files['name']." is too large! Max allowed size is 20MB.";
                            //continue; // Skip large files
                           
                        }
                        elseif( ! in_array(pathinfo($files['name'], PATHINFO_EXTENSION), $valid_formats) ){
                            $errors = $files['name']." is not a valid format, Allowed format are doc,docx,PDF.";
                           // continue; // Skip invalid file formats
                          
                        }
                        else{ // No error found! Move uploaded files 
                            $setNewFileName = time() . "_" . rand(000000, 999999);
                            if(move_uploaded_file($files["tmp_name"], $path.$setNewFileName.$files['name'])) { // Number of successfully uploaded files
                                $imgCamp = $setNewFileName.$files['name'];
                                chmod($path.$imgCamp, 0777);
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
    
    public function uploadStratupProfileDocs($files = null)
    {   
            if(!empty($files)){
                $valid_formats = array("doc", "docx", "pdf","PDF","DOCX","DOC");
                //$max_file_size = 1024*100; //100 kb
                //$max_file_size = 2097152; //2MB
                //$max_file_size = 5*1024*1024; //5MB
                $max_file_size = 20971520; //20MB
                $path = WWW_ROOT . "img/startup_profile_docs/"; // Upload directory
                $imgCamp='';
                $errors='';

                if ($files['error'] == 0) {              
                        if ($files['size'] > $max_file_size) {
                            $errors = $files['name']." is too large! Max allowed size is 20MB.";
                            //continue; // Skip large files
                           
                        }
                        elseif( ! in_array(pathinfo($files['name'], PATHINFO_EXTENSION), $valid_formats) ){
                            $errors = $files['name']." is not a valid format, Allowed format are doc,docx,PDF.";
                           // continue; // Skip invalid file formats
                          
                        }
                        else{ // No error found! Move uploaded files 
                            $setNewFileName = time() . "_" . rand(000000, 999999);
                            if(move_uploaded_file($files["tmp_name"], $path.$setNewFileName.$files['name'])) { // Number of successfully uploaded files
                                $imgCamp = $setNewFileName.$files['name'];
                                chmod($path.$imgCamp, 0777);
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
    
    public function campaignImageApi($files = null)
    {   
            if(!empty($files)){
                $valid_formats = array("jpg", "jpeg", "png","gif","JPG","JPEG","PNG","GIF");
                //$max_file_size = 1024*100; //100 kb
                //$max_file_size = 2097152; //2MB
                $max_file_size = 20971520; //20MB
                $path = WWW_ROOT . "img/campaign/"; // Upload directory
                $imgCamp='';
                $errors='';
                
                if ($files['error'] == 0) {              
                        /*if ($files['size'] > $max_file_size) {
                            $errors = $files['name']." is too large! Max allowed size is 2MB.";
                            //continue; // Skip large files
                           
                        }
                        else*/
                        if( ! in_array(pathinfo($files['name'], PATHINFO_EXTENSION), $valid_formats) ){
                           
                           return $errors = '1'; //invalid file
                          
                        }
                        else{
                            $setNewFileName = time() . "_" . rand(000000, 999999);
                            if(move_uploaded_file($files["tmp_name"], $path.$setNewFileName.$files['name'])) { // Number of successfully uploaded files
                                $imgCamp = $setNewFileName.$files['name'];
                                chmod($path.$imgCamp, 0777);
                                return $imgCamp;
                            }
                        }
                    }else{
                        return $errors = '0'; //image has errors file
                    }
             }   
    }


    public function uploadImg($files = null){
        
        if(!empty($files)){
                $valid_formats = array("png","jpg","jpeg","gif");
                //$max_file_size = 1024*100; //100 kb
                $max_file_size = 30*1024*1024; //30MB
                $path = WWW_ROOT . "img/businesscards/"; // Upload directory
                $errors= array();
                $imgArray= array();
                                    
                if ($files['error'] == 0) {              
                    if ($files['size'] > $max_file_size) {
                        $errors[] = $files['name']." is too large!.";
                        continue; // Skip large files
                       
                    }elseif( ! in_array(pathinfo($files['name'], PATHINFO_EXTENSION), $valid_formats) ){
                        $errors[$files['name']] = $files['name']." is not a valid format";
                        //continue; // Skip invalid file formats
                    }
                    else{ // No error found! Move uploaded files 
                        $setNewFileName = time() . "_" . rand(000000, 999999);
                        if(move_uploaded_file($files["tmp_name"], $path.$setNewFileName.$files['name'])) {
                            
                            chmod($path.$setNewFileName.$files['name'], 0777);
                            
                            $imgArray[] = array(
                                'name' => $setNewFileName.$files['name']
                            );
                        }
                    }
                }

                $docdata = array(
                                    'imgArray' => $imgArray,
                                    'errors' => $errors,                                 
                            );   

                return $docdata;
                
        }            
    }

    


}
?>