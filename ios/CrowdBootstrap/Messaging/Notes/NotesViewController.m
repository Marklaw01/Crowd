//
//  NotesViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 13/01/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "NotesViewController.h"
#import "SWRevealViewController.h"
#import "MessagesTableViewCell.h"
#import "CDTestEntity.h"
#import "AddNoteViewController.h"

@interface NotesViewController ()

@end

@implementation NotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addObserver];
    [self resetUISettings] ;
}

-(void)viewWillAppear:(BOOL)animated{
     [self getStartupsList] ;
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

-(void)resetUISettings {
    startupsArray = [[NSMutableArray alloc] init] ;
    notesArray = [[NSMutableArray alloc] init] ;
    notesTblView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    notesTblView.hidden = YES ;
    [self navigationBarSettings] ;
    [self revealViewSettings] ;
   
}

-(void)navigationBarSettings{
    self.navigationItem.hidesBackButton = YES ;
    self.title = @"Notes" ;
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

#pragma mark - IBAction Methods
- (IBAction)AddNote_ClickAction:(id)sender {
    [UtilityClass setAddNoteMode:YES] ;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kAddNoteIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
}

- (IBAction)navigateToNotification_Click:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:kNotificationViewIdentifier] ;
    [self.navigationController pushViewController:viewController animated:YES] ;
    
}

#pragma mark - CoreData Methods
- (void)fetchNotesList
{
    if(notesArray)[notesArray removeAllObjects] ;
    else notesArray = [[NSMutableArray alloc] init] ;
    
    for (NSDictionary *dict in startupsArray) {
     
        NSString *startup_id = [dict valueForKey:kProfileUserStartupApi_StartupID] ;
        NSMutableDictionary *obj = [[NSMutableDictionary alloc] init] ;
        [obj setValue:[dict valueForKey:kProfileUserStartupApi_StartupName] forKey:kProfileUserStartupApi_StartupName] ;
        [obj setValue:[dict valueForKey:kProfileUserStartupApi_StartupID] forKey:kProfileUserStartupApi_StartupID] ;
        NSMutableArray *arr = [[NSMutableArray alloc] init] ;
        NSPredicate *pred = [[AppDelegate appDelegate].coreDataManager setPredicateEqualWithSearchKey:@"note_startupid" searchValue:startup_id];
        [[AppDelegate appDelegate].coreDataManager fetchWithEntity:NOTES_ENTITY
                                Predicate:pred
                                  success:^(NSArray *fetchLists)
         {
             // display the data
             for (CDTestEntity *fetchEntity in fetchLists)
             {
                 [arr addObject:fetchEntity] ;
                 //NSLog(@"fetchEntity: %@  note_startupid: %@  startupName: %@",fetchEntity.note_title,fetchEntity.note_startupid,[dict valueForKey:kProfileUserStartupApi_StartupName]) ;
             }
             
         }
                                   failed:^(NSError *error)
         {
             
         }];
        
        [obj setObject:arr forKey:@"notes"] ;
        if(arr.count > 0)[notesArray addObject:obj] ;
    }
    [notesTblView reloadData] ;
    if(notesArray.count > 0)notesTblView.hidden = NO ;
    else notesTblView.hidden = YES ;
    
}

