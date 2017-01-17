//
//  PopupViewController.m
//  CrowdBootstrap
//
//  Created by RICHA on 16/02/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "PopupViewController.h"
#import "PaymentsTableViewCell.h"

@interface PopupViewController ()

@end

@implementation PopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"" ;
    self.tblArray = [[NSMutableArray alloc] init] ;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
-(void)displayListForView:(NSString*)viewIdentifer withData:(NSMutableArray*)array withTitle:(NSString*)title{
    self.tblArray = array ;
    self.sectionTitle = title ;
    currentViewIdentifier = viewIdentifer ;
    tbleView.dataSource = self ;
    tbleView.delegate = self ;
    [tbleView reloadData] ;
    
}

#pragma mark - IBAction Methods
- (IBAction)checkUncheck_ClickAction:(UIButton*)sender {
    NSLog(@"tag: %ld",(long)[sender tag]) ;
    UIButton *btn = (UIButton*)sender ;
    //if([btn backgroundImageForState:UIControlStateNormal] == checkImg)
    if([btn.accessibilityLabel isEqualToString:CHECK_IMAGE ]){ // Check
        [btn setBackgroundImage:[UIImage imageNamed:UNCHECK_IMAGE] forState:UIControlStateNormal] ;
        btn.accessibilityLabel = UNCHECK_IMAGE ;
        selectedCellIndex = -1 ;
    }
    else{ // Uncheck
        for (int i = 0; i< self.tblArray.count; i++) {
            PaymentsTableViewCell *cell = [tbleView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]] ;
            if([cell.checkboxBtn.accessibilityLabel isEqualToString:CHECK_IMAGE]){
                [cell.checkboxBtn setBackgroundImage:[UIImage imageNamed:UNCHECK_IMAGE] forState:UIControlStateNormal] ;
                cell.checkboxBtn.accessibilityLabel = UNCHECK_IMAGE ;
            }
        }
        [btn setBackgroundImage:[UIImage imageNamed:CHECK_IMAGE] forState:UIControlStateNormal] ;
        btn.accessibilityLabel = CHECK_IMAGE ;
        selectedCellIndex = (int)[sender tag] ;
    }
}

- (IBAction)OKButtion_ClickAction:(id)sender {
}


#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tblArray.count ;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PaymentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customCell"] ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.companyNameLbl.text = [self.tblArray objectAtIndex:indexPath.row] ;
    cell.checkboxBtn.tag = indexPath.row ;
    cell.checkboxBtn.accessibilityLabel = UNCHECK_IMAGE ;
    return cell ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50 ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35 ;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.sectionTitle ;
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
