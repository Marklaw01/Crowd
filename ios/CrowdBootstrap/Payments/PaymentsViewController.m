//
//  PaymentsViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 13/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "PaymentsViewController.h"
#import "SWRevealViewController.h"
#import "ShoppingCartDetailViewController.h"

@interface PaymentsViewController ()

@end

@implementation PaymentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    companyArray = @[@"Group Buying",@"Launch Deals",@"Product/Service Exchange",@"Recommended Suppliers",@"CBS App Store",@"Recommended Apps"] ;
    contentArray = @[@"Coming soon – A Group Purchasing application that leverages purchasing volume to reduce price and improve terms and conditions.",@"Coming soon – An App that enables entrepreneurs to promote special deals for products and services that they are launching.",@"Coming soon – An App that enables startups to barter products and services.",@"Coming soon – A list of suppliers recommended by Crowd Bootstrap.",@"Coming soon – A list of Crowd Bootstrap applications.",@"Coming soon – A list of applications recommended by Crowd Bootstrap."] ;
    selectedCompanyIndex = -1 ;
    agreeBtn.accessibilityLabel = UNCHECK_IMAGE ;
    
    [self addObserver];
    [self navigationBarSettings] ;
    [self revealViewSettings] ;
    tbleView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
- (void) addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setNotificationIconOnNavigationBar:)name:kNotificationIconOnNavigationBar
                                               object:nil];
}

-(void)setNotificationIconOnNavigationBar:(NSNotification *) notification {
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"notifications"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(navigateToNotification_Click:)forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lblNotificationCount = [[UILabel alloc]init];
    
    [UtilityClass setNotificationIconOnNavigationBar:button
                                lblNotificationCount:lblNotificationCount navItem:self.navigationItem];
}

-(void)navigationBarSettings {
    self.navigationItem.hidesBackButton = YES ;
    self.title = @"Shopping Cart" ;
}

-(void)revealViewSettings{
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    menuBarBtn.target = self.revealViewController;
    menuBarBtn.action = @selector(revealToggle:);
    
    // Set the gesture
    //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    SWRevealViewController *revealController = [self revealViewController] ;
    [revealController panGestureRecognizer] ;
    [revealController tapGestureRecognizer] ;
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return companyArray.count ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.backgroundColor = [UIColor clearColor] ;
    cell.textLabel.text = [companyArray objectAtIndex:indexPath.row] ;
    cell.textLabel.textColor = [UtilityClass textColor] ;
    return cell ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40 ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *contentStr = [contentArray objectAtIndex:indexPath.row] ;
    if(![contentStr isEqualToString:@""]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ShoppingCartDetailViewController *viewController = (ShoppingCartDetailViewController*)[storyboard instantiateViewControllerWithIdentifier:kShoppingCartDetailViewIdentifier] ;
        viewController.title = [companyArray objectAtIndex:indexPath.row] ;
        viewController.contentStr = [contentArray objectAtIndex:indexPath.row] ;
        
        [self.navigationController pushViewController:viewController animated:YES] ;
    }
}

#pragma mark - IBAction Methods
- (IBAction)Confirm_ClickAction:(id)sender {
   /* if(selectedCompanyIndex == -1){
        [self presentViewController:[UtilityClass displayAlertMessage:kAlert_SelectCompany] animated:YES completion:nil];
        return ;
    }
    else  agreementView.hidden = NO ;*/
    
    agreementView.hidden = NO ;
    
}

- (IBAction)Submit_ClickAction:(id)sender {
    if([agreeBtn.accessibilityLabel isEqualToString:CHECK_IMAGE]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kHomeIdentifer] ;
        [self.navigationController pushViewController:viewController animated:YES] ;
    }
    else{
         [self presentViewController:[UtilityClass displayAlertMessage:kAlert_Agreement] animated:YES completion:nil];
    }
}

- (IBAction)Agree_ClickAction:(id)sender {
    if([agreeBtn.accessibilityLabel isEqualToString:CHECK_IMAGE ]){ // Check
        [agreeBtn setBackgroundImage:[UIImage imageNamed:UNCHECK_IMAGE] forState:UIControlStateNormal] ;
        agreeBtn.accessibilityLabel = UNCHECK_IMAGE ;
    }
    else{
        [agreeBtn setBackgroundImage:[UIImage imageNamed:CHECK_IMAGE] forState:UIControlStateNormal] ;
        agreeBtn.accessibilityLabel = CHECK_IMAGE ;
    }
}

- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
    
}

- (IBAction)checkUncheck_ClickAction:(UIButton*)sender {
    NSLog(@"tag: %ld",(long)[sender tag]) ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
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
