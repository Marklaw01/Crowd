//
//  LeanRoadmapViewController.m
//  CrowdBootstrap
//
//  Created by OSX on 23/08/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import "LeanRoadmapViewController.h"
#import "Title1CollectionViewCell.h"
#import "Title2CollectionViewCell.h"
#import "RoadmapCollectionViewCell.h"

@interface LeanRoadmapViewController ()

@end

@implementation LeanRoadmapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self resetUISettings] ;
    [self getLeanStartupRoadMaps] ;
    
    upwardArray = [[NSMutableArray alloc] init];
    downwardArray = [[NSMutableArray alloc] init];

    [collectionViewUpward registerNib:[UINib nibWithNibName:@"Title1CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Title1Cell"];
    [collectionViewUpward registerNib:[UINib nibWithNibName:@"Title3CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Title3Cell"];
    [collectionViewDownward registerNib:[UINib nibWithNibName:@"Title1CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Title1Cell"];
    [collectionViewDownward registerNib:[UINib nibWithNibName:@"Title3CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Title3Cell"];
    [collectionViewRoadmap registerNib:[UINib nibWithNibName:@"RoadmapCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"RoadmapCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods
-(void)resetUISettings{
    self.title = @"Lean Startup Roadmap" ;
}

#pragma mark - IBAction Methods
- (IBAction)BackBtn_Click:(id)sender {
    [self.navigationController popViewControllerAnimated:YES] ;
}

#pragma mark - CollectionView Data Source and Delegate Methods
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == collectionViewRoadmap) {
        return 1;
    } else
        return roadMapArray.count/2;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == collectionViewRoadmap) {
        RoadmapCollectionViewCell *cell = (RoadmapCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"RoadmapCell" forIndexPath:indexPath];
        return cell;
        
    } else {
        Title1CollectionViewCell *cell1 = (Title1CollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"Title1Cell" forIndexPath:indexPath];
        Title2CollectionViewCell *cell2 = (Title2CollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"Title3Cell" forIndexPath:indexPath];
        
        // Upward Steps
        if (collectionView == collectionViewUpward) {
            if ((indexPath.row) % 2 == 0) { //Yellow Button
                [cell1 setData:[upwardArray objectAtIndex:indexPath.row]];
                return cell1;
                
            } else { //Green Button
                [cell2 setData:[upwardArray objectAtIndex:indexPath.row]];
                return cell2;
            }
        } else { // Downward Steps
            if ((indexPath.row) % 2 == 0) { //Yellow Button
                [cell1 setData:[downwardArray objectAtIndex:indexPath.row]];
                return cell1;
                
            } else { //Green Button
                [cell2 setData:[downwardArray objectAtIndex:indexPath.row]];
                return cell2;
            }
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    if (collectionView == collectionViewRoadmap) {
        CGFloat width = collectionViewRoadmap.frame.size.width;
        return CGSizeMake(width, 60);
    }
    return CGSizeMake(85, 125);
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout blockSizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row % 2 == 0)
        return CGSizeMake(2, 1);
    
    return CGSizeMake(1, 2);
}

#pragma mark - API Methods
-(void)getLeanStartupRoadMaps {
    if([UtilityClass checkInternetConnection]){
        
        [UtilityClass showHudWithTitle:kHUDMessage_PleaseWait] ;
        [ApiCrowdBootstrap getLeanStartupRoadmap:^(NSDictionary *responseDict) {
            
            [UtilityClass hideHud] ;
            if([[responseDict valueForKey:@"code"] intValue] == kSuccessCode )  {
                roadMapArray = [NSMutableArray arrayWithArray:(NSArray*)[responseDict objectForKey:@"startup"]] ;
                for (int i = 0; i < roadMapArray.count; i++) {
                    if (i % 2 == 0) {
                        [upwardArray addObject:[roadMapArray objectAtIndex:i]];
                    } else {
                        [downwardArray addObject:[roadMapArray objectAtIndex:i]];
                    }
                }
                [collectionViewUpward reloadData];
                [collectionViewRoadmap reloadData];
                [collectionViewDownward reloadData];
            }
            else [self presentViewController:[UtilityClass displayAlertMessage:[responseDict valueForKey:@"message"]] animated:YES completion:nil];
            
        } failure:^(NSError *error) {
            
            [UtilityClass displayAlertMessage:error.description] ;
            [UtilityClass hideHud] ;
        }] ;
    }
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
