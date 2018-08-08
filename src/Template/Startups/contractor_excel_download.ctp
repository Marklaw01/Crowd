<?php
/**
 * PHPExcel
 *
 * Copyright (C) 2006 - 2014 PHPExcel
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 *
 * @category   PHPExcel
 * @package    PHPExcel
 * @copyright  Copyright (c) 2006 - 2014 PHPExcel (http://www.codeplex.com/PHPExcel)
 * @license    http://www.gnu.org/licenses/old-licenses/lgpl-2.1.txt	LGPL
 * @version    1.8.0, 2014-03-02
 */

/** Error reporting */
error_reporting(E_ALL);
ini_set('display_errors', TRUE);
ini_set('display_startup_errors', TRUE);
date_default_timezone_set('Europe/London');

define('EOL',(PHP_SAPI == 'cli') ? PHP_EOL : '<br />');

require_once WWW_ROOT.'excel/PHPExcel.php';


if(!empty($FinalObject)){

/** Include PHPExcel */

$objPHPExcel = new PHPExcel();

$objPHPExcel->getProperties()->setCreator("Maarten Balliauw")
							 ->setLastModifiedBy("Maarten Balliauw")
							 ->setTitle("PHPExcel Test Document")
							 ->setSubject("PHPExcel Test Document")
							 ->setDescription("Test document for PHPExcel, generated using PHP classes.")
							 ->setKeywords("office PHPExcel php")
							 ->setCategory("Test result file");
//pr($deliverables);
//pr($FinalObject);die;

/*setting the deliverables name as headings*/

$totalDeliverable = count($deliverables);
$totalDays = count($FinalObject);

for($column=0; $column<$totalDeliverable; $column++){
    $objPHPExcel->setActiveSheetIndex(0)->setCellValue($columns[$column+1].'1', $deliverables[$column]);
}

/*setting the dates*/

$dateIndex = 2;
foreach($FinalObject as $singleObject){ 
    $objPHPExcel->setActiveSheetIndex(0)->setCellValue('A'.$dateIndex,date('F d, Y',strtotime($singleObject['date'])) );
    
        for($column=0; $column<$totalDeliverable; $column++){ 
             
            if(isset($singleObject['deliverables'][$column]['work_units'])&&($singleObject['deliverables'][$column]['work_units']!='')):
                $objPHPExcel->setActiveSheetIndex(0)->setCellValue($columns[$column+1].$dateIndex, $singleObject['deliverables'][$column]['work_units']);    
            else:
                $objPHPExcel->setActiveSheetIndex(0)->setCellValue($columns[$column+1].$dateIndex, '0');
            endif;
            
        }
        
    $dateIndex++;
}

/*setting the sum of the deliverables hours*/
    
    for($column=0; $column<$totalDeliverable; $column++){
        
        $col = $columns[$column+1];
        $row = ($totalDays+2);
        
        $StartCell = $col.'2';
        $EndCell = $col.($row-1);
        
        $objPHPExcel->getActiveSheet()
                                    ->setCellValue(
                                        $col.$row,
                                        "=SUM($StartCell:$EndCell)"
                                );
        
    }

/*setting the user hours details*/

$objPHPExcel->setActiveSheetIndex(0)->setCellValue('A'.($totalDays+2),'TotalHours'); 

if(isset($UserHoursDetails['AllocatedHours'])&&($UserHoursDetails['AllocatedHours']!='')):
    $ApprovedHours = $UserHoursDetails['AllocatedHours'];
else:
    $ApprovedHours = '0';
endif;

$objPHPExcel->setActiveSheetIndex(0)->setCellValue('A'.($totalDays+3),'AllocatedHours Hours'); 
$objPHPExcel->setActiveSheetIndex(0)->setCellValue('B'.($totalDays+3),$ApprovedHours);


if(isset($UserHoursDetails['RemainingHours'])&&($UserHoursDetails['RemainingHours']!='')):
    $RemainingHours = $UserHoursDetails['RemainingHours'];
else:
    $RemainingHours = '0';
endif;

$objPHPExcel->setActiveSheetIndex(0)->setCellValue('A'.($totalDays+4),'Remaining Hours'); 
$objPHPExcel->setActiveSheetIndex(0)->setCellValue('B'.($totalDays+4),$RemainingHours); 

$objPHPExcel->getActiveSheet()->setTitle('User WorkOrders');

// Set active sheet index to the first sheet, so Excel opens this as the first sheet
$objPHPExcel->setActiveSheetIndex(0);

$objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'Excel2007');
$objWriter->setPreCalculateFormulas(true);

$objWriter->save(WWW_ROOT.'excel_files/workorder_from_'.$from.'_to_'.$too.'.xlsx');
chmod(WWW_ROOT.'excel_files/test.xlsx', 0777);

//if(!empty($file_name)){
            $filePath = WWW_ROOT .'excel_files'. DS . 'workorder_from_'.$from.'_to_'.$too.'.xlsx';
            $this->response->file($filePath ,array('download'=> true));
            return $this->response;
            $this->redirect(['action' => 'viewStartupWorkorder',$startupId]);
//}
    //$result['code'] = 200;
    //$result['file_path'] = 'workorder_from_'.$from.'.xlsx';
    
}else{
    
    //$result['code'] = 404;
   // $result['message'] = 'No file found';
    //echo json_encode($result);
    
}