//
//  LeanRoadmapViewController.h
//  CrowdBootstrap
//
//  Created by OSX on 23/08/16.
//  Copyright © 2016 trantor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeanRoadmapViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    
//    IBOutlet UITableView             *tblView ;
    IBOutlet UICollectionView             *collectionViewUpward ;
    IBOutlet UICollectionView             *collectionViewRoadmap ;
    IBOutlet UICollectionView             *collectionViewDownward ;

    NSMutableArray                   *upwardArray ;
    NSMutableArray                   *roadMapArray ;
    NSMutableArray                   *downwardArray ;
}

@end