#pragma mark - Api Methods
-(void)getStartupsList{
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        NSMutableDictionary *dictParam =[[NSMutableDictionary alloc] init];
        [dictParam setObject:[NSString stringWithFormat:@"%d",[UtilityClass getLoggedInUserID]] forKey:kProfileUserStartupApi_UserID] ;
        
        [ApiCrowdBootstrap getNotesStartupListWithParameters:dictParam success:^(NSDictionary *responseDict) {
            
            [UtilityClass hideHud] ;
            NSLog(@"responseDict %@", responseDict);
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                if([responseDict objectForKey:kProfileUserStartupApi_StartupData]){
                    startupsArray = [NSMutableArray arrayWithArray:(NSArray*)[[responseDict objectForKey:kProfileUserStartupApi_StartupData] mutableCopy]] ;
                    if(startupsArray.count > 0)[self fetchNotesList] ;
                }
            }
            //else [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
}

#pragma mark - TableView Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[[notesArray objectAtIndex:section] objectForKey:@"notes"]] ;
    return arr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return notesArray.count ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessagesTableViewCell *cell = (MessagesTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"notesCell"] ;
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[[notesArray objectAtIndex:indexPath.section] objectForKey:@"notes"]] ;
    CDTestEntity *noteEntity = (CDTestEntity*)[arr objectAtIndex:indexPath.row] ;
    cell.messageLbl.text = noteEntity.note_title ;
    cell.descriptionLbl.text = noteEntity.note_desc ;
    cell.dateLbl.text = noteEntity.note_date ;
    
    NSMutableArray *rightUtilityButtons = [NSMutableArray new] ;
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:197.0/255.0f green:4.0/255.0f blue:25.0/255.0f alpha:1] icon:[UIImage imageNamed:FORUM_DELETE_IMAGE]] ;
    cell.rightUtilityButtons = rightUtilityButtons ;
    cell.delegate = self ;
    return cell ;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, notesTblView.frame.size.width, 35)] ;
    sectionView.backgroundColor = [UIColor darkGrayColor] ;
    
    // Add shadow
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:sectionView.bounds];
    sectionView.layer.masksToBounds = NO;
    sectionView.layer.shadowColor = [UIColor blackColor].CGColor;
    sectionView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    sectionView.layer.shadowOpacity = 0.5f;
    sectionView.layer.shadowPath = shadowPath.CGPath;
    
    UILabel *sectionLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, sectionView.frame.size.width-20, sectionView.frame.size.height)] ;
    sectionLbl.text = [NSString stringWithFormat:@"%@",[[notesArray objectAtIndex:section] valueForKey:kProfileUserStartupApi_StartupName]] ;
    sectionLbl.font = [UIFont fontWithName:@"HelveticaNeue" size:17] ;
    sectionLbl.textColor = [UIColor whiteColor] ;
    [sectionView addSubview:sectionLbl] ;
    return sectionView ;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90 ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35 ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [UtilityClass setAddNoteMode:NO] ;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddNoteViewController *viewController = (AddNoteViewController*)[storyboard instantiateViewControllerWithIdentifier:kAddNoteIdentifier] ;
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[[notesArray objectAtIndex:indexPath.section] objectForKey:@"notes"]] ;
    viewController.selectedEntity = (CDTestEntity*)[arr objectAtIndex:indexPath.row] ;
    
    [self.navigationController pushViewController:viewController animated:YES] ;
}

#pragma mark - SWRevealTableViewCell Delegate Methods
-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *cellIndexPath = [notesTblView indexPathForCell:cell];
    
    [[AppDelegate appDelegate].coreDataManager fetchWithEntity:NOTES_ENTITY
                            Predicate:nil
                              success:^(NSArray *fetchLists)
     {
         // delete entity
         
          NSMutableArray *arr = [NSMutableArray arrayWithArray:[[notesArray objectAtIndex:cellIndexPath.section] objectForKey:@"notes"]] ;
         [[AppDelegate appDelegate].coreDataManager deleteWithEntity:(CDTestEntity*)[arr objectAtIndex:cellIndexPath.row]];
         
     }
                               failed:^(NSError *error)
     {
         
     }];
    
    [[[notesArray objectAtIndex:cellIndexPath.section] objectForKey:@"notes"] removeObjectAtIndex:cellIndexPath.row] ;
    [notesTblView deleteRowsAtIndexPaths:@[cellIndexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    [self removeStartupWithEmptyNotes] ;
    
}

-(void)removeStartupWithEmptyNotes{
    NSMutableArray *tempArray = [notesArray mutableCopy] ;
    for (int i=0; i<tempArray.count ;i++) {
        NSArray *arr = [NSArray arrayWithArray:[[tempArray objectAtIndex:i] objectForKey:@"notes"]];
        if(arr.count == 0) [notesArray removeObjectAtIndex:i] ;
        
    }
    [notesTblView reloadData] ;
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
