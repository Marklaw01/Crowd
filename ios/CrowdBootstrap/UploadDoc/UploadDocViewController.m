//
//  UploadDocViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 22/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "UploadDocViewController.h"
#import "UploadDocTableViewCell.h"

@interface UploadDocViewController ()

@end

@implementation UploadDocViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"File Upload" ;
    contractorsArray = [[NSMutableArray alloc] initWithObjects:@"Member 1",@"Member 2",@"Member 3",@"Member 4", nil] ;
    roadmapArray = [[NSMutableArray alloc] initWithObjects:@"Step 1",@"Step 2",@"Step 3",@"Step 4", nil] ;
    [self resetUISettings] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
-(void)resetUISettings{
    [UtilityClass setTextFieldBorder:fileNameTxtFld] ;
    [UtilityClass setTextFieldBorder:roadmapTxtFld] ;
    
    [UtilityClass addMarginsOnTextField:fileNameTxtFld] ;
    [UtilityClass addMarginsOnTextField:roadmapTxtFld] ;
    
    publicBtn.accessibilityValue = CHECKBOX_UNSELECTED ;
    roadmapTxtFld.inputView = pickerViewContainer ;
    selectedRoadmapIndex = 0 ;
}

#pragma mark - IBAction Methods
- (IBAction)Back_Click:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)Upload_ClickAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

- (IBAction)selectContractor_ClickAction:(UIButton*)button {
    if([button.accessibilityValue isEqualToString:CHECKBOX_UNSELECTED ]){
        [button setBackgroundImage:[UIImage imageNamed:CHECKBOX_SELECTED] forState:UIControlStateNormal] ;
        button.accessibilityValue = CHECKBOX_SELECTED ;
    }
    else{
        [button setBackgroundImage:[UIImage imageNamed:CHECKBOX_UNSELECTED] forState:UIControlStateNormal] ;
        button.accessibilityValue = CHECKBOX_UNSELECTED ;
    }
}

- (IBAction)SelectDeselectAllBtn_ClickAction:(id)sender {
    NSString *selectedType ;
    if([sender tag] == SELECT_ALL){
        selectedType = CHECKBOX_SELECTED  ;
        [selectAllBtn setBackgroundImage:[UIImage imageNamed:RADIOBUTON_SELECTED] forState:UIControlStateNormal] ;
        [deselectAllBtn setBackgroundImage:[UIImage imageNamed:RADIOBUTTON_UNSELECTED] forState:UIControlStateNormal] ;
    }
    else{
        selectedType = CHECKBOX_UNSELECTED ;
        [selectAllBtn setBackgroundImage:[UIImage imageNamed:RADIOBUTTON_UNSELECTED] forState:UIControlStateNormal] ;
        [deselectAllBtn setBackgroundImage:[UIImage imageNamed:RADIOBUTON_SELECTED] forState:UIControlStateNormal] ;
    }
     
    for (int i=0; i< contractorsArray.count; i++) {
        UploadDocTableViewCell *cell = [contractorsTblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]] ;
        [cell.checkboxBtn setBackgroundImage:[UIImage imageNamed:selectedType] forState:UIControlStateNormal] ;
        cell.checkboxBtn.accessibilityValue = selectedType ;
    }
}

- (IBAction)PublicBtn_ClickAction:(id)sender {
    if([publicBtn.accessibilityValue isEqualToString:CHECKBOX_UNSELECTED]){
        [publicBtn setBackgroundImage:[UIImage imageNamed:CHECKBOX_SELECTED] forState:UIControlStateNormal] ;
        publicBtn.accessibilityValue = CHECKBOX_SELECTED ;
    }
    else{
        [publicBtn setBackgroundImage:[UIImage imageNamed:CHECKBOX_UNSELECTED] forState:UIControlStateNormal] ;
        publicBtn.accessibilityValue = CHECKBOX_UNSELECTED ;
    }
}

- (IBAction)RoadmapDropdown_ActionClick:(id)sender {
    [roadmapTxtFld becomeFirstResponder] ;
}

- (IBAction)toolbarButtons_ClickAction:(id)sender {
    [roadmapTxtFld resignFirstResponder] ;
    
    if([sender tag] == DONE_CLICKED){
        roadmapTxtFld.text = [roadmapArray objectAtIndex:[pickerView selectedRowInComponent:0]]  ;
        selectedRoadmapIndex = (int)[pickerView selectedRowInComponent:0] ;
    }
    else{
        if(selectedRoadmapIndex != -1) roadmapTxtFld.text = [roadmapArray objectAtIndex:selectedRoadmapIndex]  ;
        else roadmapTxtFld.text = [roadmapArray objectAtIndex:0] ;
    }
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return contractorsArray.count ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UploadDocTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customCell"] ;
    cell.nameLbl.text = [contractorsArray objectAtIndex:indexPath.row] ;
    cell.checkboxBtn.tag = (int)indexPath.row ;
    cell.checkboxBtn.accessibilityValue = CHECKBOX_UNSELECTED ;
    return cell ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40 ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UploadDocTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath] ;
    [self selectContractor_ClickAction:cell.checkboxBtn] ;
}

#pragma mark - Picker View Delegate Methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1 ;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return roadmapArray.count ;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [roadmapArray objectAtIndex:row] ;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    roadmapTxtFld.text = [roadmapArray objectAtIndex:row] ;
}

#pragma mark - Disable Editing Method
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


#pragma mark - TextField Delegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder] ;
    return NO ;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
